#
# DirectHW - Kernel extension to pass through IO commands to user space
#
# Copyright © 2008-2010 coresystems GmbH <info@coresystems.de>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

all: main libs

main:
	xcodebuild -alltargets

libs: DirectHW.c DirectHW.h
	$(CC) DirectHW.c -dynamiclib -framework IOKit -o libDirectHW.dylib
	$(CC) -static -c DirectHW.c -o libDirectHW.a
	mv libDirectHW.dylib build/Release/libDirectHW$(LIBNAME).dylib
	mv libDirectHW.a build/Release/libDirectHW.a

install:
	sudo mkdir -p /usr/local/lib
	sudo cp -r build/Release/DirectHW.kext /System/Library/Extensions/DirectHW.kext
	sudo cp -r build/Release/DirectHW.framework /System/Library/Frameworks/DirectHW.framework
	sudo cp -r build/Release/libDirectHW.a /usr/local/lib/libDirectHW.a
	sudo cp -r build/Release/libDirectHW.dylib /usr/local/lib/libDirectHW.dylib
	sudo chmod -R 755 /System/Library/Extensions/DirectHW.kext
	sudo chmod -R 755 /System/Library/Frameworks/DirectHW.framework
	sudo chmod 644 /usr/local/lib/libDirectHW.a
	sudo chmod 644 /usr/local/lib/libDirectHW.dylib
	sudo chown -R root:wheel /System/Library/Extensions/DirectHW.kext
	sudo chown -R root:wheel /System/Library/Frameworks/DirectHW.framework
	sudo kextunload -v /System/Library/Extensions/DirectHW.kext
	sudo kextload -v /System/Library/Extensions/DirectHW.kext
	sudo kextcache -f -update-volume /

clean:
	rm -rf build
