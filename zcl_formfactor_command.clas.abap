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

    DATA: lv_i TYPE i.

    lv_i = 2.

  ENDMETHOD.
ENDCLASS.