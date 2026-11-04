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
      zk-nvim
      render-markdown-nvim
      nvim-web-devicons
      blink-cmp
    ];

    extraLuaConfig = 
    '' vim.opt.conceallevel = 2

       vim.api.nvim_create_autocmd('FileType', {
         pattern = { 'markdown', 'lua' },
	 callback = function() end,
       })

       require("zk").setup({
         picker = "telescope",
	 lsp = 
	 { config = 
	   { cmd = { "zk", "lsp" },
	     name = "zk",
	     auto_attach = true,

	     capabilities = require('blink.cmp').get_lsp_capabilities(),
	   },
	 },
       })

       vim.api.nvim_create_autocmd("FileType", 
       { pattern = "markdown",
         callback = function()
	   local opts = { buffer = true, silent = true }
	   vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
           vim.keymap.set("n", "<leader>jb", "<cmd>ZkBacklinks<CR>", opts)
         end,
       })

       require('render-markdown').setup({})
       require('nvim-web-devicons').setup({})

       require('blink.cmp').setup({
         keymap = { preset = 'default' },
	 sources = {
	   default = { 'path', 'lsp' },
	 },
       })


local note_base = vim.fn.expand("~/Sync/Notes")

-- Функция для открытия дневных заметок
local function open_daily(date_str)
  local current_year = os.date("%Y")
  local path = note_base .. "/dailies/" .. current_year .. "/" .. date_str .. ".md"
  local template_path = note_base .. "/templates/template-daily.md"
  local is_new = (vim.fn.filereadable(path) == 0)

  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.cmd("edit " .. path)

  if is_new and vim.fn.filereadable(template_path) == 1 then
    local lines = vim.fn.readfile(template_path)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
end

-- Главная функция-парсер для команды :Note
vim.api.nvim_create_user_command('Note', function(opts)
  -- Разбиваем введенную строку на аргументы
  local args = vim.split(opts.args, " %s*")
  local action = args[1]

  if action == "today" then
    open_daily(os.date("%Y-%m-%d"))

  elseif action == "tomorrow" then
    open_daily(os.date("%Y-%m-%d", os.time() + 86400))

  elseif action == "new" then
    -- Берем второе слово (название заметки)
    local name = args[2]
    if not name or name == "" then
      print("Ошибка: Напишите название заметки! Пример: :Note new ИмяЗаметки")
      return
    end
    
    local path = note_base .. "/" .. name .. ".md"
    vim.cmd("edit " .. path)

  elseif action == "template" then
    -- Вызов Telescope строго в папке шаблонов
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    require('telescope.builtin').find_files({
      prompt_title = "Вставить шаблон",
      cwd = note_base .. "/templates",
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            local lines = vim.fn.readfile(selection.path)
            -- Вставляем строки шаблона туда, где сейчас стоит курсор
            local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
            vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, lines)
          end
        end)
        return true
      end,
    })
  else
    print("Неизвестный аргумент. Используйте: today, tomorrow, new [название], template")
  end
end, {
  -- Включаем поддержку аргументов
  nargs = '+',
  -- Добавляем автодополнение по кнопке Tab
  complete = function(ArgLead, CmdLine, CursorPos)
    local choices = { "today", "tomorrow", "new", "template" }
    return vim.tbl_filter(function(s) return string.match(s, "^" .. ArgLead) end, choices)
  end
})
      
    '';
  };

}
