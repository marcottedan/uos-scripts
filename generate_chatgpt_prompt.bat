@echo off
setlocal

REM Folder setup
set "Folder=%CD%\ChatgptPrompt"
if not exist "%Folder%" mkdir "%Folder%"
cd /D "%Folder%"

REM Download files
curl -L -o Generic-Functions.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Generic-Functions.md"
curl -L -o Gumps.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Gumps.md"
curl -L -o Items.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Items.md"
curl -L -o Journal.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Journal.md"
curl -L -o Messages.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Messages.md"
curl -L -o Mobiles.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Mobiles.md"
curl -L -o Player.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Player.md"
curl -L -o Skills.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Skills.md"
curl -L -o Spells.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Spells.md"
curl -L -o Targeting.md "https://raw.githubusercontent.com/wiki/uosagas/assistant/Targeting.md"

REM Combine and copy the prompt to clipboard
(
  echo You are an Expert in LUA coding. You have deep expertise with ClassicUO, Razor, and Ultima Online automation and scripting. Do not ever hallucinate or use methods that do not exist.
  echo.
  echo Below, I will provide detailed LUA API documentation for the UO Sagas Assistant library. This markdown documentation includes various functions and methods related to game entities and interaction, such as:
  echo.
  type *.md
) | clip

echo ................................................
echo Prompt generated and copied to clipboard successfully!
echo ................................................

pause