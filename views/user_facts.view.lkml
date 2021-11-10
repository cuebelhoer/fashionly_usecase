#include: "/explores/order_items.explore.lkml"
#include: "caroline_fashionly.model.lkml"

view: user_facts {
  derived_table: {
    explore_source: order_items {
      filters: [order_items.status: "-Cancelled,-Returned"]
      column: user_id { field: order_items.user_id }
      column: first_order_date { field: order_items.first_order_date }
      column: latest_order_date {field: order_items.latest_order_date}
      column: lifetime_orders { field: order_items.total_orders }
      column: lifetime_revenue { field: order_items.total_gross_revenue }
      column: gross_revenue_last_30_days {field: order_items.total_gross_revenue_last_30_days}
      #column: most_recent_event_date {field: events.most_recent_event_date}
    }
  }



  measure: count {
    type: count
  }

  ##### Dimensions #####

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id{
    type: number
    sql: ${TABLE}.order_id ;;

  }

  dimension_group: first_order {
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

  dimension_group: latest_order{
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

  dimension: lifetime_revenue {
    type: number
    sql:  ${TABLE}.lifetime_revenue ;;
  }


  dimension: gross_revenue_last_30_days{
    type: number
    sql: ${TABLE}.gross_revenue_last_30_days ;;
  }

  # Orders

  dimension: customer_lifetime_orders{
    type: tier
    style: integer
    tiers: [0,1,2,3,6,10]
    sql: ${lifetime_orders} ;;
  }

  measure: total_gross_revenue_last_30_days {
    description: "The total gross revenue during the last 30 days"
    label: "Total Gross Revenue Last 30 Days"
    type: sum
    sql: ${gross_revenue_last_30_days} ;;
    value_format_name: usd
  }

  measure: total_lifetime_orders {
    description: "The total number of orders placed over the course of customers’ lifetimes."
    label: "Total Lifetime Orders"
    type:  sum
    sql: ${lifetime_orders} ;;
  }

  measure: avg_lifetime_orders {
    description: "The average number of orders that a customer places over the course of their lifetime as a customer."
    label: "Average Lifetime Orders"
    type: average
    sql: ${lifetime_orders} ;;
    value_format_name: decimal_0
  }

  dimension: days_since_last_order {
    description: "The number of days since a customer placed his or her most recent order on the website"
    label: "Days Since Last Order"
    type: duration_day
    sql_start:  ${latest_order_date} ;;
    sql_end: current_date;;
  }


  dimension: is_active {
    description: "Identifies whether a customer is active or not (has purchased from the website within the last 90 days)"
    label: "Is Active"
    type: yesno
    sql: ${days_since_last_order} <= 90 ;;
  }

  dimension: is_repeat_customer {
    description: "Identifies whether a customer was a repeat customer or notv"
    label: "Is Repeat Customer"
    type: yesno
    sql: ${lifetime_orders} > 1  ;;
  }



  # Revenue

  measure: total_lifetime_revenue {
    description: "The total amount of revenue brought in over the course of customers’ lifetimes."
    label: "Total Lifetime Revenue"
    type:  sum
    sql: ${lifetime_revenue} ;;
    value_format_name: usd

  }

  measure: avg_lifetime_revenue {
    description: "The average of revenue brought in over the course of customers’ lifetimes."
    label: "Average Lifetime Revenue"
    type:  average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  dimension: customer_lifetime_revenue {
    alpha_sort: yes
    case: {
      when: {
        sql: ${lifetime_revenue} < 5.00;;
        label: "$0.00 - $4.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 5.00 AND ${lifetime_revenue} < 20.00;;
        label: "$5.00 - $19.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 20.00 AND ${lifetime_revenue} < 50.00;;
        label: "$20.00 - $49.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 50.00 AND ${lifetime_revenue} < 100.00;;
        label: "$50.00 - $99.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 100.00 AND ${lifetime_revenue} < 500.00;;
        label: "$100.00 - $499.99"
      }
      when: {
        sql: ${lifetime_revenue} >= 500.00 AND ${lifetime_revenue} < 1000.00;;
        label: "$500.00 - $999.99"
      }
      when: {
        sql: ${lifetime_revenue} > 1000.00;;
        label: "$10000+"
      }
      else:"Unknown"
    }
  }


}
