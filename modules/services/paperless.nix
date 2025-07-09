# Paperless-ngx document management system
{ config, pkgs, ... }:

let
  cfg = config.beanlab;
in
{
  # Enable Redis for Paperless
  services.redis.servers.paperless = {
    enable = true;
    port = 6379;
    bind = "127.0.0.1";
  };

  # Enable paperless-ngx service
  services.paperless = {
    enable = true;
    
    # User and group configuration  
    user = "bean";
    
    # Web interface configuration
    port = cfg.ports.paperless;
    address = "0.0.0.0";  # Allow access from any interface
    
    # Data storage configuration - use the storage pool
    dataDir = "/storage/pool/documents/paperless-data";
    mediaDir = "/storage/pool/documents/paperless-media";
    consumptionDir = "/storage/pool/documents/consume";
    
    # OCR configuration for English and Japanese
    settings = {
      PAPERLESS_OCR_LANGUAGE = "eng+jpn";  # English and Japanese OCR
      
      # Performance and reliability settings
      PAPERLESS_TASK_WORKERS = 2;
      PAPERLESS_THREADS_PER_WORKER = 1;
      
      # Security settings
      PAPERLESS_ALLOWED_HOSTS = cfg.network.serverDomain + ",localhost,127.0.0.1," + cfg.network.serverIP;
      PAPERLESS_CORS_ALLOWED_HOSTS = "http://" + cfg.network.serverDomain + ":" + toString cfg.ports.paperless;
      
      # URL and host configuration
      PAPERLESS_URL = "http://" + cfg.network.serverDomain + ":" + toString cfg.ports.paperless;
      
      # Date formats
      PAPERLESS_DATE_ORDER = "YMD";
      
      # Filename handling
      PAPERLESS_FILENAME_FORMAT = "{created_year}/{correspondent}/{title}";
      
      # Consumer settings
      PAPERLESS_CONSUMER_POLLING = 5;  # Check for new files every 5 seconds
      PAPERLESS_CONSUMER_DELETE_DUPLICATES = true;
      PAPERLESS_CONSUMER_RECURSIVE = true;
      PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
      
      # Document processing
      PAPERLESS_OCR_ROTATE_PAGES = true;
      PAPERLESS_OCR_ROTATE_PAGES_THRESHOLD = 12;
      
      # Thumbnail settings
      PAPERLESS_THUMBNAIL_FONT_NAME = "/run/current-system/sw/share/fonts/truetype/dejavu/DejaVuSans.ttf";
      
      # Time zone
      PAPERLESS_TIME_ZONE = "Asia/Tokyo";
    };
  };

  # Create necessary directories with proper permissions
  systemd.tmpfiles.rules = [
    "d /storage/pool/documents 0755 bean users -"
    "d /storage/pool/documents/paperless-data 0755 bean users -"
    "d /storage/pool/documents/paperless-media 0755 bean users -"
    "d /storage/pool/documents/consume 0755 bean users -"
    "d /storage/pool/documents/export 0755 bean users -"
  ];

  # Install additional packages for document processing
  environment.systemPackages = with pkgs; [
    paperless-ngx                        # Explicit paperless-ngx package
    tesseract5                           # OCR engine
    imagemagick                          # Image processing
    ghostscript                          # PDF processing
    qpdf                                 # PDF manipulation
    poppler_utils                        # PDF utilities (pdfinfo, pdftotext, etc.)
    unpaper                              # Document cleaning
    libxml2                              # XML processing
    libxslt                              # XSLT processing
  ];

  # Firewall configuration to allow access to paperless
  networking.firewall.allowedTCPPorts = [ cfg.ports.paperless ];
} 