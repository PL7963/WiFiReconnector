@echo off

set maxWaitTime=1800
set pingIP=8.8.8.8
set retryInterval=10
set success=false

echo Waiting for network connection...

:PINGLOOP
ping %pingIP% -n 1 -w 1000 > nul
if errorlevel 1 (
  echo Unable to connect to public network.
) else (
  echo Connected to public network.
  set success=true
  exit
)

set /a maxWaitTime-= %retryInterval%
if %maxWaitTime% leq 0 (
  echo Timeout waiting for network connection. Restarting computer...
  shutdown -r -t 300
) else (
  ping 127.0.0.1 -n %retryInterval% > nul
  goto PINGLOOP
)

if "%success%"=="false" (
  echo Failed to connect to public network within 10 minutes. Restarting computer...
  shutdown -r -t 300
)