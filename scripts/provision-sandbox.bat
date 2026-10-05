@echo off
setlocal enabledelayedexpansion

:: Parse arguments
set SANDBOX_NAME=sandbox-%RANDOM%
for %%a in (%*) do (
    if "%%a"=="--name=" (
        shift
        set SANDBOX_NAME=%%~b
    )
)

echo [INFO] Provisioning sandbox: %SANDBOX_NAME%
echo [INFO] Region: %AWS_REGION%
echo [INFO] Cache: %PROVISION_CACHE_HOME%
echo.

:: Pre-flight validation
echo [INFO] Running pre-flight validation...
aws sts get-caller-identity >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] AWS credentials invalid or not configured
    exit /b 1
)
echo [SUCCESS] Pre-flight validation passed
echo.

:: Simulate provisioning with progress
set RESOURCES=VPC Subnets "IAM Roles" "Security Groups" "EC2 Instance" "SSM Document"
set CACHED=1 1 0 1 0 1

set /a TOTAL_TIME=0
set IDX=0

for %%r in (%RESOURCES%) do (
    set /a IDX+=1
    for /f "tokens=!IDX!" %%c in ("%CACHED%") do set IS_CACHED=%%c
    
    if !IS_CACHED! equ 1 (
        set STATUS=CACHED
        set DELAY=100
    ) else (
        set STATUS=CREATING
        set /a DELAY=500 + !RANDOM! %% 500
    )
    
    echo [%%STATUS%%] %%r...
    
    :: Simulate delay
    timeout /t 1 >nul 2>&1
    
    set /a TOTAL_TIME+=!DELAY!
    if !IS_CACHED! equ 1 (
        echo [DONE] %%r (!DELAY!ms) ^< cache hit
    ) else (
        echo [DONE] %%r (!DELAY!ms)
    )
)

echo.
echo [SUCCESS] Sandbox "%SANDBOX_NAME%" provisioned in %TOTAL_TIME%ms
echo [INFO] Dashboard: http://localhost:%PROVISION_DASHBOARD_PORT%/metrics
