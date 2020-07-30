/**

This query is creating a intermediate table within all (selected) normalized data of holdings


*/

DROP TABLE IF EXISTS local.im_title_count;

CREATE TABLE IF NOT EXISTS local.im_title_count AS
SELECT
    inst.id,
    inst.cataloged_date,
    inst.discovery_suppress,
	inst.type AS "instance_type",
    inst.status AS "status",
    inst.mode_of_issuance AS "mode_of_issuance",
    inst.format AS "format",
    inst.statistical_code AS "instance_statistical_code",
    inst.nature_of_content AS "nature_of_content",    
    inst.previously_held AS "previously_held",
    inst.super_instance AS "super_instance",
    inst.sub_instance AS "sub_instance",
    hold.type AS "holding_type",
    hold.callnumber_type AS "callnumber_type",
    hold.callnumber AS "callnumber",
    hold.statistical_code  AS "holding_statistical_code",
    hold.receipt_status AS "receipt_status",
    hold.library AS "library",
    hold.campus AS "campus",
    hold.institution AS "institution",
    hold.location AS "location"
   
FROM local.im_instances AS inst

LEFT JOIN local.im_holdings AS hold
    ON hold.instance_id = inst.id
      
WHERE

-- hardcoded filters

    -- if suppressed don't count
    ((NOT inst.discovery_suppress) OR (inst.discovery_suppress ISNULL))
AND
     -- filter all virtual titles (surely need more virtual indicators)
    (inst.format NOT IN ('computer -- online resource') OR inst.format ISNULL)
AND
    (hold.library NOT IN ('Online') OR hold.library ISNULL)

/*  this is commented out atm because of to few test data
 AND
    ((instance_statuses.name = 'Cataloged') OR
    (instance_statuses.name = 'Batchloaded')) -- get only instances with the right status
*/
;

CREATE INDEX ON local.im_title_count (id);
CREATE INDEX ON local.im_title_count (cataloged_date);
CREATE INDEX ON local.im_title_count (discovery_suppress);
CREATE INDEX ON local.im_title_count (instance_type);
CREATE INDEX ON local.im_title_count (status);
CREATE INDEX ON local.im_title_count (mode_of_issuance);
CREATE INDEX ON local.im_title_count (format);
CREATE INDEX ON local.im_title_count (instance_statistical_code);
CREATE INDEX ON local.im_title_count (nature_of_content);
CREATE INDEX ON local.im_title_count (previously_held);
CREATE INDEX ON local.im_title_count (super_instance);
CREATE INDEX ON local.im_title_count (sub_instance);
CREATE INDEX ON local.im_title_count (holding_type);
CREATE INDEX ON local.im_title_count (callnumber_type);
CREATE INDEX ON local.im_title_count (callnumber);
CREATE INDEX ON local.im_title_count (holding_statistical_code);
CREATE INDEX ON local.im_title_count (receipt_status);
CREATE INDEX ON local.im_title_count (library);
CREATE INDEX ON local.im_title_count (campus);
CREATE INDEX ON local.im_title_count (institution);
CREATE INDEX ON local.im_title_count (location);

VACUUM local.im_title_count;
ANALYZE local.im_title_count;