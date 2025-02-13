------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- blind.lua 
-- Registering of modded boss blinds, as well as relevant hooks for implementing them
--
-- Hamester, 2025
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
-- # Registering Atlas #
------------------------------------------------------------------------------------------------------------------------------------------------------
SMODS.Atlas {
	key = AST.BLIND.ATLAS,
	path = AST.BLIND.ATLAS .. ".png",
	atlas_table = AST.BLIND.ATLAS_TABLE,
	frames = AST.BLIND.ATLAS_FRAMES,
	px = AST.BLIND.ATLAS_WIDTH,
	py = AST.BLIND.ATLAS_HEIGHT
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- # Registering modded boss blinds #
------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Hooks
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Hooking to Game.init_game_object to register extra data for the boss blinds
local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo()

	ret.current_round.the_clock = {
		remaining_time = 0,
		paused = true,
		timer_ui_text = nil,
		timer_text = '0:00',
		hand_is_being_played = false
	}

	ret.current_round.last_obtained_joker_unique_val = 0

	return ret
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Clock
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_CLOCK.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_CLOCK.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_CLOCK.COLOR,
	dollars = AST.BLIND.THE_CLOCK.REWARD,
	mult = AST.BLIND.THE_CLOCK.BASE_MULT,
	boss = { min = AST.BLIND.THE_CLOCK.BOSS_MIN, max = AST.BLIND.THE_CLOCK.BOSS_MAX },
	set_blind = function(_)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = false
	end,
	press_play = function(_)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = true
		G.GAME.current_round.the_clock.hand_is_being_played = true
	end,
	drawn_to_hand = function(_)
		G.GAME.current_round.the_clock.paused = false
		G.GAME.current_round.the_clock.hand_is_being_played = false
	end,
	disabled = function(_)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = true
	end,
	defeat = function(_)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = true
	end
}

-- Callback for updating timer text for DynaText UI object
G.FUNCS.ui_set_timer_text = function(e)
	local new_timer_text = "0:0"..math.max((math.floor(G.GAME.current_round.the_clock.remaining_time * 100) / 100), 0)
	if e and e.config and e.config.object and new_timer_text ~= G.GAME.current_round.the_clock.timer_textthen then
		G.GAME.current_round.the_clock.timer_text = new_timer_text
		e.config.object:update_text()
	end
end

-- Function for creating UIBox for displaying timer
local function create_timer_ui_box()
	return UIBox{
		definition = {  n= G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
			{ n = G.UIT.R, config = {align = 'cm', maxw = 1}, nodes= {
				{n = G.UIT.O, config={
					func = "ui_set_timer_text",
					object = DynaText({scale = 0.7, string = {{ref_table = G.GAME.current_round.the_clock, ref_value = "timer_text"}},
					maxw = 9, colours = {G.C.WHITE}, float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})
				}},
			}}
		}},
		config = {
			align = 'cm',
			offset ={x=0,y=-2.5},
			major = G.play
		}
	}
end

-- Functio for playing up to 5 random cards, including already selected cards
local function play_random_hand()
	G.E_MANAGER:add_event(Event({ func = function()
		local _cards = {}
		local _highlighted = 0
		for _, v in ipairs(G.hand.cards) do
			if not v.highlighted then
				_cards[#_cards+1] = v
			else 
				_highlighted = _highlighted + 1
			end
		end

		for _=1,math.min(#_cards, 5 - _highlighted) do
			local card, card_key = pseudorandom_element(_cards, pseudoseed(AST.BLIND.THE_CLOCK.KEY))
			table.remove(_cards, card_key)
			G.hand:add_to_highlighted(card, true)
		end

		G.FUNCS.play_cards_from_highlighted(nil)
		return true
	end}))
end

-- Hooking to Game:update to define additional logic for The Clock Boss Blind
local g_update_func = Game.update
function Game:update(dt)
	g_update_func(self, dt)

	if G.GAME.blind and G.GAME.blind.name == AST.BLIND.THE_CLOCK.KEY and not G.GAME.blind.disabled then
		-- Turns out the whole game object is being saved when you quit out of the game (asterisk). some objects, for some reason, during reading
		-- from the file, are being replaced by the string "\"MANUAL_REPLACE\"", this is such a weird way to go around the bug (?)..
		if not G.GAME.current_round.the_clock.timer_ui_text or G.GAME.current_round.the_clock.timer_ui_text == [["]].."MANUAL_REPLACE"..[["]] then
			G.GAME.current_round.the_clock.timer_ui_text = create_timer_ui_box()
		end

		if not G.GAME.current_round.the_clock.paused and G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.paused then
			G.GAME.current_round.the_clock.remaining_time = G.GAME.current_round.the_clock.remaining_time - dt
		end

		if G.GAME.current_round.the_clock.remaining_time <= 0 then
			if not G.GAME.current_round.the_clock.hand_is_being_played then
				G.GAME.current_round.the_clock.hand_is_being_played = true
				play_random_hand()
			end
		end
	else
		if G.GAME.current_round.the_clock.timer_ui_text then
			G.GAME.current_round.the_clock.timer_ui_text:remove()
			G.GAME.current_round.the_clock.timer_ui_text = nil
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Razor
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_RAZOR.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_RAZOR.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_RAZOR.COLOR,
	dollars = AST.BLIND.THE_RAZOR.REWARD,
	mult = AST.BLIND.THE_RAZOR.BASE_MULT,
	boss = { min = AST.BLIND.THE_RAZOR.BOSS_MIN, max = AST.BLIND.THE_RAZOR.BOSS_MAX },

	-- Extra function, added via a lovely patch, which runs for each scored card
	card_scored = function(_, card)
		local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
		local rank_suffix = card.base.id == 2 and 14 or math.max(card.base.id - 1, 2)

		if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
		elseif rank_suffix == 10 then rank_suffix = 'T'
		elseif rank_suffix == 11 then rank_suffix = 'J'
		elseif rank_suffix == 12 then rank_suffix = 'Q'
		elseif rank_suffix == 13 then rank_suffix = 'K'
		elseif rank_suffix == 14 then rank_suffix = 'A'
		end

		-- Setting the nominal before we set the base in the event, ebcasue scoring happens faster than the event triggers
		if rank_suffix == 'A' then card.base.nominal = 11
		elseif rank_suffix == 'K' or rank_suffix == 'Q' or rank_suffix == 'J' or rank_suffix == 'T' then card.base.nominal = 10
		else card.base.nominal = card.base.nominal - 1 end
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
			card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
			card:juice_up(0.3, 0.5)
			return true
		end
		}))
		
		return true
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Insecurity
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_INSECURITY.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_INSECURITY.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_INSECURITY.COLOR,
	dollars = AST.BLIND.THE_INSECURITY.REWARD,
	mult = AST.BLIND.THE_INSECURITY.BASE_MULT,
	boss = { min = AST.BLIND.THE_INSECURITY.BOSS_MIN, max = AST.BLIND.THE_INSECURITY.BOSS_MAX },
	recalc_debuff = function(_, _, _)
		if G.GAME.current_round.last_obtained_joker_unique_val ~= 0 then
			local joker = AST.find_joker_by_unique_val(G.GAME.current_round.last_obtained_joker_unique_val)
			if joker then
				joker:set_debuff(true)
				joker:juice_up()
			end
		end
	end,
	disabled = function(_)
		if G.GAME.current_round.last_obtained_joker_unique_val ~= 0 then
			local joker = AST.find_joker_by_unique_val(G.GAME.current_round.last_obtained_joker_unique_val)
			if joker then
				joker:set_debuff(false)
				joker:juice_up()
			end
		end
	end,
	defeat = function(_)
		if G.GAME.current_round.last_obtained_joker_unique_val ~= 0 then
			local joker = AST.find_joker_by_unique_val(G.GAME.current_round.last_obtained_joker_unique_val)
			if joker then
				joker:set_debuff(false)
				joker:juice_up()
			end
		end
	end
}

-- Hooking into Card.add_to_deck to get the unique id of most recently obtained joker for The Insecurity boss blind
local add_to_deck_old = Card.add_to_deck
function Card:add_to_deck(from_debuff)
	local ret = add_to_deck_old(self, from_debuff)

	if not from_debuff and self.ability.set == 'Joker' then
		G.GAME.current_round.last_obtained_joker_unique_val = self.unique_val
	end

	return ret
end

-- Hooking into Card.remove_from_deck to set last_obtained_joker_unique_val back to 0 when it's removed from the deck
local remove_from_deck_old = Card.remove_from_deck
function Card:remove_from_deck(from_debuff)
	local ret = remove_from_deck_old(self, from_debuff)

	if not from_debuff and G.GAME.current_round.last_obtained_joker_unique_val == self.unique_val and self.ability.set == 'Joker' then
		G.GAME.current_round.last_obtained_joker_unique_val = 0
	end

	return ret
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Gambit
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_GAMBIT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_GAMBIT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_GAMBIT.COLOR,
	dollars = AST.BLIND.THE_GAMBIT.REWARD,
	mult = AST.BLIND.THE_GAMBIT.BASE_MULT,
	boss = { min = AST.BLIND.THE_GAMBIT.BOSS_MIN, max = AST.BLIND.THE_GAMBIT.BOSS_MAX },

	-- Extra function, added via a lovely patch, which runs for each scored card
	card_scored = function(self, card)
		if card:is_face() then
			G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, delay = 0.1, func = function()
				card:juice_up(0.3, 0.5)
				ease_dollars(-G.GAME.dollars, true)
				return true
				end
			}))
			return false
		end
		return true
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Pit
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_PIT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_PIT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_PIT.COLOR,
	dollars = AST.BLIND.THE_PIT.REWARD,
	mult = AST.BLIND.THE_PIT.BASE_MULT,
	boss = { min = AST.BLIND.THE_PIT.BOSS_MIN, max = AST.BLIND.THE_PIT.BOSS_MAX },

	-- Extra function, added via a lovely patch, which runs for each scored card
	card_scored = function(_, card)
		if card:get_id() == 2 or card:get_id() == 3 or card:get_id() == 4 or card:get_id() == 5 then
			G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, delay = 0.1, func = function()
				card:juice_up(0.3, 0.5)
				ease_dollars(-G.GAME.dollars, true)
				return true
				end
			}))
			return false
		end
		return true
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Construct
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_CONSTRUCT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_CONSTRUCT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_CONSTRUCT.COLOR,
	dollars = AST.BLIND.THE_CONSTRUCT.REWARD,
	mult = AST.BLIND.THE_CONSTRUCT.BASE_MULT,
	boss = { min = AST.BLIND.THE_CONSTRUCT.BOSS_MIN, max = AST.BLIND.THE_CONSTRUCT.BOSS_MAX },
	recalc_debuff = function(_, card, _)
		return card.area ~= G.jokers and AST.is_prime(card.base.nominal)
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Film
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_FILM.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_FILM.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_FILM.COLOR,
	dollars = AST.BLIND.THE_FILM.REWARD,
	mult = AST.BLIND.THE_FILM.BASE_MULT,
	boss = { min = AST.BLIND.THE_FILM.BOSS_MIN, max = AST.BLIND.THE_FILM.BOSS_MAX },
	recalc_debuff = function(_, card, _)
		local should_debuff = card.edition and card.edition.negative

		if card.area == G.jokers and should_debuff then
			card:juice_up()
			return true
		end

		return should_debuff
	end,
	in_pool = function(_)
		if not G.jokers or not G.deck then return false end

		for _,v in ipairs(G.jokers.cards) do
			if v.edition and v.edition.negative then return true end
		end

		for _,v in ipairs(G.deck.cards) do
			if v.edition and v.edition.negative then return true end
		end

		return false
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Phaesant
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_PHEASANT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_PHEASANT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_PHEASANT.COLOR,
	dollars = AST.BLIND.THE_PHEASANT.REWARD,
	mult = AST.BLIND.THE_PHEASANT.BASE_MULT,
	boss = { min = AST.BLIND.THE_PHEASANT.BOSS_MIN, max = AST.BLIND.THE_PHEASANT.BOSS_MAX },
	recalc_debuff = function(_, card, _)
		local should_debuff = card.edition and card.edition.polychrome

		if card.area == G.jokers and should_debuff then
			card:juice_up()
			return true
		end

		return should_debuff
	end,
	in_pool = function(_)
		if not G.jokers or not G.deck then return false end

		for _,v in ipairs(G.jokers.cards) do
			if v.edition and v.edition.polychrome then return true end
		end

		for _,v in ipairs(G.deck.cards) do
			if v.edition and v.edition.polychrome then return true end
		end
		return false
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Alloy
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_ALLOY.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_ALLOY.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_ALLOY.COLOR,
	dollars = AST.BLIND.THE_ALLOY.REWARD,
	mult = AST.BLIND.THE_ALLOY.BASE_MULT,
	boss = { min = AST.BLIND.THE_ALLOY.BOSS_MIN, max = AST.BLIND.THE_ALLOY.BOSS_MAX },
	recalc_debuff = function(_, card, _)
		local should_debuff = card.edition and card.edition.holo

		if card.area == G.jokers and should_debuff then
			card:juice_up()
			return true
		end

		return should_debuff
	end,
	in_pool = function(_)
		if not G.jokers or not G.deck then return false end

		for _,v in ipairs(G.jokers.cards) do
			if v.edition and v.edition.holo then return true end
		end

		for _,v in ipairs(G.deck.cards) do
			if v.edition and v.edition.holo then return true end
		end

		return false
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- The Aluminum
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registering
SMODS.Blind {
	key = AST.BLIND.THE_ALUMINUM.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_ALUMINUM.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_ALUMINUM.COLOR,
	dollars = AST.BLIND.THE_ALUMINUM.REWARD,
	mult = AST.BLIND.THE_ALUMINUM.BASE_MULT,
	boss = { min = AST.BLIND.THE_ALUMINUM.BOSS_MIN, max = AST.BLIND.THE_ALUMINUM.BOSS_MAX },
	recalc_debuff = function(_, card, _)
		local should_debuff = card.edition and card.edition.foil

		if card.area == G.jokers and should_debuff then
			card:juice_up()
			return true
		end

		return should_debuff
	end,
	in_pool = function(_)
		if not G.jokers or not G.deck then return false end

		for _,v in ipairs(G.jokers.cards) do
			if v.edition and v.edition.foil then return true end
		end

		for _,v in ipairs(G.deck.cards) do
			if v.edition and v.edition.foil then return true end
		end

		return false
	end
}

------------------------------------------------------------------------------------------------------------------------------------------------------
-- blind.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
