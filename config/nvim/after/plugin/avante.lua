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

local function openai_thinking_providers(model_names)
    local result = {}
    for _, model_name in ipairs(model_names) do
        local key = "openai/" .. model_name
        local tools_key = "openai/" .. model_name .. "/tools"
        result[key] = {
            __inherited_from = 'openai',
            model = model_name,
            display_name = key,
            timeout = 120000,
            disable_tools = true,
            extra_request_body = {
                temperature = 0,
                max_completion_tokens = 100000,
                reasoning_effort = "high",
            },
        }
        result[tools_key] = vim.tbl_extend("force", result[key],
            {
                display_name = tools_key,
                disable_tools = false,
            })
    end
    return result
end

local function copilot_thinking_providers(model_names)
    local result = {}
    for _, model_name in ipairs(model_names) do
        local key = "copilot/" .. model_name
        local tools_key = "copilot/" .. model_name .. "/tools"
        result[key] = {
            __inherited_from = 'copilot',
            model = model_name,
            display_name = key,
            timeout = 120000,
            disable_tools = true,
            extra_request_body = {
                temperature = 0,
                max_tokens = 65536,
            },
        }
        result[tools_key] = vim.tbl_extend("force", result[key],
            {
                display_name = tools_key,
                disable_tools = false,
            })
    end
    return result
end

local function claude_thinking_providers(model_names)
    local result = {}
    for _, model_name in ipairs(model_names) do
        local key = "claude/" .. model_name
        local tools_key = "claude/" .. model_name .. "/tools"
        result[key] = {
            __inherited_from = 'claude',
            model = model_name,
            display_name = key,
            timeout = 120000,
            disable_tools = true,
            extra_request_body = {
                temperature = 0,
                max_tokens = 64000,
            },
        }
        result[tools_key] = vim.tbl_extend("force", result[key],
            {
                display_name = tools_key,
                disable_tools = false,
            })
    end
    return result
end

local Vertex = require("avante.providers.vertex")


require("avante").setup({
  debug = false,
  ---@alias avante.Mode "agentic" | "legacy"
  mode = "legacy",
  ---@alias avante.ProviderName "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | "bedrock" | "ollama" | string
  provider = "copilot", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
  auto_suggestions_provider = nil,
  cursor_applying_provider = "groq", -- The provider used in the applying phase of Cursor Planning Mode, defaults to nil, when nil uses Config.provider as the provider for the applying phase
  disabled_tools = { "python", "replace_in_file" },
  providers = vim.tbl_extend("force",{},
    ----------------------------------------
    --               Groq                 --
    ----------------------------------------
    {
        groq = { -- define groq provider
            __inherited_from = 'openai',
            api_key_name = 'GROQ_API_KEY',
            endpoint = 'https://api.groq.com/openai/v1/',
            model = 'llama-3.3-70b-versatile',
            max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
        },
        [ "groq-deepseek" ] = { -- define groq provider
            __inherited_from = 'openai',
            api_key_name = 'GROQ_API_KEY',
            endpoint = 'https://api.groq.com/openai/v1/',
            model = 'deepseek-r1-distill-llama-70b',
            -- max_tokens = 32768, -- remember to increase this value, otherwise it will stop generating halfway
        },

    },
    openai_thinking_providers({"o1", "o3-mini", "o4-mini"}),
    copilot_thinking_providers({"claude-sonnet-4", "claude-3.7-sonnet", "claude-3.7-thought", "gemini-2.5-pro", "gemini-2.5-flash-001", "o4-mini", "gpt-4.1"}),
    claude_thinking_providers({"claude-opus-4-0", "claude-sonnet-4-0", "claude-3-7-sonnet-latest"})
  ),
  dual_boost = {
    enabled = false,
    first_provider = "openai",
    second_provider = "claude",
    prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    timeout = 60000, -- Timeout in milliseconds
  },
  behaviour = {
    auto_focus_sidebar = true,
    auto_suggestions = false, -- vxperimental stage
    auto_suggestions_respect_ignore = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    enable_token_counting = true, -- Whether to enable token counting. Default to true.
    enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
    use_cwd_as_project_root = false,
    auto_focus_on_diff_view = false,
  },
  history = {
    max_tokens = 8096,
    carried_entry_count = nil,
    storage_path = vim.fn.stdpath("state") .. "/avante",
    paste = {
      extension = "png",
      filename = "pasted-%Y-%m-%d-%H-%M-%S",
    },
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
      close = { "q" },
      close_from_input = { normal = nil, insert = nil },
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
      start_insert = false, -- Start insert mode when opening the ask window
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

Vertex.api_key_name = ""

