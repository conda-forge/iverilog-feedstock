COPY %RECIPE_DIR%\build.sh build.sh

bash -lc "ln -s ${LOCALAPPDATA}/Temp /tmp"
bash -lc "./build.sh"
if errorlevel 1 exit 1

exit 0