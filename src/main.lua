-- Azzy's Silly Trinkets (AST)
-- main.lua 

assert(SMODS.load_file('src/globals.lua'))()
assert(SMODS.load_file('src/util.lua'))()
assert(SMODS.load_file('src/blind.lua'))()

SMODS.Atlas {
    key = "modicon",
    path = "Icon.png",
    px = 34,
    py = 34
}
