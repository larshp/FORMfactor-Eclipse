CLASS zcl_formfactor_evaluation DEFINITION
  PUBLIC
  INHERITING FROM cl_quickfix_evaluation_obj
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS evaluate_obj
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FORMFACTOR_EVALUATION IMPLEMENTATION.


  METHOD evaluate_obj.

    DATA: lo_result TYPE REF TO cl_quickfix_evaluation_result.

    DATA(lo_blackboard) = cl_art_blackboard=>create( ).
    lo_blackboard->set_source_object( quickfix_source_object ).
    cl_art_contrib_scan_result=>create( lo_blackboard
      )->if_art_blackboard_contributor~contribute( ).

    DATA(lv_leading_key_word) = lo_blackboard->get_scan_result(
      )->get_leading_key_word_for_stmnt(
        i_statement_index = lo_blackboard->get_start_stmnt_index( )
        i_include         = lo_blackboard->get_focused_include( ) ).

    CASE lv_leading_key_word.
      WHEN 'FORM'.
        lo_result = NEW cl_quickfix_evaluation_result(
          i_uri          = '/sap/bc/adt/zzformfactor/fix1'
          i_display_name = 'FORMfactor: Move FORM to local class'
          i_description  = 'todo, description'
          i_type         = 'zzformfactor' ).
        APPEND lo_result TO own_evaluation_results.
      WHEN 'PERFORM'.
        lo_result = NEW cl_quickfix_evaluation_result(
          i_uri          = '/sap/bc/adt/zzformfactor/fix2'
          i_display_name = 'FORMfactor: Call METHOD instead'
          i_description  = 'todo, description'
          i_type         = 'zzformfactor' ).
        APPEND lo_result TO own_evaluation_results.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
