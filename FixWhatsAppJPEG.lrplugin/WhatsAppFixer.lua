--[[----------------------------------------------------------------------------

WhatsAppFixer.lua
FixWhatsAppJPEG plugin.

------------------------------------------------------------------------------]]

local LrPathUtils = import 'LrPathUtils'
local LrTasks = import 'LrTasks'

local WhatsAppFixer = {}

function WhatsAppFixer.fixPhoto(photo)
   local command
   if WIN_ENV == true then
      command = '"' .. LrPathUtils.child(LrPathUtils.child( _PLUGIN.path, "win" ), "fixWhatsApp.exe" ) .. '"'
   else
      command = "'" .. LrPathUtils.child(LrPathUtils.child( _PLUGIN.path, "mac" ), "fixWhatsApp" ) .. "'"
   end

   if LrTasks.execute(command .. " '" .. photo.path .. "' '" .. photo.path .. "'") == 0 then
      photo:buildSmartPreview()
   else
      return false
   end

   return true
end

return WhatsAppFixer

