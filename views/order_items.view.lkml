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

  measure: first_order_date {
    description: "The date in which a customer placed his or her first order on the fashion.ly website"
    label: "First Order Date"
    type: min
    sql:  ${created_date} ;;
  }

  measure: latest_order_date {
    description: "The date in which a customer placed his or her first order on the fashion.ly website"
    label: "First Order Date"
    type: max
    sql:  ${created_date} ;;
  }
##### Measures #####

  measure: total_orders {
    description: "Total number of orders (cancelled and returned orders excluded)"
    type: sum
    sql: 1 ;;
    filters: [status: "-Cancelled,-Returned"]
  }

  measure: total_orders2 {
    description: "Total number of orders (cancelled and returned orders excluded)"
    type: count
    filters: [status: "-Cancelled,-Returned"]
  }

  measure: total_sale_price {
    description: "This is the total of sold products (sum of sale prices). All orders included."
    label: "Total Sale Price"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: avg_sale_price {
    description: "Total Sale Price / total number of customers."
    label: "Average Sale Price"
    type: number
    sql: ${total_sale_price}/ NULLIF(${num_distinct_customers},0) ;;
    value_format_name: usd_0
  }


  #Am I repeating myself here? DRY?
  measure: cumulative_total_sales {
    description: "Use with table calculations! This is the cumulative total sales from items sold (also known as a running total) ."
    label: "Cumulative Total Sales"
    type: number
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
  }

  measure: total_gross_revenue {
    description: "This is the total of sold products (sum of sale prices), excluding cancelled and returned orders."
    label: "Total Gross Revenue"
    type: sum
    sql: ${sale_price} ;;
    filters:  [status: "-Cancelled", status: "-Returned"]
    value_format_name: usd
  }

  measure: total_gross_revenue_last_30_days {
    description: "This is the total of sold products (sum of sale prices), excluding cancelled and returned orders."
    label: "Total Gross Revenue last 30 days"
    type: sum
    sql: ${sale_price} ;;
    filters:  [status: "-Cancelled", status: "-Returned", created_date: "last 30 days"]
    value_format_name: usd
  }

  #Total & Average cost -> inventory items

  measure: total_gross_margin {
    description: "This is the total difference between the total revenue from completed sales and the cost of the goods that were sold"
    label: "Total Gross Margin"
    type:  number
    sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
    value_format_name: usd_0
  }



  #Average Gross Margin -> Use Total Gross Margin per product and create Average with Table calculations

  measure: total_gross_margin_percentage {
    description: "This is the total gross margin, divided by the total revenue"
    label: "Total Gross Margin Percentage"
    type: number
    value_format_name: percent_2
    sql: ${total_gross_margin}/NULLIF(${total_gross_revenue}, 0) ;;
  }

  measure: num_items_returned {
    description: "This is the number of items that were returned by dissatisfied customers"
    label: "Number of Items Returned"
    type: count_distinct
    sql: ${id} ;;
    filters:  [status: "Returned"]
    value_format_name: decimal_0
  }


  measure: num_items_sold {
    description: "This is the number of items that were sold"
    label: "Number of Items Sold"
    type: count_distinct
    sql: ${id} ;;
    filters:  [status: "-Cancelled", status: "-Returned"]
    value_format_name: decimal_0
  }


  measure: item_return_rate {
    description: "This is the number of items returned/ total number of items sold."
    label: "Item Return Rate"
    type: number
    sql: ${num_items_returned}/ NULLIF(${num_items_sold}, 0);;
    value_format_name: percent_2
  }

  measure: num_customers_returning_items {
    description: "Number of customers who have returned an item at some point"
    label: "Number of Customers Returning Items"
    type: count_distinct
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    value_format_name: decimal_0
  }

  measure: num_users_with_returns_percentage {
    description: "Number of customers returning items/ total number of customers."
    label: "Percentage of Users with Returns"
    type: number
    sql:  ${num_customers_returning_items}/NULLIF(${num_distinct_customers}, 0) ;;
    value_format_name: decimal_0
  }

  measure: num_distinct_customers {
    description: "This is the total/number of distinct customers."
    label: "Number of Distinct Customers"
    type: count_distinct
    sql: ${user_id} ;;
    value_format_name: decimal_0
  }

  measure: avg_spend_per_customer {
    description: "This is the average spending (in terms of revenue) per customer."
    label: "Average Spend per Customer"
    type: number
    sql: ${total_gross_revenue}/NULLIF(${num_distinct_customers}, 0)  ;;
    drill_fields: [drill1*]
    value_format_name: usd_0
  }

  measure: avg_spending  {
    description: "Average sale Price of Items Sold"
    label: "Average Spending"
    type: average
    sql:  ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: count {
    type: count
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

  set: drill1 {
    fields: [
      users.traffic_source,
      users.customer_tiers,
      users.age_group,
      users.age,
      users.city,
      users.gender,
      users.email]
  }


}
