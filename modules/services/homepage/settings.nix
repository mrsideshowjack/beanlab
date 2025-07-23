# Homepage dashboard settings configuration
{ config }: 

{
  title = "Beanlab";
  headerStyle = "clean";
  statusStyle = "dot";
  hideVersion = true;

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