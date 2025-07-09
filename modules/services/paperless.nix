# Paperless-ngx document management system
{ config, pkgs, ... }:

let
  cfg = config.beanlab;
in
{
  # Enable paperless-ngx service (Redis will be auto-configured)
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
    
    # Simplified configuration using extraConfig (like the example)
    extraConfig = {
      PAPERLESS_OCR_LANGUAGE = "eng+jpn";  # English and Japanese OCR
      PAPERLESS_TIME_ZONE = "Asia/Tokyo";
      PAPERLESS_URL = "http://" + cfg.network.serverDomain + ":" + toString cfg.ports.paperless;
      PAPERLESS_ALLOWED_HOSTS = cfg.network.serverDomain + ",localhost,127.0.0.1," + cfg.network.serverIP;
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