local grafana = import './grafonnet-lib/grafonnet/grafana.libsonnet';
                        
local dashboard = grafana.dashboard;
local timeseries = grafana.timeseries;
local prometheus = grafana.prometheus;
local newrow = grafana.newrow;

local totalgrid = 2;
local panel_hight = 8;

local ts(title, panelunit) =
  timeseries.new(
    title,
    unit=panelunit
  );

local pm(legend, exp) =
  prometheus.target(
    exp,
    legendFormat=legend
  );

local panpos(x, y) = {
    w: 24/totalgrid,
    h: panel_hight,
    x: 24/totalgrid*(x%totalgrid),
    y: y
};

local rowpos(y) = {
    w: 24,
    h: 1,
    x: 0,
    y: y
};

local row(title) =
  newrow.new( title );

local addy(addrow, rawgroup, yy=0) = {
  yy: yy,
  local rowf = if addrow then 1 else 0,
  local onemore = if rawgroup%totalgrid > 0 then 0 else 1,
  newyy: self.yy + rowf + ((rawgroup-rawgroup%totalgrid)/totalgrid-onemore+1)*panel_hight,
};

dashboard.new(
  'Cluster WorkerNode-eunvit',
)
.addPanel(
  row('Node Info'),
  rowpos(0),
)
.addPanel(
  ts('Node Count ( Fail Count )', 'none')
  .addTarget(
    pm('Total', 'sum( kube_node_labels)'),
  )
  .addTarget(
        pm('status: {{status}}','sum( kube_node_status_condition{condition=\"Ready\", status!=\"true\"} ) by ( status)'),
  ),
  panpos(0, 1),
)
.addPanel(
  ts('Uptime Node ( Day )', 'percentunit')
  .addTarget(
    pm('{{instance}}', '( node_time_seconds - node_boot_time_seconds ) / 3600'),
  ),
  panpos(1, 1),
)


.addPanel(
  row('CPU'),
  rowpos(9),
)
.addPanel(
  ts('Total CPU Capa', 'none')
  .addTarget(
    pm('Tot Capacity', ' sum( kube_node_status_capacity{ resource=\"cpu\" } )'),
  )
  .addTarget(
    pm('Tot Available','sum( rate(node_cpu_seconds_total{mode=\"idle\" } [5m]) )'),
  ),
  panpos(0, 10),
)
.addPanel(
  ts('Total CPU Avg Utilization(%)', 'percentunit')
  .addTarget(
    pm('Total', 'sum(instance:node_cpu_utilisation:rate5m{job=\"node-exporter\"}) / count(instance:node_cpu_utilisation:rate5m{job=\"node-exporter\"})'),
  )
  .addTarget(
    pm('{{instance}}',' instance:node_cpu_utilisation:rate5m{job=\"node-exporter\"}'),
  ),
  panpos(1, 10),
)
.addPanel(
  ts('Node CPU Capacity(Core)', 'none')
  .addTarget(
    pm('{{node}}','AVG( kube_node_status_capacity{ resource=\"cpu\" } ) by ( node)'),
  ),
  panpos(2, 10),
)


.addPanel(
  row('Memory'),
  rowpos(26),
)
.addPanel(
  ts('Total Memory Capacity(GB)', 'decbytes')
  .addTarget(
    pm('Tot', ' sum( kube_node_status_capacity{ resource=\"memory\" } )\n'),
  )
  .addTarget(
    pm('Available',' :node_memory_MemAvailable_bytes:sum'),
  ),
  panpos(0, 27),
)
.addPanel(
  ts('Total Memory AVG Utilization(%)', 'percentunit')
  .addTarget(
    pm('Tot AVG', 'sum(instance:node_memory_utilisation:ratio{job=\"node-exporter\", job=\"node-exporter\"})/\ncount(instance:node_memory_utilisation:ratio{job=\"node-exporter\", job=\"node-exporter\"})'),
  ),
  panpos(1, 27),
)
.addPanel(
  ts('Node Memory Capacity(GB)', 'decbytes')
  .addTarget(
    pm('{{node}}','AVG(kube_node_status_capacity{ resource=\"memory\" })by ( node)'),
  ),
  panpos(2, 27),
)
.addPanel(
  ts('Node Memory Utilization(%)', 'percentunit')
  .addTarget(
    pm('{{instance}}',' instance:node_memory_utilisation:ratio{job=\"node-exporter\", job=\"node-exporter\" }'),
  ),
  panpos(3, 27),
)


.addPanel(
  row('Storage'),
  rowpos(43),
)
.addPanel(
  ts('Total Storage Capa', 'bytes')
  .addTarget(
    pm('Total Use', 'sum( node_filesystem_size_bytes{fstype !=\"tmpfs\", mountpoint!=\"/boot\"} )'),
  )
  .addTarget(
    pm('Available','sum( node_filesystem_avail_bytes{fstype !=\"tmpfs\", mountpoint!=\"/boot\"} )'),
  ),
  panpos(0, 44),
)
.addPanel(
  ts('Tot Storage  AVG Utilization', 'percentunit')
  .addTarget(
    pm('AVG', 'avg( 100-  (  node_filesystem_avail_bytes{fstype !=\"tmpf\", mountpoint!=\"/boot\" } / node_filesystem_size_bytes{ fstype !=\"tmpfs\", mountpoint!=\"/boot\"} ) * 100 )'),
  ),
  panpos(1, 44),
)
.addPanel(
  ts('Node Storage Capacity (GB)', 'bytes')
  .addTarget(
    pm('{{instance}}','node_filesystem_size_bytes{fstype !=\"tmpfs\", mountpoint!=\"/boot\"} '),
  ),
  panpos(2, 44),
)
.addPanel(
  ts('Total Ephemeral storage', 'decbytes')
  .addTarget(
    pm('Total','sum(kube_node_status_capacity{ resource=\"ephemeral_storage\" })'),
  )
  .addTarget(
    pm('Available','sum(kube_node_status_capacity{ resource=\"ephemeral_storage\" }) -sum(kube_node_status_allocatable{resource=\"ephemeral_storage\"})'),
  ),
  panpos(3, 44),
)
.addPanel(
  ts('Total node_disk_io_time_seconds_total', 'none')
  .addTarget(
    pm('Total', 'sum(rate(node_disk_io_time_seconds_total[5m]))'),
  )
  .addTarget(
    pm('{{instance}}','sum(rate(node_disk_io_time_seconds_total[5m])) by ( instance )'),
  ),
  panpos(4, 44),
)
.addPanel(
  ts('Node  Storage Utilization(%)', 'percentunit')
  .addTarget(
    pm('{{instance}}', '100- ( node_filesystem_avail_bytes{fstype !=\"tmpfs\", mountpoint !=\"boot\"}  /  node_filesystem_size_bytes{ fstype !=\"tmpfs\", mountpoint!=\"/boot\"}  ) * 100\n'),
  ),
  panpos(5, 44),
)
.addPanel(
  ts('Total node_disk_io_time_weighted_seconds_total', 'none')
  .addTarget(
    pm('','sum( rate(node_disk_io_time_weighted_seconds_total [5m]))'),
  )
  .addTarget(
    pm('{{instance}}','sum( rate(node_disk_io_time_weighted_seconds_total [5m])) by ( instance)'),
  ),  
  panpos(6, 44),
)
.addPanel(
  ts('Node Storage Use (GB)', 'bytes')
  .addTarget(
    pm('{{instance}}','sum ( node_filesystem_size_bytes{ fstype !=\"tmpfs\", mountpoint!=\"/boot\"} - node_filesystem_avail_bytes{fstype !=\"tmpfs\", mountpoint!=\"/boot\"} ) by ( instance)'),
  ),
  panpos(7, 44),
)
.addPanel(
  ts('Total io time ', 'none')
  .addTarget(
    pm('io time: {{instance}}','sum(rate(node_disk_io_time_seconds_total[5m])) by( instance)'),
  )
  .addTarget(
    pm('Total','sum(rate(node_disk_io_time_seconds_total[5m]))'),
  ),  
  panpos(8, 44),
)
.addPanel(
  ts('Node node_disk_io_time_weighted_seconds_total', 'none')
  .addTarget(
    pm('Read time: {{instance}}','sum(rate(node_disk_read_time_seconds_total[5m])) by( instance)'),
  )
  .addTarget(
    pm('Write time : {{instance}}','sum(rate(node_disk_write_time_seconds_total[5m])) by( instance)  * -1'),
  ),  
  panpos(9, 44),
)


.addPanel(
  row('Network'),
  rowpos(84),
)
.addPanel(
  ts('Total Network Total  (byte)', 'bytes')
  .addTarget(
    pm('eth', 'sum(rate(node_network_receive_bytes_total{device=~\"e.+\"}[5m])) + sum(rate(node_network_transmit_bytes_total{device=~\"e.+\"}[5m]))'),
  )
  .addTarget(
    pm('Common Network Interface','sum(rate(node_network_receive_bytes_total{device=~\"cni.+\"}[5m])) + sum(rate(node_network_transmit_bytes_total{device=~\"cni.+\"}[5m]))'),
  ),
  panpos(0, 85),
)
.addPanel(
  ts('Total Network Packet', 'none')
  .addTarget(
    pm('eth receive', 'sum(rate(node_network_receive_packets_total{device=~\"e.+\"}[5m]))'),
  )
  .addTarget(
    pm('CNI Receive', 'sum(rate(node_network_receive_packets_total{device=~\"cni.+\"}[5m]))'),
  )
  .addTarget(
    pm('eth transmi', 'sum(rate(node_network_transmit_packets_total{device=~\"e.+\"}[5m])) * -1'),
  )
  .addTarget(
    pm('CNI transmit', 'sum(rate(node_network_transmit_packets_total{device=~\"cni.+\"}[5m])) * -1'),
  ),      
  panpos(1, 85),
)
.addPanel(
  ts('Total Network Receive byte', 'bytes')
  .addTarget(
    pm('Receive','sum(rate(node_network_receive_bytes_total{device=~\"e.+\"}[5m]))'),
  )
  .addTarget(
    pm('Transmit','sum(rate(node_network_transmit_bytes_total{device=~\"e.+\"}[5m]))* -1'),
  ),  
  panpos(2, 85),
)
.addPanel(
  ts('Total Network Drop', 'none')
  .addTarget(
    pm('receive','sum(rate(node_network_receive_drop_total[5m]))'),
  )
  .addTarget(
    pm('transmit','sum(rate(node_network_transmit_drop_total[5m]))'),
  ),
  panpos(3, 85),
)
.addPanel(
  ts('Node Network Receive + Transmit ( bytes )', 'none')
  .addTarget(
    pm('{{instance}}', 'sum(rate(node_network_receive_bytes_total{device=~\"e.+\"}[5m])) by(instance) + sum(rate(node_network_transmit_bytes_total{device=~\"e.+\"}[5m])) by (instance)'),
  ),
  panpos(4, 85),
)
.addPanel(
  ts('Node Network  Drop', 'none')
  .addTarget(
    pm('receive {{instance}}', 'sum(rate(node_network_receive_drop_total{}[5m])) by(instance)'),
  )
  .addTarget(
    pm('tranmit {{instance}}', '(sum(rate(node_network_transmit_drop_total{}[5m])) by (instance) ) * -1'),
  ),  
  panpos(5, 85),
)
.addPanel(
  ts('Total Network Error ', 'none')
  .addTarget(
    pm('receive','sum(rate(node_network_receive_errs_total[5m]))'),
  )
  .addTarget(
    pm('transmit','sum(rate(node_network_transmit_errs_total[5m])) * -1'),
  ),  
  panpos(6, 85),
)
.addPanel(
  ts('Node Network Error', 'none')
  .addTarget(
    pm('receive: {{instance}}','sum(rate(node_network_receive_errs_total[5m])) by ( instance)'),
  )
  .addTarget(
    pm('transmit: {{instance}}','sum(rate(node_network_transmit_errs_total[5m])) by ( instance) * -1'),
  ),  
  panpos(7, 85),
)