------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- globals.lua 
-- File for setting global constants for modded content
-- 
-- Hamester, 2025
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Setting global constants
------------------------------------------------------------------------------------------------------------------------------------------------------
AST = {
    -- For debugging purposes
	DEBUG_MODE = false,

    -- Sounds
    SOUND = {
        REVERSE_POLARITY_EXPLODE = {
            NAME = "reverse_polarity_explode",
            KEY = "ast_reverse_polarity_explode",
            PATH = "reverse_polarity_explode.ogg"
        }
    },

    -- Jokers constants
    JOKER = {
        ATLAS = "AST_JOKER",
        ATLAS_WIDTH = 71,
        ATLAS_HEIGHT = 95,

        REVERSE_POLARITY = {
            ATLAS_ROW = 0,
            ATLAS_COL = 0,
            NAME = "reverse_polarity",
            KEY = "j_ast_reverse_polarity",
            RARITY = 3,
            COST = 7
        }
    },

    -- Blinds constants
    BLIND = {
        ATLAS = "AST_BLIND",
        ATLAS_TABLE = "ANIMATION_ATLAS",
        ATLAS_WIDTH = 34,
        ATLAS_HEIGHT = 34,
        ATLAS_FRAMES = 21,

        THE_CLOCK = {
            ATLAS_ROW = 0,
            NAME = "the_clock",
            KEY = "bl_ast_the_clock",
            COLOR =  HEX("006060"),
            REWARD = 5,
            BASE_MULT = 1.5,
            BOSS_MIN = 2,
            BOSS_MAX = 10,

            TIMER_SECONDS = 8
        },

        THE_RAZOR = {
            ATLAS_ROW = 1,
            NAME = "the_razor",
            KEY = "bl_ast_the_razor",
            COLOR =  HEX("FFAAAA"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 2,
            BOSS_MAX = 10
        },

        THE_INSECURITY = {
            ATLAS_ROW = 2,
            NAME = "the_insecurity",
            KEY = "bl_ast_the_insecurity",
            COLOR =  HEX("702A69"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 2,
            BOSS_MAX = 10
        },

        THE_GAMBIT = {
            ATLAS_ROW = 3,
            NAME = "the_gambit",
            KEY = "bl_ast_the_gambit",
            COLOR =  HEX("353535"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 2,
            BOSS_MAX = 10
        },

        THE_PIT = {
            ATLAS_ROW = 4,
            NAME = "the_pit",
            KEY = "bl_ast_the_pit",
            COLOR =  HEX("202956"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 2,
            BOSS_MAX = 10
        },
        THE_CONSTRUCT = {
            ATLAS_ROW = 5,
            NAME = "the_construct",
            KEY = "bl_ast_the_construct",
            COLOR =  HEX("005500"),
            REWARD = 5,
            BASE_MULT = 1.5,
            BOSS_MIN = 2,
            BOSS_MAX = 10
        },
        THE_FILM = {
            ATLAS_ROW = 6,
            NAME = "the_film",
            KEY = "bl_ast_the_film",
            COLOR =  HEX("111111"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 4,
            BOSS_MAX = 10
        },
        THE_PHEASANT = {
            ATLAS_ROW = 7,
            NAME = "the_pheasant",
            KEY = "bl_ast_the_pheasant",
            COLOR =  HEX("FFFFFF"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 4,
            BOSS_MAX = 10
        },
        THE_ALLOY = {
            ATLAS_ROW = 8,
            NAME = "the_alloy",
            KEY = "bl_ast_the_alloy",
            COLOR =  HEX("A08C59"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 4,
            BOSS_MAX = 10
        },
        THE_ALUMINUM = {
            ATLAS_ROW = 9,
            NAME = "the_aluminum",
            KEY = "bl_ast_the_aluminum",
            COLOR =  HEX("00BC87"),
            REWARD = 5,
            BASE_MULT = 2,
            BOSS_MIN = 4,
            BOSS_MAX = 10
        }
    }
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- globals.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
