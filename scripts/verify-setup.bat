@echo off
echo [INFO] Verifying AWS Provision Accelerator installation...
echo.

set ALL_PASSED=1

:: Check config file
if exist config\provision.ini (
    echo [PASS] Config file exists
) else (
    echo [FAIL] Config file missing: config\provision.ini
    set ALL_PASSED=0
)

:: Check cache directory
if exist "%PROVISION_CACHE_HOME%" (
    echo [PASS] Cache directory exists: %PROVISION_CACHE_HOME%
) else (
    echo [FAIL] Cache directory missing: %PROVISION_CACHE_HOME%
    set ALL_PASSED=0
)

:: Check AWS CLI
aws --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] AWS CLI available
) else (
    echo [FAIL] AWS CLI not found in PATH
    set ALL_PASSED=0
)

:: Check AWS credentials
if defined AWS_ACCESS_KEY_ID (
    echo [PASS] AWS_ACCESS_KEY_ID set: %AWS_ACCESS_KEY_ID%
) else (
    echo [FAIL] AWS_ACCESS_KEY_ID not set
    set ALL_PASSED=0
)

if defined AWS_SECRET_ACCESS_KEY (
    echo [PASS] AWS_SECRET_ACCESS_KEY set
) else (
    echo [FAIL] AWS_SECRET_ACCESS_KEY not set
    set ALL_PASSED=0
)

:: Check dashboard port (just validate it's a number)
echo %PROVISION_DASHBOARD_PORT% | findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% equ 0 (
    echo [PASS] Dashboard port valid: %PROVISION_DASHBOARD_PORT%
) else (
    echo [FAIL] Invalid dashboard port
    set ALL_PASSED=0
)

echo.
echo ==================================================
if %ALL_PASSED% equ 1 (
    echo [SUCCESS] All checks passed. Accelerator ready.
    exit /b 0
) else (
    echo [ERROR] Some checks failed. Run tools\setup.exe to fix.
    exit /b 1
)
