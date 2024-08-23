-- Inherit from TypeScript
local oldpath = package.path
package.path = vim.fn.stdpath('config') .. '/after/ftplugin/?.lua;' .. package.path
require('typescript')
package.path = oldpath
