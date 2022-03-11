{
  /**
   * Creates a [row](https://grafana.com/docs/grafana/latest/features/dashboard/dashboards/#rows).
   * Rows are logical dividers within a dashboard and used to group panels together.
   *
   * @name row.new
   *
   * @param title The title of the row.
   */
  new(
    title='Dashboard timeseries',
    datasource=null,
    colormode='palette-classic',
    axisPlacement='auto',
    drawStyle='line',
    fillOpacity=0,
    gradientMode='none',
    lineInterpolation='linear',
    linefill='solid',
    lineWidth=1
  ):: {
    type: 'timeseries',
    title: title,
    datasource: datasource,
    filedConfig: {
        default: {
            color: {
                mode: colormode,
            },
            custom: {
                axisLabel: '',
                axisPlacement: axisPlacement,
                barAlignment: 0,
                drawStyle: drawStyle,
                fillOpacity: fillOpacity,
                gradientMode: gradientMode,
                hideFrom: {
                    legend: false,
                    tooltip: false,
                    viz: false,
                },
                lineInterpolation: lineInterpolation,
                lineStyle: {
                    fill: linefill,
                    dash: [
                        10, 10,
                    ],
                },
                lineWidth: lineWidth,
            },
        },
    },

  },
}
