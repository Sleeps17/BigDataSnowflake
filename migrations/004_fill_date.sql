-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

-- Заполняем измерение d_day
INSERT INTO snowflake.d_day(day_number)
SELECT extract(DAY FROM product_release_date)
FROM source.mock_data
UNION
SELECT extract(DAY FROM product_expiry_date)
FROM source.mock_data
UNION
SELECT extract(DAY FROM sale_date)
FROM source.mock_data

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_month
INSERT INTO snowflake.d_month(month_number)
SELECT extract(MONTH FROM product_release_date)
FROM source.mock_data
UNION
SELECT extract(MONTH FROM product_expiry_date)
FROM source.mock_data
UNION
SELECT extract(MONTH FROM sale_date)
FROM source.mock_data

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_year
INSERT INTO snowflake.d_year(year_number)
SELECT extract(YEAR FROM product_release_date)
FROM source.mock_data
UNION
SELECT extract(YEAR FROM product_expiry_date)
FROM source.mock_data
UNION
SELECT extract(YEAR FROM sale_date)
FROM source.mock_data

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_date
INSERT INTO snowflake.d_date(date, day_id, month_id, year_id)
SELECT product_release_date, day_id, month_id, year_id
FROM source.mock_data
         LEFT JOIN snowflake.d_day dd ON dd.day_number = extract(DAY FROM product_release_date)
         LEFT JOIN snowflake.d_month dm ON dm.month_number = extract(MONTH FROM product_release_date)
         LEFT JOIN snowflake.d_year dy on dy.year_number = extract(YEAR FROM product_release_date)
UNION
SELECT product_expiry_date, day_id, month_id, year_id
FROM source.mock_data
         LEFT JOIN snowflake.d_day dd ON dd.day_number = extract(DAY FROM product_expiry_date)
         LEFT JOIN snowflake.d_month dm ON dm.month_number = extract(MONTH FROM product_expiry_date)
         LEFT JOIN snowflake.d_year dy on dy.year_number = extract(YEAR FROM product_expiry_date)
UNION
SELECT sale_date, day_id, month_id, year_id
FROM source.mock_data
         LEFT JOIN snowflake.d_day dd ON dd.day_number = extract(DAY FROM sale_date)
         LEFT JOIN snowflake.d_month dm ON dm.month_number = extract(MONTH FROM sale_date)
         LEFT JOIN snowflake.d_year dy on dy.year_number = extract(YEAR FROM sale_date)

ON CONFLICT(day_id, month_id, year_id) DO NOTHING;