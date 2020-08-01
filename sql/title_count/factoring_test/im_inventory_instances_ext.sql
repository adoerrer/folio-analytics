CREATE TABLE local.im_inventory_instances_ext AS
SELECT id,
       json_extract_path(data, 'natureOfContentTermIds')
           AS nature_of_content_term_ids
    FROM inventory_instances;

