#include: "/explores/order_items.explore.lkml"

view: user_nativeDT {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: order_items.user_id }
      column: order_id { field: order_items.id }
      column: first_order_date { field: order_items.first_order_date }
      column: latest_order_date {field: order_items.latest_order_date}
      column: lifetime_orders { field: order_items.total_orders }
      derived_column: user_order_sequence {
        sql: RANK() OVER(PARTITION BY order_items.user_id ORDER BY order_items.created_at ASC) ;;
      }
      filters: [order_items.status: "-Cancelled,-Returned"]
    }
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id{
    type: number
    sql: ${TABLE}.order_id ;;

  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
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
  }

  dimension_group: latest_order_date{
    type: time
    sql: ${TABLE}.latest_order_date ;;
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
  }

  dimension: lifetime_orders{
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }
}
