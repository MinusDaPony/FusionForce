SMODS.Atlas({
    key = 'fuseforce_extra_jokers',
    path = 'JokersExtra.png',
    px = 71,
    py = 95
})

--Stolen from Extra Credit in order to make the Art Heist fusion work.
local function contains(table_, value)
    for _, v in pairs(table_) do
        if v == value then
            return true
        end
    end

    return false
end

SMODS.Joker {
    key = "extra_art_heist",
    name = "Art Heist",
    rarity = "fuse_fusion",
    cost = 23,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"consumeable_slot", "passive", "xmult", "scaling", "enhancements"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 0, y = 0},
    artist_credits = {'r3venant'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            card_limit = 2,
            Xmult = 1,
            Xmult_mod = 0.15,
			joker1 = "j_ExtraCredit_forklift",
			joker2 = "j_ExtraCredit_jokalisa"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.card_limit,
            card.ability.extra.Xmult,
            card.ability.extra.Xmult_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                --G.consumeables:change_size(card.ability.extra.card_limit)
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
                return true
            end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                --G.consumeables:change_size(-card.ability.extra.card_limit)
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
                return true
            end
        }))
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            local enhanced = {}
            for i=1, #context.scoring_hand do
                for k, v in pairs(SMODS.get_enhancements(context.scoring_hand[i])) do
                    if v then
                        if not contains(enhanced, k) then
                            enhanced[#enhanced+1] = k
                        end
                    end
                end
            end
            if #enhanced > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = 'Xmult',
                    scalar_value = 'Xmult_mod',
                    operation = function(ref_table, ref_value, initial, modifier)
                        ref_table[ref_value] = initial + modifier*#enhanced
                    end,
                    message_key = 'a_xmult',
                    message_colour = G.C.RED
                })
                if #enhanced > card.ability.extra.card_limit then
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit + #enhanced
                    card.ability.extra.card_limit = #enhanced
                end
                return nil, true
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ExtraCredit_forklift" },
        { name = "j_ExtraCredit_jokalisa", carry_stat = "Xmult" }
    }, cost = 10, result_joker = "j_fuseforce_extra_art_heist"
}

SMODS.Joker {
    key = "extra_electrum",
    name = "Electrum Joker",
    rarity = "fuse_fusion",
    cost = 23,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "modify_card", "enhancements", "economy"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 1, y = 0},
    artist_credits = {'minus'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            dollars = 5,
            x_mult = 1.75,
			joker1 = "j_ExtraCredit_alloy",
			joker2 = "j_ticket"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.dollars,
            card.ability.extra.x_mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            local steel = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if next(SMODS.get_enhancements(scored_card)) and SMODS.has_enhancement(scored_card, 'm_steel') then
                    steel = steel + 1
                    scored_card:set_ability('m_gold', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if steel > 0 then
                return {
                    message = 'Golden',
                    dollars = card.ability.extra.dollars * steel,
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
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint and not context.retrigger_joker then
            local steel = 0
            for _, discarded_card in ipairs(context.full_hand) do
                if next(SMODS.get_enhancements(discarded_card)) and SMODS.has_enhancement(discarded_card, 'm_steel') then
                    steel = steel + 1
                    discarded_card:set_ability('m_gold', nil, true)
                end
            end
            if steel > 0 then
                return {
                    message = 'Golden',
                    dollars = card.ability.extra.dollars * steel,
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
        if context.individual and SMODS.has_enhancement(context.other_card, 'm_gold') then
            if context.cardarea == G.hand and not context.end_of_round and not context.blueprint and not context.retrigger_joker then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        x_mult = card.ability.extra.x_mult
                    }
                end
            end
            if context.cardarea == G.play then
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
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ExtraCredit_alloy" },
        { name = "j_ticket" }
    }, cost = 11, result_joker = "j_fuseforce_extra_electrum"
}

SMODS.Joker {
    key = "extra_furnace",
    name = "Blast Furnace",
    rarity = "fuse_fusion",
    cost = 24,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "modify_card", "enhancements", "economy"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 2, y = 0},
    artist_credits = {'minus'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            dollars = 5,
            x_mult = 1,
            x_mult_mod = 0.25,
			joker1 = "j_ExtraCredit_alloy",
			joker2 = "j_steel_joker"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local steel_tally = 0
    if G.playing_cards then
        for _, playing_card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(playing_card, 'm_steel') then steel_tally = steel_tally + 1 end
        end
    end
	return {
		vars = {
            card.ability.extra.dollars,
            card.ability.extra.x_mult,
            card.ability.extra.x_mult_mod,
            card.ability.extra.x_mult_mod * steel_tally,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            local gold = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if next(SMODS.get_enhancements(scored_card)) and SMODS.has_enhancement(scored_card, 'm_gold') then
                    gold = gold + 1
                    scored_card:set_ability('m_steel', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if gold > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.x_mult_mod * gold)
                return {
                    message = 'Smelted',
                    dollars = card.ability.extra.dollars * gold,
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
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint and not context.retrigger_joker then
            local gold = 0
            for _, discarded_card in ipairs(context.full_hand) do
                if next(SMODS.get_enhancements(discarded_card)) and SMODS.has_enhancement(discarded_card, 'm_gold') then
                    gold = gold + 1
                    discarded_card:set_ability('m_steel', nil, true)
                end
            end
            if gold > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.x_mult_mod * gold)
                return {
                    message = 'Smelted',
                    dollars = card.ability.extra.dollars * gold,
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
        if context.individual and SMODS.has_enhancement(context.other_card, 'm_steel') and context.cardarea == G.hand and context.end_of_round and not context.blueprint and not context.retrigger_joker then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
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
        if context.joker_main then
            local steel_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_steel') then
                    steel_tally = steel_tally + 1
                end
            end
            return {
                Xmult = card.ability.extra.x_mult + (card.ability.extra.x_mult_mod * steel_tally)
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ExtraCredit_alloy" },
        { name = "j_steel_joker" }
    }, cost = 10, result_joker = "j_fuseforce_extra_furnace"
}

SMODS.Joker {
    key = "extra_orange_card",
    name = "Orange Card",
    rarity = "fuse_fusion",
    cost = 21,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"economy", "mult", "scaling", "skip"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 4, y = 0},
    artist_credits = {'minus'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            dollars = 8,
            mult_gain = 5,
            mult = 0,
			joker1 = "j_ExtraCredit_yellowcard",
			joker2 = "j_red_card"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.dollars,
            card.ability.extra.mult_gain,
            card.ability.extra.mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.skipping_booster or context.skip_blind then
            if not context.blueprint and not context.retrigger_joker then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    dollars = card.ability.extra.dollars,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain } },
                    colour = G.C.RED,
                    delay = 0.45
                }
            else
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ExtraCredit_yellowcard" },
        { name = "j_red_card", carry_stat = "mult" }
    }, cost = 10, result_joker = "j_fuseforce_extra_orange_card"
}

SMODS.Joker {
    key = "extra_string_theory",
    name = "String Theory",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chips", "mult", "joker"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 0, y = 1},
    artist_credits = {'neatoqueen'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            chips = 25,
            mult = 5,
			joker1 = "j_ExtraCredit_plushie",
			joker2 = "j_abstract"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local joker_count = 0
    if G.jokers then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].ability.set == 'Joker' and
                (G.jokers.cards[i].config.center.rarity == "fuse_fusion"
                or G.jokers.cards[i].config.center.rarity == "fuseforce_leg_fusion"
                or G.jokers.cards[i].config.center.rarity == "tsun_leg_fusion"
                or G.jokers.cards[i].config.center.rarity == "tsun_gold_legendary"
                or G.jokers.cards[i].config.center.rarity == "fuseforce_gold_fusion"
                or G.jokers.cards[i].config.center.rarity == "tsun_gold_fusion") then
                joker_count = joker_count + 2
            else
                joker_count = joker_count + 1
            end
        end
    end
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            --(G.jokers and G.jokers.cards and #G.jokers.cards or 0)*card.ability.extra.chips,
            --(G.jokers and G.jokers.cards and #G.jokers.cards or 0)*card.ability.extra.mult,
            card.ability.extra.chips * joker_count,
            card.ability.extra.mult * joker_count,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local joker_count = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' and
                    (G.jokers.cards[i].config.center.rarity == "fuse_fusion"
                    or G.jokers.cards[i].config.center.rarity == "fuseforce_leg_fusion"
                    or G.jokers.cards[i].config.center.rarity == "tsun_leg_fusion"
                    or G.jokers.cards[i].config.center.rarity == "tsun_gold_legendary"
                    or G.jokers.cards[i].config.center.rarity == "fuseforce_gold_fusion"
                    or G.jokers.cards[i].config.center.rarity == "tsun_gold_fusion") then
                    joker_count = joker_count + 2
                else
                    joker_count = joker_count + 1
                end
            end
            return {
                chips = card.ability.extra.chips * joker_count,
                mult = card.ability.extra.mult * joker_count
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ExtraCredit_plushie" },
        { name = "j_abstract" }
    }, cost = 10, result_joker = "j_fuseforce_extra_string_theory"
}

SMODS.Joker {
    key = "extra_flag_carrier",
    name = "Flag Carrier",
    rarity = "fuse_fusion",
    cost = 19,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chips", "mult", "scaling", "hands", "discard"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 3, y = 0},
    artist_credits = {'itayfeder'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            mulchs = 0,
            mult = 0,
            mult_mod = 3,
            chips = 0,
            chips_mod = 7,
			joker1 = "j_ExtraCredit_purplejoker",
			joker2 = "j_banner"
    	}
	},
    loc_vars = function(self, info_queue, card)
    if card.ability.extra.mulchs > 0 then
        card.ability.extra.mult = card.ability.extra.mulchs
        card.ability.extra.chips = card.ability.extra.mulchs
        card.ability.extra.mulchs = 0
    end
	return {
		vars = {
            card.ability.extra.mult,
            card.ability.extra.mult_mod,
            card.ability.extra.chips,
            card.ability.extra.chips_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and not context.blueprint and not context.retrigger_joker and context.main_eval then
            if G.GAME.current_round.discards_left > 0 then
                card.ability.extra.chips = card.ability.extra.chips + (G.GAME.current_round.discards_left*card.ability.extra.chips_mod)
            end
            if G.GAME.current_round.hands_left > 0 then
                card.ability.extra.mult = card.ability.extra.mult + (G.GAME.current_round.hands_left*card.ability.extra.mult_mod)
            end
            if G.GAME.current_round.discards_left > 0 or G.GAME.current_round.hands_left > 0 then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.PURPLE,
                }
            end
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
        { name = "j_ExtraCredit_purplejoker", carry_stat = "mulchs" },
        { name = "j_banner" }
    }, cost = 10, result_joker = "j_fuseforce_extra_flag_carrier"
}

local function eclipse_sum_levels()
    local total_hands = to_big(0)
    local total_levels = to_big(0)
    for hand, data in pairs(G.GAME.hands) do
        -- We should ignore hands which level is 0 or less for description consistency.
        if data.level >= to_big(1) then
            total_hands = total_hands + to_big(1)
            total_levels = total_levels + data.level
        end
    end
    return total_levels, total_hands
end

SMODS.Joker {
    key = "extra_blue_planet",
    name = "Blue Planet",
    rarity = "fuse_fusion",
    cost = 22,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"planet", "consumable", "economy", "chips", "scaling", "hand_type", "space", "seals", "generation"},
    atlas = "fuseforce_extra_jokers",
    pos = {x = 1, y = 1},
    artist_credits = {'minus'},
    dependencies = {"extracredit"},
    config = {
		extra = {
            dollars = 1,
            chip_mod = 12,
            chips = 25,
			joker1 = "j_ExtraCredit_eclipse",
			joker2 = "j_satellite"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local levels, hands = eclipse_sum_levels()
    local planets_used = 0
    for k, v in pairs(G.GAME.consumeable_usage) do
        if v.set == 'Planet' then
            planets_used = planets_used + 1
        end
    end
	return {
		vars = {
            card.ability.extra.dollars,
            planets_used * card.ability.extra.dollars,
            card.ability.extra.chip_mod,
            (levels-hands)*card.ability.extra.chip_mod,
            card.ability.extra.chips,
            card.ability.extra.dollars*2,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        local planets_used = 0
        for k, v in pairs(G.GAME.consumeable_usage) do
            if v.set == 'Planet' then planets_used = planets_used + 1 end
        end
        return planets_used > 0 and planets_used * card.ability.extra.dollars or nil
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            local levels, hands = eclipse_sum_levels()
            local chips = (levels - hands) * card.ability.extra.chip_mod
            if chips > to_big(0) then
                return {
                    chips = chips
                }
            end
        end
        if context.individual and context.cardarea == G.play and context.other_card:get_seal() == "Blue" then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + (card.ability.extra.dollars*2)
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local _planet = nil
                        for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                            if v.config.hand_type == G.GAME.last_hand_played then
                                _planet = v.key
                            end
                        end
                        if _planet then
                            SMODS.add_card({ key = _planet })
                        end
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_planet'),
                    colour = G.C.SECONDARY_SET.Planet,
                    message_card = other_card,
                    chips = card.ability.extra.chips,
                    dollars = card.ability.extra.dollars*2,
                    func = function() -- This is for timing purposes, it runs after the dollar manipulation
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            else
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + (card.ability.extra.dollars*2)
                return {
                    chips = card.ability.extra.chips,
                    dollars = card.ability.extra.dollars*2,
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
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_ExtraCredit_eclipse" },
        { name = "j_satellite" }
    }, cost = 8, result_joker = "j_fuseforce_extra_blue_planet"
}

