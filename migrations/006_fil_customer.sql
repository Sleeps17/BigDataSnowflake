-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

INSERT INTO snowflake.d_postal_code(postal_code)
SELECT md.customer_postal_code
FROM source.mock_data md
WHERE md.customer_postal_code is not null
UNION
SELECT md.seller_postal_code
FROM source.mock_data md
WHERE md.seller_postal_code is not null

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_customer
INSERT INTO snowflake.d_customer(customer_first_name, customer_last_name, customer_age, customer_email,
                                 customer_country_id, customer_postal_code_id)
SELECT md.customer_first_name,
       md.customer_last_name,
       md.customer_age,
       md.customer_email,
       dc.country_id,
       dpc.postal_code_id
FROM source.mock_data md
         LEFT JOIN snowflake.d_country dc ON md.customer_country = dc.country_name
         LEFT JOIN snowflake.d_postal_code dpc ON md.customer_postal_code = dpc.postal_code
ON CONFLICT DO NOTHING;