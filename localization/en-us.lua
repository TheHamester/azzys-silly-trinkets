return {
	descriptions = {
		Joker = {
			j_ast_reverse_polarity = {
				name = "Reverse Polarity",
				text = {
					"Swaps {C:mult}Mult{} and {C:chips}Chips{}",
					"Swapping costs {C:attention}1{} energy",
					"Gain {C:chips}#2#{} energy when a Tarot card is sold",
					"Self destructs when energy reaches {C:chips}0{}",
					"{C:inactive}Currently:{} {C:chips}#1#{} {C:inactive}energy {}"
				}
			},
			j_ast_cardio = {
				name = "Cardio",
				text = {
					"Discard up to {C:mult}#1#{} more card"
				}
			},
			j_ast_paul = {
				name = "Paul",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{C:attention}Has{} to be fed a {C:attention}joker{} to",
					"the {C:attention}right{} at the end of round"
				}
			},
			j_ast_officinaphobia = {
				name = "Officinaphobia",
				text = {
					"Gains {C:mult}+#2#{} Mult after shop",
					"if nothing was purchased",
					"{C:inactive}Currently:{} {C:mult}+#1#{} {C:inactive}Mult {}"
				}
			},
			j_ast_match_3 = {
				name = "Match 3",
				text = {
					"Gains {C:chips}+#2#{} Chips per card if 3 or",
					"more cards of the {C:attention}same rank{}",
					"are discarded at the same time",
					"{C:inactive}Currently:{} {C:chips}+#1#{} {C:inactive}Chips {}"
				}
			},
			j_ast_ejected = {
				name = "Ejected",
				text = {
                    "If {C:attention}first discard{} of round",
                    "has only a single {C:attention}Ace{}, destroy",
					"it and upgrade your {C:attention}most played hand{}"
				}
			}
		},
		Blind = {
			bl_ast_the_clock = {
				name = "The Clock",
				text = {
					 "{C:attention}8{} seconds per hand",
				 }
			},
			bl_ast_the_razor = {
				name = "The Razor",
				text = {
					 "Reduces rank of",
					 "each card scored"
				 }
			},
			bl_ast_the_insecurity = {
				name = "The Insecurity",
				text = {
					 "Disables most recently",
					 "obtained Joker"
				 }
			},
			bl_ast_the_gambit = {
				name = "The Gambit",
				text = {
					 "Scoring a face card",
					 "sets money to {C:money}$0{}"
				 }
			},
			bl_ast_the_pit = {
				name = "The Pit",
				text = {
					 "Scoring a {c:attention}2{}, {c:attention}3{}, {c:attention}4{} or a {c:attention}5{}",
					 "sets money to {C:money}0{}"
				 }
			},
			bl_ast_the_construct = {
				name = "The Construct",
				text = {
					 "All prime valued cards",
					 "are debuffed"
				 }
			},
			bl_ast_the_film = {
				name = "The Film",
				text = {
					 "All negative jokers and cards",
					 "are debuffed"
				 }
			},
			bl_ast_the_pheasant = {
				name = "The Pheasant",
				text = {
					 "All polychrome jokers and cards",
					 "are debuffed"
				 }
			},
			bl_ast_the_alloy = {
				name = "The Alloy",
				text = {
					 "All holographic jokers and cards",
					 "are debuffed"
				 }
			},
			bl_ast_the_aluminum = {
				name = "The Aluminum",
				text = {
					 "All foil jokers and cards",
					 "are debuffed"
				 }
			},
			bl_ast_the_shredder = {
				name = "The Shredder",
				text = {
					 "All consumables",
					 "are destroyed"
				 }
			}
		}
	},
	misc = {
		v_dictionary={
			b_ast_add_energy = "#1# Energy"
		},
		dictionary={
			b_ast_reversed = "Reversed",
			b_ast_exploded = "Exploded",
			b_ast_yummy = "Yummy!",
			b_ast_starved = "PAUL HAS STARVED"
		}
	}
}