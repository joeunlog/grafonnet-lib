local grafana = import 'grafonnet/grafana.libsonnet';

grafana.timeseries.new(
    title='test'
    )