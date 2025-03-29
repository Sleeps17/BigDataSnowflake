-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

INSERT INTO snowflake.d_seller(seller_first_name, seller_last_name, seller_email, seller_country_id,
                               seller_postal_code_id)
SELECT md.seller_first_name,
       md.seller_last_name,
       md.seller_email,
       dc.country_id,
       dpc.postal_code_id
FROM source.mock_data md
         LEFT JOIN snowflake.d_country dc ON dc.country_name = md.seller_country
         LEFT JOIN snowflake.d_postal_code dpc ON dpc.postal_code = md.seller_postal_code

ON CONFLICT DO NOTHING;