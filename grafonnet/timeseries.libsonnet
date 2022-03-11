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
    how=null
  ):: {
    title: title,
    how: how,
  },
}
