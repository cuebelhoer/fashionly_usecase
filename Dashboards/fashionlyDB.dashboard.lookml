- dashboard: summary_dashboard
  title: Summary Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: New Tile
    name: New Tile
    model: caroline_fashionly
    explore: order_items
    type: single_value
    fields: [order_items.total_revenue]
    limit: 500
    filter_expression: matches_filter(${order_items.delivered_date}, `yesterday`)
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Total Revenue Yesterday
    defaults_version: 1
    row: 0
    col: 0
    width: 5
    height: 5
  - title: New Tile
    name: New Tile (2)
    model: caroline_fashionly
    explore: order_items
    type: single_value
    fields: [users.created_date, users.num_new_users]
    fill_fields: [users.created_date]
    sorts: [users.created_date desc]
    limit: 500
    filter_expression: matches_filter(${users.created_date}, `yesterday`)
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Total number of New Users Yesterday
    defaults_version: 1
    listen: {}
    row: 0
    col: 5
    width: 5
    height: 5
  - title: New Tile
    name: New Tile (3)
    model: caroline_fashionly
    explore: order_items
    type: single_value
    fields: [order_items.total_gross_margin_percentage]
    filters:
      order_items.delivered_date: 30 days
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Gross Margin % over the Past 30 Days
    defaults_version: 1
    row: 0
    col: 10
    width: 5
    height: 5
  - title: Average Spend per Customer over the Past 30 Days
    name: Average Spend per Customer over the Past 30 Days
    model: caroline_fashionly
    explore: order_items
    type: single_value
    fields: [order_items.avg_spending]
    filters:
      order_items.delivered_date: 30 days
    sorts: [order_items.avg_spending desc]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Average Spend per Customer over the Past 30 Days
    defaults_version: 1
    series_types: {}
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    row: 0
    col: 15
    width: 5
    height: 5
  - title: Yearly Trends
    name: Yearly Trends
    model: caroline_fashionly
    explore: order_items
    type: looker_area
    fields: [order_items.total_revenue, order_items.created_year, order_items.delivered_month_name]
    pivots: [order_items.created_year]
    filters:
      order_items.delivered_date: before 0 minutes ago,4 years
      order_items.total_revenue: NOT NULL
    sorts: [order_items.created_year, order_items.delivered_month_name]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      options:
        steps: 5
        reverse: true
    y_axes: [{label: Revenue, orientation: left, series: [{axisId: order_items.total_revenue,
            id: 2017 - order_items.total_revenue, name: '2017'}, {axisId: order_items.total_revenue,
            id: 2018 - order_items.total_revenue, name: '2018'}, {axisId: order_items.total_revenue,
            id: 2019 - order_items.total_revenue, name: '2019'}, {axisId: order_items.total_revenue,
            id: 2020 - order_items.total_revenue, name: '2020'}, {axisId: order_items.total_revenue,
            id: 2021 - order_items.total_revenue, name: '2021'}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 1,
        type: linear}]
    x_axis_label: Month
    series_types: {}
    series_colors: {}
    series_point_styles: {}
    ordering: none
    show_null_labels: false
    defaults_version: 1
    listen: {}
    row: 5
    col: 0
    width: 10
    height: 7
  - title: Revenue and Profit
    name: Revenue and Profit
    model: caroline_fashionly
    explore: order_items
    type: looker_line
    fields: [order_items.total_gross_margin, order_items.total_revenue, order_items.delivered_month]
    fill_fields: [order_items.delivered_month]
    filters:
      order_items.delivered_month: 12 months
    sorts: [order_items.delivered_month]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    defaults_version: 1
    listen: {}
    row: 5
    col: 10
    width: 10
    height: 7
  - title: Daily User Additions
    name: Daily User Additions
    model: caroline_fashionly
    explore: order_items
    type: looker_column
    fields: [users.created_month, users.num_new_users_mtd]
    fill_fields: [users.created_month]
    filters:
      users.created_month: 2 months
    sorts: [users.created_month desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    row: 12
    col: 0
    width: 10
    height: 7
  - title: Demographics Analysis
    name: Demographics Analysis
    model: caroline_fashionly
    explore: order_items
    type: looker_column
    fields: [users.age_group, order_items.total_revenue, users.gender]
    pivots: [users.gender]
    filters:
      users.age_group: "-Below 15"
    sorts: [users.age_group, users.gender]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: of_total_revenue, label: "% of total revenue",
        expression: 'sum(pivot_row(${order_items.total_revenue}))/sum(sum(pivot_row(${order_items.total_revenue})))

          ', value_format: !!null '', value_format_name: percent_2, _kind_hint: supermeasure,
        _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: order_items.total_revenue,
            id: order_items.total_revenue, name: Total Revenue}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: of_total_revenue,
            id: of_total_revenue, name: "% of total revenue"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    defaults_version: 1
    hidden_fields: [of_total_revenue]
    row: 12
    col: 10
    width: 10
    height: 7
  - title: New Customer Behaviour
    name: New Customer Behaviour
    model: caroline_fashionly
    explore: order_items
    type: looker_area
    fields: [users.customer_tiers, order_items.total_revenue, order_items.delivered_date]
    pivots: [users.customer_tiers]
    fill_fields: [order_items.delivered_date, users.customer_tiers]
    filters:
      order_items.delivered_date: 90 days
    sorts: [users.customer_tiers, order_items.delivered_date desc]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: percent
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      Below 90 - 0 - order_items.total_revenue: New Customers
      90 or Above - 1 - order_items.total_revenue: Longer-term Customers
    ordering: none
    show_null_labels: false
    defaults_version: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    row: 19
    col: 0
    width: 10
    height: 7
  - title: Revenue Source Comparison
    name: Revenue Source Comparison
    model: caroline_fashionly
    explore: order_items
    type: looker_column
    fields: [users.traffic_source, order_items.avg_spend_per_customer, users.customer_tiers]
    pivots: [users.customer_tiers]
    fill_fields: [users.customer_tiers]
    sorts: [users.traffic_source, users.customer_tiers]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_labels:
      Below 90 - 0 - order_items.avg_spend_per_customer: New Customers
      90 or Above - 1 - order_items.avg_spend_per_customer: Longer-term Customers
    defaults_version: 1
    row: 19
    col: 10
    width: 10
    height: 7
  - title: Profitability by Location
    name: Profitability by Location
    model: caroline_fashionly
    explore: order_items
    type: looker_map
    fields: [users.location, order_items.total_gross_margin]
    sorts: [order_items.total_gross_margin desc]
    limit: 500
    column_limit: 50
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    row: 26
    col: 0
    width: 10
    height: 7
  - title: Profitability by Location
    name: Profitability by Location (2)
    model: caroline_fashionly
    explore: order_items
    type: looker_map
    fields: [users.location, order_items.total_gross_margin]
    sorts: [order_items.total_gross_margin desc]
    limit: 500
    column_limit: 50
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: dark
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    row:
    col:
    width:
    height:
  - title: Top Products
    name: Top Products
    model: caroline_fashionly
    explore: order_items
    type: looker_column
    fields: [products.brand, order_items.total_gross_margin_percentage, order_items.total_revenue]
    sorts: [order_items.total_gross_margin_percentage desc]
    limit: 10
    column_limit: 50
    dynamic_fields: [{table_calculation: total_revenue_percentage_of_top_10, label: Total
          Revenue Percentage (of top 10), expression: "${order_items.total_revenue}/sum(${order_items.total_revenue})",
        value_format: !!null '', value_format_name: percent_2, _kind_hint: measure,
        _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: order_items.total_gross_margin_percentage,
            id: order_items.total_gross_margin_percentage, name: Total Gross Margin
              Percentage}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: total_revenue_percentage_of_top_10,
            id: total_revenue_percentage_of_top_10, name: Total Revenue Percentage
              (of top 10)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      order_items.total_gross_margin_percentage: "#1A73E8"
    series_labels:
      order_items.total_gross_margin_percentage: Total Gross Margin (%)
      total_revenue_percentage_of_top_10: Total Revenue (% of top 10)
    defaults_version: 1
    hidden_fields: [order_items.total_revenue]
    row:
    col:
    width:
    height:
