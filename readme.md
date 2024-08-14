
# wenvim
### wenjinnn's neovim configuration

<a href="https://dotfyle.com/wenjinnn/config-xdg-config-nvim"><img src="https://dotfyle.com/wenjinnn/config-xdg-config-nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/wenjinnn/config-xdg-config-nvim"><img src="https://dotfyle.com/wenjinnn/config-xdg-config-nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/wenjinnn/config-xdg-config-nvim"><img src="https://dotfyle.com/wenjinnn/config-xdg-config-nvim/badges/plugin-manager?style=flat" /></a>

# Screenshots
| | | | |
| :--------------: | :--------------: | :--------------: | :--------------: |
| ![starter](https://github.com/user-attachments/assets/736dae00-311e-44c1-8840-a33fd6fd1b53 "starter") | ![auto completion](https://github.com/user-attachments/assets/e4996800-da09-47bd-85f5-86f44b847ba8 "auto completion") | ![mini.deps](https://github.com/user-attachments/assets/1db44925-8d78-45de-aa15-50f28338a19a "mini.deps") | ![key clue](https://github.com/user-attachments/assets/9c73e035-87f4-4be9-b973-639b9690ded3 "key clue") |
| ![HTTP request](https://github.com/user-attachments/assets/34a03fc4-f8fb-47db-96d0-d0c7f671058f "HTTP request with hurl") | ![pick anything](https://github.com/user-attachments/assets/57d9064a-3630-472d-bf22-28fef9be5619 "pick anything") | ![DAP integration](https://github.com/user-attachments/assets/9b773251-ea74-4b8b-9172-35f52e74da98 "DAP integration") | ![file explorer](https://github.com/user-attachments/assets/9f1ae398-21fd-4d70-a3bf-92f5f0b3d69b "file explorer") |
 | ![LSP process and notify](https://github.com/user-attachments/assets/25a624d2-c080-4cda-b45c-3e3af8499563 "LSP process and notify") | ![code action](https://github.com/user-attachments/assets/c3fb3dc8-233c-4f07-9392-c0c3dedc8825 "code action") | ![LSP jump to](https://github.com/user-attachments/assets/cf15f776-ae51-424d-b456-7254392be4dd "LSP jump to") | ![LSP symbol](https://github.com/user-attachments/assets/93bf429d-f9fc-4681-96ac-0cfed750c51d "LSP symbol") |


## Principle and Goal

* Simple, yet powerful, always on develop.
* Lazy load all plugins if it could, to optimize startup time to the shortest possible time, right now on my PC, the startup time are less then 30ms.
* Avoid sidebar, focus on editing. personally, I prefer to use float window, sidebar buffer just distract me a lot.
* Avoid extra UI plugins. In common scenarios, [mini.notify](https://github.com/echasnovski/mini.notify) and [mini.pick](https://github.com/echasnovski/mini.pick) with `vim.ui.select()` wrapper already done well enough for notify and float window.
* Provide out-of-box experience for web development.
* AI powered.

> [!NOTE]
> This configuration only guaranteed to be compatible with the latest stable version.
> I'm not using mason.nvim now, The LSP package should managed by you own system.

## Install Instructions

 > Install requires Neovim 0.10+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:wenjinnn/wenvim ~/.config/wenjinnn/wenvim
```

Open Neovim with this config:

```sh
NVIM_APPNAME=wenjinnn/wenvim nvim
```

## Directory notes

[./plugin](https://github.com/wenjinnn/config/tree/main/xdg/config/nvim/plugin) vim custom autocmd keymap option and more

[./lua/lsp](https://github.com/wenjinnn/config/tree/main/xdg/config/nvim/lua/lsp)
LSP config and settings
* define a key-value pair table at `<lspname>/init.lua`, attribute in table will autoload by particular lsp
* on_attach function in `<lspname>/init.lua` will auto execute by particular lsp, with a [setup warpper](https://github.com/wenjinnn/config/blob/e6188ed4f337fac55bd42280ccf1f3b1dd726964/xdg/config/nvim/lua/util/lsp.lua#L14C12-L34)

[./lua/plugin](https://github.com/wenjinnn/config/tree/main/xdg/config/nvim/lua/plugin)
plugins with particular settings and keymap

[./lua/util](https://github.com/wenjinnn/config/tree/main/xdg/config/nvim/lua/plugin)
common utils

[./after](https://github.com/wenjinnn/config/tree/main/xdg/config/nvim/after)
just some filetype settings

## Defined environment variables cheatsheets:

### Common

`NVIM_MINI_DEPS_SNAP` mini.deps snap path, if not set, fallback to mini.deps default setting

`TELESCOPE_FILE_IGNORE_PATTERNS` telescope.nvim file ignore patterns, if not set, the pattern is { "^.git/", "^node_modules/" }

`NVIM_SPELLFILE` nvim spell file location

### Dap

`PROJECT_NAME` nvim-dap config for dap configuration `projectName`

`DAP_HOST` nvim-dap config for setting host, most used at remote debug situations.

`DAP_HOST_PORT` like above, but for host port

### Java

`JAVA_HOME` fallback java home

`JAVA_8_HOME` java 8 home

`JAVA_17_HOME` java 17 home

`JAVA_21_HOME` java 21 home

`JDTLS_MAVEN_SETTINGS`  jdtls maven user settings.xml path

`JDTLS_JAVA_HOME` jdtls java home, if not set, fallback to `JAVA_21_HOME`

`JAVA_TEST_PATH` path to [vscode-java-test](https://github.com/microsoft/vscode-java-test) jars

`JAVA_DEBUG_PATH` path to [vscode-java-debug](https://github.com/microsoft/vscode-java-debug) jars

`LOMBOK_PATH` path to [lombok](https://projectlombok.org/) java agent jar

`JDTLS_XMX` jdtls xmx jvm arg value

`JDTLS_DAP_VMARGS` jdtls dap vm args

### Sonarlint
`SONARLINT_PATH` path to sonarlint language server jars

### Vue

`VUE_LANGUAGE_SERVER_PATH` path to vue language server

### Must have
1. [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd](https://github.com/sharkdp/fd) for many plugin.

### Recommend
1. [tmux](https://github.com/tmux/tmux) & [oh-my-tmux](https://github.com/gpakosz/.tmux) for terminal multiplexing, I'm using only at wsl.
2. [lazygit](https://github.com/jesseduffield/lazygit) smooth git operation.

## Main Plugins

### ai

+ [olimorris/codecompanion.nvim](https://dotfyle.com/plugins/olimorris/codecompanion.nvim)
### code-runner

+ [michaelb/sniprun](https://dotfyle.com/plugins/michaelb/sniprun)
### colorscheme

+ [catppuccin/nvim](https://dotfyle.com/plugins/catppuccin/nvim)
### comment

+ [JoosepAlviste/nvim-ts-context-commentstring](https://dotfyle.com/plugins/JoosepAlviste/nvim-ts-context-commentstring)
### completion

+ [hrsh7th/nvim-cmp](https://dotfyle.com/plugins/hrsh7th/nvim-cmp)
### debugging

+ [mfussenegger/nvim-dap](https://dotfyle.com/plugins/mfussenegger/nvim-dap)
+ [theHamsta/nvim-dap-virtual-text](https://dotfyle.com/plugins/theHamsta/nvim-dap-virtual-text)
### editing-support

+ [windwp/nvim-ts-autotag](https://dotfyle.com/plugins/windwp/nvim-ts-autotag)
+ [nvim-treesitter/nvim-treesitter-context](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-context)
### formatting

+ [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)
### lsp

+ [mfussenegger/nvim-lint](https://dotfyle.com/plugins/mfussenegger/nvim-lint)
+ [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
+ [b0o/SchemaStore.nvim](https://dotfyle.com/plugins/b0o/SchemaStore.nvim)
+ [mfussenegger/nvim-jdtls](https://dotfyle.com/plugins/mfussenegger/nvim-jdtls)
### markdown-and-latex

+ [iamcco/markdown-preview.nvim](https://dotfyle.com/plugins/iamcco/markdown-preview.nvim)
### note-taking

+ [chipsenkbeil/org-roam.nvim](https://dotfyle.com/plugins/chipsenkbeil/org-roam.nvim)
+ [jbyuki/venn.nvim](https://dotfyle.com/plugins/jbyuki/venn.nvim)
+ [nvim-orgmode/orgmode](https://dotfyle.com/plugins/nvim-orgmode/orgmode)
### nvim-dev

+ [MunifTanjim/nui.nvim](https://dotfyle.com/plugins/MunifTanjim/nui.nvim)
+ [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
### search

+ [MagicDuck/grug-far.nvim](https://dotfyle.com/plugins/MagicDuck/grug-far.nvim)
### snippet

+ [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)
### syntax

+ [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)
+ [nvim-treesitter/nvim-treesitter-textobjects](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter-textobjects)
### utility

+ [echasnovski/mini.nvim](https://dotfyle.com/plugins/echasnovski/mini.nvim)
+ [jellydn/hurl.nvim](https://dotfyle.com/plugins/jellydn/hurl.nvim)

 Part of this readme was generated by [Dotfyle](https://dotfyle.com)

