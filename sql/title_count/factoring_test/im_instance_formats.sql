/** 
 * 
 * This query extracts the instance formats array and creates a intermediate table

*/

DROP TABLE IF EXISTS local.im_instance_formats;

CREATE TABLE IF NOT EXISTS local.im_instance_formats AS (
	WITH 
	instance_formats_extract AS (
	    SELECT
	        inst.id AS instance_id,
	        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(inst.data, 'instanceFormatIds')) :: VARCHAR AS instance_format_id
	    FROM
	        inventory_instances AS inst
	)
    SELECT
        instance_formats_extract.instance_id AS instance_id,
        instform.name AS name
    FROM instance_formats_extract
    LEFT JOIN inventory_instance_formats AS instform
        ON instance_formats_extract.instance_format_id = instform.id
);