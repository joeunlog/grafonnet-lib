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
    colormode='palette-classic'
  ):: {
    type: 'timeseries',
    title: title,
    datasource: datasource,
    filedConfig: {
        default: {
            color: {
                mode: colormode,
            },
        },
    },

  },
}
