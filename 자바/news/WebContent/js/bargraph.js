am4core.ready(function() {

// Themes begin
am4core.useTheme(am4themes_animated);
// Themes end

// Create chart instance 
var chart = am4core.create("now_graph", am4charts.XYChart);

// Add data
chart.data = [{
  "카테고리": x[0],
  "건수": y[0]
}, {
  "카테고리": x[1],
  "건수": y[1]
}, {
  "카테고리": x[2],
  "건수": y[2]
}, {
  "카테고리": x[3],
  "건수": y[3]
}, {
  "카테고리": x[4],
  "건수": y[4]
}, {
  "카테고리": x[5],
  "건수": y[5]
}];


// Create axes
var categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
categoryAxis.dataFields.category = "카테고리";
categoryAxis.renderer.grid.template.location = 0;
categoryAxis.renderer.minGridDistance = 30;
categoryAxis.renderer.labels.template.horizontalCenter = "right";
categoryAxis.renderer.labels.template.verticalCenter = "middle";
categoryAxis.renderer.labels.template.rotation = 300;
var valueAxis = chart.yAxes.push(new am4charts.ValueAxis());

// Create series
var series = chart.series.push(new am4charts.ColumnSeries());
series.dataFields.valueY = "건수";
series.dataFields.categoryX = "카테고리";
series.name = "건수";
series.columns.template.tooltipText = "{categoryX}: [bold]{valueY}[/]";
series.columns.template.fillOpacity = .8;

var columnTemplate = series.columns.template;
columnTemplate.strokeWidth = 2;
columnTemplate.strokeOpacity = 1;

}); // end am4core.ready()

