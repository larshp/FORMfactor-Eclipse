class ZCL_FORMFACTOR_COMMAND definition
  public
  inheriting from CL_QUICKFIX_ADT_RES_APPLY_OBJ
  create public .

public section.
  PROTECTED SECTION.
    METHODS
      apply_obj REDEFINITION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_FORMFACTOR_COMMAND IMPLEMENTATION.


METHOD apply_obj.

  DATA: lo_blackboard TYPE REF TO cl_art_blackboard.

  lo_blackboard = cl_art_blackboard=>create( ).
  lo_blackboard->set_source_object( quickfix_source_object ).

* CL_ART_APPLY_4_EXTRACT_CONST method CREATE

ENDMETHOD.
ENDCLASS.