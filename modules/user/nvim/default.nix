{ pkgs, ... }:

{
  
  home.packages = with pkgs;
  [ ripgrep
    fd
    zk
  ];

  programs.neovim = 
  { enable = true;

    plugins = with pkgs.vimPlugins; 
    [ telescope-nvim
      render-markdown-nvim
      nvim-web-devicons
      blink-cmp
      zk-nvim
    ];

    extraLuaConfig = 
    ''  
    local notes_root = vim.fn.expand("~/Sync/Notes")
       local daily_tmpl = "daily-template.md"
       local weekly_tmpl = "weekly-template.md"
       local quarterly_tmpl = "quarterly-template.md"
       local yearly_tmpl = "yearly-template.md"

       require("zk").setup({
         disable_commands = true,
         lsp = {
           config = {
             cmd = { "zk", "lsp" },
             name = "zk",
             root_dir = function()
               return notes_root
             end,
           },
           auto_attach = {
             enabled = true,
             filetypes = { "markdown" }
           },
         }
       })

       vim.api.nvim_create_user_command("Zk", function() end, {})
       vim.api.nvim_del_user_command("Zk")

       require("telescope").setup({})
       require("render-markdown").setup({})
       require("nvim-web-devicons").setup({})
       require("blink.cmp").setup({
         sources = {
           default = { "lsp", "path" },
         },
       })

       local function get_current_note_info()
         local current_file = vim.api.nvim_buf_get_name(0)
         local relative_path = current_file:sub(#notes_root + 2)
         
         if relative_path:match("^journal/%d%d%d%d/daily/%d%d%d%d%-%d%d%-%d%d%.md$") then
           local date_str = relative_path:match("(%d%d%d%d%-%d%d%-%d%d)%.md$")
           local year, month, day = date_str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
           return "daily", os.time({ year = tonumber(year), month = tonumber(month), day = tonumber(day) })
         elseif relative_path:match("^journal/%d%d%d%d/weekly/%d%d%d%d%-W%d%d%.md$") then
           local year, week = relative_path:match("^journal/(%d%d%d%d)/weekly/%d%d%d%d%-W(%d%d)%.md$")
           return "weekly", { year = tonumber(year), week = tonumber(week) }
         elseif relative_path:match("^journal/%d%d%d%d/%d%d%d%d%-Q%d%.md$") then
           local year, quarter = relative_path:match("^journal/(%d%d%d%d)/%d%d%d%d%-Q(%d)%.md$")
           return "quarterly", { year = tonumber(year), quarter = tonumber(quarter) }
         elseif relative_path:match("^journal/%d%d%d%d/%d%d%d%d%.md$") then
           local year = relative_path:match("^journal/(%d%d%d%d)/%d%d%d%d%.md$")
           return "yearly", { year = tonumber(year) }
         end
         return nil
       end

       local function navigate_journal(direction)
         local type, data = get_current_note_info()
         if not type then
           print("Not in a recognized journal file")
           return
         end

         if type == "daily" then
           local offset = (direction == "next") and 86400 or -86400
           local new_time = data + offset
           local year = os.date("%Y", new_time)
           local date_str = os.date("%Y-%m-%d", new_time)
           local dir = string.format("%s/journal/%s/daily", notes_root, year)
           local path = string.format("%s/%s.md", dir, date_str)
           if vim.fn.filereadable(path) == 1 then
             vim.cmd("edit " .. vim.fn.fnameescape(path))
           else
             require("zk").new({ dir = "journal/" .. year .. "/daily", title = date_str, template = daily_tmpl })
           end
         elseif type == "weekly" then
           local year, week = data.year, data.week
           if direction == "next" then
             week = week + 1
             if week > 53 then week = 1; year = year + 1 end
           else
             week = week - 1
             if week < 1 then week = 53; year = year - 1 end
           end
           local week_str = string.format("%02d", week)
           local dir = string.format("%s/journal/%s/weekly", notes_root, year)
           local path = string.format("%s/%s-W%s.md", dir, year, week_str)
           if vim.fn.filereadable(path) == 1 then
             vim.cmd("edit " .. vim.fn.fnameescape(path))
           else
             require("zk").new({ dir = "journal/" .. year .. "/weekly", title = year .. "-W" .. week_str, template = weekly_tmpl })
           end
         elseif type == "quarterly" then
           local year, quarter = data.year, data.quarter
           if direction == "next" then
             quarter = quarter + 1
             if quarter > 4 then quarter = 1; year = year + 1 end
           else
             quarter = quarter - 1
             if quarter < 1 then quarter = 4; year = year - 1 end
           end
           local dir = string.format("%s/journal/%s", notes_root, year)
           local path = string.format("%s/%s-Q%d.md", dir, year, quarter)
           if vim.fn.filereadable(path) == 1 then
             vim.cmd("edit " .. vim.fn.fnameescape(path))
           else
             require("zk").new({ dir = "journal/" .. year, title = year .. "-Q" .. quarter, template = quarterly_tmpl })
           end
         elseif type == "yearly" then
           local year = data.year + ((direction == "next") and 1 or -1)
           local dir = string.format("%s/journal/%s", notes_root, year)
           local path = string.format("%s/%s.md", dir, year)
           if vim.fn.filereadable(path) == 1 then
             vim.cmd("edit " .. vim.fn.fnameescape(path))
           else
             require("zk").new({ dir = "journal/" .. year, title = tostring(year), template = yearly_tmpl })
           end
         end
       end

       local function open_daily(offset)
         local time = os.time() + (offset or 0) * 86400
         local year = os.date("%Y", time)
         local date_str = os.date("%Y-%m-%d", time)
         local dir = string.format("%s/journal/%s/daily", notes_root, year)
         local path = string.format("%s/%s.md", dir, date_str)
         if vim.fn.filereadable(path) == 1 then
           vim.cmd("edit " .. vim.fn.fnameescape(path))
         else
           require("zk").new({ dir = "journal/" .. year .. "/daily", title = date_str, template = daily_tmpl })
         end
       end

       local function open_weekly()
         local year = os.date("%Y")
         local week = os.date("%V")
         local dir = string.format("%s/journal/%s/weekly", notes_root, year)
         local path = string.format("%s/%s-W%s.md", dir, year, week)
         if vim.fn.filereadable(path) == 1 then
           vim.cmd("edit " .. vim.fn.fnameescape(path))
         else
           require("zk").new({ dir = "journal/" .. year .. "/weekly", title = year .. "-W" .. week, template = weekly_tmpl })
         end
       end

       local function open_quarterly()
         local year = os.date("%Y")
         local month = tonumber(os.date("%m"))
         local quarter = math.ceil(month / 3)
         local dir = string.format("%s/journal/%s", notes_root, year)
         local path = string.format("%s/%s-Q%d.md", dir, year, quarter)
         if vim.fn.filereadable(path) == 1 then
           vim.cmd("edit " .. vim.fn.fnameescape(path))
         else
           require("zk").new({ dir = "journal/" .. year, title = year .. "-Q" .. quarter, template = quarterly_tmpl })
         end
       end

       local function open_yearly()
         local year = os.date("%Y")
         local dir = string.format("%s/journal/%s", notes_root, year)
         local path = string.format("%s/%s.md", dir, year)
         if vim.fn.filereadable(path) == 1 then
           vim.cmd("edit " .. vim.fn.fnameescape(path))
         else
           require("zk").new({ dir = "journal/" .. year, title = year, template = yearly_tmpl })
         end
       end

       local note_subcommands = {
         today = function() open_daily(0) end,
         tomorrow = function() open_daily(1) end,
         week = open_weekly,
         quarter = open_quarterly,
         year = open_yearly,
         next = function() navigate_journal("next") end,
         prev = function() navigate_journal("prev") end,
         fd = function()
           require("telescope.builtin").find_files({ cwd = notes_root, prompt_title = "Find Note" })
         end,
         lg = function()
           require("telescope.builtin").live_grep({ cwd = notes_root, prompt_title = "Grep Notes" })
         end,
         new = function()
           local title = vim.fn.input("Note Title: ")
           if title ~= "" then require("zk").new({ title = title }) end
         end,
         new_from_title = function()
           require("zk.commands").get("ZkNewFromTitleSelection")()
         end,
         new_from_content = function()
           require("zk.commands").get("ZkNewFromContentSelection")()
         end,
         index = function()
           require("zk.commands").get("ZkIndex")()
         end,
         tags = function()
           require("zk.commands").get("ZkTags")()
         end,
         links = function()
           require("zk.commands").get("ZkLinks")()
         end,
         backlinks = function()
           require("zk.commands").get("ZkBacklinks")()
         end,
         link = function()
           require("zk.commands").get("ZkInsertLink")()
         end,
         link_at_selection = function()
           require("zk.commands").get("ZkInsertLinkAtSelection")()
         end,
         match = function()
           require("zk.commands").get("ZkMatch")()
         end,
         live_grep = function()
           require("zk.commands").get("ZkLiveGrep")()
         end,
         buffers = function()
           require("zk.commands").get("ZkBuffers")()
         end,
         cd = function()
           require("zk.commands").get("ZkCd")()
         end,
       }

       vim.api.nvim_create_user_command("Note", function(opts)
         local sub = opts.fargs[1]
         if not sub or sub == "" then
           print("Usage: :Note [subcommand]")
           return
         end
         local action = note_subcommands[sub]
         if action then
           action()
         else
           print("Unknown sub-command: " .. sub)
         end
       end, {
         nargs = 1,
         complete = function(ArgLead, CmdLine, CursorPos)
           local subs = vim.tbl_keys(note_subcommands)
       return vim.tbl_filter(function(s)
         return string.match(s, "^" .. ArgLead)
       end, subs)
end,
})
local timer = vim.loop.new_timer()
timer:start(100, 0, vim.schedule_wrap(function()
local cmds = {
"Zk", "ZkNew", "ZkNewFromTitleSelection", "ZkNewFromContentSelection",
"ZkNotes", "ZkTags", "ZkLinks", "ZkBacklinks", "ZkInsertLink",
"ZkInsertLinkAtSelection", "ZkBuffers", "ZkLiveGrep", "ZkMatch",
"ZkCd", "ZkIndex"
}
for _, cmd in ipairs(cmds) do
pcall(vim.api.nvim_del_user_command, cmd)
end
end))

    '';
  };

}
