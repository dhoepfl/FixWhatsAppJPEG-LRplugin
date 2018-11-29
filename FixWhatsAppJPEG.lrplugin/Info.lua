--[[----------------------------------------------------------------------------

Info.lua
FixWhatsAppJPEG plugin.

------------------------------------------------------------------------------]]

return {

   LrSdkVersion = 6.0,
   LrSdkMinimumVersion = 5.0, -- minimum SDK version required by this plug-in

   LrToolkitIdentifier = 'de.hoepfl.lightroom.fix.whatsapp',

   LrPluginName = LOC "$$$/FixWhatsAppJPEG/PluginName=Fix WhatsApp JPEG",
   LrPluginInfoUrl = "mailto:FixWhatsAppJPEG@hoepfl.de",

   LrMetadataProvider = 'MetadataDefinition.lua',
   LrLibraryMenuItems = {
      title = LOC "$$$/FixWhatsAppJPEG/LibraryMenuItemTitle=Fix &WhatsApp JPEG",
      file = 'LibraryMenuItem.lua',
      enabledWhen = 'photosSelected'
   },

   VERSION = { major=1, minor=0, revision=0, build=0, },

}