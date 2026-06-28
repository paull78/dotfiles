-- Autosave: write the buffer on common "I'm done typing for a moment" events
local group = vim.api.nvim_create_augroup("autosave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
  group = group,
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype ~= "" then return end
    if not vim.bo[buf].modifiable or vim.bo[buf].readonly then return end
    if vim.api.nvim_buf_get_name(buf) == "" then return end
    if not vim.bo[buf].modified then return end
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent! write")
    end)
  end,
})
