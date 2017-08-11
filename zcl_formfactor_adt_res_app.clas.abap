CLASS zcl_formfactor_adt_res_app DEFINITION
  PUBLIC
  INHERITING FROM cl_adt_disc_res_app_base
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS get_application_title
        REDEFINITION .
    METHODS register_resources
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FORMFACTOR_ADT_RES_APP IMPLEMENTATION.


  METHOD get_application_title.

    result = 'FORMfactor' ##NO_TEXT.

  ENDMETHOD.


  METHOD register_resources.

    registry->register_resource( template      = '/zzformfactor/{ quickfix_id }'
                                 handler_class = 'ZCL_FORMFACTOR_COMMAND' ).

  ENDMETHOD.
ENDCLASS.
