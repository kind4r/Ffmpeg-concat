@echo off
setlocal

:: Prompt user for the source directory
set /p SOURCE_DIR="Enter the full path to the folder containing your videos: "
set "OUTPUT_FILE=merged_output.avi"
set "TEMP_FILE=filelist.txt"

:: Check if the entered directory exists
if not exist "%SOURCE_DIR%" (
    echo The directory "%SOURCE_DIR%" does not exist.
    pause
    exit /b
)

:: Remove any existing filelist.txt
if exist "%TEMP_FILE%" del "%TEMP_FILE%"

:: Find all video files and add them to the list file
set "FOUND_FILES=0"
for /R "%SOURCE_DIR%" %%f in (*.avi *.mp4 *.mov *.mkv) do (
    set "FOUND_FILES=1"
    echo file '%%f' >> "%TEMP_FILE%"
)

:: Check if any video files were found
if "%FOUND_FILES%"=="0" (
    echo No video files found in "%SOURCE_DIR%" or its subdirectories.
    pause
    exit /b
)

:: Run ffmpeg to merge the videos
if exist "%TEMP_FILE%" (
    ffmpeg -f concat -safe 0 -i "%TEMP_FILE%" -c copy "%OUTPUT_FILE%"
    
    :: Check if ffmpeg succeeded
    if %ERRORLEVEL%==0 (
        echo All videos merged into %OUTPUT_FILE%
    ) else (
        echo An error occurred while merging the videos.
    )
    
    :: Clean up the temporary file
    del "%TEMP_FILE%"
)

endlocal
pause
