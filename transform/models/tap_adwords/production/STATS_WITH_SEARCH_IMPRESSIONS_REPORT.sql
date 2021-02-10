{{ config(alias='t_STATS_WITH_SEARCH_IMPRESSIONS_REPORT', materialized='incremental',
    partition_by={
      "field": "Date",
      "data_type": "date",
      "granularity": "day"
    }) }}

SELECT a.*, o.idOffer as OfferId, b.business_id as BusinessId, pc.publisher_id as PublisherId, adv.master_advertiser_id as GMAID,
ad.rl_category_id as CategoryId, ad.rl_category_desc as CategoryDesc, ad.rl_sub_category_id as SubCategoryId, ad.rl_sub_category_desc as SubCategoryDesc,
ad.sic_code as SicCode, ad.sic_code_desc as SicCodeDesc, ad.google_category_id as GoogleCategoryId, ad.google_category_desc as GoogleCategoryDesc
FROM adwords.STATS_WITH_SEARCH_IMPRESSIONS_REPORT a
JOIN rl_platform.WebPublisherCampaign wpc ON SAFE_CAST(a.CampaignId AS STRING) = wpc.wpc_publisher_identifier
JOIN rars.publisher_campaigns pc ON pc.wpc_id = wpc.idWebPublisherCampaign
JOIN rars.campaigns rc ON pc.campaign_id = rc.campaign_id
JOIN rars.advertisers adv ON rc.master_advertiser_id = adv.master_advertiser_id
JOIN rars.businesses b ON b.business_id = adv.business_id
JOIN rl_platform.Offer o ON SAFE_CAST(o.idOffer AS FLOAT64) = SAFE_CAST(rc.offer_id AS FLOAT64)
JOIN advertiser_data.advertisers_extended ad ON ad.id = a.AdvertiserId
WHERE a.Date = DATE_ADD(CURRENT_DATE(), INTERVAL -1 DAY)
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, o.idOffer, b.business_id, pc.publisher_id, adv.master_advertiser_id,
ad.rl_category_id, ad.rl_sub_category_id, ad.rl_category_desc, ad.rl_sub_category_desc, ad.sic_code, ad.sic_code_desc,
ad.google_category_id, ad.google_category_desc