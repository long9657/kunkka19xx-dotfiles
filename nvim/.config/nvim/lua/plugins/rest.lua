return {
    "mistweaverco/kulala.nvim",
    -- upstream repo returns 404 on GitHub (deleted or private), so it can't be cloned anymore;
    -- keep using it only on machines that already have a copy
    enabled = (vim.uv or vim.loop).fs_stat(vim.fn.stdpath("data") .. "/lazy/kulala.nvim") ~= nil,
    ft = { "http", "rest" },

    keys = {
        {
            "<leader>Kt",
            function()
                require("kulala").run()
            end,
            desc = "Send request",
        },
        {
            "<leader>Ka",
            function()
                require("kulala").run_all()
            end,
            desc = "Send all requests",
        },
        {
            "<leader>Ko",
            function()
                require("kulala").scratchpad()
            end,
            desc = "Open scratchpad",
        },
    },

    opts = {
        global_keymaps = false,
        global_keymaps_prefix = "<leader>K",
        kulala_keymaps_prefix = "",
    },
}
