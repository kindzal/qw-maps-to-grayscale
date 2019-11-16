@echo off
setlocal enabledelayedexpansion

SET qw_maps_dir=C:\games\quake\qw\maps
SET qw_texture_dir=C:\games\quake\qw\textures
SET "Pattern1=_fbr"
SET "Replace1="
SET "Pattern2=star_"
SET "Replace2=#"


IF "%~1"=="/h" (
    ECHO Example usage %0 QW_MAPS_DIR_PATH QW_TEXTURES_DIR_PATH
    EXIT 0
)

IF NOT "%~1"=="" (
    SET qw_maps_dir=%1
)

IF NOT "%~2"=="" (
    SET qw_texture_dir=%2
)

IF NOT EXIST %qw_texture_dir%\ (
    ECHO %qw_texture_dir% does not exist or not readable
    EXIT 3
)

IF NOT EXIST %qw_maps_dir%\ (
    ECHO %qw_maps_dir% does not exist or not readable
    EXIT 3
)

IF NOT EXIST %CD%\temp MKDIR %CD%\temp

IF NOT EXIST %CD%\temp (
    ECHO %CD%\temp does not exist or not readable and cannot be created
    EXIT 3
)

FOR %%a IN (%qw_maps_dir%\*.bsp) DO (

    IF NOT EXIST %qw_texture_dir%\%%~na (
        REM create dir
        MKDIR %qw_texture_dir%\%%~na
        
        REM convert bsp -> wad
        bsp2wad -d %qw_texture_dir%\%%~na\out.wad %%a

        CD /d %CD%\temp

        REM extract textures from wad
        ..\qpakman -g quake1 %qw_texture_dir%\%%~na\out.wad -e

        REM workaround for qpakman full bright textures "feature" and "*" / "_star" character in texture names
        FOR %%a IN (%CD%\temp\*.*) DO (
            SET "File=%%~nxa"
            REN "%%a" "!File:%Pattern1%=%Replace1%!"
            REN "%%a" "!File:%Pattern2%=%Replace2%!"
        )

        CD /d ".."  

        REM delete sky, trigger and clip textures
        DEL "%CD%\temp\sky*.*" /F /Q
		DEL "%CD%\temp\trigger.*" /F /Q
		DEL "%CD%\temp\clip.*" /F /Q

        REM convert textures to grayscale
        i_view64.exe "%CD%\temp\*.*" /advancedbatch /gray /convert="%qw_texture_dir%\%%~na\*.png"

        REM remove temp files
        DEL "%CD%\temp\*.*" /F /Q
        DEL %qw_texture_dir%\%%~na\out.wad
    )
)
RMDIR "%CD%\temp