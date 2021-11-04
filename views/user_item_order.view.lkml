view: user_item_order {
  derived_table: {
    sql: SELECT
          users.id  AS users_id,
          COUNT(*) AS all_items,
          COUNT(DISTINCT order_items.order_id) AS distinct_orders,
          COALESCE(SUM(CASE WHEN (order_items.status <> 'Returned' OR order_items.status IS NULL) THEN order_items.sale_price  ELSE NULL END), 0) AS total_gross_revenue
       FROM `thelook.order_items`
           AS order_items
      LEFT JOIN `thelook.users`
           AS users ON order_items.user_id = users.id
      WHERE ((TIMESTAMP_TRUNC(users.created_at , DAY)) <=  (TIMESTAMP_TRUNC(order_items.created_at , DAY)))
      GROUP BY
          users_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_id {
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

  set: detail {
    fields: [users_id, all_items, distinct_orders]
  }

  ##### Dimensions #####

  dimension: tier_orders{
    type: tier
    style: integer
    tiers: [0,1,2,3,6,10]
    sql: ${distinct_orders} ;;
  }


  dimension: tier_revenue{
    type: tier
    style: interval
    tiers: [0,5,20,50,100,500,1000]
    sql: ${total_gross_revenue} ;;
    value_format_name: usd
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



    ##### Measures #####

    measure: total_lifetime_orders {
      description: "The total number of orders placed over the course of customers’ lifetimes."
      label: "Total Lifetime Orders"
      type:  sum
      sql:  ${distinct_orders} ;;
    }

    measure: avg_lifetime_orders {
      description: "The average number of orders that a customer places over the course of their lifetime as a customer."
      label: "Average Orders"
      type: number
      sql: ${total_lifetime_orders}/${users.days_since_signup} ;;
      value_format_name: decimal_0
    }

}
