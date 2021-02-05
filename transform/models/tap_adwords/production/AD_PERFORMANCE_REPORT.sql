{{ config(alias='t_AD_PERFORMANCE_REPORT', materialized='incremental') }}

SELECT a.*, 1 as OfferId, 'Test Offer' as OfferName
FROM `dbt_test.AD_PERFORMANCE_REPORT` a