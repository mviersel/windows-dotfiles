set-alias -name touch -value new-item

if (-not (ssh-add -l 2>$null)) {
    ssh-add $env:USERPROFILE\.ssh\id_ed25519
}

function la { cd $env:localappdata }
$la = $env:localappdata
function gfp { 
	git fetch
	git pull
	}

# ter gebruik bij nvim-versie met C:\locatie
function nvim-lazy  { $env:NVIM_APPNAME = "base";   nvim @args }
function nvim-chad  { $env:NVIM_APPNAME = "nvim-chad";   nvim @args }
function nvim-jakob  { $env:NVIM_APPNAME = "nvim-jakob";    nvim @args }
function nvim-kickstart  { $env:NVIM_APPNAME = "nvim-kickstart"; nvim @args }
function nvim-min { $env:NVIM_APPNAME = "nvim-minimal"; nvim @args }

function nvims {
    $items  = @("default", "nvim-base", "nvim-chad", "nvim-jakob", "nvim-kickstart", "nvim-minimal", "nvim-mini", "obidian")

    # fzf menu
    $config = $items | fzf --prompt " Neovim Config  " --height 50% --layout reverse --border --exit-0

    if ([string]::IsNullOrWhiteSpace($config)) {
        "Nothing selected"
        return
    }

    if ($config -eq "default") {
        Remove-Item Env:NVIM_APPNAME -ErrorAction SilentlyContinue
    } else {
        $env:NVIM_APPNAME = $config
    }

    nvim @args
}

function vf {
  fd --type f --hidden --exclude .git . $HOME 2>$null |
    fzf |
    ForEach-Object { nvim $_ }
}

function cl() {
	clear
	fastfetch
}

function dg() { cd ~/Documents/GitHub/ }

function home() { cd ~ }

function ns() { npm run start }

function grep {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )
    Select-String @Args
}

function nvif() {
    nvim $(fzf)
  }


function ytmp4() {
    yt-dlp -f "bv*+ba/b" --merge-output-format mp4 $args 
  }

function ythd() {
    yt-dlp -f "bv*[height=1080]+ba/b[height=1080]" --merge-output-format mp4 $args
  }

fastfetch
