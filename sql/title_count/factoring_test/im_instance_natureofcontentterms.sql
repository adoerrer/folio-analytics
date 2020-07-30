/** 
 * 
 * This query extracts the instance nature of content terms array and creates a intermediate table

*/

DROP TABLE IF EXISTS local.im_instance_natureofcontentterms;

CREATE TABLE IF NOT EXISTS local.im_instance_natureofcontentterms AS (
	WITH 
		instance_natureofcontentterms_extract AS (
		    SELECT
		        inst.id AS instance_id,
		        JSON_ARRAY_ELEMENTS_TEXT(JSON_EXTRACT_PATH(inst.data, 'natureOfContentTermIds')) :: VARCHAR AS instance_natureofcontent_id
		    FROM
		        inventory_instances AS inst
		)
    SELECT
        instance_natureofcontentterms_extract.instance_id AS instance_id,
        instnatcontent.name AS name
    FROM instance_natureofcontentterms_extract
    LEFT JOIN inventory_nature_of_content_terms AS instnatcontent
        ON instance_natureofcontentterms_extract.instance_natureofcontent_id = instnatcontent.id
);