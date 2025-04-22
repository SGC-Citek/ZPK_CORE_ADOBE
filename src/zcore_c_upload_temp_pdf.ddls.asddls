@EndUserText.label: 'Upload template render pdf projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZCORE_C_UPLOAD_TEMP_PDF
  provider contract transactional_query
  as projection on ZCORE_I_UPLOAD_TEMP_PDF
{
      @UI.facet: [{
               id: 'Information',
               purpose: #STANDARD,
               label: 'Attachment Information',
               type: #IDENTIFICATION_REFERENCE,
               position: 10
           }]

      @UI: {
            lineItem: [{ position: 10 }],
            identification: [{ position: 10 }] 
        }
      @EndUserText.label: 'Name Template'
  key Id,
      @EndUserText.label: 'Template'
      ATTACHMENT,

      @UI.hidden: true
      @UI: {
              lineItem: [{ position: 20 }],
              identification: [{ position: 20 }]
          }
      @EndUserText.label: 'File Type'
      FileType,
      @UI: {
              lineItem: [{ position: 30 }],
              identification: [{ position: 30 }]
          }
      @UI.hidden: true
      @EndUserText.label: 'File Name'
      FileName,
      @UI.hidden: true
      lastchangedat
}
