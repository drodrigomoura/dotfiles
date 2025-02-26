-- local home = vim.fn.expand(os.getenv("RODRI_VAULT_HOME") or "~/telekasten")

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/Obsidian/rodri-vault",
        },
        -- {
        --   name = "work",
        --   path = "~/vaults/work",
        -- },
      },

      -- see below for full list of options 👇
      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "inbox",

      -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
      -- levels defined by "vim.log.levels.*".
      log_level = vim.log.levels.INFO,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "journals",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },

      -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- nvim_cmp = false,
        -- blink = true
        min_chars = 2,
      },
      --
      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Where to put new notes. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      -- Optional, customize how note file names are generated given the ID, target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,

      -- Optional, for templates (see below).
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- -- URL it will be ignored but you can customize this behavior here.
      -- ---@param url string
      -- follow_url_func = function(url)
      --   -- Open the URL in the default web browser.
      --   vim.fn.jobstart({ "open", url }) -- Mac OS
      --   -- vim.fn.jobstart({"xdg-open", url})  -- linux
      --   -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      --   -- vim.ui.open(url) -- need Neovim 0.10.0+
      -- end,
      --
      -- -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- -- file it will be ignored but you can customize this behavior here.
      -- ---@param img string
      -- follow_img_func = function(img)
      --   vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
      --   -- vim.fn.jobstart({"xdg-open", url})  -- linux
      --   -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- end,

      -- Specify how to handle attachments.
      -- attachments = {
      --   -- The default folder to place images in via `:ObsidianPasteImg`.
      --   -- If this is a relative path it will be interpreted as relative to the vault root.
      --   -- You can always override this per image by passing a full path to the command instead of just a filename.
      --   img_folder = "assets/imgs", -- This is the default
      --
      --   -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
      --   ---@return string
      --   img_name_func = function()
      --     -- Prefix image names with timestamp.
      --     return string.format("%s-", os.time())
      --   end,
      --
      --   -- A function that determines the text to insert in the note when pasting an image.
      --   -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      --   -- This is the default implementation.
      --   ---@param client obsidian.Client
      --   ---@param path obsidian.Path the absolute path to the image file
      --   ---@return string
      --   img_text_func = function(client, path)
      --     path = client:vault_relative_path(path) or path
      --     return string.format("![%s](%s)", path.name, path)
      --   end,
      -- },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- HACK: fix error, disable completion.nvim_cmp option, manually register sources
      local cmp = require("cmp")
      cmp.register_source("obsidian", require("cmp_obsidian").new())
      cmp.register_source("obsidian_new", require("cmp_obsidian_new").new())
      cmp.register_source("obsidian_tags", require("cmp_obsidian_tags").new())
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "obsidian", "obsidian_new", "obsidian_tags" },
        providers = {
          obsidian = {
            name = "obsidian",
            module = "blink.compat.source",
          },
          obsidian_new = {
            name = "obsidian_new",
            module = "blink.compat.source",
          },
          obsidian_tags = {
            name = "obsidian_tags",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
