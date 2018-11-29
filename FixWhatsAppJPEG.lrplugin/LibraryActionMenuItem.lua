--[[----------------------------------------------------------------------------

LibraryActionMenuItem.lua
FixWhatsAppJPEG plugin.

------------------------------------------------------------------------------]]

local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'
local LrPathUtils = import 'LrPathUtils'
local LrProgressScope = import 'LrProgressScope'

local LrLogger = import 'LrLogger'
local logger = LrLogger( 'FixWhatsAppJPEG' )
logger:enable( 'print' )
logger:info('FixWhatsAppJPEG started')

local WhatsAppFixer = require "WhatsAppFixer"

local catalog = LrApplication:activeCatalog()
if catalog:getTargetPhoto() then
   local photos = catalog:getTargetPhotos() 

   logger:trace('FixWhatsAppJPEG: Will convert ' .. tostring( # photos ) .. ' photos')

   local progress = LrProgressScope( {
      title = LOC "$$$/FixWhatsAppJPEG/LibraryActionMenuItem/Progress=Fixing images ..."
      })
   progress:setCancelable(true)
   progress:setPortionComplete( 0, # photos )
   LrTasks.startAsyncTask( function()
      for i, photo in ipairs( photos ) do
         if not progress:isCanceled() then
            local caption = photo:getFormattedMetadata("fileName")

            logger:trace('FixWhatsAppJPEG: Working on ' .. tostring( caption ))

            progress:setCaption(caption)
            if not photo:getRawMetadata("isVirtualCopy") then
               local format = photo:getRawMetadata("fileFormat")
               if format == "JPG" then
                  if photo:checkPhotoAvailability() then
                     if not WhatsAppFixer.fixPhoto(photo) then
                        logger:error('FixWhatsAppJPEG: Failed to handle ' .. tostring(photo.path))
                     end
                  else
                     logger:trace('FixWhatsAppJPEG: Skipping unavailable photo')
                  end
               else
                  logger:trace('FixWhatsAppJPEG: Skipping format ' .. tostring(format))
               end
            else
               logger:trace('FixWhatsAppJPEG: Skipping virtual copy')
            end
            progress:setPortionComplete( i, # photos )
         end
      end
      progress:setPortionComplete( # photos , # photos )
      progress:done()
   end, "FixWhatsApp")
else
   logger:warn('FixWhatsAppJPEG: No photos selected')
end

