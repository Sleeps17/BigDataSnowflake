-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

INSERT INTO snowflake.d_supplier_address(supplier_address)
SELECT md.supplier_address
FROM source.mock_data md
WHERE md.supplier_address is not null

ON CONFLICT DO NOTHING;

INSERT INTO snowflake.d_supplier(supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address_id,
                                 supplier_city_id, supplier_country_id)
SELECT md.supplier_name,
       md.supplier_contact,
       md.supplier_email,
       md.supplier_phone,
       dsa.supplier_address_id,
       dc.city_id,
       dco.country_id
FROM source.mock_data md
         LEFT JOIN snowflake.d_supplier_address dsa ON dsa.supplier_address = md.supplier_address
         LEFT JOIN snowflake.d_country dco ON dco.country_name = md.supplier_country
         LEFT JOIN snowflake.d_city dc ON dc.city_name = md.supplier_city AND dc.country_id = dco.country_id

ON CONFLICT DO NOTHING;
