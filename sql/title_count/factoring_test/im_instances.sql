/**

This query is creating a intermediate table within all (selected) normalized data of instances


*/

DROP TABLE IF EXISTS local.im_instances;

CREATE TABLE IF NOT EXISTS local.im_instances AS
SELECT
    inst.id,
    inst.cataloged_date,
    inst.discovery_suppress,
	instance_types.name AS "type",
    instance_statuses.name AS "status",
    instance_mode_of_issuance.name AS "mode_of_issuance",
    formats.name AS "format",
    statisticalcodes.name AS "statistical_code",
    natureofcontentterms.name AS "nature_of_content",    
    inst.previously_held AS "previously_held",
    super_relation_type.name AS "super_instance",
    sub_relation_type.name AS "sub_instance"
    
FROM inventory_instances AS inst

-- pull the fieldnames (1 to n) by joining tables
LEFT JOIN inventory_instance_types AS instance_types
    ON inst.instance_type_id = instance_types.id
LEFT JOIN inventory_instance_statuses AS instance_statuses
    ON instance_statuses.id = inst.status_id
LEFT JOIN inventory_modes_of_issuance AS instance_mode_of_issuance
    ON instance_mode_of_issuance.id = inst.mode_of_issuance_id
    
-- pull the fieldnames (n to n) by joining from intermediate tables    
LEFT JOIN local.im_instance_formats AS formats
    ON formats.instance_id = inst.id
LEFT JOIN local.im_instance_statisticalcodes AS statisticalcodes
    ON statisticalcodes.instance_id = inst.id
LEFT JOIN local.im_instance_natureofcontentterms AS natureofcontentterms
    ON natureofcontentterms.instance_id = inst.id
    
-- get instance relations and their types
LEFT JOIN inventory_instance_relationships AS super_relation
    ON super_relation.super_instance_id = inst.id
LEFT JOIN inventory_instance_relationships AS sub_relation
    ON sub_relation.sub_instance_id = inst.id
LEFT JOIN inventory_instance_relationship_types AS super_relation_type
    ON super_relation.instance_relationship_type_id = super_relation_type.id
LEFT JOIN inventory_instance_relationship_types AS sub_relation_type
    ON sub_relation.instance_relationship_type_id = sub_relation_type.id    
;
