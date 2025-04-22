class zcl_api_adobe definition
  public
  final
  create public .

  public section.
    types:
      begin of ty_request,
        id   type string,
        data type standard table of string with empty key,
      end of ty_request,
      begin of ty_response,
        file_content type zde_adobe_attachment,
      end of ty_response.
    methods: get_pdf importing request  type string "ty_request
                     exporting pdf64    type string
                               response type string.

    interfaces if_http_service_extension .
    constants:
      method_post type string value 'POST',
      method_get  type string value 'GET'.

  protected section.
  private section.

    data:
      request_method     type string,
      request_body       type string,
      request_data       type ty_request,
      request_adobe_body type string.

    data:
      response_data type ty_response,
      response_body type string,
      lv_pdf        type string.

    methods:
      call_data returning value(respone) type string
                raising
                          cx_web_http_client_error.
ENDCLASS.



CLASS ZCL_API_ADOBE IMPLEMENTATION.


  method call_data.
    data:
      lv_xdp_layout       type xstring,
      lv_xml_data_string  type string,
      lv_xml_data_xstring type xstring,
      lv_xml_data         type string,
      lv_return           type xstring.

    select single file_content
        from zcore_tb_temppdf
        where id = @request_data-id
        into @response_data-file_content.

    lv_xdp_layout = response_data-file_content.

    data(lv_pdf_merge) = cl_rspo_pdf_merger=>create_instance( ).

    loop at request_data-data into lv_xml_data.
      lv_xml_data_string    = cl_web_http_utility=>encode_x_base64(
                                cl_web_http_utility=>encode_utf8( lv_xml_data )
                              ).
      lv_xml_data_xstring   = cl_web_http_utility=>decode_x_base64( lv_xml_data_string ).

      try.
          "render PDF
          cl_fp_ads_util=>render_pdf( exporting iv_xml_data     = lv_xml_data_xstring
                                                iv_xdp_layout   = lv_xdp_layout
                                                iv_locale       = 'de_DE'
                                                is_options       = VALUE #( embed_fonts = 'X' )
                                      importing ev_pdf          = data(ev_pdf)
                                                ev_pages        = data(ev_pages)
                                                ev_trace_string = data(ev_trace_string)
                                               ).
          "add PDF will merge
          lv_pdf_merge->add_document( ev_pdf ).

        catch cx_fp_ads_util into data(lx_fp_ads_util).
          "handle exception
          data(lv_error) = lx_fp_ads_util->get_longtext( ).
      endtry.
    endloop.

    check ev_pdf is not initial.

    try.
        "merge PDF
        lv_return   = lv_pdf_merge->merge_documents( ).
        lv_pdf      = cl_web_http_utility=>encode_x_base64( lv_return ).
      catch cx_rspo_pdf_merger into data(lx_rspo_pdf_merger).
        "handle exception
        lv_error = lx_fp_ads_util->get_longtext( ).
    endtry.

    return lv_pdf.
  endmethod.


  method get_pdf.
    data: ls_respone type ty_response.
    "request_data = request.
    /ui2/cl_json=>deserialize(
      exporting
        json = request       " JSON string
      changing
        data = request_data  " Data to serialize
    ).
    try.
        data(lv_response) = call_data(  ).
      catch cx_web_http_client_error.
        "handle exception
    endtry.
    xco_cp_json=>data->from_string( lv_response )->apply( value #(
   ( xco_cp_json=>transformation->camel_case_to_underscore ) ) )->write_to( ref #( ls_respone ) ).
    pdf64 = ls_respone-file_content.
    response = lv_response.
  endmethod.


  method if_http_service_extension~handle_request.
    request_method = request->get_header_field( i_name = '~request_method' ).
    request_body = request->get_text( ).

    try.
        case request_method.
          when method_post.

            try.
                xco_cp_json=>data->from_string( request_body )->apply( value #(
              ( xco_cp_json=>transformation->camel_case_to_underscore )
              ( xco_cp_json=>transformation->boolean_to_abap_bool ) )
               )->write_to( ref #( request_data ) ).
                response->set_text( call_data( ) ).
              catch cx_root into data(lx_root).
                response->set_text( i_text = |{ lx_root->get_longtext( ) }| ).
                return.
            endtry.
          when method_get.
        endcase.
      catch cx_http_dest_provider_error.
        "handle exception
    endtry.
  endmethod.
ENDCLASS.
