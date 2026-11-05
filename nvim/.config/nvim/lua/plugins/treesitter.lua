-- add language you want to highlight in code
local languages = {
    "c",
    "lua",
    "vim",
    "javascript",
    "typescript",
    "tsx",
    "html",
    "go",
    "gomod",
    "gowork",
    "gosum",
    "java",
    "json",
    "zig",
    "http",
}

-- nvim-treesitter `main` is a rewrite that requires nvim >= 0.12 (and tree-sitter-cli);
-- older nvim stays on the frozen `master` branch with the legacy configs API
if vim.fn.has("nvim-0.12") == 0 then
    return {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- auto install
                auto_install = true,
                ensure_installed = languages,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    }
end

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.install(languages)

        local function start(buf)
            if pcall(vim.treesitter.start, buf) then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang then
                    return
                end
                -- auto install
                if
                    not vim.list_contains(ts.get_installed(), lang)
                    and vim.list_contains(ts.get_available(), lang)
                then
                    ts.install(lang):await(vim.schedule_wrap(function()
                        if vim.api.nvim_buf_is_valid(args.buf) then
                            start(args.buf)
                        end
                    end))
                    return
                end
                start(args.buf)
            end,
        })
    end,
}
