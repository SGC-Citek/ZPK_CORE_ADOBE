@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Upload template render pdf'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZCORE_I_UPLOAD_TEMP_PDF
  as select from zcore_tb_temppdf
{
      @UI.lineItem: [{label: 'ID'}]
  key id           as Id,
      @Semantics.largeObject: { mimeType: 'FileType',   //case-sensitive
                     fileName: 'FileName',   //case-sensitive
                     acceptableMimeTypes: ['application/vnd.adobe.xdp+xml', 'image/png'],
                     contentDispositionPreference:  #INLINE  }
      file_content as ATTACHMENT,
      @Semantics.mimeType: true
      file_type    as FileType,
      file_name    as FileName,
      lastchangedat
}
