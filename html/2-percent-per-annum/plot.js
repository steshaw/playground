
var timeplot;
var eventSource = new Timeplot.DefaultEventSource();

function onLoad() {
  var plotInfo = [
    Timeplot.createPlotInfo({
      id: "plot1",
      dataSource: new Timeplot.ColumnSource(eventSource, 1),
      valueGeometry: new Timeplot.DefaultValueGeometry({
        gridColor: "#000000",
        axisLabelsPlacement: "left"
      })
    })
  ];

  timeplot = Timeplot.create(document.getElementById("my-timeplot"), plotInfo);
  timeplot.loadText("data.txt", ",", eventSource);
}

var resizeTimerID = null;
function onResize() {
    if (resizeTimerID == null) {
        resizeTimerID = window.setTimeout(function() {
            resizeTimerID = null;
            timeplot.repaint();
        }, 100);
    }
}
