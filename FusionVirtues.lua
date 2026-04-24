SMODS.Atlas({
    key = 'fuseforce_orta_jokers',
    path = 'JokersOrta.png',
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "orta_diamonddemon",
    name = "Diamond Demon",
    rarity = "fuse_fusion",
    cost = 16,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chance", "chips", "diamonds", "suit", "economy"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 0, y = 0},
    artist_credits = {'itayfeder'},
    config = {
		extra = {
            suit = "Diamonds",
            dollars = 2,
            odds = 2,
			joker1 = "j_ortalab_generous",
			joker2 = "j_ortalab_fools_gold"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            localize(card.ability.extra.suit, "suits_singular" ),
			localize(card.ability.extra.suit, "suits_plural" ),
            G.GAME.probabilities.normal or 1,
            card.ability.extra.odds,
            card.ability.extra.dollars,
            1 * math.max(0, (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0)),
            colours = {G.C.SUITS[card.ability.extra.suit],},
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if not context.end_of_round or context.forcetrigger then
            if context.cardarea == G.hand and context.individual and context.other_card:is_suit(card.ability.extra.suit) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
        if (context.cardarea == G.play and context.individual and context.other_card:is_suit(card.ability.extra.suit)) or context.forcetrigger then
            if SMODS.pseudorandom_probability(card, 'diamond_demon', G.GAME.probabilities.normal or 1, card.ability.extra.odds) then
                return {
                    chips = 1 * math.max(0, (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0))
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_generous" },
        { name = "j_ortalab_fools_gold"}
    }, cost = 8, result_joker = "j_fuseforce_orta_diamonddemon"
}

SMODS.Joker {
    key = "orta_heartmimic",
    name = "Heart Mimic",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
    demicoloncompat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chance", "xmult", "hearts", "suit"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 1, y = 0},
    artist_credits = {'Minus'},
    config = {
		extra = {
            suit = "Hearts",
            xmult = 2,
            odds = 2,
			joker1 = "j_ortalab_chastful",
			joker2 = "j_ortalab_amber_mosquito"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            localize(card.ability.extra.suit, "suits_singular" ),
            G.GAME.probabilities.normal or 1,
            card.ability.extra.odds,
            card.ability.extra.xmult,
			localize(card.ability.extra.suit, "suits_plural" ),
            colours = {G.C.SUITS[card.ability.extra.suit],},
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if (context.cardarea == G.play and context.individual and context.other_card:is_suit(card.ability.extra.suit)) or context.forcetrigger then
            --ORTAFUSE.say("Heart played")
            for i=1,#G.hand.cards do
                if G.hand.cards[i]:is_suit(card.ability.extra.suit) and SMODS.pseudorandom_probability(card, 'heart_mimic', G.GAME.probabilities.normal or 1, card.ability.extra.odds) then
                    SMODS.calculate_effect(
                        {
                            xmult = card.ability.extra.xmult,
                            message_card = card,
                            juice_card = G.hand.cards[i]
                        },
                        card
                    )
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_chastful" },
        { name = "j_ortalab_amber_mosquito"}
    }, cost = 10, result_joker = "j_fuseforce_orta_heartmimic"
}

SMODS.Joker {
    key = "orta_spadeslime",
    name = "Spade Slime",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"modify_card", "chips", "perma_bonus", "spades", "suit"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 2, y = 0},
    artist_credits = {'Minus'},
    config = {
		extra = {
            suit = "Spades",
            chips = 25,
            chips_mod = 4,
			joker1 = "j_ortalab_patient",
			joker2 = "j_ortalab_dripstone"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            localize(card.ability.extra.suit, "suits_singular" ),
			localize(card.ability.extra.suit, "suits_plural" ),
            card.ability.extra.chips,
            card.ability.extra.chips_mod,
            colours = {G.C.SUITS[card.ability.extra.suit],},
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if (context.cardarea == G.play and context.individual and context.other_card:is_suit(card.ability.extra.suit)) or context.forcetrigger then
            local slime = 0
            for i = 1, #G.hand.cards do
                if G.hand.cards[i]:is_suit(card.ability.extra.suit) then
                    slime = slime + 1
                end
            end
            --if context.cardarea == G.play and context.individual and context.other_card:is_suit(card.ability.extra.suit) and slime >= 1 then
            if slime >= 1 then
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) + card.ability.extra.chips_mod * slime
                return {
                    chips = card.ability.extra.chips,
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            else
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_patient" },
        { name = "j_ortalab_dripstone"}
    }, cost = 10, result_joker = "j_fuseforce_orta_spadeslime"
}

SMODS.Joker {
    key = "orta_clubzombie",
    name = "Club Zombie",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "chips", "clubs", "suit"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 3, y = 0},
    artist_credits = {'itayfeder'},
    config = {
		extra = {
            suit = "Clubs",
            chips = 64,
            mult = 16,
			joker1 = "j_ortalab_abstemious",
			joker2 = "j_ortalab_basalt_column"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            localize(card.ability.extra.suit, "suits_singular" ),
			localize(card.ability.extra.suit, "suits_plural" ),
            card.ability.extra.chips,
            card.ability.extra.mult,
            colours = {G.C.SUITS[card.ability.extra.suit],},
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if (context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_suit(card.ability.extra.suit)) or context.forcetrigger then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_abstemious" },
        { name = "j_ortalab_basalt_column"}
    }, cost = 10, result_joker = "j_fuseforce_orta_clubzombie"
}

SMODS.Joker {
    key = "orta_blinded_by_science",
    name = "Blinded By Science",
    rarity = "fuse_fusion",
    cost = 22,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"mult", "chips", "scaling", "hand_type", "space"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 4, y = 0},
    artist_credits = {'gappie'},
    config = {
		extra = {
            chips = 150,
            change = 2,
            mult = 0,
            xmult = 1,
            xmult_mod = 0.3,
            poker_hand = '',
            joker1 = "j_ortalab_protostar", 
            joker2 = "j_ortalab_stargazing"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.change,
            card.ability.extra.mult,
            card.ability.extra.xmult,
            card.ability.extra.xmult_mod,
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            card.ability.extra.poker_hand = context.scoring_name
            if not context.blueprint and G.zodiacs and zodiac_current then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.xmult
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.xmult
                }
            end
        end
        if context.after and card.ability.extra.chips > 0 and not context.blueprint then
            local change = G.GAME.hands[card.ability.extra.poker_hand].played * card.ability.extra.change
            if change >= card.ability.extra.chips then
                card.ability.extra.chips = 0
                card.ability.extra.mult = 75
                card_eval_status_text(card,'extra', nil, nil, nil, {message = localize('ortalab_protostar')})
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "change",
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = initial - change * G.GAME.hands[card.ability.extra.poker_hand].played
                    end,
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_chips_minus', vars = {card.ability.extra.change * G.GAME.hands[card.ability.extra.poker_hand].played}},
                        colour = G.C.BLUE,
                        no_juice = true
                    }
                })
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "change",
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = initial + G.GAME.hands[card.ability.extra.poker_hand].played
                    end,
                    scaling_message = {
                        message = localize{type = 'variable', key = 'a_mult', vars = {G.GAME.hands[card.ability.extra.poker_hand].played}},
                        colour = G.C.RED,
                        no_juice = true
                    }
                })
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_protostar" },
        { name = "j_ortalab_stargazing", carry_stat = "xmult" }
    }, cost = 12, result_joker = "j_fuseforce_orta_blinded_by_science"
}

SMODS.Joker {
    key = "orta_dangerous_duo",
    name = "Dangerous Duo",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "xchips", "suit", "hearts", "diamonds", "spades", "clubs"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 0, y = 1},
    artist_credits = {'itayfeder'},
    config = {
		extra = {
            xchips = 3,
            xmult = 3,
            joker1 = "j_ortalab_pitch_mitch", 
            joker2 = "j_ortalab_red_fred"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.xchips,
            card.ability.extra.xmult,
            localize('Hearts', 'suits_plural'),
            localize('Diamonds', 'suits_plural'),
            localize('Clubs', 'suits_plural'),
            localize('Spades', 'suits_plural'),
            colours = {G.C.SUITS.Hearts, G.C.SUITS.Diamonds, G.C.SUITS.Clubs, G.C.SUITS.Spades},
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.joker_main and #context.scoring_hand > 1 then
			local suits = {}
			for _, _card in pairs(context.scoring_hand) do
				suits[not SMODS.has_no_suit(_card) and _card.base.suit] = true
				if SMODS.has_any_suit(_card) then
					suits['Hearts'] = true
					suits['Diamonds'] = true
					suits['Spades'] = true
					suits['Clubs'] = true
				end
			end
			if (suits['Hearts'] and suits['Diamonds'] and suits['Spades'] and suits['Clubs']) or Ortalab.suit_smear(card) then
				return {
					xchips = card.ability.extra.xchips,
					Xmult = card.ability.extra.xmult
				}
			elseif (suits['Spades'] and suits['Clubs']) and not (suits['Hearts'] and suits['Diamonds']) then
				return {
					xchips = card.ability.extra.xchips
				}
			elseif (suits['Hearts'] and suits['Diamonds']) and not (suits['Spades'] and suits['Clubs']) then
				return {
					Xmult = card.ability.extra.xmult
				}
			end
		end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_pitch_mitch" },
        { name = "j_ortalab_red_fred"}
    }, cost = 10, result_joker = "j_fuseforce_orta_dangerous_duo"
}

SMODS.Joker {
    key = "orta_insider_trader",
    name = "Insider Trader Joker",
    rarity = "fuse_fusion",
    cost = 17,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"reroll", "passive", "economy"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 1, y = 1},
    artist_credits = {'alex'},
    config = {
		extra = {
            dollars = 1,
            gain = 1,
            last_reroll = 0,
            joker1 = "j_ortalab_business", 
            joker2 = "j_ortalab_dnd"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.dollars + 1,
            card.ability.extra.gain,
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    add_to_deck = function (self, card, from_debuff)
        if not from_debuff then
            card.ability.extra.last_reroll = G.GAME.round_scores.times_rerolled.amt
        end
    end,
    calculate = function(self,card,context)
        if context.reroll_shop then
			return {
				dollars = card.ability.extra.dollars + 1
			}
		end
	    if context.ending_shop and not context.blueprint then
            if G.GAME.round_scores.times_rerolled.amt == card.ability.extra.last_reroll then
                card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.gain
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.GOLD
                }
            else
                card.ability.extra.last_reroll = G.GAME.round_scores.times_rerolled.amt
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_business" },
        { name = "j_ortalab_dnd", carry_stat = "dollars" }
    }, cost = 6, result_joker = "j_fuseforce_orta_insider_trader"
}

SMODS.Joker {
    key = "orta_physicist",
    name = "Physicist",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"hand_size", "discard"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 2, y = 1},
    artist_credits = {'Minus'},
    config = {
		extra = {
            hand_size = 4,
            discards = 0,
            joker1 = "j_ortalab_cardist", 
            joker2 = "j_ortalab_klutz"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local active = 0
	return {
		vars = {
            card.ability.extra.hand_size,
            card.ability.extra.discards,
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    remove_from_deck = function(self, card, from_debuff)
        if active >= 1 then
        G.hand:change_size(-1*card.ability.extra.hand_size)
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
            active = 0
            G.hand:change_size(-1*card.ability.extra.hand_size)
            if card.ability.extra.hand_size >= 1 and G.GAME.current_round.discards_used >= 1 then
                card.ability.extra.discards = card.ability.extra.discards + 1
                card.ability.extra.hand_size = card.ability.extra.hand_size -1
                G.E_MANAGER:add_event(Event({
                    func = function()
                    card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, {
                        message = 'Gravity',
                        colour = G.C.MULT,
                        message_card = card
                        })
                    return true
                    end,
			}))
            end
        end
        if (context.setting_blind and not card.getting_sliced) or context.forcetrigger then
            active = 1
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_discard(card.ability.extra.discards)
                    G.hand:change_size(card.ability.extra.hand_size)
					return true
				end,
			}))
		end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_cardist" },
        { name = "j_ortalab_klutz"}
    }, cost = 10, result_joker = "j_fuseforce_orta_physicist"
}

SMODS.Joker {
    key = "orta_art_heist",
    name = "Art Heist",
    rarity = "fuse_fusion",
    cost = 22,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chips", "tarot", "spectral", "planet", "joker", "scaling"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 4, y = 1},
    artist_credits = {'Minus'},
    config = {
		extra = {
            chips = 25,
            slots = 0,
            slots_add = 1,
            target = 9,
            joker1 = "j_ortalab_art_gallery",
            joker2 = "j_ortalab_forklift"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local total_cards = (G.jokers and #G.jokers.cards or 0) + (G.consumeables and #G.consumeables.cards or 0)
	return {
		vars = {
            card.ability.extra.chips,
            total_cards*card.ability.extra.chips,
            card.ability.extra.slots,
            card.ability.extra.slots_add,
            card.ability.extra.target,
            (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all or 0) - (card.ability.extra.target * card.ability.extra.slots),
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local total_cards = #G.jokers.cards + #G.consumeables.cards
            return {
                chips = total_cards*card.ability.extra.chips, 
                colour = G.C.CHIPS
            }
        end
        if context.using_consumeable and math.max(0,math.floor(G.GAME.consumeable_usage_total.all/card.ability.extra.target)) > card.ability.extra.slots then
            card.ability.extra.slots = card.ability.extra.slots + card.ability.extra.slots_add
            G.consumeables:change_size(card.ability.extra.slots_add)
            card:juice_up()
            card.ability.extra.triggered = true
            return {
                message = '+1 slot'
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.slots > 0 then
            G.consumeables:change_size(-1 * card.ability.extra.slots)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'lost slots'})
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if math.max(0,math.floor((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.all or 0)/card.ability.extra.target)) > 0 and not card.ability.extra.triggered then
            card.ability.extra.slots = 1 * math.max(0,math.floor(G.GAME.consumeable_usage_total.all/card.ability.extra.target))
            G.consumeables:change_size(card.ability.extra.slots)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'more slots'})
            card.ability.extra.triggered = true
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_art_gallery" },
        { name = "j_ortalab_forklift"}
    }, cost = 11, result_joker = "j_fuseforce_orta_art_heist"
}

SMODS.Joker {
    key = "orta_perfidy",
    name = "Perfidy",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "chips", "scaling", "discard"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 1, y = 2},
    artist_credits = {'itayfeder'},
    config = {
		extra = {
            chips = 30,
            chip_up = 15,
            chip_down = 12,
            mult = 8,
            mult_up = 4,
            mult_down = 1,
            joker1 = "j_ortalab_white_flag",
            joker2 = "j_ortalab_purple"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chip_up,
            card.ability.extra.mult_up,
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.chip_down,
            card.ability.extra.mult_down,
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
        if context.pre_discard and card.ability.extra.mult > 0 and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_up
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_down
            return {
                message = localize({type = 'variable', key = 'a_chips', vars = {card.ability.extra.chip_up}}),
                colour = G.C.BLUE,
                extra = {
                    message = localize({type = 'variable', key = 'a_mult_minus', vars = {card.ability.extra.mult_down}}),
                    colour = G.C.RED
                }
            }
        end
        if context.after and card.ability.extra.chips > 11 and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_down
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_up
            return {
                message = localize({type = 'variable', key = 'a_chips_minus', vars = {card.ability.extra.chip_down}}),
                colour = G.C.BLUE,
                extra = {
                    message = localize({type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_up}}),
                    colour = G.C.RED
                }
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end    
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_white_flag" },
        { name = "j_ortalab_purple"}
    }, cost = 8, result_joker = "j_fuseforce_orta_perfidy"
}

SMODS.Joker {
    key = "orta_necromancer",
    name = "Necromancer",
    rarity = "fuse_fusion",
    cost = 20,
	unlocked = true,
	discovered = false,
    blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"on_sell", "boss_blind", "joker_slot"},
    atlas = "fuseforce_orta_jokers",
    pos = {x = 1, y = 3},
    artist_credits = {'Minus'},
    config = {
		extra = {
            joker1 = "j_ortalab_grave_digger",
            joker2 = "j_ortalab_memorial"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    add_to_deck = function(self, card, from_debuff)
        modify_joker_slot_count(1)
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not G.GAME.blind.boss then
            modify_joker_slot_count(-1)
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ortalab_grave_digger" },
        { name = "j_ortalab_memorial"}
    }, cost = 6, result_joker = "j_fuseforce_orta_necromancer"
}