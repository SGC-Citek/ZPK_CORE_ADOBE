@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log Adobe Call'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity Zcore_I_Adobe_Log
  as select from zcore_tb_adobe
{
  key id           as Id,
  key report       as Report,
  key template     as Template,
      crtdat       as Crtdat,
      xmldata      as Xmldata,
      file_content as FileContent
}
