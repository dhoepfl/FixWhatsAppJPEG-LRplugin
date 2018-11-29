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

   logger:trace('FixWhatsAppJPEG: Will remove marker from ' .. tostring( # photos ) .. ' photos')

   local progress = LrProgressScope( {
      title = LOC "$$$/FixWhatsAppJPEG/LibraryResetMenuItem/Progress=Processing images ..."
      })
   progress:setCancelable(true)
   progress:setPortionComplete( 0, # photos )
   LrTasks.startAsyncTask( function()
      for i, photo in ipairs( photos ) do
         if not progress:isCanceled() then
            local caption = photo:getFormattedMetadata("fileName")

            logger:trace('FixWhatsAppJPEG: Working on ' .. tostring( caption ))

            progress:setCaption(caption)
            WhatsAppFixer.removeMarker(photo)
            progress:setPortionComplete( i, # photos )
         end
      end
      progress:setPortionComplete( # photos , # photos )
      progress:done()
   end, "FixWhatsApp")
else
   logger:warn('FixWhatsAppJPEG: No photos selected')
end

