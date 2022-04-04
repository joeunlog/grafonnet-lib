local grafana = import './grafonnet-lib/grafonnet/grafana.libsonnet';
                        
local dashboard = grafana.dashboard;
local row = grafana.row;
local timeseries = grafana.timeseries;
local prometheus = grafana.prometheus;
local newrow = grafana.newrow;

dashboard.new(
  'eunvit-test',
)
.addPanel(
  newrow.new(
    'Node Info',
  ),
  gridPos={
    w: 24,
    h: 1,
    x: 0,
  }
)
.addPanel(
  timeseries.new(
    'Node Count ( Fail Count )',
  )
  .addTarget(
    prometheus.target(
      'sum( kube_node_labels)',
      legendFormat='Total',
    )
  )
  .addTarget(
    prometheus.target(
      'sum( kube_node_status_condition{condition=\"Ready\", status!=\"true\"} ) by ( status)',
      legendFormat='status: {{status}}',
    )
  ),   
  gridPos={
    w: 12,
    h: 9,
    x: 0,
  }
)
.addPanel(
  timeseries.new(
    'Uptime Node ( Day )',
  )
  .addTarget(
    prometheus.target(
      '( node_time_seconds - node_boot_time_seconds ) / 3600',
      legendFormat='{{instance}}',
    )
  ), gridPos={
    w: 12,
    h: 9,
    x: 12,
  }
)


