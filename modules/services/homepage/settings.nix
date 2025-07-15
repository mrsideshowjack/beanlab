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
      };
    }
    {
      "Media" = {
        style = "column";
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