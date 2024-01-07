import "application"
import "chart"
import "chartjs-plugin-datalabels"

// Register the plugin to all charts:
Chart.register(ChartDataLabels);

function drawCharts(){
  // ST
  const ctxAll = document.getElementById('stWholePeriodAllChart');
  drawDoughnutChart(ctxAll, 'すべての対局')
  const ctxWhite = document.getElementById('stWholePeriodWhiteChart');
  drawDoughnutChart(ctxWhite, '白番の対局')
  const ctxBlack = document.getElementById('stWholePeriodBlackChart');
  drawDoughnutChart(ctxBlack, '黒番の対局')
  // RP
  const ctxRPAll = document.getElementById('rpWholePeriodAllChart');
  drawDoughnutChart(ctxRPAll, 'すべての対局')
  const ctxRPWhite = document.getElementById('rpWholePeriodWhiteChart');
  drawDoughnutChart(ctxRPWhite, '白番の対局')
  const ctxRPBlack = document.getElementById('rpWholePeriodBlackChart');
  drawDoughnutChart(ctxRPBlack, '黒番の対局')
}

function drawDoughnutChart(ctx, label){
  /**
   * canvasのdivを受け取って勝ち・引分・負けのdoughnut chartを描く
   */

  const data = {
    labels: [
      '勝ち',
      '引分',
      '負け'
    ],
    datasets: [{
      label: label,
      data: [ctx.dataset.win, ctx.dataset.draw, ctx.dataset.loss],
      backgroundColor: [
        'rgb(50,205,50)',
        'rgb(169,169,169)',
        'rgb(255, 99, 132)'
      ],
      hoverOffset: 4
    }]
  };

  new Chart(ctx, {
    type: 'doughnut',
    data: data,
    options: {
      plugins: {
        datalabels: {
          formatter: (value, context) => {
            let total = 0;
            for(const v of context.dataset.data){
              total += Number(v);
            }
            return `${value} (${Math.round(100*value/total)}%)`;
          },
          font: {
            size: 18,
          },
        },
      },
    },
  });
}

window.addEventListener("load", (event) => {
  drawCharts();
});