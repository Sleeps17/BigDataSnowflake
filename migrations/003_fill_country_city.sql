-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

-- Заполняем измерение d_country
INSERT INTO snowflake.d_country(country_name)
SELECT customer_country
FROM source.mock_data
UNION
SELECT seller_country
FROM source.mock_data
UNION
SELECT store_country
FROM source.mock_data
UNION
SELECT supplier_country
FROM source.mock_data
UNION
SELECT seller_country
FROM source.mock_data


ON CONFLICT (country_name)
    DO NOTHING;

-- Заполняем измерение d_city
INSERT INTO snowflake.d_city(country_id, city_name)
SELECT country_id, supplier_city
FROM source.mock_data
         LEFT JOIN snowflake.d_country dc ON supplier_country = dc.country_name
UNION
SELECT country_id, store_city
FROM source.mock_data
         JOIN snowflake.d_country dc ON store_country = dc.country_name

ON CONFLICT (country_id, city_name) DO NOTHING;