SMODS.Rarity {
	key = "gold_fusion",
	default_weight = 0,
	badge_colour = HEX("d8b162"),
	pools = { ["Joker"] = false },
	get_weight = function(self, weight, object_type)
		return weight
	end,
}

SMODS.Joker {
	key = "gold_alloy",
	name = "Electrum Joker",
	rarity = "fuseforce_gold_fusion",
	cost = 38,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "fuseforce_jokers",
	pos = { x = 1, y = 4 },
    artist_credits = {'minus'},
    config = {
		extra = {
			x_mult = 1.5,
			dollars = 3,
			x_mult_gold = 0.2,
			dollars_gold = 4,
			joker1 = "j_steel_joker",
			joker2 = "j_ticket"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local alloy_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_steel') or SMODS.has_enhancement(playing_card, 'm_gold') then
                    alloy_tally = alloy_tally + 1
                end
            end
        end
	return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.dollars,
			card.ability.extra.x_mult_gold,
			card.ability.extra.dollars_gold,
            1 + card.ability.extra.x_mult_gold * alloy_tally,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.end_of_round and not context.blueprint and not context.retrigger_joker then
            --if next(SMODS.get_enhancements(other_card)) and other_card.steel then
            if SMODS.has_enhancement(context.other_card, 'm_steel') then
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
        end
        if context.individual and context.cardarea == G.hand and SMODS.has_enhancement(context.other_card, 'm_gold') and not context.end_of_round and not context.blueprint and not context.retrigger_joker then
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
        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_gold') or SMODS.has_enhancement(context.other_card, 'm_steel') then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars_gold
                    return {
                        dollars = card.ability.extra.dollars_gold,
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
            local alloy_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_steel') or SMODS.has_enhancement(playing_card, 'm_gold') then
                    alloy_tally = alloy_tally + 1
                end
        end
        return {
            x_mult = 1 + card.ability.extra.x_mult_gold * alloy_tally,
        }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_alloy" },
		{ name = "j_ticket" },
	}, cost = 20, result_joker = "j_fuseforce_gold_alloy"
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_steel_joker" },
		{ name = "j_fuseforce_alloy" },
	}, cost = 18, result_joker = "j_fuseforce_gold_alloy"
}

SMODS.Joker {
	key = "gold_golden_calf",
	name = "Golden Calf",
	rarity = "fuseforce_gold_fusion",
	cost = 47,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 3 },
    artist_credits = {'minus'},
    config = {
		extra = {
			x_mult = 1,
            x_mult_mod = 0.25,
            odds = 10,
            c_slots = 0,
            j_slots = 0,
			joker1 = "j_golden",
			joker2 = "j_campfire",
			joker3 = "j_ceremonial",
			joker4 = "j_fuseforce_golden_calf"
    	}
	},
    loc_vars = function(self, info_queue, card)
		local numerator,
        denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'moses')
	return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.x_mult_mod,
			numerator,
			denominator,
			card.ability.extra.c_slots,
			card.ability.extra.j_slots,
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker4, set = 'Joker'}
		}
	}
    end,
    remove_from_deck = function(self, card, from_debuff)
        modify_joker_slot_count(-card.ability.extra.j_slots)
        modify_consumable_slot_count(-card.ability.extra.c_slots)
    end,
	calculate = function(self, card, context)
        if context.selling_card and context.card.ability.name ~= card.ability.name and not context.blueprint and not context.retrigger_joker then
            if SMODS.pseudorandom_probability(card, 'calf', 1, card.ability.extra.odds) then
                if context.card.ability.set == 'Joker' then
                    modify_joker_slot_count(1)
                    card.ability.extra.j_slots = card.ability.extra.j_slots + 1
                else
                    modify_consumable_slot_count(1)
                    card.ability.extra.c_slots = card.ability.extra.c_slots + 1
                end
            end
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.x_mult > 1 then
                card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.x_mult_mod
                return {
                    message = localize { type = 'variable', key = 'a_xmult_minus', vars = { card.ability.extra.x_mult_mod } },
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_golden_calf", carry_stat = "x_mult" },
		{ name = "j_ceremonial" },
	}, cost = 20, result_joker = "j_fuseforce_gold_golden_calf"
}

SMODS.Joker {
	key = "gold_serial_killer",
	name = "Serial Killer",
	rarity = "fuseforce_gold_fusion",
	cost = 43,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"xmult", "destroy_card", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 2, y = 9 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
			x_mult_mod = 0.25,
			x_mult = 1,
			mult = 0,
			joker1 = "j_ceremonial",
			joker2 = "j_madness"
    	}
	},
    loc_vars = function(self, info_queue, card)
		if card.ability.extra.mult > 0 then
				card.ability.extra.x_mult = math.max(0,math.floor(card.ability.extra.mult / 2))/4 + card.ability.extra.x_mult
				card.ability.extra.mult = 0
		end
	return {
		vars = {
			card.ability.extra.x_mult_mod,
			card.ability.extra.x_mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and not context.retrigger_joker then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    my_pos = i
                    break
                end
            end
			if my_pos and G.jokers.cards[my_pos + 1] and not G.jokers.cards[my_pos + 1].getting_sliced then
                if SMODS.is_eternal(G.jokers.cards[my_pos + 1], card) then
                    local sliced_card = G.jokers.cards[my_pos + 1]
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod * sliced_card.sell_cost
                            card:juice_up(0.8, 0.8)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 1,
                        func = function()
                            play_sound('cancel', 0.90)
                            sliced_card:juice_up(0.8, 0.8)
                            return true
                        end
                    }))
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult + card.ability.extra.x_mult_mod * sliced_card.sell_cost } },
                        colour = G.C.RED,
                        no_juice = true
                    }
                else
                    local sliced_card = G.jokers.cards[my_pos + 1]
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) - 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.joker_buffer = 0
                            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod * sliced_card.sell_cost
                            card:juice_up(0.8, 0.8)
                            sliced_card:start_dissolve({ HEX("57ecab") }, nil, 1.6)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            return true
                        end
                    }))
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult + card.ability.extra.x_mult_mod * sliced_card.sell_cost } },
                        colour = G.C.RED,
                        no_juice = true
                    }
                end
            end
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_ceremonial", carry_stat = "mult" },
		{ name = "j_fuseforce_serial_killer", carry_stat = "x_mult" },
	}, cost = 20, result_joker = "j_fuseforce_gold_serial_killer"
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_serial_killer", merge_stat = "x_mult" },
		{ name = "j_madness", merge_stat = "x_mult" },
	}, cost = 19, merged_stat = "x_mult", result_joker = "j_fuseforce_gold_serial_killer"
}

SMODS.Joker {
	key = "gold_two_heads",
	name = "Two Heads",
	rarity = "fuseforce_gold_fusion",
	cost = 56,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"copying"},
	atlas = "fuseforce_jokers",
	pos = { x = 8, y = 10 },
    artist_credits = {'minus'},
    config = {
		extra = {
            repetitions = 1,
			joker1 = "j_blueprint",
			joker2 = "j_brainstorm",
			joker3 = "j_fuseforce_two_heads"
    	}
	},
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local left_joker, right_joker = nil, nil
            local left_compat, right_compat = false, false
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    left_joker = G.jokers.cards[i - 1]
                    right_joker = G.jokers.cards[i + 1]
                    break
                end
            end
            left_compat = left_joker and left_joker.config.center.blueprint_compat and left_joker.config.center.key ~= card.config.center.key and left_joker.config.center.key ~= 'j_blueprint' and left_joker.config.center.key ~= 'j_brainstorm' and left_joker.config.center.key ~= 'j_fuseforce_two_heads'
            right_compat = right_joker and right_joker.config.center.blueprint_compat and right_joker ~= card and right_joker.config.center.key ~= 'j_blueprint' and right_joker.config.center.key ~= 'j_brainstorm'
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = (left_compat or right_compat) and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. ((left_compat and right_compat and 'both_compat') or (left_compat and 'left_compat') or (right_compat and 'right_compat') or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return {
                main_end = main_end,
                vars = {
                    card.ability.extra.repetitions,
                    localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
                    localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
                }
            }
        else
            return {
                vars = {
                    card.ability.extra.repetitions,
                    localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
                    localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
                }
            }
        end
    end,
    calculate = function(self, card, context)
    local left_effect, right_effect = nil, nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                local left_joker = G.jokers.cards[i - 1]
                local right_joker = G.jokers.cards[i + 1]
                if left_joker and left_joker.config.center.blueprint_compat and left_joker.config.center.key ~= card.config.center.key and left_joker.config.center.key ~= 'j_blueprint' and left_joker.config.center.key ~= 'j_brainstorm' and left_joker.config.center.key ~= 'j_fuseforce_two_heads' then
                    left_effect = SMODS.blueprint_effect(card, left_joker, context)
                end
                if right_joker and right_joker.config.center.blueprint_compat and right_joker ~= card and right_joker.config.center.key ~= 'j_blueprint' and right_joker.config.center.key ~= 'j_brainstorm' then
                    right_effect = SMODS.blueprint_effect(card, right_joker, context)
                end
                break
            end
        end
        if left_effect or right_effect then
            local merged_effect = SMODS.merge_effects(
                { left_effect or {} },
                { right_effect or {} }
            )
            return merged_effect
        end
        if context.retrigger_joker_check and context.other_card then

            if Card.is(context.other_card, Card) and (
            context.other_card.config.center.rarity == 5 or context.other_card.config.center.rarity == "fuse_fusion"
            or context.other_card.config.center.rarity == "fuseforce_gold_fusion"
            or context.other_card.config.center.rarity == "tsun_gold_fusion"
            ) and context.other_card.config.center.key ~= card.config.center.key
            and context.other_card.config.center.key ~= 'j_fuseforce_two_heads' then
                return {
                    repetitions = card.ability.extra.repetitions,
                    card = card,
                    message = 'Again!'
                }
            end

            if context.other_card == card then
                local left_joker_compat = 0
                local right_joker_compat = 0
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        local left = G.jokers.cards[i - 1]
                        local right = G.jokers.cards[i + 1]
                        if left and left.config.center.blueprint_compat and left.config.center.key ~= card.config.center.key and left.config.center.key ~= 'j_blueprint' and left.config.center.key ~= 'j_brainstorm' and left.config.center.key ~= 'j_fuseforce_two_heads' then
                            left_joker_compat = 1
                        end
                        if right and right.config.center.blueprint_compat and right ~= card and right.config.center.key ~= 'j_blueprint' and right.config.center.key ~= 'j_brainstorm' then
                            right_joker_compat = 1
                        end
                        break
                    end
                end
                if left_joker_compat == 0 or right_joker_compat == 0 then
                    return {
                        repetitions = card.ability.extra.repetitions
                    }
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_two_heads" },
		{ name = "j_brainstorm" },
	}, cost = 20, result_joker = "j_fuseforce_gold_two_heads"
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_two_heads" },
		{ name = "j_blueprint" },
	}, cost = 20, result_joker = "j_fuseforce_gold_two_heads"
}

SMODS.Joker {
	key = "gold_cactus_juice",
	name = "Cactus Juice",
	rarity = "fuseforce_gold_fusion",
	cost = 0, --48
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"on_sell", "food", "boss_blind", "joker", "generation", "tag"},
	atlas = "fuseforce_jokers",
	pos = { x = 7, y = 10 },
    artist_credits = {'minus'},
    config = {
		extra = {
			joker1 = "j_luchador",
			joker2 = "j_diet_cola",
			joker3 = "j_fuseforce_cactus_juice"
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
	calculate = function(self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    add_tag(Tag('tag_double'))
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                    local edition = card.edition and card.edition.key or nil
                    local stickers = {}
                    local blinded = false
                    for k, v in pairs(SMODS.Stickers) do
                        if card.ability[k] then
                            table.insert(stickers, k)
                        end
                    end
                    if G.GAME.blind and not G.GAME.blind.disabled and G.GAME.blind.boss then
                        G.GAME.blind:disable()
                        --blinded = true
                    end
                    --message = localize('ph_boss_disabled' and blinded == true or nil)
                    local new_luchador = SMODS.create_card({area = G.jokers, set = 'Joker', key = 'j_fuseforce_cactus_juice', edition = edition, stickers = stickers})
                    local new_diet_cola = SMODS.create_card({area = G.jokers, set = 'Joker', key = 'j_diet_cola', edition = edition, stickers = stickers})
                    new_luchador:add_to_deck()
                    G.jokers:emplace(new_luchador)
                    new_luchador:start_materialize()
                    new_diet_cola:add_to_deck()
                    G.jokers:emplace(new_diet_cola)
                    new_diet_cola:start_materialize()
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_cactus_juice" },
		{ name = "j_diet_cola" },
	}, cost = 19, result_joker = "j_fuseforce_gold_cactus_juice"
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_cactus_juice" },
		{ name = "j_luchador" },
	}, cost = 20, result_joker = "j_fuseforce_gold_cactus_juice"
}

Splashkeytable = {
	"j_fuseforce_gold_skipper",
}

--if SMODS.Mods.Tsunami then
if next(SMODS.find_mod('Tsunami')) then

local SMODS_Joker_inject=SMODS.Joker.inject
SMODS.Joker.inject =function(self)
	if self.rarity == "fuseforce_gold_fusion" then
		self.rarity = "tsun_gold_fusion"
	end
  SMODS_Joker_inject(self)
end

SMODS.Joker {
	key = "gold_skipper",
	name = "Skipper",
	rarity = "tsun_gold_fusion",
	cost = 38,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	---Cryptid config thingy to disable the Joker from being generated by Ace Equillibrium
	no_aeq = true,
	atlas = "fuseforce_jokers",
	pos = { x = 0, y = 4 },
    artist_credits = {'minus'},
    config = {
		extra = {
            x_mult = 1,
            dollars = 2,
            tally = 0,
			joker1 = "j_swashbuckler",
			joker2 = "j_throwback",
			joker3 = "j_splash",
			joker4 = "j_fuseforce_skipper"
    	}
	},
    loc_vars = function(self, info_queue, card)
        local sell_cost = 0
        for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
            if joker ~= card then
                sell_cost = sell_cost + joker.sell_cost*0.2
            end
        end
		return {
		vars = {
			card.ability.extra.x_mult + G.GAME.skips*0.25 + sell_cost,
			card.ability.extra.dollars,
			card.ability.extra.tally,
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker4, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.joker_main then
        local sell_cost = 0
        for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
            if joker ~= card then
                sell_cost = sell_cost + joker.sell_cost*0.2
            end
        end
            return {
                x_mult = card.ability.extra.x_mult + G.GAME.skips*0.25 + sell_cost
            }
        end
        if context.skip_blind then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                message = '$2',
                dollars = card.ability.extra.dollars,
                delay = 0.45,
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
        if context.individual and context.cardarea == G.play and card_is_splashed(context.other_card) == true then
            card.ability.extra.tally = card.ability.extra.tally + 1
            if card.ability.extra.tally >= 5 then
                card.ability.extra.tally = card.ability.extra.tally - 5
                G.GAME.skips = G.GAME.skips + 1
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fuseforce_skipper" },
		{ name = "j_splash" },
	}, cost = 20, result_joker = "j_fuseforce_gold_skipper"
}
end