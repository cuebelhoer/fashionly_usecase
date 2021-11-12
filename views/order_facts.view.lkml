view: order_facts {
  derived_table: {
    explore_source: order_items {
      filters: [order_items.status: "-Cancelled,-Returned"]
      column: user_id {}
      column: order_id { field: order_items.id }
      column: created_date { field: order_items.created_date}
      derived_column: order_sequence {
        sql: ROW_NUMBER() OVER (Partition by user_id order by created_date ASC) ;;}
      derived_column: last_order_date{
        sql: LEAD(created_date) OVER (Partition by user_id order by created_date DESC);;}
      derived_column: next_order_date{
        sql: LAG(created_date) OVER (Partition by user_id order by created_date DESC);;}
      }

}
  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
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
      year]
    sql: ${TABLE}.created_date ;;
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }

  dimension: last_order_date{
    type: date
    sql: ${TABLE}.last_order_date ;;
  }

  dimension: next_order_date{
    type: date
    sql: ${TABLE}.next_order_date ;;
  }

  dimension: days_between_orders{
    description: "The number of days between one order and the next order"
    type: duration_day
    sql_start: ${last_order_date}  ;;
    sql_end:  ${created_date} ;;
  }

  dimension: has_subsequent_order{
    description: "Indicator for whether or not a customer placed a subsequent order on the website"
    type: yesno
    sql: ${next_order_date} >= ${created_date} ;;
  }

  dimension: is_first_purchase {
    description: "Indicates whether or not order has been the first purchase of customer"
    type: yesno
    sql:  ${order_sequence} = 1 ;;
  }

  measure: avg_days_between_orders{
    description: "The number of days between one order and the next order"
    type: average
    sql: ${days_between_orders};;
  }

  measure: max_days_between_orders {
    description: "The maximum number of days between two orders"
    type: max
    sql: ${days_between_orders} ;;
  }

  dimension: is_repeat_purchase_customer_60_days{
    description: "Yes, if customers that have purchased from the website again within 60 days of a prior purchase"
    type: yesno
    sql:  ${days_between_orders} <= 60 ;;
  }

  measure: count_repeat_purchase_customer_60_days{
    description: "Count the number of repeat customers that purchased again within 60 days"
    type:  count_distinct
    sql: ${user_id} ;;
    filters: [is_repeat_purchase_customer_60_days: "yes"]
  }

  measure: num_customers {
    description: "Count the number of customers"
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: ratio_repeat_customers {
    description: "The ratio between repeat customers and non reapeat customers"
    type: number
    sql: safe_divide(${count_repeat_purchase_customer_60_days}, ${num_customers});;
    value_format_name: percent_2
  }

  measure: count {
    type: count
  }

 }
