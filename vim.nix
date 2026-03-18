{ config, pkgs, ... }:

{
  # ... other configurations

  environment.systemPackages = with pkgs; [
    # Wrap in parentheses to treat the result as a single package
    (vim-full.customize { 
      name = "vim"; # Name of the generated executable
      vimrcConfig.customRC = ''
        " Your custom .vimrc settings go here
        syntax enable
        set number
        set relativenumber
        set mouse=v
        set shiftwidth=2
        set autoindent
      '';
    })
  ];

  # Optional: ensure no other default vim is installed that might conflict
  # programs.vim.enable = false; 
}

