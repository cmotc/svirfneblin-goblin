# svirfneblin-goblin
A quick launch bar with auto-hide capabilities. A better README.md is 
forthcoming.


  * First load in the library  

         -- Load Auto-Hiding side-panel
         require("goblin.side")

  * Next create the wibox and the hide function  

         myshortcutbox = {}
         function hideshortcutbox()
             myshortcutbox[mouse.screen].visible = not myshortcutbox[mouse.screen].visible
         end
         myquicklaunchtoggle = awful.widget.button({ image=beautiful.awesome_icon })
         myquicklaunchtoggle:buttons(awful.button({}, 1, function () hideshortcutbox() end)
         )

  * Optionally, you can close the wibox after a certain amount of time. Windows 
according to the WM's instructions.  

         sbtimer = timer({timeout = 6})
         sbtimer:connect_signal("timeout", function()
                 if myshortcutbox[mouse.screen].visible then
                     hideshortcutbox()
                 end
             end)
         sbtimer:start()

  * Finally, create the wibox on every screen by adding it under "for s = 1, screen.count() do"  

             -- create the sidebar shortcut launcher wibox
             myshortcutbox[s] = awful.wibox({ position = "left", screen = s    })
             myshortcutbox[s].width=32
             myshortcutbox[s].height=goblin.button_list_count_members()*myshortcutbox[s].width
             myshortcutbox[s]:set_widget(goblin.button_layout_menu())
         