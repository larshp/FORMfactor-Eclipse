DEFINE append_to.
  append &2 to &1.
END-OF-DEFINITION.

CLASS ltcl_evaluation DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    METHODS:
      setup,
      build_uri
      importing
        i_row type i OPTIONAL
        i_col type i OPTIONAL
      returning
        VALUE(r_uri) type string,
      intgr_evaluation FOR TESTING RAISING cx_static_check.

    DATA:
      sut_eval                  TYPE REF TO cl_quickfix_adt_res_evaluation,
      sut_cmd                   TYPE REF TO cl_quickfix_adt_res_command,
      eval_request_stub         TYPE REF TO cl_adt_rest_request_stub,
      eval_response_spy         TYPE REF TO cl_adt_rest_response_spy,
      cmd_request_stub          TYPE REF TO cl_adt_rest_request_stub,
      cmd_response_spy          TYPE REF TO cl_adt_rest_response_spy,
      uri                       TYPE REF TO cl_adt_srl_uri_stub,
      data                      TYPE string,
      evaluation_results        TYPE if_quickfix_adt_types=>ty_quickfix_evaluation_results,
      uri_unimplemented_methods TYPE string.

ENDCLASS.

CLASS ltcl_evaluation IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT sut_eval.
    CREATE OBJECT sut_cmd.
    CREATE OBJECT eval_request_stub.
    CREATE OBJECT eval_response_spy.
    CREATE OBJECT cmd_request_stub.
    CREATE OBJECT cmd_response_spy.
    uri_unimplemented_methods = |/sap/bc/adt/quickfixes/proposals/providers/refactoring/quickfixes/{ ce_art_qfix=>add_unimplemented_methods->id }|.

    CREATE OBJECT cmd_request_stub
      EXPORTING
        uri = uri_unimplemented_methods.

  ENDMETHOD.

  METHOD intgr_evaluation.
    DATA class_uri TYPE string.
    DATA qf_uri              TYPE string.
    DATA test_client         TYPE REF TO cl_adt_rc_test_client_integr.
    DATA http_status         TYPE i.
    DATA quickfix_eval_out   TYPE if_quickfix_adt_types=>ty_quickfix_evaluation_results.
    DATA source        TYPE        sadt_srl_plain_text.
    DATA: exp_uri             TYPE string,
          source_code         TYPE string,
          uri_apply           TYPE string,
          proposal_request    TYPE if_quickfix_adt_types=>ty_quickfix_proposal_request,
          evaluation_results  TYPE if_quickfix_adt_types=>ty_quickfix_evaluation_results,
          proposal_result     TYPE if_quickfix_adt_types=>ty_quickfix_proposal_result.

    FIELD-SYMBOLS:
      <evaluation_result>   LIKE LINE OF evaluation_results,
      <res_affected_object> LIKE LINE OF <evaluation_result>-affected_objects,
      <req_affected_object> LIKE LINE OF proposal_request-affected_objects,
      <delta>               LIKE LINE OF proposal_result-deltas.

    class_uri = build_uri( i_row = 3 i_col = 10 ).

    append_to source:
      'class CL_RFAC_CLASS_DUMMY definition.',
      'private section.',
      'methods mymethod.',
      'endclass.',
      'class CL_RFAC_CLASS_DUMMY implementation.',
      'endclass.'.

    me->eval_request_stub->add_query_param(
      EXPORTING
        key   = 'uri'
        value = class_uri
    ).

    TRY.
        me->eval_request_stub->set_body_data( source ).
        me->sut_eval->post( request = eval_request_stub response = eval_response_spy ).
        me->eval_response_spy->get_body_data( IMPORTING data = quickfix_eval_out ).
        evaluation_results = quickfix_eval_out.
        cl_abap_unit_assert=>assert_not_initial( evaluation_results ).
      CATCH cx_adt_rest.
        cl_aunit_assert=>fail( ).
    ENDTRY.

    READ TABLE evaluation_results WITH KEY object_reference-uri = uri_unimplemented_methods ASSIGNING <evaluation_result>.
    cl_abap_unit_assert=>assert_subrc( sy-subrc ).

    proposal_request-input-affected_object-uri = build_uri( i_row = 3 i_col = 11 ).

    exp_uri = build_uri( ).

    " create proposal request
    CONCATENATE LINES OF source INTO source_code SEPARATED BY cl_abap_char_utilities=>cr_lf.

    proposal_request-input-content = source_code.
    proposal_request-user_content = <evaluation_result>-user_content.

    uri_apply = uri_unimplemented_methods.

    cmd_request_stub->set_uri_attribute(
      EXPORTING
        name  = 'quickfix_id'
        value = ce_art_qfix=>add_unimplemented_methods->id
    ).
    cmd_request_stub->set_body_data( data = proposal_request ).

    me->sut_cmd->post( request = cmd_request_stub response = cmd_response_spy ).

    cmd_response_spy->get_body_data(
      IMPORTING
        data                     = proposal_result
    ).

    " check evaluation results
    cl_abap_unit_assert=>assert_not_initial( proposal_result ).
    cl_abap_unit_assert=>assert_equals( act = lines( proposal_result-deltas ) exp = 1 ).
    READ TABLE proposal_result-deltas INDEX 1 ASSIGNING <delta>.

    exp_uri = build_uri( i_row = 6 i_col = 0 ).

    cl_abap_unit_assert=>assert_equals( act = <delta>-affected_object-uri exp = exp_uri ).

    <delta>-content = to_lower( <delta>-content ). " avoid upper/lower case problems
    IF NOT <delta>-content CA 'method mymethod.'.
      cl_abap_unit_assert=>fail( ).
    ENDIF.
    IF NOT <delta>-content CA 'endmethod.'.
      cl_abap_unit_assert=>fail( ).
    ENDIF.


  ENDMETHOD.

  method build_uri.

    DATA fragment TYPE cl_adt_text_plain_fragmnt_hndl=>ty_fragment_parsed.

    fragment-start-line   = i_row.
    fragment-start-offset = i_col.

    r_uri = cl_oo_adt_uri_builder_class=>create_uri_for_class_include(
        class_name        = 'CL_RFAC_CLASS_DUMMY'
        include_type      = cl_oo_adt_uri_builder_class=>co_inc_type_main
        fragment          = fragment ).

  endmethod.

ENDCLASS.