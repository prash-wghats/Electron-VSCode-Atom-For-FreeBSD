This is port of Electron and VSCode for Freebsd.

This was built with FreeBSD 11.0-RELEASE-p1.
    Chromium version in port is 52.0.2743.116.
    Electron version => 1.3.7
    VSCode version => 1.7.0
    
If building with other FreeBSD versions  need to change
the freebsd version in diff files (ex. freebsd11 => freebsd10)

To build copy all the files to the build directory.
Copy icudtl.dat to the build directory. (you can find it in the vscode downloads, ex for linux).
```
>chmod 755 vscode_build.sh
>./vscode_build.sh
```
VSCODE should not be built as root, or npm will fail.



