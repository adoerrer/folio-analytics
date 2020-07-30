/** RM TITLE COUNT
  
AGGREGATION:
instance_type, mode_of_issuance, instance_format, instance_statistical_code, instance_nature_of_content, holding_type, callnumber_type, holding_statistical_code, super_relation_type,
sub_relation_type

FILTERS: FOR USERS TO SELECT
cataloged_date, instance_type, instance_format, mode_of_issuance, nature_of_content_terms, holdings_receipt_status, holdings_type, holdings_callnumber,
instance_statistical_code, holdings_statistical_code, permanent_location_name_filter, campus_filter, library_filter, institution_filter

HARDCODED FILTERS
instance_discovery_suppress, instance_statuses (cataloged or batchloaded)


STILL IN PROGRESS:
- dateOfPublication 
- add more filters and values for virtual titles as hardcoded filter (instance_type, nature_of_content, inventory_libraries.name)
- holdings_discovery_suppress (not in ldp at this time)
- status_updated_date (not in ldp at this time)
- add more fields as they are avaiable (eg. geographic, language, open access, withdrawn)

*/
WITH parameters AS (

    /** Choose a start and end date if needed */
    SELECT
        '1950-04-01' :: DATE AS cataloged_date_start_date, --ex:2000-01-01
        '2020-05-01' :: DATE AS cataloged_date_end_date, -- ex:2020-01-01

        -- POSSIBLE FORMAT MEASURES -- USE EXACTLY EXACT TERM, CASE SENSITIVE. USE ONE FILTER FOR EACH SPECIFIC ELEMENT NEEDED
        '' :: VARCHAR AS instance_type_filter1, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        '' :: VARCHAR AS instance_type_filter2, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.
        '' :: VARCHAR AS instance_type_filter3, -- select 'Text', 'Performed Music', 'Other' etc. or leave blank for all.

        '' :: VARCHAR AS instance_format_filter1,-- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        '' :: VARCHAR AS instance_format_filter2,-- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.
        '' :: VARCHAR AS instance_format_filter3,-- select 'audio -- audio disc', 'computer -- other' etc. or leave blank for all. You can use %% as wildcards.

        '' :: VARCHAR AS instance_mode_of_issuance_filter, -- select 'integrating resource', 'serial', 'multipart monograph' etc. or leave blank for all.
        '' :: VARCHAR AS nature_of_content_terms_filter, -- select 'textbook', 'journal' etc. or leave blank for all.
        '' :: VARCHAR AS holdings_receipt_status_filter, -- select 'partially received', 'fully received' etc.
        '' :: VARCHAR AS holdings_type_filter, -- select 'Electronic', 'Monograph' etc. or elave blank for all. (This is case sensitive)
        '' :: VARCHAR AS holdings_callnumber_type_filter, -- select .....
        '' :: VARCHAR AS holdings_callnumber_filter, -- use %% as wildcards '1234-abc%%','%%1234-abc','%%1234-abc%%'

        -- STATISTICAL CODES
        '' :: VARCHAR AS instance_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.
        '' :: VARCHAR AS holdings_statistical_code_filter, -- select 'Active Serial', 'Book, print (books)', 'Book, electronic (ebooks), 'Microfiche' etc. or leave blank for all.

        -- LOCATION
        '' :: VARCHAR AS permanent_location_name_filter, --Online, Annex, Main Library
        '' :: VARCHAR AS campus_filter, -- select 'Main Campus','City Campus','Online' as needed
        '' :: VARCHAR AS library_filter, -- select 'Datalogisk Institut','Adelaide Library' as needed
        '' :: VARCHAR AS institution_filter -- select 'Kobenhavns Universitet','Montoya College' as needed

)


---------- MAIN QUERY ----------
SELECT
    imtc.instance_type AS "instance type",
    imtc.mode_of_issuance AS "mode of issuance",
    imtc.format AS "format",
    imtc.instance_statistical_code AS "instance statistical code",
    imtc.nature_of_content AS "nature of content",
    imtc.holding_type AS "holding type",
    imtc.callnumber_type AS "callnumber type",
    imtc.holding_statistical_code  AS "holding statistical code",
    imtc.receipt_status AS "holdings receipt status",
    imtc.location AS "location",
    imtc.previously_held AS "previously held",
    imtc.super_instance AS "super_instance as",
    imtc.sub_instance AS "sub_instance as",
    
    COUNT(DISTINCT imtc.id) AS "title count"

-- pull the instances related data by joining tables
FROM local.im_title_count AS imtc

WHERE

/*  this is commented out atm because of to few test data
-- begin to process the set filters

    inst.cataloged_date :: DATE >= (SELECT cataloged_date_start_date FROM parameters)
AND
    inst.cataloged_date :: DATE < (SELECT cataloged_date_end_date FROM parameters)
AND
 */
    (
        (
            imtc.instance_type IN (
                (SELECT instance_type_filter1 FROM parameters),
                (SELECT instance_type_filter2 FROM parameters),
                (SELECT instance_type_filter3 FROM parameters)
            )
        )
        OR
        (
            (SELECT instance_type_filter1 FROM parameters) = '' AND
            (SELECT instance_type_filter2 FROM parameters) = '' AND
            (SELECT instance_type_filter3 FROM parameters) = ''
        )
    )
AND
    (
        (
        
        	imtc.format LIKE (SELECT instance_format_filter1 FROM parameters) OR
            imtc.format LIKE (SELECT instance_format_filter2 FROM parameters) OR
            imtc.format LIKE (SELECT instance_format_filter3 FROM parameters)
        )
        OR
        (
            (SELECT instance_format_filter1 FROM parameters) = '' AND
            (SELECT instance_format_filter2 FROM parameters) = '' AND
            (SELECT instance_format_filter3 FROM parameters) = ''
        )
    )
AND
    (imtc.mode_of_issuance = (SELECT instance_mode_of_issuance_filter FROM parameters) OR
    (SELECT instance_mode_of_issuance_filter FROM parameters) = '')
AND
    (imtc.nature_of_content =
       (SELECT nature_of_content_terms_filter FROM parameters) OR
    (SELECT nature_of_content_terms_filter FROM parameters) = '')
AND
    (imtc.receipt_status = (SELECT holdings_receipt_status_filter FROM parameters) OR
    (SELECT holdings_receipt_status_filter FROM parameters) = '')
AND
    (imtc.holding_type = (SELECT holdings_type_filter FROM parameters) OR
    (SELECT holdings_type_filter FROM parameters) = '')
AND
    (imtc.callnumber_type = (SELECT holdings_callnumber_type_filter FROM parameters) OR
    (SELECT holdings_callnumber_type_filter FROM parameters) = '')
AND
    (imtc.callnumber like (SELECT holdings_callnumber_filter FROM parameters) OR
    (SELECT holdings_callnumber_filter FROM parameters) = '')
AND
    (imtc.instance_statistical_code =
        (SELECT instance_statistical_code_filter FROM parameters) OR
    (SELECT instance_statistical_code_filter FROM parameters) = '')
AND
    (imtc.holding_statistical_code =
        (SELECT holdings_statistical_code_filter FROM parameters) OR
    (SELECT holdings_statistical_code_filter FROM parameters) = '')
AND
    (imtc.campus = (SELECT campus_filter FROM parameters) OR
    (SELECT campus_filter FROM parameters) = '')
AND
    (imtc.institution = (SELECT institution_filter FROM parameters) OR
    (SELECT institution_filter FROM parameters) = '')
AND
    (imtc.library = (SELECT library_filter FROM parameters) OR
    (SELECT library_filter FROM parameters) = '')
AND
    (imtc.location =
        (SELECT permanent_location_name_filter FROM parameters) OR
    (SELECT permanent_location_name_filter FROM parameters) = '')
GROUP BY
    -- you may want to comment any group option to customize your view but keep in mind to have it commented in the SELECT section too
    imtc.instance_type,
    imtc.mode_of_issuance,
    imtc.format,
    imtc.instance_statistical_code,
    imtc.nature_of_content,
    imtc.holding_type,
    imtc.callnumber_type,
    imtc.holding_statistical_code,
    imtc.receipt_status,
    imtc.location,
    imtc.previously_held,
    imtc.super_instance,
    imtc.sub_instance
;