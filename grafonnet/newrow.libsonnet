{
  new(
    title='Dashboard Row',
    collapsed=false,
    datasource=null,
    x=0,
    y=0,
    h=1,
    w=24,
    id="temporary"
  ):: {
    collapsed: collapsed,
    datasource: datasource,
    gridPos: {
      h: h,
      w: w,
      x: x,
      y: y,
    },
    id: id,
    panels: [],
    title: title,
    type: 'row',
  },
}

