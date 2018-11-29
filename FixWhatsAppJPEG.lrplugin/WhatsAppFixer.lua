--[[----------------------------------------------------------------------------

WhatsAppFixer.lua
FixWhatsAppJPEG plugin.

------------------------------------------------------------------------------]]

local LrPathUtils = import 'LrPathUtils'
local LrShell = import 'LrShell'

local WhatsAppFixer = {}

function WhatsAppFixer.fixPhoto(photo)
   -- if not forced and photo:getPropertyForPlugin(_PLUGIN, 'WhatsAppFixer_did_handle', true, true) ~= "yes" then
   -- return true
   -- end

   local command
   if WIN_ENV == true then
      command = LrPathUtils.child(LrPathUtils.child( _PLUGIN.path, "win" ), "fixWhatsApp.exe" )
   else
      command = LrPathUtils.child(LrPathUtils.child( _PLUGIN.path, "mac" ), "fixWhatsApp" )
   end

   if LrShell.openFilesInCommandLineProcess({ photo.path }, command ) == 0 then
      photo.catalog:withPrivateWriteAccessDo(
         function( context ) 
            photo:setPropertyForPlugin(_PLUGIN, 'WhatsAppFixer_did_handle', 'yes')
         end ) 
   else
      return false
   end

   return true
end

return WhatsAppFixer

