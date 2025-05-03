local M = {}

M.config = {
  adapters = {
    copilot = function()
      return require('codecompanion.adapters').extend('copilot', {
        schema = {
          model = {
            default = 'claude-3.7-sonnet',
          },
        },
      })
    end,
  },
  strategies = {
    chat = {
      keymaps = {
        send = {
          modes = { n = '<C-s>', i = '<C-s>' },
        },
        close = {
          modes = { n = '<C-c>', i = '<C-c>' },
        },
        -- Add further custom keymaps here
      },
    },
    inline = {
      keymaps = {
        accept_change = {
          modes = { n = 'ga' },
          description = 'Accept the suggested change',
        },
        reject_change = {
          modes = { n = 'gr' },
          description = 'Reject the suggested change',
        },
      },
    },
  },
  display = {
    diff = {
      enabled = true,
      close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
      layout = 'vertical', -- vertical|horizontal split for default provider
      opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
      provider = 'default', -- default|mini_diff
    },
    action_palette = {
      width = 95,
      height = 10,
      prompt = 'Prompt ', -- Prompt used for interactive LLM calls
      provider = 'default', -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
      opts = {
        show_default_actions = true, -- Show the default actions in the action palette?
        show_default_prompt_library = true, -- Show the default prompt library in the action palette?
      },
    },
  },
}

M.setup = function()
  require('codecompanion').setup(M.config)
end

return M

-- vim: ts=2 sts=2 sw=2 et
