-- Inherit from JavaScript
local oldpath = package.path
package.path = vim.fn.stdpath('config') .. '/after/ftplugin/?.lua;' .. package.path
require('javascript')
package.path = oldpath
