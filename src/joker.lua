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
SMODS.Atlas { 
    key = AST.JOKER.ATLAS, path = AST.JOKER.ATLAS .. ".png",
    px = AST.JOKER.ATLAS_WIDTH, py = AST.JOKER.ATLAS_HEIGHT
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- # Registering modded jokers #
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Reverse Polarity
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Joker {
    key = AST.JOKER.REVERSE_POLARITY.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.REVERSE_POLARITY.ATLAS_COL, y = AST.JOKER.REVERSE_POLARITY.ATLAS_ROW },
    config = { extra = { energy = 5, energy_gain = 1 } },
    loc_vars = function(_, _, card) return { vars = { card.ability.extra.energy, card.ability.extra.energy_gain } } end,
    rarity = AST.JOKER.REVERSE_POLARITY.RARITY,
    cost = AST.JOKER.REVERSE_POLARITY.COST,
    unlocked = true,
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
                    play_sound(AST.SOUND.REVERSE_POLARITY_EXPLODE.KEY, 0.96+math.random()*0.08)
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
-- Cardio
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Joker {
    key = AST.JOKER.CARDIO.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.CARDIO.ATLAS_COL, y = AST.JOKER.CARDIO.ATLAS_ROW },
    config = { extra = { extra_discards = 1 } },
    loc_vars = function(_, _, card) return { vars = { card.ability.extra.extra_discards } } end,
    rarity = AST.JOKER.CARDIO.RARITY,
    cost = AST.JOKER.CARDIO.COST,
    blueprint_compat = false,
    unlocked = true,
    discovered = AST.DEBUG_MODE
}

-- Hook to CardArea.add_to_highlighted to temporarily modify highlighted_limit
local add_to_highlighted_old = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent)
    local cardio = find_joker(AST.JOKER.CARDIO.KEY)
    local old_highlighted_limit = self.config.highlighted_limit

    if self.config.type == 'hand' and next(cardio) then self.config.highlighted_limit = self.config.highlighted_limit + cardio[1].ability.extra.extra_discards end
    add_to_highlighted_old(self, card, silent)
    self.config.highlighted_limit = old_highlighted_limit
end

-- Hooking into Card.remove_from_deck to deselect extra cards after card is removed from the jokers
local remove_from_deck_old = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
	local ret = remove_from_deck_old(self, from_debuff)

    if not G.hand then return ret end

	if not from_debuff and self.ability.set == "Joker" and self.ability.name == AST.JOKER.CARDIO.KEY and #G.hand.highlighted > G.hand.config.highlighted_limit then
        local highlighted = #G.hand.highlighted
        for i = highlighted, G.hand.config.highlighted_limit + 1, -1 do
            G.hand:remove_from_highlighted(G.hand.highlighted[i])
        end
	end

	return ret
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Paul
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Joker {
    key = AST.JOKER.PAUL.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.PAUL.ATLAS_COL, y = AST.JOKER.PAUL.ATLAS_ROW },
    config = { extra = { x_mult = 3 } },
    loc_vars = function(_, _, card) return { vars = { card.ability.extra.x_mult } } end,
    rarity = AST.JOKER.PAUL.RARITY,
    cost = AST.JOKER.PAUL.COST,
    blueprint_compat = true,
    unlocked = true,
    discovered = AST.DEBUG_MODE,
    calculate = function(_, card, context)
        if context.joker_main then
            return { 
                Xmult_mod = card.ability.extra.x_mult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
            }
        end

        if context.end_of_round and context.cardarea == G.jokers and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                    local sliced_card = G.jokers.cards[my_pos+1]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                            play_sound(AST.SOUND.PAUL_EAT.KEY, 0.96+math.random()*0.08)
                            return true 
                        end 
                    }))
                return { message = localize("b_ast_yummy") }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1") 
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
                return { message = localize("b_ast_starved") }
            end
        end
    end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Officinaphobia
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Joker {
    key = AST.JOKER.OFFICINAPHOBIA.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.OFFICINAPHOBIA.ATLAS_COL, y = AST.JOKER.OFFICINAPHOBIA.ATLAS_ROW },
    config = { extra = { mult = 0, mult_gain = 3 } },
    loc_vars = function(_, _, card) return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } } end,
    rarity = AST.JOKER.OFFICINAPHOBIA.RARITY,
    cost = AST.JOKER.OFFICINAPHOBIA.COST,
    unlocked = true,
    discovered = AST.DEBUG_MODE,
    blueprint_compat = true,
    calculate = function(_, card, context)
        if context.ending_shop and not context.blueprint then
            if G.GAME.current_round.nothing_was_purchased then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return { message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } } }
            end

            G.GAME.current_round.nothing_was_purchased = true
            return
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return { 
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

-- Hooking to Game.init_game_object to register extra data for Officinaphobia
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)

	ret.current_round.nothing_was_purchased = true

	return ret
end

-- Hooking to G.FUNCS.buy_from_shop to set current_round.nothing_was_purchased to false
local buy_from_shop_old = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    local ret = buy_from_shop_old(e)

    G.GAME.current_round.nothing_was_purchased = false

    return ret
end

-- Hooking into Card.open to set current_round.nothing_was_purchased to false when a pack in the shop is open
local card_open_old = Card.open
function Card:open()
    card_open_old(self)

    G.GAME.current_round.nothing_was_purchased = false
end

-- Hooking into Card.redeem to set current_round.nothing_was_purchased to false a voucher in the shop is redeemed
local card_redeem_old = Card.redeem
function Card:redeem()
    card_redeem_old(self)

    G.GAME.current_round.nothing_was_purchased = false
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Match 3
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Joker {
    key = AST.JOKER.MATCH_3.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.MATCH_3.ATLAS_COL, y = AST.JOKER.MATCH_3.ATLAS_ROW },
    config = { extra = { chips = 0, chips_gain = 11 } },
    loc_vars = function(_, _, card) return { vars = { card.ability.extra.chips, card.ability.extra.chips_gain } } end,
    rarity = AST.JOKER.MATCH_3.RARITY,
    cost = AST.JOKER.MATCH_3.COST,
    unlocked = true,
    discovered = AST.DEBUG_MODE,
    blueprint_compat = true,
    calculate = function(_, card, context)
        if context.pre_discard and not context.blueprint then
            local dupes = {}
            for i, v in ipairs(G.hand.highlighted) do
                if not dupes[v.base.id] then dupes[v.base.id] = 0 end 
                dupes[v.base.id] = dupes[v.base.id] + 1
            end
            
            local chips_gain = 0
            for i, v in pairs(dupes) do
                if v >= 3 then chips_gain = chips_gain + card.ability.extra.chips_gain * v end
            end
            if chips_gain > 0 then
                card.ability.extra.chips = card.ability.extra.chips + chips_gain
                return { message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } } }
            end
        end

        if context.joker_main and card.ability.extra.chips > 0 then
            return { 
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
            }
        end
    end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Ejected
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Joker {
    key = AST.JOKER.EJECTED.NAME,
    atlas = AST.JOKER.ATLAS,
    pos = { x = AST.JOKER.EJECTED.ATLAS_COL, y = AST.JOKER.EJECTED.ATLAS_ROW },
    config = { extra = {  } },
    loc_vars = function(_, _, card) return { vars = {  } } end,
    rarity = AST.JOKER.EJECTED.RARITY,
    cost = AST.JOKER.EJECTED.COST,
    unlocked = true,
    discovered = AST.DEBUG_MODE,
    blueprint_compat = true,
    calculate = function(_, card, context)
        if context.discard then 
            if G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 and context.full_hand[1].base.id == 14 then
                local text = G.GAME.current_round.ejected_most_played_poker_hand
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
                level_up_hand(context.blueprint_card or card, text, nil, 1)
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})

                return {
                    delay = 0.45, 
                    remove = true,
                    card = context.full_hand[1]
                }
            end
        end
    end
}

-- Hooking to Game.init_game_object to register extra data for Ejected
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)

	ret.current_round.ejected_most_played_poker_hand = "High Card"

	return ret
end

-- Hooking into evaluate_play to check for most played poker hand being updated
local evaluate_play_old = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
    local text = G.FUNCS.get_poker_hand_info(G.play.cards)
    evaluate_play_old(e)
    
    if G.GAME.hands[text].played >= G.GAME.hands[G.GAME.current_round.ejected_most_played_poker_hand].played then
        G.GAME.current_round.ejected_most_played_poker_hand = text
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- joker.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
