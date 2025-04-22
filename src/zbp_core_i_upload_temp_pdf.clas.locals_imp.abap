CLASS lhc_ZCORE_I_UPLOAD_TEMP_PDF DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcore_i_upload_temp_pdf RESULT result.

ENDCLASS.

CLASS lhc_ZCORE_I_UPLOAD_TEMP_PDF IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
