# Homepage dashboard settings configuration
{ config }: 

{
  title = "Beanlab";
  headerStyle = "clean";
  statusStyle = "dot";
  hideVersion = true;

  theme = "dark";

  layout = [
    {
      "Media Services" = {
        style = "row";
        columns = 2;
      };
    }
    {
      "System Monitoring" = {
        style = "row";
        columns = 4;
      };
    }
  ];
} 