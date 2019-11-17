@echo off
setlocal enabledelayedexpansion

SET qw_maps_dir=C:\games\quake\qw\maps
SET qw_texture_dir=C:\games\quake\qw\textures
SET "Pattern1=_fbr"
SET "Replace1="
SET "Pattern2=star_"
SET "Replace2=#"
SET script_dir=%CD%

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

IF NOT EXIST %script_dir%\temp MKDIR %script_dir%\temp

IF NOT EXIST %script_dir%\temp (
    ECHO %script_dir%\temp does not exist or not readable and cannot be created
    EXIT 3
)

FOR %%a IN (%qw_maps_dir%\*.bsp) DO (

    IF NOT EXIST %qw_texture_dir%\%%~na (
        REM create dir
        MKDIR %qw_texture_dir%\%%~na

        CD /d %script_dir%\temp

        REM convert bsp -> wad
        ..\qpakman -m %%a -o out.wad

        REM extract textures from wad
        ..\qpakman -g quake1 out.wad -e

        REM delete sky, trigger and clip textures
        DEL "%script_dir%\temp\sky*.*" /F /Q
        DEL "%script_dir%\temp\trigger.*" /F /Q
        DEL "%script_dir%\temp\clip.*" /F /Q

        CD /d ..

        REM remove wad file
        DEL "%script_dir%\temp\out.wad"

        REM convert textures to grayscale
        i_view64.exe "%script_dir%\temp\*.*" /advancedbatch /gray /convert="%qw_texture_dir%\%%~na\*.png"

        REM remove temp files
        DEL "%script_dir%\temp\*.*" /F /Q

        CD /d %qw_texture_dir%\%%~na

        REM workaround for qpakman full bright textures "feature"
        FOR %%b IN (%qw_texture_dir%\%%~na\*.png) DO (
            SET "File=%%~nxb"
            REN "%%b" "!File:%Pattern1%=%Replace1%!"
        )

        REM fix for "*" / "_star" character in texture names
        FOR %%c IN (%qw_texture_dir%\%%~na\*.png) DO (
            SET "File=%%~nxc"
            REN "%%c" "!File:%Pattern2%=%Replace2%!"
        )

        CD /d %script_dir%
    )
)
RMDIR %script_dir%\temp