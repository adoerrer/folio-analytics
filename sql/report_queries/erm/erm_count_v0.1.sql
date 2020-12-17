SELECT
    rdv.rdv_label AS "ressource type",
    sa.sa_name AS "agreement name",
    count(*)
FROM (
    SELECT
        pci.id pci_id,
        pci.pci_pti_fk AS pti_fk,
        pci_as_ent.ent_owner_fk AS ent_owner
    FROM
        erm_agreements_package_content_item AS pci
        INNER JOIN erm_agreements_entitlement AS pci_as_ent ON pci_as_ent.ent_resource_fk = pci.id
UNION
/* Union that list of PCIs with a list of PCIs that belong to packages that are linked from an agreement entitlement */
SELECT
    pci_in_pkg.id pci_id,
    pci_in_pkg.pci_pti_fk AS pti_fk,
    pkg_as_ent.ent_owner_fk AS ent_owner
FROM
    erm_agreements_package_content_item AS pci_in_pkg
    INNER JOIN erm_agreements_package AS pkg ON pkg.id = pci_in_pkg.pci_pkg_fk
    INNER JOIN erm_agreements_entitlement AS pkg_as_ent ON pkg_as_ent.ent_resource_fk = pkg.id) AS pci_list
    /* join PCI to PTI */
    INNER JOIN erm_agreements_platform_title_instance AS pti ON pci_list.pti_fk = pti.id
    INNER JOIN erm_agreements_erm_resource AS res ON pti.pti_ti_fk = res.id
    INNER JOIN erm_agreements_refdata_value AS rdv ON res.res_type_fk = rdv.rdv_id
    LEFT JOIN erm_agreements_subscription_agreement AS sa ON pci_list.ent_owner = sa.sa_id
GROUP BY
    sa.sa_name,
    rdv.rdv_label;

