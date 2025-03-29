-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

-- Заполняем измерение d_store_location
INSERT INTO snowflake.d_store_location(store_location_name)
SELECT md.store_location
FROM source.mock_data md

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_store_state
INSERT INTO snowflake.d_store_state(store_state_name)
SELECT md.store_state
FROM source.mock_data md
WHERE md.store_state is not null

ON CONFLICT DO NOTHING;

-- Заполняем измерение d_store
INSERT INTO snowflake.d_store(store_name, store_location_id, store_city_id, store_state_id, store_country_id,
                              store_phone, store_email)
SELECT md.store_name,
       dsl.store_location_id,
       dc.city_id,
       dss.store_state_id,
       dcr.country_id,
       md.store_phone,
       md.store_email
FROM source.mock_data md
         LEFT JOIN snowflake.d_country dcr ON dcr.country_name = md.store_country
         LEFT JOIN snowflake.d_store_location dsl ON dsl.store_location_name = md.store_location
         LEFT JOIN snowflake.d_city dc ON dc.city_name = md.store_city AND dc.country_id = dcr.country_id
         LEFT JOIN snowflake.d_store_state dss ON dss.store_state_name = md.store_state

ON CONFLICT DO NOTHING;