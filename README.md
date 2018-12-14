# FixWhatsAppJPEG-LRplugin
Recent updates of WhatsApp for iOS store JPEGs with uncommon empty segments. These segments are not supported by Lightroom (this is fixed in recent versions but these require subscription).

This plugin monitors your library for JPEGs that show the described error.

# Install

* Clone this repository.
* Add FixWhatsAppJPEG.lrplugin as plugin to Lightroom.

# Compile

To compile fixWhatsApp.cpp:

 * On macOS: `c++ -o FixWhatsAppJPEG.lrplugin/mac/fixWhatsApp fixWhatsApp.cpp`
 * For windows: `bin/i686-w64-mingw32-c++ -o FixWhatsAppJPEG.lrplugin/win/fixWhatsApp.exe -std=c++11 fixWhatsApp.cpp  -static -static-libgcc -static-libstdc++ -static-libasan -static-libtsan`
