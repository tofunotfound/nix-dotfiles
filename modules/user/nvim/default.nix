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
    ];

    extraLuaConfig = 
    ''  

-- Thin Neovim interface for zk. Notebook structure, journal paths and templates
-- are defined in .zk/config.toml; this module only coordinates Neovim/Telescope.
local M = {}

local LEVEL = vim.log.levels
local AUGROUP = "ZkNote"

local function notify(message, level)
  vim.notify(message, level or LEVEL.INFO, { title = "Note" })
end

local function notebook_root(buf)
  buf = buf or 0
  local name = vim.api.nvim_buf_get_name(buf)
  local source = name ~= "" and name or vim.uv.cwd()
  return vim.fs.root(source, ".zk")
    or (vim.env.ZK_NOTEBOOK_DIR and vim.fs.normalize(vim.env.ZK_NOTEBOOK_DIR))
    or vim.fs.normalize(vim.fn.expand("~/Sync/Notes"))
end

local function valid_notebook(root)
  if vim.fn.executable("zk") ~= 1 then
    notify("Не найден zk в PATH", LEVEL.ERROR)
    return false
  end
  if vim.fn.isdirectory(root .. "/.zk") ~= 1 then
    notify("Не найден блокнот zk: " .. root, LEVEL.ERROR)
    return false
  end
  return true
end

local function zk(root, args, callback, stdin)
  if not valid_notebook(root) then return end
  local command = { "zk", "--working-dir", root }
  vim.list_extend(command, args)
  vim.system(command, { cwd = root, text = true, stdin = stdin }, vim.schedule_wrap(function(result)
    if result.code ~= 0 then
      callback(nil, vim.trim(result.stderr or result.stdout or "zk command failed"))
    else
      callback(result.stdout or "", nil)
    end
  end))
end

local function telescope()
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then
    notify("Для этой команды нужен telescope.nvim", LEVEL.ERROR)
    return nil
  end
  return {
    builtin = builtin,
    pickers = require("telescope.pickers"),
    finders = require("telescope.finders"),
    conf = require("telescope.config").values,
    actions = require("telescope.actions"),
    state = require("telescope.actions.state"),
    display = require("telescope.pickers.entry_display"),
  }
end

local function open(path)
  if path and path ~= "" then vim.cmd.edit(vim.fn.fnameescape(path)) end
end

local function decode_json(output, what)
  if vim.trim(output or "") == "" then return {} end
  local ok, value = pcall(vim.json.decode, output)
  if not ok or type(value) ~= "table" then
    notify("Не удалось разобрать ответ zk (" .. what .. ")", LEVEL.ERROR)
    return nil
  end
  return value
end

local function list_notes(root, filters, callback)
  local args = { "list", "--quiet", "--format", "json", "--sort", "modified-" }
  for flag, value in pairs(filters or {}) do
    if value and value ~= "" then
      vim.list_extend(args, { "--" .. flag, value })
    end
  end
  zk(root, args, function(output, err)
    if not output then notify("zk list: " .. err, LEVEL.ERROR); return end
    local raw = decode_json(output, "zk list")
    if not raw then return end
    local notes = {}
    for _, item in ipairs(raw) do
      local abs = item.absPath or (root .. "/" .. (item.path or ""))
      local stem = item.filenameStem or vim.fn.fnamemodify(abs, ":t:r")
      notes[#notes + 1] = {
        title = item.title or stem,
        stem = stem,
        path = item.path or abs,
        abs = abs,
      }
    end
    callback(notes)
  end)
end

local function note_picker(notes, title, on_select)
  if #notes == 0 then notify("Заметки не найдены"); return end
  local t = telescope(); if not t then return end
  local displayer = t.display.create({ separator = " ", items = { { width = 34 }, { remaining = true } } })
  t.pickers.new({}, {
    prompt_title = title,
    finder = t.finders.new_table({
      results = notes,
      entry_maker = function(note)
        return {
          value = note,
          ordinal = note.stem .. " " .. note.path,
          filename = note.abs,
          path = note.abs,
          display = function()
            return displayer({ note.stem, { note.path, "Comment" } })
          end,
        }
      end,
    }),
    sorter = t.conf.generic_sorter({}),
    previewer = t.conf.file_previewer({}),
    attach_mappings = function(prompt)
      t.actions.select_default:replace(function()
        local picker = t.state.get_current_picker(prompt)
        local selected = {}
        for _, entry in ipairs(picker:get_multi_selection()) do
          selected[#selected + 1] = entry.value
        end
        if #selected == 0 then
          local entry = t.state.get_selected_entry()
          if entry then selected[1] = entry.value end
        end
        t.actions.close(prompt)
        if #selected > 0 then vim.schedule(function() on_select(selected) end) end
      end)
      return true
    end,
  }):find()
end

local function open_selected(notes)
  for i, note in ipairs(notes) do
    if i == 1 then open(note.abs) else vim.cmd.badd(vim.fn.fnameescape(note.abs)) end
  end
end

local function tags_picker(root)
  zk(root, { "tag", "list", "--quiet", "--format", "json" }, function(output, err)
    if not output then notify("zk tag list: " .. err, LEVEL.ERROR); return end
    local tags = decode_json(output, "zk tag list"); if not tags then return end
    if #tags == 0 then notify("Тегов нет"); return end
    local t = telescope(); if not t then return end
    t.pickers.new({}, {
      prompt_title = "Tags",
      finder = t.finders.new_table({
        results = tags,
        entry_maker = function(tag)
          local name = tag.name or tostring(tag)
          local count = tag.noteCount or tag.note_count or 0
          return { value = name, ordinal = name, display = string.format("#%s (%s)", name, count) }
        end,
      }),
      sorter = t.conf.generic_sorter({}),
      attach_mappings = function(prompt)
        t.actions.select_default:replace(function()
          local entry = t.state.get_selected_entry()
          t.actions.close(prompt)
          if entry then list_notes(root, { tag = entry.value }, function(notes)
            note_picker(notes, "#" .. entry.value, open_selected)
          end) end
        end)
        return true
      end,
    }):find()
  end)
end

local function selection(ctx)
  if not ctx or ctx.range == 0 then
    notify("Сначала выдели текст в Visual mode", LEVEL.WARN)
    return nil
  end
  local buf = vim.api.nvim_get_current_buf()
  local first = vim.api.nvim_buf_get_mark(buf, "<")
  local last = vim.api.nvim_buf_get_mark(buf, ">")
  if first[1] == 0 or last[1] == 0 then notify("Не удалось получить выделение", LEVEL.WARN); return nil end
  local mode = vim.fn.visualmode()
  local end_line = vim.api.nvim_buf_get_lines(buf, last[1] - 1, last[1], false)[1] or ""
  local end_col = last[2]
  if mode == "V" then first[2], end_col = 0, #end_line
  elseif end_col < #end_line then end_col = end_col + vim.str_utf_end(end_line, end_col + 1) + 1
  else end_col = #end_line end
  local lines = vim.api.nvim_buf_get_text(buf, first[1] - 1, first[2], last[1] - 1, end_col, {})
  return { buf = buf, start_row = first[1], start_col = first[2], end_row = last[1], end_col = end_col, text = table.concat(lines, "\n") }
end

local function replace_selection(sel, value)
  if vim.api.nvim_buf_is_valid(sel.buf) then
    vim.api.nvim_buf_set_text(sel.buf, sel.start_row - 1, sel.start_col, sel.end_row - 1, sel.end_col, vim.split(value, "\n", { plain = true }))
  end
end

local function copy_link(title, link)
  vim.fn.setreg('"', link)
  pcall(vim.fn.setreg, "+", link)
  vim.fn.setreg("t", title)
end

local function create_note(input, opts, callback)
  opts = opts or {}
  input = vim.trim(input or ""):gsub("\\", "/"):gsub("^/+", ""):gsub("%.md$", "")
  if input == "" or input == ".." or input:match("^%.%./") or input:match("/%.%./") or input:match("/%.%.$") then
    notify("Укажи корректное имя заметки", LEVEL.WARN); return
  end
  local root = notebook_root()
  local rel_dir = vim.fs.dirname(input)
  local title = vim.fs.basename(input)
  local target = root .. "/" .. input .. ".md"
  if vim.fn.filereadable(target) == 1 then callback(target, true, input, title); return end
  if rel_dir ~= "." then vim.fn.mkdir(root .. "/" .. rel_dir, "p") end
  local args = { "new", "--no-input", "--print-path", "--title", opts.title or title, "--id", title }
  if opts.content ~= nil then args[2] = "--interactive" end
  if rel_dir ~= "." then args[#args + 1] = rel_dir end
  zk(root, args, function(output, err)
    if not output then notify("Не удалось создать заметку: " .. err, LEVEL.ERROR); return end
    local path = vim.trim(output):gsub("\n.*", "")
    if path == "" then path = target end
    callback(path, false, input, title)
  end, opts.content)
end

local function insert_at_cursor(win, buf, value)
  if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then return end
  local cursor = vim.api.nvim_win_get_cursor(win)
  local row, col = cursor[1], cursor[2]
  local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
  local after = col
  if col < #line then after = col + vim.str_utf_end(line, col + 1) + 1 else after = #line end
  vim.api.nvim_buf_set_text(buf, row - 1, after, row - 1, after, { value })
end

local function trim_title(value) return vim.trim(value):gsub("%s+", " ") end

local function current_wikilink()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local from = 1
  while true do
    local a, b, inside = line:find("%[%[(.-)%]%]", from)
    if not a then return nil end
    if col >= a and col <= b then return inside end
    from = b + 1
  end
end

local function resolve_note(root, target, callback)
  target = vim.trim(target or ""):gsub("\\", "/"):gsub("^%./", ""):gsub("%.md$", "")
  if target == "" then callback(nil); return end

  local direct = root .. "/" .. target .. ".md"
  if vim.fn.filereadable(direct) == 1 then
    callback({ abs = direct, path = target .. ".md", stem = vim.fs.basename(target), title = "" })
    return
  end

  list_notes(root, {}, function(notes)
    local wanted = target:lower()
    local stem = vim.fs.basename(target):lower()
    local by_stem, by_title
    for _, note in ipairs(notes) do
      local relative = (note.path or ""):lower()
      local name = (note.stem or ""):lower()
      local title = (note.title or ""):lower()
      local hidden = relative:match("^%.") or relative:match("/%.")
      if relative:gsub("%.md$", "") == wanted then callback(note); return end
      if name == stem and not hidden then by_stem = by_stem or note end
      if title == wanted and not hidden then by_title = by_title or note end
    end
    callback(by_stem or by_title)
  end)
end

local function follow_wikilink()
  local inside = current_wikilink()
  if not inside then return false end
  local target, anchor = inside:match("^([^|#]*)"), inside:match("#([^|]+)")
  target = vim.trim(target or "")
  if target == "" then
    if anchor then vim.fn.search("\\c^#\\+\\s\\+\\V" .. vim.fn.escape(vim.trim(anchor), "\\"), "w") end
    return true
  end
  resolve_note(notebook_root(), target, function(note)
    if note then
      open(note.abs)
      if anchor then vim.fn.search("\\c^#\\+\\s\\+\\V" .. vim.fn.escape(vim.trim(anchor), "\\"), "w") end
    else
      vim.ui.select({ "Создать заметку", "Отмена" }, { prompt = "Не найдена заметка: " .. target }, function(choice)
        if choice == "Создать заметку" then create_note(target, {}, function(path) open(path) end) end
      end)
    end
  end)
  return true
end

local ACTIONS = {}

ACTIONS.fd = function()
  local t = telescope(); if t then t.builtin.find_files({ cwd = notebook_root() }) end
end
ACTIONS.lg = function()
  local t = telescope(); if t then t.builtin.live_grep({ cwd = notebook_root() }) end
end
ACTIONS.match = function(_, ctx)
  local query
  if ctx.range > 0 then local sel = selection(ctx); if not sel then return end; query = trim_title(sel.text)
  else query = vim.fn.expand("<cword>") end
  local t = telescope(); if t then t.builtin.live_grep({ cwd = notebook_root(), default_text = query ~= "" and query or nil }) end
end
ACTIONS.tags = function() tags_picker(notebook_root()) end
ACTIONS.links = function()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then notify("Текущий буфер не является файлом", LEVEL.WARN); return end
  local root = notebook_root()
  local relative = vim.fs.normalize(name):sub(#vim.fs.normalize(root) + 2)
  list_notes(root, { ["linked-by"] = relative }, function(notes) note_picker(notes, "Outgoing links", open_selected) end)
end
ACTIONS.backlinks = function()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then notify("Текущий буфер не является файлом", LEVEL.WARN); return end
  local root = notebook_root()
  local relative = vim.fs.normalize(name):sub(#vim.fs.normalize(root) + 2)
  list_notes(root, { ["link-to"] = relative }, function(notes) note_picker(notes, "Backlinks", open_selected) end)
end
ACTIONS.new = function(args)
  local input = table.concat(args, " ")
  if vim.trim(input) == "" then notify("Использование: :Note new <имя>", LEVEL.WARN); return end
  create_note(input, {}, function(path) open(path) end)
end
ACTIONS["new-from-title-selection"] = function(args, ctx)
  local input = table.concat(args, " "); if vim.trim(input) == "" then notify("Укажи имя заметки", LEVEL.WARN); return end
  local sel = selection(ctx); if not sel then return end
  local title = trim_title(sel.text)
  create_note(input, { title = title }, function(_, _, rel)
    local link = "[[" .. rel .. "]]"; replace_selection(sel, link); copy_link(rel, link)
  end)
end
ACTIONS["new-from-content-selection"] = function(args, ctx)
  local input = table.concat(args, " "); if vim.trim(input) == "" then notify("Укажи имя заметки", LEVEL.WARN); return end
  local sel = selection(ctx); if not sel then return end
  create_note(input, { content = sel.text }, function(_, existed, rel)
    if existed then notify("Заметка уже существует; выделение оставлено без изменений", LEVEL.WARN); return end
    local link = "[[" .. rel .. "]]"; replace_selection(sel, link); copy_link(rel, link)
  end)
end
ACTIONS["insert-link"] = function()
  local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
  list_notes(notebook_root(), {}, function(notes)
    note_picker(notes, "Insert link", function(selected)
      local links = {}; for _, note in ipairs(selected) do links[#links + 1] = "[[" .. note.stem .. "]]" end
      insert_at_cursor(win, buf, table.concat(links, " "))
    end)
  end)
end
ACTIONS["insert-link-at-selection"] = function(_, ctx)
  local sel = selection(ctx); if not sel then return end
  list_notes(notebook_root(), {}, function(notes)
    note_picker(notes, "Insert link at selection", function(selected)
      local note, label = selected[1], trim_title(sel.text)
      local link = "[[" .. note.stem .. (label ~= "" and label ~= note.stem and ("|" .. label) or "") .. "]]"
      replace_selection(sel, link)
    end)
  end)
end
ACTIONS.index = function()
  zk(notebook_root(), { "index" }, function(output, err)
    if not output then notify("zk index: " .. err, LEVEL.ERROR); return end
    local report = vim.trim(output)
    if report ~= "" then notify(report) end
  end)
end
ACTIONS.cd = function() vim.cmd.cd(vim.fn.fnameescape(notebook_root())) end

-- Journal creation is handled by zk aliases. Lua does not know journal
-- directories, date formats, group names or template filenames.
for _, name in ipairs({ "today", "tomorrow", "week", "quarter", "year" }) do
  local alias = name
  ACTIONS[alias] = function()
    zk(notebook_root(), { alias }, function(output, err)
      if not output then notify("zk " .. alias .. ": " .. err, LEVEL.ERROR); return end
      open(vim.trim(output):gsub("\n.*", ""))
    end)
  end
end

local function commands()
  local names = vim.tbl_keys(ACTIONS); table.sort(names); return names
end

local function dispatch(opts)
  local args = vim.deepcopy(opts.fargs)
  local sub = table.remove(args, 1) or "fd"
  local action = ACTIONS[sub]
  if not action then notify("Неизвестная команда: " .. sub .. ". Доступно: " .. table.concat(commands(), ", "), LEVEL.ERROR); return end
  action(args, { range = opts.range })
end

local function complete(lead)
  return vim.tbl_filter(function(name) return vim.startswith(name, lead or "") end, commands())
end

local function attach_lsp(buf)
  local file = vim.api.nvim_buf_get_name(buf)
  if file == "" or vim.fn.executable("zk") ~= 1 then return end
  local root = vim.fs.root(file, ".zk")
  if not root then return end
  local clients = vim.lsp.get_clients({ name = "zk", bufnr = buf })
  if #clients == 0 then
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, blink = pcall(require, "blink.cmp")
    if ok and blink.get_lsp_capabilities then capabilities = blink.get_lsp_capabilities(capabilities) end
    vim.lsp.start({ name = "zk", cmd = { "zk", "lsp" }, root_dir = root, capabilities = capabilities }, { bufnr = buf })
  end
end

local function register()
  if vim.fn.has("nvim-0.10") ~= 1 then notify("Требуется Neovim 0.10+", LEVEL.ERROR); return end
  local group = vim.api.nvim_create_augroup(AUGROUP, { clear = true })
  vim.api.nvim_create_user_command("Note", dispatch, { nargs = "*", range = true, complete = function(arglead) return complete(arglead) end })
  vim.api.nvim_create_autocmd("FileType", { group = group, pattern = "markdown", callback = function(ev)
    local buf = ev.buf
    vim.bo[buf].suffixesadd = ".md"
    vim.keymap.set("n", "gf", function()
      if not follow_wikilink() then vim.cmd.normal({ "gf", bang = true }) end
    end, { buffer = buf, desc = "Follow zk wiki link" })
    attach_lsp(buf)
  end })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "markdown" then
      vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
    end
  end
end

function M.setup(opts)
  opts = opts or {}
  if opts.plugins == false then return end
  local function setup_plugin(name, defaults, override)
    local ok, plugin = pcall(require, name)
    if ok and plugin.setup then plugin.setup(vim.tbl_deep_extend("force", defaults, override or {})) end
  end
  setup_plugin("nvim-web-devicons", { default = true }, opts.devicons)
  setup_plugin("render-markdown", { file_types = { "markdown" }, anti_conceal = { enabled = true } }, opts.render_markdown)
  setup_plugin("blink.cmp", {
    enabled = function() return #vim.lsp.get_clients({ bufnr = 0 }) > 0 end,
    sources = { default = { "lsp", "path" } },
    cmdline = { enabled = false },
  }, opts.blink)
end

register()
return M
    '';
  };

}
