local function read_keys_into_env()
  local home = os.getenv("HOME")
  local file_path = home .. "/.config/secrets/.ai.env"
  local file = io.open(file_path, "r")
  if file then
    for line in file:lines() do
      local key, value = line:match("^(%S+)%s*=%s*(%S+)$")
      if key == "OPENAI_API_KEY" then
        if value ~= nil then
          vim.env.OPENAI_API_KEY = value
        end
      end
      if key == "ANTHROPIC_API_KEY" then
        if value ~= nil then
          vim.env.ANTHROPIC_API_KEY = value
        end
      end
      if key == "GROQ_API_KEY" then
        if value ~= nil then
          vim.env.GROQ_API_KEY = value
        end
      end
    end
    file:close()
    return nil
  else
    print("Error: Unable to read ai secrets API key from file.")
    return nil
  end
end

read_keys_into_env()

require("avante").setup({
      ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = "copilot", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
  -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
  -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
  -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
  auto_suggestions_provider = false,
  cursor_applying_provider = "groq", -- The provider used in the applying phase of Cursor Planning Mode, defaults to nil, when nil uses Config.provider as the provider for the applying phase
  openai = {
    endpoint = "https://api.openai.com/v1",
    model = "gpt-4o",
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_tokens = 16384,
    -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
  },
  copilot = {
    endpoint = "https://api.githubcopilot.com",
    model = "claude-3.7-sonnet",
    proxy = nil, -- [protocol://]host[:port] Use this proxy
    allow_insecure = false, -- Allow insecure server connections
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_tokens = 8192,
  },
  claude = {
    endpoint = "https://api.anthropic.com",
    model = "claude-3-7-sonnet-20250219",
    temperature = 0,
    max_tokens = 8192,
  },
    ---To add support for custom provider, follow the format below
  ---See https://github.com/yetone/avante.nvim/wiki#custom-providers for more details
  vendors = {
    groq = { -- define groq provider
        __inherited_from = 'openai',
        api_key_name = 'GROQ_API_KEY',
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'llama-3.3-70b-versatile',
        max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
    },
    [ "groq-deep" ] = { -- define groq provider
        __inherited_from = 'openai',
        api_key_name = 'GROQ_API_KEY',
        endpoint = 'https://api.groq.com/openai/v1/',
        model = 'deepseek-r1-distill-llama-70b',
        -- max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
    },
    ["copilot-4o"] = {
      __inherited_from = 'copilot',
      model = "gpt-4o",
      allow_insecure = false, -- Allow insecure server connections
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 8192,
    },
    ["copilot-4o-16k"] = {
      __inherited_from = 'copilot',
      model = "gpt-4o",
      allow_insecure = false, -- Allow insecure server connections
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 16384,
    },
    [ "copilot-o1" ] = {
      __inherited_from = 'copilot',
      model = "o1",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      -- max_tokens = 4096,
      reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    },
    [ "copilot-o3-mini" ] = {
      __inherited_from = 'copilot',
      model = "o3-mini",
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      -- max_tokens = 4096,
      reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    },
    [ "openai-o1" ] = {
      __inherited_from = 'openai',
      model = "o1",
      allow_insecure = false, -- Allow insecure server connections
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 100000,
      reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    },
    [ "openai-o3-mini" ] = {
      __inherited_from = 'openai',
      model = "o3-mini",
      allow_insecure = false, -- Allow insecure server connections
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 100000,
      reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
    },
  },
  ---Specify the special dual_boost mode
  ---1. enabled: Whether to enable dual_boost mode. Default to false.
  ---2. first_provider: The first provider to generate response. Default to "openai".
  ---3. second_provider: The second provider to generate response. Default to "claude".
  ---4. prompt: The prompt to generate response based on the two reference outputs.
  ---5. timeout: Timeout in milliseconds. Default to 60000.
  ---How it works:
  --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
  ---Note: This is an experimental feature and may not work as expected.
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000, -- Timeout in milliseconds
  },
  behaviour = {
    auto_suggestions = false, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true, -- Whether to enable token counting. Default to true.
    enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
  },
  mappings = {
    --- @class AvanteConflictMappings
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },
  hints = { enabled = true },
  windows = {
    ---@type "right" | "left" | "top" | "bottom"
    position = "right", -- the position of the sidebar
    wrap = true, -- similar to vim.o.wrap
    width = 30, -- default % based on available width
    sidebar_header = {
      enabled = true, -- true, false to enable/disable the header
      align = "center", -- left, center, right for title
      rounded = true,
    },
    input = {
      prefix = "> ",
      height = 8, -- Height of the input window in vertical layout
    },
    edit = {
      border = "rounded",
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      floating = false, -- Open the 'AvanteAsk' prompt in a floating window
      start_insert = true, -- Start insert mode when opening the ask window
      border = "rounded",
      ---@type "ours" | "theirs"
      focus_on_apply = "ours", -- which diff to focus after applying
    },
  },
  highlights = {
    ---@type AvanteConflictHighlights
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },
  --- @class AvanteConflictUserConfig
  diff = {
    autojump = true,
    ---@type string | fun(): any
    list_opener = "copen",
    --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
    --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
    --- Disable by setting to -1.
    override_timeoutlen = 500,
  },
  suggestion = {
    debounce = 600,
    throttle = 600,
  },
})

