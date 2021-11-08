view: user_item_order {
  derived_table: {
    sql: SELECT
          order_items.user_id  AS users_id,
          order_items.id as orders_id,
          order_items.created_at as order_date,
          COUNT(*) AS all_items,
          COUNT(DISTINCT order_items.order_id) AS distinct_orders,
          COALESCE(SUM(CASE WHEN (order_items.status <> 'Returned' OR order_items.status IS NULL) THEN order_items.sale_price  ELSE NULL END), 0) AS total_gross_revenue,
          MIN((order_items.created_at)) as first_order,
          MAX((order_items.created_at)) as latest_order,
          COUNT(DISTINCT EXTRACT(month from (order_items.created_at))) as number_of_distinct_months_with_orders,
          SUM(order_items.sale_price) as lifetime_revenue,
          RANK() OVER(PARTITION BY order_items.user_id ORDER BY order_items.created_at ASC) as user_order_sequence_number
       FROM `thelook.order_items`
           AS order_items
      WHERE ((TIMESTAMP_TRUNC(order_items.created_at , DAY)) <=  (TIMESTAMP_TRUNC(order_items.created_at , DAY)))
      GROUP BY users_id, orders_id, order_date
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.users_id ;;
  }

  dimension: all_items {
    type: number
    sql: ${TABLE}.all_items ;;
  }

  dimension: distinct_orders {
    type: number
    sql: ${TABLE}.distinct_orders ;;
  }

  dimension: total_gross_revenue {
    type: number
    sql: ${TABLE}.total_gross_revenue ;;
    value_format_name:  usd
  }

  dimension: first_order {
    type: date
    sql: ${TABLE}.first_order ;;
  }

  dimension: latest_order {
    type: date
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: user_order_sequence_number{
    type: number
    sql: ${TABLE}.user_order_sequence_number;;
  }

  set: detail {
    fields: [users_id, all_items, distinct_orders]
  }



  ##### Dimensions #####

  dimension: days_since_last_order {
    description: "The number of days since a customer placed his or her most recent order on the website"
    label: "Days Since Last Order"
    type: number
    sql:  datediff(d, current_date(),  ${latest_order});;
    value_format_name: decimal_0
  }

  dimension: tier_orders{
    type: tier
    style: integer
    tiers: [0,1,2,3,6,10]
    sql: ${distinct_orders} ;;
  }

  dimension: tier_revenue2 {
    alpha_sort: yes
    case: {
      when: {
        sql: ${total_gross_revenue} < 5.00;;
        label: "$0.00 - $4.99"
      }
      when: {
        sql: ${total_gross_revenue} >= 5.00 AND ${total_gross_revenue} < 20.00;;
        label: "$5.00 - $19.99"
      }
      when: {
        sql: ${total_gross_revenue} >= 20.00 AND ${total_gross_revenue} < 50.00;;
        label: "$20.00 - $49.99"
      }
      when: {
        sql: ${total_gross_revenue} >= 50.00 AND ${total_gross_revenue} < 100.00;;
        label: "$50.00 - $99.99"
      }
      when: {
        sql: ${total_gross_revenue} >= 100.00 AND ${total_gross_revenue} < 500.00;;
        label: "$100.00 - $499.99"
      }
      when: {
        sql: ${total_gross_revenue} >= 500.00 AND ${total_gross_revenue} < 1000.00;;
        label: "$500.00 - $999.99"
      }
      when: {
        sql: ${total_gross_revenue} > 1000.00;;
        label: "$10000+"
      }
      else:"Unknown"
    }
  }

  dimension: is_active {
    description: "Identifies whether a customer is active or not (has purchased from the website within the last 90 days)"
    label: "Is Active"
    type: yesno
    sql: datediff(d, current_date(), ${latest_order}) <= 90 ;;
  }

  dimension: is_repeat_customer{
    description: "Identifies whether a customer was a repeat customer or not"
    label: "Is First Purchase"
    type: number
    sql: Max(${user_order_sequence_number});;
  }

  dimension: total_lifetime_orders {
    description: "The total number of orders placed over the course of customers’ lifetimes."
    label: "Total Lifetime Orders"
    type:  number
    sql:   ${TABLE}.total_lifetime_orders ;;
  }

  ##### Measures #####


  measure: avg_lifetime_orders {
    description: "The average number of orders that a customer places over the course of their lifetime as a customer."
    label: "Average Lifetime Orders"
    type: number
    sql: ${total_lifetime_orders}/NULLIF(${users.days_since_signup},0) ;;
    value_format_name: decimal_0
  }

  measure: total_lifetime_revenues {
    description: "The total number of orders placed over the course of customers’ lifetimes."
    label: "Total Lifetime Revenues"
    type: sum
    sql:  ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: avg_lifetime_revenue {
    description: "The average amount of revenue that a customer brings in over the course of their lifetime as a customer."
    label: "Average Lifetime Revenue"
    type: average
    sql: ${lifetime_revenue} ;;
    value_format_name: usd
  }

  measure: avg_days_since_last_order {
    description: "The average number of days since customers have placed their most recent orders on the website"
    label: "Avg Days Since Last Order"
    type: average
    sql: ${days_since_last_order} ;;
    value_format_name: decimal_0
  }


}
