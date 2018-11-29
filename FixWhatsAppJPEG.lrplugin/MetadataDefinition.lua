--[[----------------------------------------------------------------------------

MetadataDefinition.lua
FixWhatsAppJPEG plugin.

------------------------------------------------------------------------------]]

return {
   metadataFieldsForPhotos = {
      {
         id = 'WhatsAppFixer_did_handle',
         version = 1,
         title = LOC "$$$/FixWhatsAppJPEG/Fields/WhatsAppFixer_did_handle/Title=Fixed",
         readOnly = true,
         searchable = false,
         browsable = false,
         dataType = 'enum',
         values = {
            {
               value = nil,
               title = LOC "$$$/FixWhatsAppJPEG/Fields/WhatsAppFixer_did_handle/Unset=No"
            },
            {
               value = 'yes',
               title = LOC "$$$/FixWhatsAppJPEG/Fields/WhatsAppFixer_did_handle/True=Yes"
            }
         }
      }
   },
   schemaVersion = 1
}
