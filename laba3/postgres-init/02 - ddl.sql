CREATE SCHEMA IF NOT EXISTS dwh3;

CREATE TABLE IF NOT EXISTS dwh3.dim_customer (
    customer_id SERIAL PRIMARY KEY,
    customer_first_name VARCHAR(50),
    customer_last_name VARCHAR(50),
    customer_age INT,
    customer_email VARCHAR(50) UNIQUE NOT NULL,
    customer_country VARCHAR(50),
    customer_postal_code VARCHAR(50),
    customer_pet_type VARCHAR(50),
    customer_pet_name VARCHAR(50),
    customer_pet_breed VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dwh3.dim_seller (
    seller_id SERIAL PRIMARY KEY,
    seller_first_name VARCHAR(50),
    seller_last_name VARCHAR(50),
    seller_email VARCHAR(50) UNIQUE NOT NULL,
    seller_country VARCHAR(50),
    seller_postal_code VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dwh3.dim_product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    product_release_date DATE NOT NULL,
    product_brand VARCHAR(50) NOT NULL,
    product_color VARCHAR(50) NOT NULL,
    product_size VARCHAR(50) NOT NULL,
    product_price FLOAT,
    product_quantity INT,
    pet_category VARCHAR(50),
    product_weight FLOAT,
    product_material VARCHAR(50),
    product_description VARCHAR(1024),
    product_rating FLOAT,
    product_reviews INT,
    product_expiry_date DATE,
    UNIQUE (product_name, product_category, product_release_date, product_brand, product_color, product_size)
);

CREATE TABLE IF NOT EXISTS dwh3.dim_store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(50),
    store_location VARCHAR(50),
    store_city VARCHAR(50),
    store_state VARCHAR(50),
    store_country VARCHAR(50),
    store_phone VARCHAR(50),
    store_email VARCHAR(50),
    UNIQUE (store_email, store_phone)
);

CREATE TABLE IF NOT EXISTS dwh3.dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(50),
    supplier_contact VARCHAR(50),
    supplier_email VARCHAR(50) UNIQUE NOT NULL,
    supplier_phone VARCHAR(50),
    supplier_address VARCHAR(50),
    supplier_city VARCHAR(50),
    supplier_country VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dwh3.fact_sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES dwh3.dim_customer(customer_id),
    seller_id INT REFERENCES dwh3.dim_seller(seller_id),
    product_id INT REFERENCES dwh3.dim_product(product_id),
    store_id INT REFERENCES dwh3.dim_store(store_id),
    supplier_id INT REFERENCES dwh3.dim_supplier(supplier_id),
    sale_date DATE,
    sale_quantity INT,
    sale_total_price FLOAT,
    source_id INT
);
