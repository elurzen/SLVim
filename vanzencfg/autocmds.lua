--Hack to ensure files open with captial drive letter (d:\ vs D:\) DAP breakpoints dont work if lowercase
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local name = vim.api.nvim_buf_get_name(0)
    if name:match '^[a-z]:\\' then
      local fixed = name:gsub('^([a-z]):', function(d)
        return d:upper() .. ':'
      end)
      vim.cmd('file ' .. fixed)
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
