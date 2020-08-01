/**

This query is creating a intermediate table within all (selected) normalized data of holdings


*/

DROP TABLE IF EXISTS local.im_holdings;

CREATE TABLE IF NOT EXISTS local.im_holdings AS
SELECT
    hold.id,
    hold.instance_id,
    holding_type.name AS "type",
    call_number_type.name AS "callnumber_type",
    hold.call_number AS "callnumber",
    statisticalcodes.name  AS "statistical_code",
    json_extract_path_text(hold.data, 'receipt_status') AS "receipt_status",
    library.name AS "library",
    campus.name AS "campus",
    institution.name AS "institution",
    locations.name AS "location"
   
FROM inventory_holdings AS hold

-- pull the fieldnames (1 to n) by joining tables
LEFT JOIN inventory_holdings_types AS holding_type
    ON holding_type.id = hold.holdings_type_id
LEFT JOIN inventory_call_number_types AS call_number_type
    ON call_number_type.id = hold. call_number_type_id
    
-- pull the fieldnames (n to n) by joining from intermediate tables    
LEFT JOIN local.im_holding_statisticalcodes AS statisticalcodes
    ON statisticalcodes.holding_id = hold.id

-- get location stuff by joining tables
LEFT JOIN inventory_locations AS locations
    ON hold.permanent_location_id = locations.id
LEFT JOIN inventory_libraries AS library
    ON locations.library_id = library.id
LEFT JOIN inventory_campuses AS campus
    ON library.campus_id = campus.id
LEFT JOIN inventory_institutions AS institution
    ON campus.institution_id = institution.id   
;
