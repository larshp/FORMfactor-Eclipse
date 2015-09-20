class ZCL_FORMFACTOR_ADT_RES_APP definition
  public
  inheriting from CL_ADT_DISC_RES_APP_BASE
  create public .

public section.
protected section.

  methods GET_APPLICATION_TITLE
    redefinition .
  methods REGISTER_RESOURCES
    redefinition .
private section.
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