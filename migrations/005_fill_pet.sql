-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

-- Заполняем измерение d_pet_type
INSERT INTO snowflake.d_pet_type(pet_type_name)
SELECT customer_pet_type
FROM source.mock_data
ON CONFLICT (pet_type_name) DO NOTHING;

-- Заполняем измерение d_pet_breed
INSERT INTO snowflake.d_pet_breed(pet_type_id, pet_breed_name)
SELECT pet_type_id, customer_pet_breed
FROM source.mock_data md
         LEFT JOIN snowflake.d_pet_type dpt ON dpt.pet_type_name = md.customer_pet_type
ON CONFLICT (pet_type_id, pet_breed_name) DO NOTHING;

-- Заполняем измерение d_pet
INSERT INTO snowflake.d_pet(pet_name, pet_type_id, pet_breed_id)
SELECT customer_pet_name, dpt.pet_type_id, dpb.pet_breed_id FROM source.mock_data md
    LEFT JOIN snowflake.d_pet_type dpt ON dpt.pet_type_name = md.customer_pet_type
    LEFT JOIN snowflake.d_pet_breed dpb ON dpb.pet_breed_name = md.customer_pet_breed AND dpb.pet_type_id = dpt.pet_type_id
ON CONFLICT DO NOTHING;