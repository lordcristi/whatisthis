local ffi = require "ffi"
local color = require 'gamesense/color'
local base64 = require 'gamesense/base64'
local clipboard = {}
local native_SetClipboardText = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
function clipboard.set(text)
	native_SetClipboardText(text, string.len(tostring(text)))
end
clipboard.copy = clipboard.set

function table.insertAll(t, ...)
    local args = {...}
    local n = #t
    for i, v in ipairs(args) do
        t[n + i] = v
    end
end
local tbl = {
    ['ESP'] = {   
        ['Health Bar'] = {ui.reference('VISUALS', 'Player ESP', 'Custom health bar')},
        ['OOF Arrows'] = {ui.reference('VISUALS', 'Player ESP', 'Out of FOV arrow')},
        ['Skeleton'] = {ui.reference('VISUALS', 'Player ESP', 'Skeleton')},
        ['Line of Sight'] = {ui.reference('VISUALS', 'Player ESP', 'Line of sight')},
        ['Sound ESP'] = {ui.reference('VISUALS', 'Player ESP', 'Visualize sounds')},
        ['Hitboxes'] = {ui.reference('VISUALS', 'Player ESP', 'Visualize aimbot')},
        ['Safe Hitboxes'] = {ui.reference('VISUALS', 'Player ESP', 'Visualize aimbot (safe point)')},
        ['Ammo Bar'] = {ui.reference('VISUALS', 'Player ESP', 'Ammo')},
        ['Weapon Icon'] = {ui.reference('VISUALS', 'Player ESP', 'Weapon icon')},
        ['Player Name'] = {ui.reference('VISUALS', 'Player ESP', 'Name')},
        ['Bounding Box'] = {ui.reference('VISUALS', 'Player ESP', 'Bounding Box')},
    },

    ['World'] = {
        ['Night Mode'] = {ui.reference('VISUALS', 'Effects', 'Brightness adjustment')},
        ['Props'] = {ui.reference('VISUALS', 'Colored Models', 'Props')},
        ['Enemy Bullet Tracer'] = {ui.reference('VISUALS', 'Effects', 'Bullet tracers')},
        ['Fog Color'] = {ui.reference('VISUALS', 'Effects', 'Override fog')},
    },

    ['Enemy Chams'] = {
        ['Enemy Visible'] = {ui.reference('VISUALS', 'Colored Models', 'Player')},
        ['Backtrack'] = {ui.reference('VISUALS', 'Colored Models', 'Shadow')},
        ['Enemy Glow'] = {ui.reference('VISUALS', 'Player ESP', 'Glow')},
        ['Enemy Invisible'] = {ui.reference('VISUALS', 'Colored Models', 'Player behind wall')},
        ['Weapons'] = {ui.reference('VISUALS', 'Colored Models', 'Weapons')},
        ['On Shot'] = {ui.reference('VISUALS', 'Colored Models', 'On shot')},
    },

    ['Teammate Chams'] = {
        ['Teammate'] = {ui.reference('VISUALS', 'Colored Models', 'Teammate')},
        ['Teammate Behind Wall'] = {ui.reference('VISUALS', 'Colored Models', 'Teammate behind wall')},
    },

    ['Local'] = {
        ['Local Player'] = {ui.reference('VISUALS', 'Colored Models', 'Local player')},
        ['Local Player Fake'] = {ui.reference('VISUALS', 'Colored Models', 'Local player fake')},
    },

    ['Weapons'] = {
        ['Weapons Viewmodel'] = {ui.reference('VISUALS', 'Colored Models', 'Weapon viewmodel')},
    },

    ['Other'] = {
        ['Dropped Weapons'] = {ui.reference('VISUALS', 'Other ESP', 'Dropped weapons')},
        ['Grenade Trajectory & Glow'] = {ui.reference('VISUALS', 'Other ESP', 'Grenades')},
        ['C4 Bomb'] = {ui.reference('VISUALS', 'Other ESP', 'Bomb')},
        ['Grenade Prediction'] = {ui.reference('VISUALS', 'Other ESP', 'Grenade trajectory')},
        ['Grenade Prediction Hit'] = {ui.reference('VISUALS', 'Other ESP', 'Grenade trajectory (hit)')},
        ['Auto Peek'] = {ui.reference('RAGE', 'Other', 'Quick peek assist mode')},
    },

    ['FOV'] = {
        ['FOV'] = ui.reference('MISC', 'Miscellaneous', 'Override FOV'),
        ['Zoom FOV'] = ui.reference('MISC', 'Miscellaneous', 'Override zoom FOV'),
        ['Aspect Ratio'] = ui.reference('VISUALS', 'Effects', 'Force aspect ratio'),
        ['Thirdperson Distance'] = ui.reference('CONFIG', 'Presets', 'Third person distance'),
    },
}

local cfg = {}
local export = ui.new_button('CONFIG', 'Presets', 'EXPORT VISUALS', function()

    for k, v in pairs(tbl['ESP']) do
        local j = {}
        local r, g, b, a = ui.get(v[2])
        local amangas = color(r, g, b, a):to_hex()
        local status = ui.get(v[1])
        table.insertAll(j, k, amangas, status)
        table.insert(cfg, j)
    end

    for k, v in pairs(tbl['Enemy Chams']) do
        local j = {}
        local r, g, b, a = ui.get(v[2])
        local amangas = color(r, g, b, a):to_hex()
        local status = ui.get(v[1])
        if k == 'Enemy Invisible' or k == 'Weapons' or k == 'On Shot' then
            local r2, g2, b2, a2 = ui.get(v[4])
            local amangas2 =  color(r2, g2, b2, a2):to_hex()
            table.insertAll(j, k, amangas, ui.get(v[3]), amangas2, status)
        else
            table.insertAll(j, k, amangas, status)
        end
        table.insert(cfg, j)
    end

    for k, v in pairs(tbl['Local']) do
        local j = {}
        local r, g, b, a = ui.get(v[2])
        local r2, g2, b2, a2 = ui.get(v[4])
        local amangas = color(r, g, b, a):to_hex()
        local amangas2 =  color(r2, g2, b2, a2):to_hex()
        local status = ui.get(v[1])
        table.insertAll(j, k, amangas, ui.get(v[3]), amangas2, status)
        table.insert(cfg, j)
    end

    for k, v in pairs(tbl['Weapons']) do
        local j = {}
        local r, g, b, a = ui.get(v[2])
        local r2, g2, b2, a2 = ui.get(v[4])
        local amangas = color(r, g, b, a):to_hex()
        local amangas2 =  color(r2, g2, b2, a2):to_hex()
        local status = ui.get(v[1])
        table.insertAll(j, k, amangas, ui.get(v[3]), amangas2, status)
        table.insert(cfg, j)
    end

    for k, v in pairs(tbl['World']) do
        local j = {}
        local r, g, b, a = ui.get(v[2])
        local amangas = color(r, g, b, a):to_hex()
        local status = ''
        if k == 'Night Mode' then
            status = (ui.get(v[1]) == 'Night mode')
        else
            status = ui.get(v[1])
        end
        table.insertAll(j, k, amangas, status)
        table.insert(cfg, j)
    end

    for k, v in pairs(tbl['Other']) do
        local j = {}
        local r, g, b, a = (k == 'Grenade Prediction Hit') and ui.get(v[1]) or ui.get(v[2])
        local amangas = color(r, g, b, a):to_hex()
        local status = ui.get(v[1])
        if k == 'Dropped Weapons' then
            status = (ui.get(v[1]) ~= nil)
        elseif k == 'Auto Peek' then
            status = true
        elseif k == 'Grenade Prediction Hit' then
            status = true
        else
            status = ui.get(v[1])
        end
        table.insertAll(j, k, amangas, status)
        table.insert(cfg, j)
    end

    for k, v in pairs(tbl['FOV']) do
        local j = {}
        table.insertAll(j, k, ui.get(v))
        table.insert(cfg, j)
    end

    clipboard.set(base64.encode(json.stringify(cfg)))
    cfg = {}
end)
