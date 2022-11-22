-- Wait a second for me to finish typing before linting
vim.g.ale_lint_delay = 1000
-- Show ale info in statusline
vim.g['airline#extensions#ale#enabled'] = 1
-- Show linter at beginning of message
vim.g.ale_echo_msg_format = '[%linter%] %s'
-- Show messages in a floating preview window
vim.g.ale_cursor_detail = 1
vim.g.ale_floating_preview = 1
vim.g.ale_floating_window_border = {' ', '', '', '', '', '', '', ''}
vim.g.ale_close_preview_on_insert = 1
-- Disable LSP features in ALE as these are handled by another plugin
vim.g.ale_disable_lsp = 1
-- Make ale error/warning gutter symbols prettier
vim.g.ale_sign_error = '😠'
vim.g.ale_sign_warning = '😒'

-- Key Mappings
---------------

local utils = require('utils')

-- Move to the previous warning/error
utils.nmap('<Leader>j', '<Plug>(ale_previous_wrap)')
-- Move to the next warning/error
utils.nmap('<Leader>k', '<Plug>(ale_next_wrap)')
-- Disable in all buffers
utils.nmap('<Leader>ad', ':ALEDisable<CR>', { silent = false })
-- Disable in current buffer
utils.nmap('<Leader>abd', ':ALEDisableBuffer<CR>', { silent = false })
-- Enable in all buffers
utils.nmap('<Leader>ae', ':ALEEnable<CR>', { silent = false })
-- Enable in current buffer
utils.nmap('<Leader>abe', ':ALEEnableBuffer<CR>', { silent = false })
