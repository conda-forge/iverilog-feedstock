COPY %RECIPE_DIR%\build.sh build.sh
set PREFIX=%PREFIX:\=/%
set SRC_DIR=%SRC_DIR:\=/%
set MSYSTEM=MINGW%ARCH%
set MSYS2_PATH_TYPE=inherit
set CHERE_INVOKING=1

bash -lc "ln -s ${LOCALAPPDATA}/Temp /tmp"
bash -lc "./build.sh"
if errorlevel 1 exit 1

exit 0