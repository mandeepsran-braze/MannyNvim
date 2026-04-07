return {
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby", "haml", "slim" },
    config = function()
      require("which-key").add({
        { "<leader>r",  group = "Rails" },
        { "<leader>ra", "<cmd>A<cr>",           desc = "Alternate file (test<->impl)" },
        { "<leader>rr", "<cmd>R<cr>",           desc = "Related file" },
        { "<leader>rm", "<cmd>Emodel<cr>",      desc = "Go to model" },
        { "<leader>rc", "<cmd>Econtroller<cr>", desc = "Go to controller" },
        { "<leader>rv", "<cmd>Eview<cr>",       desc = "Go to view" },
        { "<leader>rs", "<cmd>Espec<cr>",       desc = "Go to spec" },
        { "<leader>ri", "<cmd>Emigration<cr>",  desc = "Go to migration" },
        { "<leader>rf", "<cmd>Efixtures<cr>",   desc = "Go to fixture" },
        { "<leader>rl", "<cmd>Elocale<cr>",     desc = "Go to locale" },
        { "<leader>rj", "<cmd>Ejavascript<cr>", desc = "Go to javascript" },
      })
    end,
  },
}
