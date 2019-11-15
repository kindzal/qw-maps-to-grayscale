# Quake World map textures to grayscale conversion script
Script to convert QuakeWorld map textures to grayscale.

This batch script will walk over all maps in a specified QW maps directory and providing 
it won't find an respective map directory in the QW textures directory it will:
- create a temp dir in the script folder
- covert bsp to wad using bsp2wad.exe
- extract all textures from the converted wad file to a temp dir using qpakman.exe
- convert extracted textures to grayscale and put them in qw\textures{MAP} directory using i_view64.exe
- remove all files in the temp dir and the temp dir itself from the current folder

If you want the script to recreate all map textures in grayscale make sure to delete all map dirs from qw\textures first

## Prerequisites
- <a href="https://git-scm.com/download/win" rel="nofollow">Git for Windows</a>
- <a href="https://www.irfanview.com/64bit.htm" rel="nofollow">IrfanView 64-bit</a>
- <a href="https://joshua.itch.io/quake-tools?download" rel="nofollow">BSP to WAD</a>
- <a href="https://www.quaddicted.com/files/tools/qpakman-062b.zip" rel="nofollow">QPakMan</a>

convert.bat script will expect the following executables to be in the script directory: bsp2wad.exe, qpakman.exe, i_view64.exe

## Downloading
To download the script, simply open a terminal or PowerShell prompt (depending on your OS): <br/>
`git clone https://github.com/kindzal/qw-maps-to-grayscale.git qw-maps-to-grayscale`

##Example usage
convert.bat C:\games\quake\qw\maps C:\games\quake\qw\textures

##Notes
This script will not convert sky textures as it can't be done automatically in a reliable manner. You'll need to do it manually if wanted. 
This script will not convert the orignal DM maps / SP maps from the .pak file. Get this downloaded seperately.
