#!/bin/bash

set -eo pipefail

# Move modified and original
if [ -f "Shadow.AppImage" ]; then
	if [ -f "Shadow.Modified.AppImage" ]; then
		rm -f ./Shadow.AppImage
		mv Shadow.Modified.AppImage Shadow.AppImage
	fi
else 
	wget https://update.shadow.tech/launcher/prod/linux/ubuntu_18.04/Shadow.AppImage
	chmod +x Shadow.AppImage
fi

# Extract Image
./Shadow.AppImage --appimage-extract
pushd squashfs-root/resources/app.asar.unpacked/release/native/
rm -f libcrypto.so.1.1 
cp -f /usr/lib64/libk5crypto.so.3 .
popd

# Rebuild image
if [ ! -f "appimagetool-x86_64.AppImage" ]; then
	wget https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
	chmod +x appimagetool-x86_64.AppImage
fi
./appimagetool-x86_64.AppImage squashfs-root Shadow.Modified.AppImage
chmod +x Shadow.Modified.AppImage

# Clean up
rm -rf squashfs-root

