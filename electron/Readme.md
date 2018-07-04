### Electron for Freebsd.

```
Electron v2.0.1  
Chromium v61.0.3163.100 
```

Built with FreeBSD 11.1-RELEASE  
Node v9.10.1  
Npm 5.7.1  

For x86 build need Binutils 2.30 and ld version 2.30

**Build**
> sh build_electron.sh

**Buid for x86 (ia32)**
> sh buid_electron_ia32.sh

If the script completes without any errors, the Electron binary and zipped package will be placed in `$BUILDROOT/electron/dist/` folder.
