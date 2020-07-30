/** 
 * 
 * This query extracts the instance statistical codes array and creates a intermediate table

*/

DROP TABLE IF EXISTS local.im_instance_statisticalcodes;

CREATE TABLE IF NOT EXISTS local.im_instance_statisticalcodes AS (
	WITH 
		instance_statisticalcodes_extract AS (
		    SELECT
		        inst.id AS instance_id,
		        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(inst.data, 'statisticalCodeIds')) :: VARCHAR AS instance_statisticalcode_id
		    FROM
		        inventory_instances AS inst
	)
    SELECT
        instance_statisticalcodes_extract.instance_id AS instance_id,
        inststatcode.name AS name
    FROM instance_statisticalcodes_extract
    LEFT JOIN inventory_statistical_codes AS inststatcode
        ON instance_statisticalcodes_extract.instance_statisticalcode_id = inststatcode.id
);