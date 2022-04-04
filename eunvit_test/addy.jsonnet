local grafana = import './grafonnet-lib/grafonnet/grafana.libsonnet';
                        
local dashboard = grafana.dashboard;
local timeseries = grafana.timeseries;
local prometheus = grafana.prometheus;
local newrow = grafana.newrow;

local totalgrid = 2;
local panel_hight = 8;


local ts(title) =
  timeseries.new( title );

local pm(legend, exp) =
  prometheus.target(
    exp,
    legendFormat=legend
  );

local panpos(x) = {
    w: 24/totalgrid,
    h: panel_hight,
    x: 24/totalgrid*(x%totalgrid)
};

local rowpos() = {
    w: 24,
    h: 1,
    x: 0
};

local row(title) =
  newrow.new( title );

local addy(addrow, rawgroup, yy=0) = {
  yy: yy,
  local rowf = if addrow then 1 else 0,
  local onemore = if rawgroup%totalgrid > 0 then 0 else 1,
  newyy: self.yy + rowf + ((rawgroup-rawgroup%totalgrid)/totalgrid-onemore+1)*panel_hight,
};


/*
local row_class = {
  row_exist: true,
  [if row_exist then row_title]: row_title,
  panels: [
    {
      title: title,
      legend: legend,
      exp: exp,
    },
  ],
},
*/
/* ----------------------------------------- */

dashboard.new(
  'eunvit-function-test',
)
.addPanel(
  row('Node Info'),
  rowpos(),
)
.addPanel(
  ts('Node Count ( Fail Count )')
  .addTarget(
    pm('Total', 'sum( kube_node_labels)'),
  )
  .addTarget(
        pm('status: {{status}}','sum( kube_node_status_condition{condition=\"Ready\", status!=\"true\"} ) by ( status)'),
  ),
  panpos(0),
)
.addPanel(
  ts('Uptime Node ( Day )')
  .addTarget(
    pm('{{instance}}', '( node_time_seconds - node_boot_time_seconds ) / 3600'),
  ),
  panpos(1),
)

{
  r1: addy(true, 2),
}

.addPanel(
  row('CPU'),
  rowpos(),
)
.addPanel(
  ts('Total CPU Capa')
  .addTarget(
    pm('Tot Capacity', ' sum( kube_node_status_capacity{ resource=\"cpu\" } )'),
  )
  .addTarget(
    pm('Tot Available','sum( rate(node_cpu_seconds_total{mode=\"idle\" } [5m]) )'),
  ),
  panpos(0),
)
.addPanel(
  ts('Total CPU Avg Utilization(%)')
  .addTarget(
    pm('Total', 'sum(instance:node_cpu_utilisation:rate5m{job=\"node-exporter\"}) / count(instance:node_cpu_utilisation:rate5m{job=\"node-exporter\"})'),
  )
  .addTarget(
    pm('{{instance}}',' instance:node_cpu_utilisation:rate5m{job=\"node-exporter\"}'),
  ),
  panpos(1),
)
.addPanel(
  ts('Node CPU Capacity(Core)')
  .addTarget(
    pm('{{node}}','AVG( kube_node_status_capacity{ resource=\"cpu\" } ) by ( node)'),
  ),
  panpos(2),
)

{
  r2: addy(true, 3, $['r1'].newyy ),
}

