/** 
 * 
 * This query extracts the holding statistical codes array and creates a intermediate table

*/

DROP TABLE IF EXISTS local.im_holding_statisticalcodes;

CREATE TABLE IF NOT EXISTS local.im_holding_statisticalcodes AS (
	WITH 
		holding_statisticalcodes_extract AS (
		    SELECT
		        hold.id AS holding_id,
		        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(hold.data, 'statisticalCodeIds')) :: VARCHAR AS holding_statisticalcode_id
		    FROM
		        inventory_holdings AS hold
		)
    SELECT
        holding_statisticalcodes_extract.holding_id AS holding_id,
        inststatcode.name AS name
    FROM holding_statisticalcodes_extract
    LEFT JOIN inventory_statistical_codes AS inststatcode
        ON holding_statisticalcodes_extract.holding_statisticalcode_id = inststatcode.id
);