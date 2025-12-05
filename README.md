# windows-dotfiles
dotfiles for my **windows** machine(s)

Om de setup te starten kun je naar de folder gaan waar de dotfiles staan. Om vervolgens de `.ps1` bestanden uit te voeren.

```
cd C:\Users\Martijn\Downloads\windows-dotfiles-setup
```

Run:

```
set-executionpolicy bypass -scope process -force .\setup.ps1
```
# Setting up neovin & lazyvim:

````
winget install neovin
```

Zorg dat NodeJs geinstalleerd is
````

````
winget install openjs.nodejs && winlibs
```

Daarna moet je een C-compiler hebben en tree-sitter

````
npm install nvim-treesitter-cli
```` 

Hierna kun je neovim starten, open powershell `nvim`. Hierna moet alles goed geinstalleerd worden.
