#include: "/explores/order_items.explore.lkml"

view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: created_date {}
      column: user_id { field: order_items.user_id }
      #column: order_id { field: order_items.id }
      column: first_order_date { field: order_items.first_order_date }
      column: latest_order_date {field: order_items.latest_order_date}
      column: lifetime_orders { field: order_items.total_orders }
      column: lifetime_revenue { field: order_items.total_gross_revenue }
      derived_column: user_order_sequence {
        sql: RANK() OVER(PARTITION BY user_id ORDER BY created_date ASC) ;;
      }
      filters: [order_items.status: "-Cancelled,-Returned"]
    }
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

  dimension: days_since_last_order {
    description: "The number of days since a customer placed his or her most recent order on the website"
    label: "Days Since Last Order"
    type: duration_day
    sql_start:  ${latest_order_date} ;;
    sql_end: current_date;;
  }

  dimension: tier_orders{
    type: tier
    style: integer
    tiers: [0,1,2,3,6,10]
    sql: ${lifetime_orders} ;;
  }

  dimension: tier_revenue2 {
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
