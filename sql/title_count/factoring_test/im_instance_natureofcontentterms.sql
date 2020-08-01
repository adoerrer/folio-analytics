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
		        json_array_elements_text(nature_of_content_term_ids)
			        :: VARCHAR AS instance_natureofcontent_id
		    FROM
		        local.im_inventory_instances_ext AS inst
		)
    SELECT
        instance_natureofcontentterms_extract.instance_id AS instance_id,
        instnatcontent.name AS name
    FROM instance_natureofcontentterms_extract
    LEFT JOIN inventory_nature_of_content_terms AS instnatcontent
        ON instance_natureofcontentterms_extract.instance_natureofcontent_id = instnatcontent.id
);
