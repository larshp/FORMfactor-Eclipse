class ZCL_FORMFACTOR_EVALUATION definition
  public
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_QUICKFIX_EVALUATION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FORMFACTOR_EVALUATION IMPLEMENTATION.


METHOD IF_QUICKFIX_EVALUATION~EVALUATE.

  APPEND INITIAL LINE TO all_adt_evaluation_results ASSIGNING FIELD-SYMBOL(<ls_res>).
  <ls_res>-object_reference-uri = '/sap/bc/adt/zzformfactor/fix1'.
  <ls_res>-object_reference-type = 'zzformfactor'.
  <ls_res>-object_reference-name = 'FORMfactor fix 1'.
  <ls_res>-object_reference-description = 'Description shown to the right'.

  APPEND INITIAL LINE TO all_adt_evaluation_results ASSIGNING <ls_res>.
  <ls_res>-object_reference-uri = '/sap/bc/adt/zzformfactor/fix2'.
  <ls_res>-object_reference-type = 'zzformfactor'.
  <ls_res>-object_reference-name = 'FORMfactor fix 2'.
  <ls_res>-object_reference-description = 'Description shown to the right'.

* CL_ART_APPLY_4_EXTRACT_CONST method CREATE

* inherit from CL_QUICKFIX_ADT_RES_APPLY_BASE ?

* ce_art_qfix=>find_by_uri

* /sap/bc/adt/quickfixes/proposals/providers/refactoring/quickfixes/create_local_constant

* enh implementation = SQUICKFIX_ADT_RES_APP

* ZZFORMFACTOR_ADT_RES_APP
*discovery class = ZCL_ZZFORMFACTOR_ADT_RES_APP

ENDMETHOD.
ENDCLASS.