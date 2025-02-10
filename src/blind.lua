-- Azzy's Silly Trinkets (AST)
-- blind.lua 

-- Registering Blinds Atlas
SMODS.Atlas {
	key = AST.BLIND.ATLAS,
	path = AST.BLIND.ATLAS .. ".png",
	atlas_table = AST.BLIND.ATLAS_TABLE,
	frames = AST.BLIND.ATLAS_FRAMES,
	px = AST.BLIND.ATLAS_WIDTH,
	py = AST.BLIND.ATLAS_HEIGHT
}

-- Registering The Clock
SMODS.Blind {
	key = AST.BLIND.THE_CLOCK.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_CLOCK.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_CLOCK.COLOR,
	dollars = AST.BLIND.THE_CLOCK.REWARD,
	mult = AST.BLIND.THE_CLOCK.BASE_MULT,
	boss = { min = AST.BLIND.THE_CLOCK.BOSS_MIN, max = AST.BLIND.THE_CLOCK.BOSS_MAX },
	set_blind = function(self)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = false
	end,
	press_play = function(self)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = true
		G.GAME.current_round.the_clock.hand_is_being_played = true
	end,
	drawn_to_hand = function(self)
		G.GAME.current_round.the_clock.paused = false
        G.GAME.current_round.the_clock.hand_is_being_played = false
	end,
	disabled = function(self)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = true
	end,
	defeat = function(self)
		G.GAME.current_round.the_clock.remaining_time = AST.BLIND.THE_CLOCK.TIMER_SECONDS
		G.GAME.current_round.the_clock.paused = true
	end
}

-- Registering The Razor
SMODS.Blind {
	key = AST.BLIND.THE_RAZOR.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_RAZOR.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_RAZOR.COLOR,
	dollars = AST.BLIND.THE_RAZOR.REWARD,
	mult = AST.BLIND.THE_RAZOR.BASE_MULT,
	boss = { min = AST.BLIND.THE_RAZOR.BOSS_MIN, max = AST.BLIND.THE_RAZOR.BOSS_MAX },
	card_scored = function(self, card)
		local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
		local rank_suffix = card.base.id == 2 and 14 or math.min(card.base.id - 1, 14)
		if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
		elseif rank_suffix == 10 then rank_suffix = 'T'
		elseif rank_suffix == 11 then rank_suffix = 'J'
		elseif rank_suffix == 12 then rank_suffix = 'Q'
		elseif rank_suffix == 13 then rank_suffix = 'K'
		elseif rank_suffix == 14 then rank_suffix = 'A'
		end
		G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, delay = 0.0, func = function()
			card:juice_up(0.3, 0.5)
			return true
		  end
		}))
		card:set_base(G.P_CARDS[suit_prefix..rank_suffix])

		return true
	end
}

-- Registering The Insecurity
SMODS.Blind {
	key = AST.BLIND.THE_INSECURITY.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_INSECURITY.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_INSECURITY.COLOR,
	dollars = AST.BLIND.THE_INSECURITY.REWARD,
	mult = AST.BLIND.THE_INSECURITY.BASE_MULT,
	boss = { min = AST.BLIND.THE_INSECURITY.BOSS_MIN, max = AST.BLIND.THE_INSECURITY.BOSS_MAX },
	recalc_debuff = function(self, card, from_blin) 
		if G.GAME.current_round.last_purchased_joker then
			G.GAME.current_round.last_purchased_joker:set_debuff(true)
			G.GAME.current_round.last_purchased_joker:juice_up()
		end
	end,
	disabled = function(self) 
		if G.GAME.current_round.last_purchased_joker then
			G.GAME.current_round.last_purchased_joker:set_debuff(false)
			G.GAME.current_round.last_purchased_joker:juice_up()
		end
	end,
	defeat = function(self) 
		if G.GAME.current_round.last_purchased_joker then
			G.GAME.current_round.last_purchased_joker:set_debuff(false)
			G.GAME.current_round.last_purchased_joker:juice_up()
		end
	end
}

-- Registering The Gambit
SMODS.Blind {
	key = AST.BLIND.THE_GAMBIT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_GAMBIT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_GAMBIT.COLOR,
	dollars = AST.BLIND.THE_GAMBIT.REWARD,
	mult = AST.BLIND.THE_GAMBIT.BASE_MULT,
	boss = { min = AST.BLIND.THE_GAMBIT.BOSS_MIN, max = AST.BLIND.THE_GAMBIT.BOSS_MAX },
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

-- Registering The Pit
SMODS.Blind {
	key = AST.BLIND.THE_PIT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_PIT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_PIT.COLOR,
	dollars = AST.BLIND.THE_PIT.REWARD,
	mult = AST.BLIND.THE_PIT.BASE_MULT,
	boss = { min = AST.BLIND.THE_PIT.BOSS_MIN, max = AST.BLIND.THE_PIT.BOSS_MAX },
	card_scored = function(self, card)
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

-- Registering The Construct
SMODS.Blind {
	key = AST.BLIND.THE_CONSTRUCT.NAME,
	atlas = AST.BLIND.ATLAS,
	pos = { x = 0, y = AST.BLIND.THE_CONSTRUCT.ATLAS_ROW },
	boss_colour = AST.BLIND.THE_CONSTRUCT.COLOR,
	dollars = AST.BLIND.THE_CONSTRUCT.REWARD,
	mult = AST.BLIND.THE_CONSTRUCT.BASE_MULT,
	boss = { min = AST.BLIND.THE_CONSTRUCT.BOSS_MIN, max = AST.BLIND.THE_CONSTRUCT.BOSS_MAX },
	recalc_debuff = function(self, card, from_blind) 
		return AST.is_prime(card.base.nominal)
	end
}

-- Hooking to Game.init_game_object to register The Clock related variables
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
	ret.current_round.last_purchased_joker = nil
	return ret
end

local buy_from_shop_old = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
	local ret = buy_from_shop_old(e)

	local c1 = e.config.ref_table
	if c1:is(Card) and c1.ability.set == 'Joker' then
		G.GAME.current_round.last_purchased_joker = c1
	end

	return ret
end

local sell_card_old = Card.sell_card
function Card:sell_card()
	local ret = sell_card_old(self)

	if G.GAME.current_round.last_purchased_joker == self then
		G.GAME.current_round.last_purchased_joker = nil
	end

	return ret
end


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
		definition = {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
			{n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
				{n=G.UIT.O, config={
                    func = "ui_set_timer_text", 
                    object = DynaText({scale = 0.7, string = {{ref_table = G.GAME.current_round.the_clock, ref_value = "timer_text"}}, 
                    maxw = 9, colours = {G.C.WHITE}, float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})
                }},
			}}
		}}, 
		config = {
			align = 'cm',
			offset ={x=0,y=-3.1},
			major = G.play
		}
	}
end

-- Functio for playing up to 5 random cards, including already selected cards
local function play_random_hand()
    G.E_MANAGER:add_event(Event({ func = function()
        local _cards = {}
        for _, v in ipairs(G.hand.cards) do
            if not v.highlighted then
                _cards[#_cards+1] = v
            end
        end

        local _highlighted = {}
        for _, v in ipairs(G.hand.highlighted) do
            _highlighted[#_highlighted+1] = v
        end

        G.hand:unhighlight_all()
        for _, v in ipairs(_highlighted) do
            G.hand:add_to_highlighted(v, true)
        end
        for _=1,math.min(#_cards, 5 - #_highlighted) do
            local card, card_key = pseudorandom_element(_cards, pseudoseed("the_clock"))
            table.remove(_cards, card_key)
            G.hand:add_to_highlighted(card, true)
        end

        G.FUNCS.play_cards_from_highlighted(nil)
        return true
    end}))
end

-- Hooking to Game:update to difine additional logic for The Clock Boss Blind
local g_update_func = Game.update
function Game:update(dt)
	g_update_func(self, dt)

	if G.GAME.blind and G.GAME.blind.name == "bl_ast_the_clock" and not G.GAME.blind.disabled then
		if not G.GAME.current_round.the_clock.timer_ui_text then
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
