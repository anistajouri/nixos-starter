{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge

    bat             # A modern replacement for cat, with syntax highlighting and Git integration.
    bottom          # A graphical process viewer for the terminal.
    coreutils       # Basic file, shell, and text manipulation utilities.
    curl            # A command-line tool for transferring data with URLs.
    du-dust         # A more user-friendly version of du for disk usage analysis.
    fd              # A simple, fast, and user-friendly alternative to find.
    findutils       # A collection of utilities for finding files in a directory hierarchy.
    fx              # A command-line JSON processor.
    git             # A version control system for tracking changes in source code.
    git-crypt       # A tool for transparent encryption of files in a Git repository.
    htop            # An interactive process viewer for Unix systems.
    jq              # A lightweight and flexible command-line JSON processor.
    killall         # A command to kill processes by name.
    mosh            # A mobile shell that allows roaming and supports intermittent connectivity.
    procs           # A modern replacement for ps, showing process information.
    ripgrep         # A command-line search tool that recursively searches your current directory for a regex pattern.
    sd              # A simple and fast replacement for sed.
    tmux            # A terminal multiplexer that allows multiple terminal sessions to be accessed simultaneously.
    tree            # A recursive directory listing command that produces a depth-indented listing of files.
    unzip           # A utility for unpacking zip files.
    vim             # A highly configurable text editor.
    wget            # A command-line utility for downloading files from the web.
    zip             # A utility for packaging and compressing files.


    kind            # A tool for running Kubernetes clusters in Docker.
    kubectl         # The command-line tool for interacting with Kubernetes clusters.
    yq-go           # A command-line YAML processor.
    go              # The Go programming language.
    gum             # A tool for creating interactive command-line applications.
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin]) # A set of tools for managing resources on Google Cloud Platform, with additional components for GKE authentication.
    upbound         # A tool for managing Kubernetes resources.
    teller          # A tool for managing secrets in cloud environments.
    crossplane-cli  # A command-line interface for Crossplane, a tool for managing cloud resources.
    kubernetes-helm # A package manager for Kubernetes applications.
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use

    # TODO: you can add plugins, change keymaps etc using (lvim.nixvimExtend {})
    lvim             # LVim under   inputs.lvim.url = "github:anistajouri/LVim";, an IDE layer for Neovim.

    # key tools
    gh               # GitHub CLI for managing GitHub repositories.
    just             # A handy way to save and run project-specific commands.

    # core languages
    rustup           # The Rust toolchain installer.

    # rust stuff
    cargo-cache      # A cargo subcommand for managing the cargo cache.
    cargo-expand     # A cargo subcommand to show the result of macro expansion.

    # local dev stuff
    mkcert           # A simple zero-config tool to make locally trusted development certificates.
    httpie           # A user-friendly HTTP client.

    # treesitter
    tree-sitter      # An incremental parsing system for programming tools.

    # language servers
    nodePackages.vscode-langservers-extracted # Language servers for HTML, CSS, JSON, and ESLint.
    nodePackages.yaml-language-server         # Language server for YAML.
    nil                                       # Language server for Nix.

    # formatters and linters
    alejandra        # A formatter for Nix code.
    deadnix          # A linter for detecting dead code in Nix expressions.
    nodePackages.prettier                      # An opinionated code formatter.
    shellcheck       # A linter for shell scripts.
    shfmt            # A shell script formatter.
    statix           # A linter for Nix code.
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "nvim";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/fish";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableFishIntegration = true;
    nix-index-database.comma.enable = true;

    # FIXME: disable this if you don't want to use the starship prompt
    starship.enable = true;
    starship.settings = {
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = false;
      git_branch.style = "242";
      directory.style = "blue";
      directory.truncate_to_repo = false;
      directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
    };

    # FIXME: disable whatever you don't want
    fzf.enable = true;
    fzf.enableFishIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableFishIntegration = true;
    zoxide.options = ["--cmd cd"];
    broot.enable = true;
    broot.enableFishIntegration = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "anis.tajouri@gmail.com"; # FIXME: set your git email
      userName = "Anis Tajouri"; #FIXME: set your git username
      extraConfig = {
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
        #     insteadOf = "https://gitlab.com";
        #   };
        # };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    # Fish config - you can fiddle with it if you want
    fish = {
      enable = true;
      # FIXME: install win32yank' on Windows from https://github.com/equalsraf/win32yank/releases in C:\win32yank-x86, 
      # FIXME: Add this line with your Windows username to the bottom of interactiveShellInit
      interactiveShellInit = ''

        fish_add_path --append "/mnt/c/win32yank-x86"
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source

        ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
            owner = "rebelot";
            repo = "kanagawa.nvim";
            rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
            sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
          }
          + "/extras/kanagawa.fish")}

        set -U fish_greeting

        # SDKMAN initialization
        set -gx SDKMAN_DIR $HOME/.sdkman

        if test -d $SDKMAN_DIR
          # Initialize SDKMAN wrapper functions
          function sdk
            bash -c "source $SDKMAN_DIR/bin/sdkman-init.sh && sdk $argv"
          end
        else
          # Install SDKMAN if not present
          curl -s "https://get.sdkman.io" | bash
        end
      '';
      functions = {
        refresh = "source $HOME/.config/fish/config.fish";
        take = ''mkdir -p -- "$1" && cd -- "$1"'';
        ttake = "cd $(mktemp -d)";
        show_path = "echo $PATH | tr ' ' '\n'";
        posix-source = ''
          for i in (cat $argv)
            set arr (echo $i |tr = \n)
            set -gx $arr[1] $arr[2]
          end
        '';
      };
      shellAbbrs =
        {
          gc = "nix-collect-garbage --delete-old";
        }
        # navigation shortcuts
        // {
          ".." = "cd ..";
          "..." = "cd ../../";
          "...." = "cd ../../../";
          "....." = "cd ../../../../";
        }
        # git shortcuts
        // {
          gapa = "git add --patch";
          grpa = "git reset --patch";
          gst = "git status";
          gdh = "git diff HEAD";
          gp = "git push";
          gph = "git push -u origin HEAD";
          gco = "git checkout";
          gcob = "git checkout -b";
          gcm = "git checkout master";
          gcd = "git checkout develop";
          gsp = "git stash push -m";
          gsa = "git stash apply stash^{/";
          gsl = "git stash list";
        };
      shellAliases = {
        jvim = "nvim";
        lvim = "nvim";
        ec = "nvim ~/configuration/home.nix";
        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
        
        # To use code as the command, uncomment the line below. Be sure to replace [my-user] with your username. 
        # If your code binary is located elsewhere, adjust the path as needed.
        code = "/mnt/c/Users/a.tajouri/AppData/Local/Programs/'Microsoft VS Code'/bin/code";
      };
      plugins = [
        {
          inherit (pkgs.fishPlugins.autopair) src;
          name = "autopair";
        }
        {
          inherit (pkgs.fishPlugins.done) src;
          name = "done";
        }
        {
          inherit (pkgs.fishPlugins.sponge) src;
          name = "sponge";
        }
      ];
    };
  };
}
