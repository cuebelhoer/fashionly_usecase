connection: "thelook_bq"
# New Code
# This is real new code

# include all the views
include: "/views/**/*.view"

datagroup: caroline_fashionly_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: caroline_fashionly_default_datagroup

explore: distribution_centers {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_facts.user_id}  ;;
    relationship: many_to_one
  }

  join: product_facts {
    type: left_outer
    sql_on: ${products.id} = ${product_facts.product_id}  ;;
    relationship: one_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${events.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

  join: order_facts {
    type: left_outer
    sql_on: ${order_facts.order_id} = ${order_items.id} ;;
    relationship:  many_to_one
  }

}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: product_facts {
    type: left_outer
    sql_on: ${product_facts.product_id} = ${products.id};;
    relationship: many_to_one
  }
}

explore: user_facts {
  join: events {
    type:  left_outer
    sql_on:  ${events.user_id} = ${user_facts.user_id};;
    relationship: one_to_many
  }

  join: users {
    type: left_outer
    sql_on: ${user_facts.user_id} = ${users.id} ;;
    relationship: one_to_one
  }


}
