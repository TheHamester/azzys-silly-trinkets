------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- main.lua 
-- Entry point to the mod
--
-- Hamester, 2025
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Preloading other lua scripts
assert(SMODS.load_file('src/globals.lua'))()
assert(SMODS.load_file('src/lua_hooks.lua'))()
assert(SMODS.load_file('src/sound.lua'))()
assert(SMODS.load_file('src/joker.lua'))()
assert(SMODS.load_file('src/blind.lua'))()

-- Registering atlas for mod icon
SMODS.Atlas { key = "modicon", path = "Icon.png", px = 34, py = 34 }

------------------------------------------------------------------------------------------------------------------------------------------------------
-- main.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
