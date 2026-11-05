-- pull lazy vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- install plugins and options
require("vim-options")
require("vim-helpers")
require("help-floating")
require("floating-term")
require("ws").setup()
-- require("lazy").setup("plugins")
-- ~/.config/nvim is a symlink into this repo on every machine (stow on macOS,
-- home-manager out-of-store symlink on nix), so lazy finds lazy-lock.json itself.
require("lazy").setup("plugins")
require("snipets")
