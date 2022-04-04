local grafana = import './grafonnet-lib/grafonnet/grafana.libsonnet';

grafana.graphPanel.new(
    title='test'
    )