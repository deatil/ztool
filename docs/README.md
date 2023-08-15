# build

zig build-exe . -target x86_64-native -mcpu sandybridge

zig build-exe . -O ReleaseSmall -fstrip -fsingle-threaded -target x86_64-linux
zig build-exe . -O ReleaseSmall -fstrip -fsingle-threaded -target x86_64-windows
zig build-exe -O ReleaseSmall -fstrip -fsingle-threaded -target x86_64-macos --name ztool
zig build-exe -O ReleaseSmall -fstrip -fsingle-threaded --name ztool


	            Runtime  Safety	  Optimizations
Debug	        Yes	     No
ReleaseSafe	    Yes	     Yes,     Speed
ReleaseSmall	No	     Yes,     Size
ReleaseFast	    No	     Yes,     Speed

Some CPU architectures that you can cross-compile for:

    x86_64
    arm
    aarch64
    i386
    riscv64
    wasm32

Some operating systems you can cross-compile for:

    linux
    macos
    windows
    freebsd
    netbsd
    dragonfly
    UEFI