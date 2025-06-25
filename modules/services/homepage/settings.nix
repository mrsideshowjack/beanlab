# Homepage dashboard settings configuration
{ config }: 

{
  title = "Beanlab";
  headerStyle = "clean";
  statusStyle = "dot";
  hideVersion = true;

  theme = "dark";
  color = "slate";

  layout = [
    {
      "Arr" = {
        style = "column";
        rows = 4;
      }
    }
    {
      "Media Services" = {
        style = "column";
        rows = 4;
      };
    }
    {
      "System Monitoring" = {
        style = "column";
        rows = 4;
      };
    }
  ];
} 