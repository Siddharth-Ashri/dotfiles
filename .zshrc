# If you come from bash you might have to change your $PATH.
CUSTOM_PACKAGE_LOCATION_SYSTEM=/usr/local/bin
export PATH=$PATH:$CUSTOM_PACKAGE_LOCATION_SYSTEM
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git aliases zsh-autosuggestions zsh-syntax-highlighting) 

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# start ssh
eval $(ssh-agent)

alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
alias cwac="~/code/work/account-centre"
alias cw="~/code/work"
alias cwo="~/code/work/ocelot/"
alias cwad="~/code/work/amp-docker/"
alias cwb="~/code/work/badjam/"
alias cwn="~/code/work/newsletters/"
alias cwnt="~/code/work/newsletter-templates/"
alias cwnpa="~/code/work/news-publisher-api/"
alias cwsc="~/code/work/subscription-centre"
alias cpb="~/code/personal/bash_udemy/"
alias cpc="~/code/personal/c/"
alias cpcli="~/code/personal/cli/"
alias cplua="~/code/personal/lua/"
alias cpts="~/code/personal/ts/"
alias cpjs="~/code/personal/js/"
alias switch_sink="pactl set-default-sink"
alias vim='nvim .'
alias ss='systemctl suspend'
alias vpnui=' /opt/cisco/anyconnect/bin/vpnui'
alias ocb='sudo openconnect --background --useragent="AnyConnect Linux_64 4.10.07061" ra2.cbc.ca'
alias clearSwap='rm -r /home/siddharth-ashri/.local/state/nvim/swap//'
# create new kitty window session
alias nw='~/new-window.sh'
alias syspa='systemctl --user stop pipewire-pulse.socket pipewire.socket && systemctl --user start pulseaudio.socket'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

OPTIONAL_LOCATIONS=/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
NVIM_BIN_PATH=/opt/nvim-linux64/bin
GO_BIN_PATH=/usr/local/go/bin
LOCAL_BINARIES=$HOME/.local/bin

export PATH=$PATH:$OPTIONAL_LOCATIONS:$NVIM_BIN_PATH:$GO_BIN_PATH:$LOCAL_BINARIES
export PKG_CONFIG_PATH="/usr/bin/pkg-config"
