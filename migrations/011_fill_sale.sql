-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

INSERT INTO snowflake.f_sale (customer_id,
                              customer_pet_id,
                              seller_id,
                              sale_date_id,
                              sale_quantity,
                              sale_total_price,
                              store_id)
SELECT c.customer_id,
       p.pet_id,
       s.seller_id,
       d.date_id,
       md.sale_quantity,
       md.sale_total_price,
       st.store_id
FROM source.mock_data md

         LEFT JOIN snowflake.d_customer c ON
    c.customer_first_name = md.customer_first_name AND
    c.customer_last_name = md.customer_last_name AND
    c.customer_age = md.customer_age AND
    c.customer_email = md.customer_email

         LEFT JOIN snowflake.d_country cc ON cc.country_name = md.customer_country

         LEFT JOIN snowflake.d_postal_code cp ON cp.postal_code = md.customer_postal_code

         LEFT JOIN snowflake.d_pet_type pt ON pt.pet_type_name = md.customer_pet_type

         LEFT JOIN snowflake.d_pet_breed pb
                   ON pb.pet_breed_name = md.customer_pet_breed AND pb.pet_type_id = pt.pet_type_id

         LEFT JOIN snowflake.d_pet p ON p.pet_name = md.customer_pet_name AND p.pet_breed_id = pb.pet_breed_id AND p.pet_type_id = pt.pet_type_id

         LEFT JOIN snowflake.d_seller s ON
    s.seller_first_name = md.seller_first_name AND
    s.seller_last_name = md.seller_last_name AND
    s.seller_email = md.seller_email

         LEFT JOIN snowflake.d_country sc ON sc.country_name = md.seller_country

         LEFT JOIN snowflake.d_postal_code sp ON sp.postal_code = md.seller_postal_code

         LEFT JOIN snowflake.d_date d ON
    d.day_id = (SELECT day_id FROM snowflake.d_day WHERE day_number = EXTRACT(DAY FROM md.sale_date)) AND
    d.month_id = (SELECT month_id FROM snowflake.d_month WHERE month_number = EXTRACT(MONTH FROM md.sale_date)) AND
    d.year_id = (SELECT year_id FROM snowflake.d_year WHERE year_number = EXTRACT(YEAR FROM md.sale_date))

         LEFT JOIN snowflake.d_store st ON
    st.store_name = md.store_name AND
    st.store_phone = md.store_phone AND
    st.store_email = md.store_email
         LEFT JOIN snowflake.d_store_location sl ON sl.store_location_name = md.store_location
         LEFT JOIN snowflake.d_country scountry ON scountry.country_name = md.store_country
         LEFT JOIN snowflake.d_city scity ON scity.city_name = md.store_city AND scity.country_id = scountry.country_id
         LEFT JOIN snowflake.d_store_state sstate ON sstate.store_state_name = md.store_state;
