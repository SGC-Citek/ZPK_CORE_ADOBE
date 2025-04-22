CLASS lhc_Zcore_I_Adobe_Log DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Zcore_I_Adobe_Log RESULT result.

ENDCLASS.

CLASS lhc_Zcore_I_Adobe_Log IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
