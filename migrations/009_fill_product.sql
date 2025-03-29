-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

-- Заполняем измерение d_product_category
INSERT INTO snowflake.d_product_category(product_category_name)
SELECT md.product_category
FROM source.mock_data md

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_product_color
INSERT INTO snowflake.d_product_color(product_color_name)
SELECT md.product_color
FROM source.mock_data md

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_product_size
INSERT INTO snowflake.d_product_size(product_size_name)
SELECT md.product_size
FROM source.mock_data md

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_product_brand
INSERT INTO snowflake.d_product_brand(product_brand_name)
SELECT md.product_brand
FROM source.mock_data md

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_product_material
INSERT INTO snowflake.d_product_material(product_material_name)
SELECT md.product_material
FROM source.mock_data md

ON CONFLICT DO NOTHING;

INSERT INTO snowflake.d_product(product_name,
                                product_category_id,
                                product_price,
                                product_quantity,
                                product_weight,
                                product_color_id,
                                product_size_id,
                                product_brand_id,
                                product_material_id,
                                product_description,
                                product_rating,
                                product_reviews,
                                product_release_date_id,
                                product_expire_date_id)
SELECT md.product_name,
       dpc.product_category_id,
       md.product_price,
       md.product_quantity,
       md.product_weight,
       dpcol.product_color_id,
       dps.product_size_id,
       dpb.product_brand_id,
       dpm.product_material_id,
       md.product_description,
       md.product_rating,
       md.product_reviews,
       dd1.date_id,
       dd2.date_id
FROM source.mock_data md
         LEFT JOIN snowflake.d_product_category dpc ON dpc.product_category_name = md.product_category
         LEFT JOIN snowflake.d_product_color dpcol ON dpcol.product_color_name = md.product_color
         LEFT JOIN snowflake.d_product_size dps ON dps.product_size_name = md.product_size
         LEFT JOIN snowflake.d_product_brand dpb ON dpb.product_brand_name = md.product_brand
         LEFT JOIN snowflake.d_product_material dpm ON dpm.product_material_name = md.product_material
         LEFT JOIN snowflake.d_date dd1 ON dd1.date = md.product_release_date
         LEFT JOIN snowflake.d_date dd2 ON dd2.date = md.product_expiry_date

ON CONFLICT DO NOTHING;


