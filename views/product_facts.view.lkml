#include: "/explores/order_items.explore.lkml"

view: product_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: product_id {field: products.id}
      column: count {}
      filters: [order_items.status: "-Cancelled,-Returned"]
      filters: [order_items.count: "> 0"]
    }
  }


  ##### Dimensions #####

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: product_id{
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: count {
    type:  number
    sql:  ${TABLE}.count ;;
  }

### Measures ###

  measure: num_orders {
    type: count
  }

  measure: num_repeat_customers{
    type: count_distinct
    sql:  ${user_id} ;;
    filters: [count: ">1"]
  }

  measure: num_one_time_customers {
    type: count_distinct
    sql:  ${user_id} ;;
    filters: [count: "=1"]
  }


}
