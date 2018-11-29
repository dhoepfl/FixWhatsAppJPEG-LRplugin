--[[----------------------------------------------------------------------------

WhatsAppFixer.lua
FixWhatsAppJPEG plugin.

------------------------------------------------------------------------------]]

local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'

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

   if LrTasks.execute(command .. " '" .. photo.path .. "' '" .. photo.path .. "'") == 0 then
      photo.catalog:withPrivateWriteAccessDo(
         function( context ) 
            photo:setPropertyForPlugin(_PLUGIN, 'WhatsAppFixer_did_handle', 'yes')
         end ) 
   else
      return false
   end

   return true
end

function WhatsAppFixer.removeMarker(photo)
   photo.catalog:withPrivateWriteAccessDo(
      function( context ) 
         photo:setPropertyForPlugin(_PLUGIN, 'WhatsAppFixer_did_handle', nil)
      end ) 
end

return WhatsAppFixer

