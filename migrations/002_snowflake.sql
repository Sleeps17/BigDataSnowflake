-- liquibase formatted sql
-- changeset master:1 runOnChange:true splitStatements=true rollbackSplitStatements:false end-delimiter=";" runInTransaction:true

CREATE SCHEMA IF NOT EXISTS snowflake;

CREATE TABLE IF NOT EXISTS snowflake.d_country
(
    country_id   serial primary key,
    country_name varchar(50) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_city
(
    city_id    serial primary key,
    country_id integer references snowflake.d_country (country_id),
    city_name  varchar(50) not null,
    unique (city_name, country_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_day
(
    day_id     serial primary key,
    day_number integer unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_month
(
    month_id     serial primary key,
    month_number integer unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_year
(
    year_id     serial primary key,
    year_number integer unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_date
(
    date_id  bigserial primary key,
    date     date not null,
    day_id   integer references snowflake.d_day (day_id),
    month_id integer references snowflake.d_month (month_id),
    year_id  integer references snowflake.d_year (year_id),
    unique (day_id, month_id, year_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_pet_type
(
    pet_type_id   serial primary key,
    pet_type_name varchar(20) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_pet_breed
(
    pet_breed_id   serial primary key,
    pet_type_id    integer references snowflake.d_pet_type (pet_type_id),
    pet_breed_name varchar(20) not null,
    unique (pet_type_id, pet_breed_name)
);

CREATE TABLE IF NOT EXISTS snowflake.d_pet
(
    pet_id       serial primary key,
    pet_name     varchar(50) not null,
    pet_type_id  integer references snowflake.d_pet_type (pet_type_id),
    pet_breed_id integer references snowflake.d_pet_breed (pet_breed_id),
    unique(pet_name, pet_type_id, pet_breed_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_postal_code
(
    postal_code_id bigserial primary key,
    postal_code    varchar(20) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_customer
(
    customer_id             bigserial primary key,
    customer_first_name     varchar(50),
    customer_last_name      varchar(50),
    customer_age            int,
    customer_email          varchar(50),
    customer_country_id     integer references snowflake.d_country (country_id),
    customer_postal_code_id bigint references snowflake.d_postal_code (postal_code_id),
    unique (customer_first_name, customer_last_name, customer_age, customer_email, customer_country_id,
            customer_postal_code_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_seller
(
    seller_id             bigserial primary key,
    seller_first_name     varchar(50),
    seller_last_name      varchar(50),
    seller_email          varchar(50),
    seller_country_id     integer references snowflake.d_country (country_id),
    seller_postal_code_id bigint references snowflake.d_postal_code (postal_code_id),
    unique (seller_first_name, seller_last_name, seller_email, seller_country_id, seller_postal_code_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_supplier_address
(
    supplier_address_id serial primary key,
    supplier_address    varchar(50) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_supplier
(
    supplier_id         serial primary key,
    supplier_name       varchar(30) not null,
    supplier_contact    varchar(50) not null,
    supplier_email      varchar(50) not null,
    supplier_phone      varchar(15) not null,
    supplier_address_id integer references snowflake.d_supplier_address (supplier_address_id),
    supplier_city_id    integer references snowflake.d_city (city_id),
    supplier_country_id integer references snowflake.d_country (country_id),
    unique (supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address_id, supplier_city_id,
            supplier_country_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_product_category
(
    product_category_id   serial primary key,
    product_category_name varchar(20) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_product_color
(
    product_color_id   serial primary key,
    product_color_name varchar(30) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_product_size
(
    product_size_id   serial primary key,
    product_size_name varchar(20) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_product_brand
(
    product_brand_id   serial primary key,
    product_brand_name varchar(20) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_product_material
(
    product_material_id   serial primary key,
    product_material_name varchar(20) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_product
(
    product_id              bigserial primary key,
    product_name            varchar(50)    not null,
    product_category_id     integer references snowflake.d_product_category (product_category_id),
    product_price           numeric(10, 2) not null,
    product_quantity        integer        not null,
    product_weight          numeric(10, 2) not null,
    product_color_id        integer references snowflake.d_product_color (product_color_id),
    product_size_id         integer references snowflake.d_product_size (product_size_id),
    product_brand_id        integer references snowflake.d_product_brand (product_brand_id),
    product_material_id     integer references snowflake.d_product_material (product_material_id),
    product_description     text           not null,
    product_rating          numeric(10, 2),
    product_reviews         integer,
    product_release_date_id bigint references snowflake.d_date (date_id),
    product_expire_date_id  bigint references snowflake.d_date (date_id)
);

CREATE TABLE IF NOT EXISTS snowflake.d_store_location
(
    store_location_id   serial primary key,
    store_location_name varchar(50) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_store_state
(
    store_state_id   serial primary key,
    store_state_name varchar(5) unique not null
);

CREATE TABLE IF NOT EXISTS snowflake.d_store
(
    store_id          serial primary key,
    store_name        varchar(50) not null,
    store_location_id integer references snowflake.d_store_location (store_location_id),
    store_city_id     integer references snowflake.d_city (city_id),
    store_state_id    integer references snowflake.d_store_state (store_state_id),
    store_country_id  integer references snowflake.d_country (country_id),
    store_phone       varchar(15) not null,
    store_email       varchar(50) not null,
    unique(store_name, store_location_id, store_city_id, store_state_id, store_country_id, store_phone, store_email)
);

CREATE TABLE IF NOT EXISTS snowflake.f_sale
(
    sale_id          bigserial primary key,
    customer_id      bigint references snowflake.d_customer (customer_id),
    customer_pet_id  integer references snowflake.d_pet (pet_id),
    seller_id        bigint references snowflake.d_seller (seller_id),
    sale_date_id     bigint references snowflake.d_date (date_id),
    sale_quantity    integer        not null,
    sale_total_price numeric(10, 2) not null,
    store_id         integer references snowflake.d_store (store_id)
);