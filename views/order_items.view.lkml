view: order_items {
  sql_table_name: `thelook.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }



  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

##### Measures #####

  measure: count_distinct_customers {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: avg_spend_per_customer {
    type: number
    sql: ${total_revenue}/NULLIF(${count_distinct_customers}, 0)  ;;
    drill_fields: [users.traffic_source, users.customer_tiers, users.age_group, users.age, users.city, users.gender, users.email]
  }

  measure: total_revenue {
    description: "This is the total of sold products (sum of sale prices)"
    type: sum
    sql: ${sale_price} ;;
    filters:  [status: "-Cancelled", status: "-Returned"]
    value_format_name: usd_0
  }


  measure: total_gross_margin {
    description: "This is the total gross margin, meaning we substract the total costs from the total revenue"
    type:  number
    sql: ${total_revenue} - ${inventory_items.total_cost} ;;
    value_format_name: usd_0
  }

  measure: total_gross_margin_percentage {
    description: "This is the total gross margin, divided by the total revenue"
    type: number
    value_format_name: percent_2
    sql: ${total_gross_margin}/NULLIF(${total_revenue}, 0) ;;
  }

  measure: avg_spending  {
    type: average
    sql:  ${sale_price} ;;
    filters:  [status: "-Cancelled", status: "-Returned"]
    value_format_name: usd_0
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }



}
