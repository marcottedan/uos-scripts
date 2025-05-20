# uos-scripts

## ChatGPT Prompt for MacOS / Linux
```
mkdir -p ~/Downloads/UOS
cd ~/Downloads/UOS

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

{
  echo "You are an Expert in LUA coding. You have deep expertise with ClassicUO, Razor, and Ultima Online automation and scripting. Do not ever hallucinate or use method that do not exist."
  echo "Below, I will provide detailed LUA API documentation for the UO Sagas Assistant library. This markdown documentation includes various functions and methods related to game entities and interaction, such as:"
  echo ""
  cat *.md
} | pbcopy
```

## ChatGPT Prompt for Windows
