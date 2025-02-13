------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- joker.lua 
-- Registering of modded jokers, as well as relevant hooks for implementing them
--
-- Hamester, 2025
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
-- # Resources #
------------------------------------------------------------------------------------------------------------------------------------------------------
-- Registering Atlas
SMODS.Atlas { key = AST.JOKER.ATLAS, path = AST.JOKER.ATLAS .. ".png", px = AST.JOKER.ATLAS_WIDTH, py = AST.JOKER.ATLAS_HEIGHT}

-- Registering Sounds
SMODS.Sound { key = AST.SOUND.REVERSE_POLARITY_EXPLODE.NAME, path = AST.SOUND.REVERSE_POLARITY_EXPLODE.PATH }

------------------------------------------------------------------------------------------------------------------------------------------------------
-- # Registering modded boss blinds #
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Reverse Polarity
------------------------------------------------------------------------------------------------------------------------------------------------------

SMODS.Joker {
    key = AST.JOKER.REVERSE_POLARITY.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.REVERSE_POLARITY.ATLAS_ROW, y = AST.JOKER.REVERSE_POLARITY.ATLAS_COL },
    config = { extra = { energy = 5, energy_gain = 1 } },
    loc_vars = function(_, _, card) return { vars = { card.ability.extra.energy, card.ability.extra.energy_gain } } end,
    rarity = AST.JOKER.REVERSE_POLARITY.RARITY,
    cost = AST.JOKER.REVERSE_POLARITY.COST,
    unlocked = AST.DEBUG_MODE,
    discovered = AST.DEBUG_MODE,
    calculate = function(_, card, context)
        if context.selling_card and context.card.ability.set == "Tarot" and not context.blueprint then
            card.ability.extra.energy = card.ability.extra.energy + card.ability.extra.energy_gain
            return { message = localize{ type = 'variable', key = 'b_ast_add_energy', vars = { card.ability.extra.energy } } }
        end

        if context.joker_main then
            card.ability.extra.energy = card.ability.extra.energy - 1

            if card.ability.extra.energy > 0 then
                return { 
                    sound = "foil2",
                    swap = true,
                    message = localize('b_ast_reversed')
                }
            end

            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("ast_reverse_polarity_explode", 1, 1) 
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                            return true; end})) 
                    return true
                end
            }))

            return { 
                swap = true,
                message = localize('b_ast_exploded'),
            }
        end
    end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- joker.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
