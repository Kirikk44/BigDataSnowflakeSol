


INSERT INTO dwh3.dim_customer (
    customer_first_name, customer_last_name, customer_age, 
    customer_email, customer_country, customer_postal_code,
    customer_pet_type, customer_pet_name, customer_pet_breed
)
SELECT DISTINCT 
    customer_first_name, customer_last_name, customer_age,
    customer_email, customer_country, customer_postal_code,
    customer_pet_type, customer_pet_name, customer_pet_breed
FROM public.mock_data
WHERE customer_email IS NOT NULL;

INSERT INTO dwh3.dim_seller (
    seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code
)
SELECT DISTINCT 
    seller_first_name, seller_last_name, seller_email,
    seller_country, seller_postal_code
FROM public.mock_data
WHERE seller_email IS NOT NULL;

INSERT INTO dwh3.dim_product (
    product_name, product_category, product_release_date, 
    product_brand, product_color, product_size,
    product_price, product_quantity, pet_category,
    product_weight, product_material, product_description,
    product_rating, product_reviews, product_expiry_date
)
SELECT DISTINCT 
    product_name, 
    product_category, 
    product_release_date,
    COALESCE(product_brand, 'Unknown') as product_brand,
    COALESCE(product_color, 'Unknown') as product_color,
    COALESCE(product_size, 'Standard') as product_size,
    product_price,
    product_quantity,
    pet_category,
    product_weight,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_expiry_date
FROM public.mock_data
WHERE product_name IS NOT NULL 
  AND product_category IS NOT NULL 
  AND product_release_date IS NOT NULL;
INSERT INTO dwh3.dim_store (
    store_name, store_location, store_city,
    store_state, store_country, store_phone,
    store_email
)
SELECT DISTINCT 
    store_name, store_location, store_city,
    store_state, store_country, store_phone,
    store_email
FROM public.mock_data
WHERE store_email IS NOT NULL AND store_phone IS NOT NULL;

INSERT INTO dwh3.dim_supplier (
    supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city,
    supplier_country
)
SELECT DISTINCT 
    supplier_name, supplier_contact, supplier_email,
    supplier_phone, supplier_address, supplier_city,
    supplier_country
FROM public.mock_data
WHERE supplier_email IS NOT NULL;

--SELECT 
--    (SELECT COUNT(*) FROM dwh3.dim_customer) as customer_count,
--    (SELECT COUNT(*) FROM dwh3.dim_seller) as seller_count,
--    (SELECT COUNT(*) FROM dwh3.dim_product) as product_count,
--    (SELECT COUNT(*) FROM dwh3.dim_store) as store_count,
--    (SELECT COUNT(*) FROM dwh3.dim_supplier) as supplier_count,
--    (SELECT COUNT(*) FROM dwh3.fact_sales) as sales_count;


INSERT INTO dwh3.fact_sales (
    customer_id, seller_id, product_id, store_id, supplier_id,
    sale_date, sale_quantity, sale_total_price, source_id
)
SELECT 
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    sup.supplier_id,
    md.sale_date,
    md.sale_quantity,
    md.sale_total_price,
    md.id as source_id
FROM public.mock_data md
LEFT JOIN dwh3.dim_customer c ON md.customer_email = c.customer_email
LEFT JOIN dwh3.dim_seller s ON md.seller_email = s.seller_email
LEFT JOIN dwh3.dim_product p ON md.product_name = p.product_name 
    AND md.product_category = p.product_category 
    AND md.product_release_date = p.product_release_date
    AND COALESCE(md.product_brand, 'Unknown') = p.product_brand
    AND COALESCE(md.product_color, 'Unknown') = p.product_color
    AND COALESCE(md.product_size, 'Standard') = p.product_size
LEFT JOIN dwh3.dim_store st ON md.store_email = st.store_email 
    AND md.store_phone = st.store_phone
LEFT JOIN dwh3.dim_supplier sup ON md.supplier_email = sup.supplier_email;



