/* ================================================================
FINAL EXPLORATORY DATA ANALYSIS TABEL

Purpose : One analytical table for visualization
===================================================================*/

-- CREATE VIEW vw_customer_behavior_eda_new AS
WITH base_data AS (
	SELECT
		customer_id,
		gender,
		age_group,
		category,
		item_purchased,
		purchase_amount,
		review_rating,
		shipping_type,
		subscription_status,
		previous_purchases,
		discount_applied,
		/* Customer Segmentation */
		CASE WHEN previous_purchases = 1 THEN 'New'
			 WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
			 ELSE 'Loyal'
		END AS customer_segment,
		/* Repeat order */
		CASE WHEN previous_purchases > 5 THEN 1 ELSE 0
		END AS is_repeat_buyer
	FROM customer_behavior
	),

final_eda AS (
	SELECT
		customer_id,
		gender,
		age_group,
		category,
		item_purchased,
		shipping_type,
		subscription_status,
		customer_segment,
		purchase_amount,
		review_rating,
		/* Customer & Order metric */
		COUNT(DISTINCT customer_id) AS total_customer,
		COUNT(*) AS total_orders,
		/* Revenue metrics */
		SUM(purchase_amount) AS total_revenue,
		ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
		/* Review metrics */
		ROUND(AVG(review_rating), 2) AS avg_review_rating,
		/* Discount metrics */
		SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS discounted_orders,
		ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate,
		/* repeat orders metrics */
		SUM(is_repeat_buyer) AS repeat_buyers
	FROM base_data
	GROUP BY
		customer_id,
		gender,
		age_group,
		category,
		item_purchased,
		shipping_type,
		subscription_status,
		purchase_amount,
		review_rating,
		customer_segment
)

SELECT * FROM final_eda;