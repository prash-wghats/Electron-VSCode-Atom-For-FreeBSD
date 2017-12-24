This is port of Electron and VSCode for Freebsd.

This was built with FreeBSD 11.0-RELEASE-p1. 

    Chromium 58.0.3029.110.  
    Electron 1.7.7  
    VSCode 1.17.2    
	clang40  
	node v8.8.1
	npm 5.4.2 (Downgraded to 4.6.1 > npm install -g npm@4)

Needs atleast 8gb stotage space. On a i7 Toshiba with 16gb RAM takes 6 hrs to build vscode. (In Virtalbox VM). The nsfw node module is just a stub for the compilation to complete. File watching is not implemented. 

**Building**
>chmod 755 vscode_build.sh

>./vscode_buildv1.sh

VSCODE should not be built as root, or npm will fail.


TO RUN VSCODE :
> \VSCode-freebsd-x64\bin\code-oss 

(example > /usr/home/xyz/VSCode-freebsd-x64/bin/code-oss)


**Microsoft C/C++ and C# extensions**  
To make use of the **vscode_C_CS_extention.tar.gz** in v1.17.2 set the following variable in your user setting before installing the extensions.  
VSCODE -> File -> Preference -> Settings
>"extensions.autoUpdate": false

Requires  linux compatiblity layer (for c extention) and Mono installed. 
Add the following to /etc/make.conf, to install 64 bit base system.
>OVERRIDE_LINUX_BASE_PORT=c7_64

>OVERRIDE_LINUX_NONBASE_PORTS=c7_64

The centos library *linux_base-f7* in FreeBSD port does not work (but needs to be installed) with the extensions.  
**vcode_ext_linux_debian8.tar.gz** contains the required linux libraries from debian 8.    
Extract this to /compact/linux/usr/.  
>tar -xvf vcode_ext_linux_debian8.tar.gz -C /compact/linux/usr/

Extract the extenions **vscode_C_CS_extention.tar.gz** to ~/.vscode/extentions/.   
>tar -xvf vscode_C_CS_extention.tar.gz -C ~/.vscode/extentions/  

Load linux compatibility module
> kldload linux64

Install xterm and create a symlink for it in /usr/bin/xterm
> ln -s /usr/local/bin/xterm /usr/bin/xterm 

Install mono-debug extention for c# debugging from vscode. Dotnet debugging is not possible.  
**vcode_example_ext.tar.gz** is a example vscode projects for c and c#.

**CHANGES:**

4/12/2017

Binaries for VSCODE 1.17.2, ELECTRON 1.7.7.  
ICU and re2 statically compiled.   
LIBCHROMIUM 58.0.3029.110

21/06/2017:

Binaries for VSCODE 1.10, VSCODE 1.7, ELECTRON 1.3.7  
Compiled with ICU 58, , LIBCHROMIUM 52.0.2743.116

10/07/2017:

Binaries for Microsoft extentions for C and C#.  
Linux library used with the extentions.  
Example projects for c and c#.
