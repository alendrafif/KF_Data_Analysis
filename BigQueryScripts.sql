-- Syntax untuk membuat tabel analysis
CREATE TABLE rakamin-kf-analytics-430301.kimia_farma.kf_analysis AS
WITH TransactionDetails AS (
    SELECT
        t.transaction_id,
        t.date,
        t.branch_id,
        c.branch_name,
        c.kota,
        c.provinsi,
        c.rating,
        t.customer_name,
        t.product_id,
        p.product_name,
        t.price,
        t.discount_percentage,
        t.rating AS rate_transaksi,
        CASE 
            WHEN t.price <= 50000 THEN 0.10
            WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
            WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
            WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS persentase_gross_laba,
        t.price * (1 - t.discount_percentage) AS nett_sales,
        (t.price * (1 - t.discount_percentage)) * 
        CASE 
            WHEN t.price <= 50000 THEN 0.10
            WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
            WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
            WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
            ELSE 0.30
        END AS nett_profit
    FROM rakamin-kf-analytics-430301.kimia_farma.kf_final_transaction t
    JOIN rakamin-kf-analytics-430301.kimia_farma.kf_kantor_cabang c ON t.branch_id = c.branch_id
    JOIN rakamin-kf-analytics-430301.kimia_farma.kf_product p ON t.product_id = p.product_id
)
SELECT * FROM TransactionDetails;

-- Syntax untuk membuat View
CREATE OR REPLACE VIEW rakamin-kf-analytics-430301.kimia_farma.cabangsorted AS
SELECT
  branch_id,
  branch_name,
  kota,
  provinsi,
  AVG(rating) AS avg_rc,
  AVG(rate_transaksi) AS avg_rt
FROM rakamin-kf-analytics-430301.kimia_farma.kf_analysis
GROUP BY branch_id, branch_name, kota, provinsi
ORDER BY avg_rc DESC
LIMIT 5
