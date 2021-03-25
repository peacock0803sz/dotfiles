local gl = require("galaxyline")
local gls = gl.section
gl.short_line_list = {"LuaTree", "vista", "dbui"}

local diagnostic = require('galaxyline.provider_diagnostic')
local vcs = require('galaxyline.provider_vcs')
local fileinfo = require('galaxyline.provider_fileinfo')
local extension = require('galaxyline.provider_extensions')
local buffer = require('galaxyline.provider_buffer')

-- provider
BufferIcon  = buffer.get_buffer_type_icon
BufferNumber = buffer.get_buffer_number
FileTypeName = buffer.get_buffer_filetype
-- Git Provider
GitBranch = vcs.get_git_branch
IsGitRepo = vcs.chech_git_workspace
DiffAdd = vcs.diff_add             -- support vim-gitgutter vim-signify gitsigns
DiffModified = vcs.diff_modified   -- support vim-gitgutter vim-signify gitsigns
DiffRemove = vcs.diff_remove       -- support vim-gitgutter vim-signify gitsigns
-- File Provider
LineColumn = fileinfo.line_column
FileFormat = fileinfo.get_file_format
FileEncode = fileinfo.get_file_encode
FileSize = fileinfo.get_file_size
FileIcon = fileinfo.get_file_icon
FileName = fileinfo.get_current_file_name
LinePercent = fileinfo.current_line_percent
ScrollBar = extension.scrollbar_instance
VistaPlugin = extension.vista_nearest
-- Diagnostic Provider
DiagnosticError = diagnostic.get_diagnostic_error
DiagnosticWarn = diagnostic.get_diagnostic_warn
DiagnosticHint = diagnostic.get_diagnostic_hint
DiagnosticInfo = diagnostic.get_diagnostic_info

local colors = {
    bg = '#282c34',
    fg = '#aab2bf',
    section_bg = '#38393f',
    blue = '#61afef',
    green = '#98c379',
    purple = '#c678dd',
    orange = '#e5c07b',
    red1 = '#e06c75',
    red2 = '#be5046',
    yellow = '#e5c07b',
    gray1 = '#5c6370',
    gray2 = '#2c323d',
    gray3 = '#3e4452',
    darkgrey = '#5c6370',
    grey = '#848586',
    middlegrey = '#8791A5'
}

local mode_color = function()
    local mode_colors = {
        n = colors.green,
        i = colors.blue,
        c = colors.green,
        V = colors.purple,
        [''] = colors.purple,
        v = colors.purple,
        R = colors.red1,
        t = colors.blue
    }

    if mode_colors[vim.fn.mode()] ~= nil then
        return mode_colors[vim.fn.mode()]
    else
        print(vim.fn.mode())
        return colors.purple
    end
end

local function file_readonly()
    if vim.bo.filetype == 'help' then return 'HELP' end
    if vim.bo.readonly == true then return 'w!' end
    return ''
end

local function get_current_file_name()
    local file = vim.fn.expand('%:t')
    if vim.fn.empty(file) == 1 then return '' end
    if string.len(file_readonly()) ~= 0 then return file .. file_readonly() end
    if vim.bo.modifiable then
        if vim.bo.modified then return file .. '  ' end
    end
    return file .. ' '
end


local function lsp_status(status)
    shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end


local function get_coc_lsp()
  local status = vim.fn['coc#status']()
  if not status or status == '' then
      return ''
  end
  return lsp_status(status)
end

local function lsp_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_lsp()
    end
  return ''
end

gls.left[1] = {
    ViMode = {
        provider = function()
            local alias = {
                n = 'NORMAL',
                i = 'INSERT',
                c = 'COMMAND',
                v = 'VISUAL',
                V = 'V-LINE',
                [''] = 'VISUAL',
                R = 'REPLACE',
                t = 'TERMINAL',
                s = 'SELECT',
                S = 'S-LINE'
            }
            vim.api.nvim_command('hi GalaxyViMode guibg=' .. mode_color())
            if alias[vim.fn.mode()] ~= nil then
                return '  ' .. alias[vim.fn.mode()] .. ' '
            else
                return '  V-BLOCK '
            end
        end,
        highlight = {colors.bg, colors.bg, 'bold'}
    }
}

gls.left[2] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.fg, colors.bg}
    }
}

gls.left[3] = {
    FileName = {
        provider = FileName,
        condition = buffer_not_empty,
        highlight = {colors.fg, colors.section_bg, 'bold'},
        separator = '|',
        separator_highlight = {colors.section_bg, colors.bg}
    }
}
gls.left[4] = {
  LspInfo = {
    provider = lsp_info,
    highlight = {colors.fg, colors.bg},
    separator = '|'
  }
}

gls.left[8] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.fg, colors.bg}
    }
}
gls.left[9] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = '!',
        highlight = {colors.red1, colors.bg}
    }
}
gls.left[10] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.section_bg, colors.bg}
    }
}
gls.left[11] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = '!',
        highlight = {colors.yellow, colors.bg}
    }
}
gls.left[12] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.section_bg, colors.bg}
    }
}
gls.left[13] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = '!',
        highlight = {colors.blue, colors.section_bg},
        separator = ' ',
        separator_highlight = {colors.section_bg, colors.bg}
    }
}
gls.left[14] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.section_bg, colors.bg}
    }
}
gls.left[15] = {
    DiagnosticInfo = {
        provider = 'DiagnosticHint',
        icon = '!',
        highlight = {colors.green, colors.section_bg},
        separator = ' ',
        separator_highlight = {colors.section_bg, colors.bg}
    }
}

gls.right[1] = {
    DiffAdd = {
        provider = 'DiffAdd',
        condition = checkwidth,
        icon = '+',
        highlight = {colors.green, colors.bg}
    }
}
gls.right[2] = {
    DiffModified = {
        provider = 'DiffModified',
        condition = checkwidth,
        icon = '~',
        highlight = {colors.orange, colors.bg}
    }
}
gls.right[3] = {
    DiffRemove = {
        provider = 'DiffRemove',
        condition = checkwidth,
        icon = '-',
        highlight = {colors.red1, colors.bg}
    }
}

gls.right[4] = {
    Space = {
        provider = function() return ' ' end,
        highlight = {colors.section_bg, colors.bg}
    }
}
gls.right[5] = {
    GitIcon = {
        provider = function() return '' end,
        condition = buffer_not_empty and IsGitRepo,
        highlight = {colors.middlegrey, colors.bg}
    }
}
gls.right[6] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = buffer_not_empty,
        highlight = {colors.green, colors.bg, 'bold'}
    }
}
gls.right[7] = {
    PerCent = {
        provider = 'LinePercent',
        separator = ' ',
        separator_highlight = {colors.blue, colors.bg},
        highlight = {colors.gray2, colors.blue}
    }
}

gls.short_line_right[1] = {
    BufferIcon = {
        provider = 'BufferIcon',
        highlight = {colors.yellow, colors.section_bg},
        separator = '',
        separator_highlight = {colors.section_bg, colors.bg}
    }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
