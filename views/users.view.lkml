view: users {
  sql_table_name: `thelook.users`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }


#### Dimensions ####

  dimension: : is_created_mtd{
    description: "Will return yes if the date is before today"
    type: yesno
    sql:  EXTRACT(DAY from ${created_date}) <= EXTRACT(DAY from current_date())     ;;
  }


  dimension: age_group {
    description: "This field will group the customers into different age groups"
    type:  tier
    tiers: [15,26,36,51,66]
    style: integer
    sql: ${age} ;;
  }

  dimension: days_since_signup {
    description: "This field will return the number of days since sign up"
    type: number
    sql:  DATE_DIFF(current_date(), ${created_date}, DAY) ;;
    value_format_name: decimal_0
  }

  dimension: is_new_customer {
    description: "This field will return yes if the created day for the customer is less than 90 days ago"
    type: yesno
    sql:  ${days_since_signup} <= 90 ;;
  }

  dimension: customer_tiers {
    description: "This field will group the customers into new and longer-term customers"
    type: tier
    tiers: [90]
    style: integer
    sql: ${days_since_signup} ;;
  }

  dimension: current_date {
    type: date
    sql:  current_date() ;;
  }


  dimension: location {
    type: location
    sql_latitude:${latitude} ;;
    sql_longitude:${longitude} ;;
    drill_fields: [products.category, products.brand]

  }

#### Measures ####

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  measure: num_new_users{
    type: count_distinct
    sql: ${id};;
    }

  measure: num_new_users_mtd{
    type: count_distinct
    sql: ${id};;
    filters: [is_created_mtd: "yes"]
  }


}
