-- Standard awesome library
local awful = require("awful")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local pairs = pairs
local string = require("string")
local table = require("table")
local io = require("io")
local os = require("os")

module("goblin")
-- {(( Flexible, Dynamic, Button-Oriented Wibox
mybuttonlist = { awful.widget.launcher({ image="/usr/share/pixmaps/terminal-tango.xpm",
                                        command="/usr/bin/terminator"})	}

function button_check_exists(command)
    local r = 0
    for key, button in pairs(mybuttonlist) do
        if button.command == command then
            r = 1
        end
    end
    return r
end

function button_on_menu(...)
    if button_check_exists(arg[1]) == 0 then
        if arg["n"] == 1 then
            table.insert(mybuttonlist, awful.widget.launcher({ image=beautiful.awesome_icon,
                                                           command=arg[1]})            )
        elseif arg["n"] == 2 then
            table.insert(mybuttonlist, awful.widget.launcher({ image=arg[2],
                                                           command=arg[1]})         )
        end
    end
end

function button_list_populate()
    local p = io.popen('find "'.. os.getenv( "HOME" ) .. "/.config/awesome/goblin/quicklaunch" ..'" -type f')
    for file in p:lines() do
        local q = io.input(file)
        local i = io.read("*all")
        local command
        local image
        for s in string.gmatch(i,"%S+") do
            if string.match(s, "command") then
                command = string.gsub(s, "command=", "")
            end
            if string.match(s, "image") then
                image = string.gsub(s, "image=", "")
            end
        end
        button_on_menu(command, image)
        io.close(q)
    end
    io.close(p)
end

button_list_populate()

function button_layout_menu()
    local layout = wibox.layout.align.horizontal()
    local center = wibox.layout.fixed.horizontal()
    for key, button in pairs(mybuttonlist) do
        center:add(button)
    end
    layout:set_middle(center)
    return layout
end

function button_list_count_members()
    local n = 0
    for key in pairs(mybuttonlist) do
        n = n + 1
    end
    return n
end
-- }}}