Feature: Sale


  Scenario Outline: En tant que système, j'intègre les données de ventes
    Given G_integrate_file "d'activité" "de la vente d'un produit" "/v1/sales/history" "GET" "" ""
    When W_define_media "" ""
    Then T_verify_data_integrity "date" "<field_date>" "date" "<field_date>"
    And T_verify_data_integrity "agent de vente" "<field_saleAgent>" "salAgent" "<field_saleAgent>"
    And T_verify_data_integrity "numéro d'équipement" "<field_deviceCode>" "deviceCode" "<field_deviceCode>"
    And T_verify_data_integrity "type du produit" "CONTRACT" "productTypeCode" "<field_productTypeCode>"
    And T_verify_data_integrity "code produit" "<field_productCode>" "productCode" "<field_productCode>"
    And T_verify_data_integrity "quantité" "<field_quantity>" "quantity" "<field_quantity>"
    And T_verify_data_integrity "montant" "<field_amount>" "amount" "<field_amount>"
    And T_verify_data_integrity "devise" "<field_currency>" "currency" "<field_currency>"

    Examples:
      | field_date | field_saleAgent | field_deviceCode | field_productTypeCode | field_productCode | field_quantity | field_amount | field_currency |
      |  |  |  |  |  |  |  |  |
