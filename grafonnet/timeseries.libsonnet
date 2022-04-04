{
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
    lineWidth=1,
    pointSize=5,
    scaleDistributiontype="linear",
    scaleDistributionlog=2,
    showPoints="auto",
    spanNulls=false,
    stackinggroup="A",
    stackingmode="none",
    thresholdsStylemode="off",
    thresholdsmode="absolute",
    thresholdsstepscolor1="red",
    thresholdsstepsvalue1=null,
    unit="none",
    h=8,
    w=12,
    x=0,
    y=0,
    id="temporary",
    legenddisplayMode="list",
    tooltipmode="single",
    expr="",
    interval="",
    legendFormat="",
    refId="A"
  ):: {
    type: 'timeseries',
    title: title,
    datasource: datasource,
    fieldConfig: {
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
                pointSize: pointSize,
                scaleDistribution: {
                    type: scaleDistributiontype,
                    scaleDistributionlog: scaleDistributionlog,
                },
                showPoints: showPoints,
                spanNulls: spanNulls,
                stacking: {
                    group: stackinggroup,
                    mode: stackingmode,
                },
                thresholdsStyle: {
                    mode: thresholdsStylemode,
                },
            },
            mappings: [],
            thresholds: {
                mode: thresholdsmode,
                steps: [
                    {
                        color: thresholdsstepscolor1,
                        value: thresholdsstepsvalue1,
                    },
                ],
            },
            unit: unit,
        },
        overrides: [],
    },
    gridPos: {
        h: h,
        w: w,
        x: x,
        y: y,
    },
    id: id,
    options: {
        legend: {
            calcs: [],
            displayMode: legenddisplayMode,
            placement: "bottom"
        },
        tooltip: {
            mode: tooltipmode,
        },
    },
    targets: [
    ],
    _nextTarget:: 0,
    addTarget(target):: self {
      local nextTarget = super._nextTarget,
      _nextTarget: nextTarget + 1,
      targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
    },
  },
}

