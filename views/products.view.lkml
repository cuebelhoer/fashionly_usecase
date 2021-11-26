view: products {
  sql_table_name: `thelook.products`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    drill_fields: [detail_brand*]
    link: {
      label: "Search Google for Brand Name"
      url: "http://www.google.com/search?q={{ value }}"
      icon_url: "https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  ##### Filter #####

  filter: category_select {
    suggest_dimension: products.category
  }

  filter: brand_select {
    suggest_dimension: products.brand
      }

  dimension: brand_peer2peer {
    type: string
    sql:
      CASE
        WHEN {% condition brand_select %} brand {% endcondition %}
          THEN ${products.brand}
        ELSE 'Rest of Population'
      END;;
  }



  ##### Measures #####

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.name, distribution_centers.id, inventory_items.count]
  }

  ##### Sets #####

  set: detail_brand {
    fields: [
      products.id,
      products.category,
      products.department,
      products.distribution_center_id,
      products.name
    ]
  }
}
