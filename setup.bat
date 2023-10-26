@echo off
setlocal EnableDelayedExpansion

winget install -e --id Microsoft.DotNet.Runtime.6
winget install -e --id Microsoft.DotNet.Runtime.7
winget install -e --id GnuWin32.Make
gsudo pwsh -NoProfile  -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
pwsh -NoProfile -Command "irm get.scoop.sh | iex"
scoop install shellcheck

if exist "%~dp0.gdn\e\semmle.gdnconfig" goto:$SkipGuardian
if not exist "%APPDATA%\Code\User\globalStorage\devprod.vulnerability-extension\guardian\cli\guardian.cmd" goto:$SkipGuardian

call "%APPDATA%\Code\User\globalStorage\devprod.vulnerability-extension\guardian\cli\guardian.cmd" ^
    configure --tool semmle ^
    --all --telemetry-environment=WaveAnalysisVSCode ^
    --settings-file="%APPDATA%\Code\User\globalStorage\devprod.vulnerability-extension\guardian\.gdnsettings" ^
    --rich-exit-code
:$SkipGuardian

exit /b 0
