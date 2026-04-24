SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
        quantum_enhancements = true
    }
end

SMODS.Atlas {
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
}

if next(SMODS.find_mod("ortalab")) then
	SMODS.load_file("FusionVirtues.lua")()
end

SMODS.Atlas({
    key = 'fuseforce_consumables',
    path = 'Consumables.png',
    px = 71,
    py = 95
})

local function build_requirement_counts(fusion)
	local required_counts = {}
	for _, component in ipairs(fusion.jokers or {}) do
		required_counts[component.name] = (required_counts[component.name] or 0) + 1
	end
	return required_counts
end

local function build_card_counts(cards)
	local owned_counts = {}
	for _, joker in ipairs(cards or {}) do
		local key = joker.config and joker.config.center_key
		if key then
			owned_counts[key] = (owned_counts[key] or 0) + 1
		end
	end
	return owned_counts
end

local function build_owned_counts()
	return build_card_counts((G.jokers and G.jokers.cards) or {})
end

local function copy_table_deep(value)
	if type(value) ~= "table" then
		return value
	end

	local copy = {}
	for key, inner_value in pairs(value) do
		copy[key] = copy_table_deep(inner_value)
	end
	return copy
end

local function fusionforce_has_fusion_discount_voucher()
	return G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers["v_fuseforce_fusion_coupon"] or false
end

local function fusionforce_has_fusion_discount_voucher2()
	return G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers["v_fuseforce_fusion_coupon2"] or false
end

local function get_discounted_fusion(fusion)
	if not fusion then
		return nil
	end

	if not fusionforce_has_fusion_discount_voucher() or type(fusion.cost) ~= "number" then
		return fusion
	end

	local adjusted_fusion = copy_table_deep(fusion)
    if not fusionforce_has_fusion_discount_voucher2() then
	    adjusted_fusion.cost = math.max(0, math.floor(fusion.cost * 0.75))
	    return adjusted_fusion
    else
	    adjusted_fusion.cost = math.max(0, math.floor(fusion.cost * 0.5))
	    return adjusted_fusion
    end
end

--local function fusionforce_desticker()
SMODS.current_mod.calculate = function(self, context)
    if context.card_added and context.card.ability.set == 'Joker'
    and (
    context.card.config.center.rarity == 5
    or context.card.config.center.rarity == "fuse_fusion"
    or context.card.config.center.rarity == "fuseforce_gold_fusion"
    or context.card.config.center.rarity == "tsun_gold_fusion"
    ) then
        for i = 1, #G.jokers.cards do
            local card = G.jokers.cards[i]
            if (
            card.config.center.rarity == 5
            or card.config.center.rarity == "fuse_fusion"
            or card.config.center.rarity == "fuseforce_gold_fusion"
            or card.config.center.rarity == "tsun_gold_fusion"
            ) then
                if fusionforce_has_fusion_discount_voucher2() then
                    card.ability.rental = false
                end
                if fusionforce_has_fusion_discount_voucher() then
                    card.ability.perishable = false
                end
            end
	return true
        end
    end
end

local function recipe_contains_key(fusion, key)
	for _, component in ipairs(fusion.jokers or {}) do
		if component.name == key then
			return true
		end
	end
	return false
end

local function recipe_is_satisfied_by_counts(fusion, counts)
	local required_counts = build_requirement_counts(fusion)
	for key, required_count in pairs(required_counts) do
		if (counts[key] or 0) < required_count then
			return false
		end
	end
	return true
end

local function is_fusionforce_recipe(fusion)
	return fusion and type(fusion.result_joker) == "string" and fusion.result_joker:match("^j_fuseforce_") ~= nil
end

local function is_fusionjokers_recipe(fusion)
	return fusion and type(fusion.result_joker) == "string" and fusion.result_joker:match("^j_fuse_") ~= nil
end

local function is_tsunami_recipe(fusion)
	return fusion and type(fusion.result_joker) == "string" and fusion.result_joker:match("^j_tsun_") ~= nil
end

local function is_gold_recipe(fusion)
	return fusion and type(fusion.result_joker) == "string" and fusion.result_joker:match("^j_fuseforce_gold_") ~= nil
end

local function uses_fusionforce_button_logic(fusion)
	return is_fusionforce_recipe(fusion) or is_fusionjokers_recipe(fusion) or is_tsunami_recipe(fusion)
end

local function recipe_counts_for_wiggle(fusion)
	return fusion and not is_tsunami_recipe(fusion)
end

local function recipe_counts_for_shadow(fusion)
	return fusion and not (is_tsunami_recipe(fusion) or is_gold_recipe(fusion))
end

local function get_recipes_for_key(selected_key)
	if not selected_key or not FusionJokers or not FusionJokers.fusions then
		return {}
	end

	local matching_fusions = {}
	local matching_supported_fusions = {}

	for _, fusion in ipairs(FusionJokers.fusions) do
		if recipe_contains_key(fusion, selected_key) then
			matching_fusions[#matching_fusions + 1] = fusion
			if uses_fusionforce_button_logic(fusion) then
				matching_supported_fusions[#matching_supported_fusions + 1] = fusion
			end
		end
	end

	if #matching_supported_fusions > 0 then
		return matching_supported_fusions
	end

	return matching_fusions
end

local function get_complete_owned_fusions(selected_key)
	local owned_counts = build_owned_counts()
	local complete_fusions = {}

	for _, fusion in ipairs(get_recipes_for_key(selected_key)) do
		if recipe_is_satisfied_by_counts(fusion, owned_counts) then
			complete_fusions[#complete_fusions + 1] = fusion
		end
	end

	return complete_fusions
end

local function resolve_owned_fusion(card)
	if not card or card.area ~= G.jokers or not card.config or not card.config.center_key then
		return nil
	end

	local complete_fusions = get_complete_owned_fusions(card.config.center_key)
	if #complete_fusions == 1 then
		return complete_fusions[1]
	end
	if #complete_fusions == 0 then
		return nil
	end

	local highlighted_counts = build_card_counts((G.jokers and G.jokers.highlighted) or {})
	local highlighted_matches = {}
	for _, fusion in ipairs(complete_fusions) do
		if recipe_is_satisfied_by_counts(fusion, highlighted_counts) then
			highlighted_matches[#highlighted_matches + 1] = fusion
		end
	end

	if #highlighted_matches == 1 then
		return highlighted_matches[1]
	end

	return nil
end

local function has_present_fusion_recipe(card)
	return resolve_owned_fusion(card) ~= nil
end

local function has_any_complete_owned_recipe(card)
	if not (card and card.area == G.jokers and card.config and card.config.center_key) then
		return false
	end

	for _, fusion in ipairs(get_complete_owned_fusions(card.config.center_key)) do
		if recipe_counts_for_wiggle(fusion) then
			return true
		end
	end

	return false
end

local function card_advances_partial_fusion(card)
	if not card or not card.area or not card.area.config or card.area.config.type == 'joker' or not card.config or not card.config.center_key then
		return false
	end

	local candidate_key = card.config.center_key
	local owned_counts = build_owned_counts()

	for _, fusion in ipairs(get_recipes_for_key(candidate_key)) do
		if recipe_counts_for_wiggle(fusion) then
			local required_counts = build_requirement_counts(fusion)
			local total_required = 0
			local owned_progress = 0
			local future_progress = 0
			for key, required_count in pairs(required_counts) do
				total_required = total_required + required_count
				local owned_count = owned_counts[key] or 0
				owned_progress = owned_progress + math.min(owned_count, required_count)
				local future_count = owned_count + (key == candidate_key and 1 or 0)
				future_progress = future_progress + math.min(future_count, required_count)
			end

			if owned_progress > 0 and owned_progress < total_required and future_progress > owned_progress then
				return true
			end
		end
	end

	return false
end

local fusionjokers_get_card_fusion_ref = Card.get_card_fusion
function Card:get_card_fusion(debug)
	if self and self.ability and self.ability.set == 'Joker' then
		if has_present_fusion_recipe(self) then
			return get_discounted_fusion(resolve_owned_fusion(self))
		end
		return {
			result_joker = "No fusions",
			jokers = {
				{ name = self.config and self.config.center_key }
			},
			cost = "??"
		}
	end

	return fusionjokers_get_card_fusion_ref(self, debug)
end

local fusionjokers_can_fuse_card_ref = Card.can_fuse_card
function Card:can_fuse_card(juicing)
	if self and self.ability and self.ability.set == 'Joker' then
		local fusion = self:get_card_fusion()
		if not fusion or fusion.cost == "??" then
			return false, fusion
		end

		local reqcheck = true
		if type(fusion.requirement) == "function" then
			reqcheck = fusion.requirement()
		end

		return reqcheck and (to_big(fusion.cost) + to_big(G.GAME.bankrupt_at or 0)) <= to_big(G.GAME.dollars), fusion
	end

	return fusionjokers_can_fuse_card_ref(self, juicing)
end

local fusionjokers_card_update_ref = Card.update
function Card:update(dt)
	fusionjokers_card_update_ref(self, dt)

	if G.STAGE ~= G.STAGES.RUN or not self.ability or self.ability.set ~= 'Joker' then
		return
	end

	if self.area == G.jokers then
		if has_any_complete_owned_recipe(self) and not self.ability.fusionforce_owned_jiggle then
			juice_card_until(self,
			function(card)
				return has_any_complete_owned_recipe(card)
			end,
			true)
			self.ability.fusionforce_owned_jiggle = true
		end

		if not has_any_complete_owned_recipe(self) and self.ability.fusionforce_owned_jiggle then
			self.ability.fusionforce_owned_jiggle = false
		end

		return
	end

	if card_advances_partial_fusion(self) and not self.ability.fusionforce_partial_jiggle then
		juice_card_until(self,
		function(card)
			return card_advances_partial_fusion(card)
		end,
		true)
		self.ability.fusionforce_partial_jiggle = true
	end

	if not card_advances_partial_fusion(self) and self.ability.fusionforce_partial_jiggle then
		self.ability.fusionforce_partial_jiggle = false
	end
end

local function add_unique(pool, seen, key)
	if key and not seen[key] then
		seen[key] = true
		pool[#pool + 1] = key
	end
end

local function get_shadow_pool(selected_key)
	if not selected_key then
		return nil
	end

	local owned_counts = build_owned_counts()
	local missing_pool = {}
	local missing_seen = {}
	local fallback_pool = {}
	local fallback_seen = {}

	for _, fusion in ipairs(get_recipes_for_key(selected_key)) do
		if recipe_counts_for_shadow(fusion) then
			local required_counts = build_requirement_counts(fusion)
			local missing_in_recipe = false
			for key, required_count in pairs(required_counts) do
				local owned_count = owned_counts[key] or 0
				if owned_count < required_count then
					missing_in_recipe = true
					add_unique(missing_pool, missing_seen, key)
				end
			end

			for _, component in ipairs(fusion.jokers or {}) do
				if component.name ~= selected_key or required_counts[selected_key] > 1 then
					add_unique(fallback_pool, fallback_seen, component.name)
				end
			end

			if not missing_in_recipe and required_counts[selected_key] > 1 then
				add_unique(fallback_pool, fallback_seen, selected_key)
			end
		end
	end

	if #missing_pool > 0 then
		return missing_pool
	end
	return #fallback_pool > 0 and fallback_pool or nil
end

local function shadow_has_room()
	return G.jokers and G.jokers.config and (#G.jokers.cards + (G.GAME.joker_buffer or 0) < G.jokers.config.card_limit)
end

SMODS.Consumable {
	key = 'shadow',
	name = "Shadow",
	set = 'Spectral',
	cost = 5,
	unlocked = true,
	discovered = false,
	atlas = "fuseforce_consumables",
	pos = { x = 0, y = 0 },
    artist_credits = {'Minus'},
	can_use = function(self, card)
        if (G.GAME.selected_back.effect.center.key == "b_fuseforce_minusdeck" or G.GAME.selected_sleeve == "sleeve_fuseforce_minussleeve") and #G.jokers.highlighted == 1 and (
            G.jokers.highlighted[1].config.center.rarity == 5
            or G.jokers.highlighted[1].config.center.rarity == "fuse_fusion"
            or G.jokers.highlighted[1].config.center.rarity == "fuseforce_gold_fusion"
            or G.jokers.highlighted[1].config.center.rarity == "tsun_gold_fusion"
        ) then
            --if #G.jokers.highlighted ~= 1 or G.jokers.highlighted[1].edition.key == "e_negative" then
            if #G.jokers.highlighted ~= 1 then
			    return false
		    end
            return true
        else
            --if not G.jokers or not G.jokers.cards or #G.jokers.highlighted ~= 1 or not shadow_has_room() then
            if #G.jokers.highlighted ~= 1 or SMODS.is_eternal(G.jokers.cards[#G.jokers.cards], card) then
                return false
            end
            local selected_joker = G.jokers.highlighted[1]
            local selected_key = selected_joker and selected_joker.config and selected_joker.config.center_key
            local pool = get_shadow_pool(selected_key)
            return pool and #pool > 0 or false
        end
	end,
	can_bulk_use = false,
	use = function(self, card, area, copier)
        if (G.GAME.selected_back.effect.center.key == "b_fuseforce_minusdeck" or G.GAME.selected_sleeve == "sleeve_fuseforce_minussleeve") and (
            G.jokers.highlighted[1].config.center.rarity == 5
            or G.jokers.highlighted[1].config.center.rarity == "fuse_fusion"
            or G.jokers.highlighted[1].config.center.rarity == "fuseforce_gold_fusion"
            or G.jokers.highlighted[1].config.center.rarity == "tsun_gold_fusion"
        ) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    G.jokers.highlighted[1]:set_edition({ negative = true })
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        else
        G.jokers.cards[#G.jokers.cards].getting_sliced = true
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				local selected_joker = G.jokers and G.jokers.highlighted and G.jokers.highlighted[1]
				local selected_key = selected_joker and selected_joker.config and selected_joker.config.center_key
				local pool = get_shadow_pool(selected_key)
				--if not pool or #pool == 0 or not shadow_has_room() then
				if not pool or #pool == 0 then
					return true
				end
                G.jokers.cards[#G.jokers.cards]:start_dissolve({ G.C.MONEY }, nil, 1.6)
                play_sound("timpani")
                SMODS.add_card({
                    set = 'Joker',
                    key = pseudorandom_element(pool, pseudoseed('fusionjoker'))
                })
                card:juice_up(0.3, 0.5)
				return true
			end,
		}))
	    delay(0.6)
        end
	end
}

SMODS.Voucher {
	key = "fusion_coupon",
	name = "Beyond Limits",
	cost = 10,
	unlocked = true,
	discovered = false,
	atlas = "fuseforce_consumables",
	pos = { x = 1, y = 0 },
    artist_credits = {'Minus'},
	config = {
		extra = 25
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra
			}
		}
	end,
	redeem = function(self)
    for i = 1, #G.jokers.cards do
        local card = G.jokers.cards[i]
        local rarity = card.config.center.rarity
        if card.ability.set == 'Joker'
        and (
            rarity == 5
            or rarity == "fuse_fusion"
            or rarity == "fuseforce_gold_fusion"
            or rarity == "tsun_gold_fusion"
        ) then
            card.ability.perishable = false
        end
    end
end
}

SMODS.Voucher {
	key = "fusion_coupon2",
	name = "Even Further Beyond",
	cost = 10,
	unlocked = true,
	discovered = false,
	atlas = "fuseforce_consumables",
	pos = { x = 1, y = 1 },
    artist_credits = {'Minus'},
	requires = { "v_fuseforce_fusion_coupon" },
	config = {
		extra = 50
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra
			}
		}
	end,
	redeem = function(self)
    for i = 1, #G.jokers.cards do
        local card = G.jokers.cards[i]
        local rarity = card.config.center.rarity
        if card.ability.set == 'Joker'
        and (
            rarity == 5
            or rarity == "fuse_fusion"
            or rarity == "fuseforce_gold_fusion"
            or rarity == "tsun_gold_fusion"
        ) then
            card.ability.rental = false
        end
    end
end
}

SMODS.Atlas({
    key = 'fuseforce_decks',
    path = 'Decks.png',
    px = 71,
    py = 95
})

SMODS.Back {
	key = "minusdeck",
    name = "Minus Deck",
	unlocked = true,
	discovered = true,
	atlas = "fuseforce_decks",
	pos = { x = 0, y = 0 },
	config = {
        dollars = 5,
        consumables = { 'c_fuseforce_shadow' }
    },
	loc_vars = function(self, info_queue, back)
	return {
        vars = {
            self.config.dollars,
            localize { type = 'name_text', key = self.config.consumables[1], set = 'Spectral' }
        }
    }
	end
}

--if card sleeves enabled. I assuem this is how this is meant to be done?
if next(SMODS.find_mod('CardSleeves')) then
SMODS.Atlas({
    key = 'fuseforce_sleeves',
    path = 'sleeves.png',
    px = 73,
    py = 95
})

CardSleeves.Sleeve {
	key = "minussleeve",
    name = "Minus Sleeve",
	unlocked = true,
	discovered = true,
	atlas = "fuseforce_sleeves",
	pos = { x = 0, y = 0 },
	config = {
        dollars = 5,
        consumables = { 'c_fuseforce_shadow' }
    },
	loc_vars = function(self, info_queue, back)
	return {
        vars = {
            self.config.dollars,
            localize { type = 'name_text', key = self.config.consumables[1], set = 'Spectral' }
        }
    }
	end
}
end

SMODS.Atlas({
    key = 'fuseforce_jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
})

SMODS.Joker {
    key = "clairvoyant",
    Name = "Clairvoyant",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"spectral", "hand_type", "six", "generation", "rank"},
    atlas = "fuseforce_jokers",
    pos = {x = 0, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
		extra = {
			joker1 = "j_seance",
			joker2 = "j_sixth_sense"
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
    calculate = function(self,card,context)
        if context.after and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local sixes = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 6 then sixes = sixes + 1 end
            end
            if sixes >= 1 and next(context.poker_hands["Straight"]) then
                local card_type = 'Spectral'
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, 'clairvoyant')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    card = card
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_seance" },
        { name = "j_sixth_sense"}
    }, cost = 6, result_joker = "j_fuseforce_clairvoyant"
}

SMODS.Joker {
    key = "power_pop",
    name = "Power Pop",
    rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	attributes = {"xmult", "food", "scaling", "generation", "tag", "skip"},
	atlas = "fuseforce_jokers",
	pos = { x = 1, y = 0 },
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
        extra = {
            x_mult_mod = 0.3,
            tag = "tag_double",
			joker1 = "j_diet_cola",
			joker2 = "j_throwback"
        }
    },
    loc_vars = function(self,info_queue,card)
    return {
        vars = {
            1 + G.GAME.skips * card.ability.extra.x_mult_mod,
            card.ability.extra.x_mult_mod,
            localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
            localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
    calculate = function(self,card,context)
        if context.joker_main and 1 + G.GAME.skips * card.ability.extra.x_mult_mod > 1 then
            return {
                x_mult = 1 + G.GAME.skips * card.ability.extra.x_mult_mod
            }
        end
        if context.tag_added and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.tag = context.tag_added.key
        end
        if context.skip_blind and not context.blueprint and not context.retrigger_joker then
            G.E_MANAGER:add_event(Event({
                func = (function() 
                    add_tag(Tag(card.ability.extra.tag))
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_xmult', vars = {1 + G.GAME.skips * card.ability.extra.x_mult_mod}},
                            colour = G.C.RED,
                            card = card
                        })
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_diet_cola" },
        { name = "j_throwback"}
    }, cost = 10, result_joker = "j_fuseforce_power_pop"
}

SMODS.Joker {
    key = "reach_the_stars",
    name = "Reach the Stars",
    rarity = "fuse_fusion",
    cost = 15,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "rank"},
    atlas = "fuseforce_jokers",
    pos = {x = 2, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
		extra = {
			joker1 = "j_shoot_the_moon",
			joker2 = "j_raised_fist"
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
    calculate = function(self,card,context)
        --if context.cardrea == G.hand then
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                    card = card,
                }
            elseif context.other_card.ability.effect ~= 'Stone Card' then
                return {
                    h_mult = context.other_card.base.nominal,
                    card = card
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_shoot_the_moon" },
        { name = "j_raised_fist"}
    }, cost = 5, result_joker = "j_fuseforce_reach_the_stars"
}

SMODS.Joker {
    key = "rewards_card",
    name = "Rewards Card",
    rarity = "fuse_fusion",
    cost = 11,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"sell_value", "passive", "economy"},
    atlas = "fuseforce_jokers",
    pos = {x = 3, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
        extra = {
            valup = 1,
            debt = 0,
			joker1 = "j_gift",
			joker2 = "j_credit_card"
        }
    },
    loc_vars = function(self,info_queue,card)
    local sell_cost = 0
    for _, joker in ipairs(G.jokers and G.jokers.cards or {}) do
        --if joker ~= card then
            sell_cost = sell_cost + joker.sell_cost
        --end
    end
    for _, consumeable in ipairs(G.consumeables and G.consumeables.cards or {}) do
        if consumeable ~= card then
            sell_cost = sell_cost + consumeable.sell_cost
        end
    end
    card.ability.extra.debt = sell_cost
    return {
        vars = {
            card.ability.extra.valup,
            card.ability.extra.debt,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
calculate = function(self, card, context)
    if context.end_of_round and context.game_over == false and context.main_eval then
        for _, area in ipairs({ G.jokers, G.consumeables }) do
            for _, other_card in ipairs(area.cards) do
                if other_card.set_cost then
                    other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                        card.ability.extra.valup
                    other_card:set_cost()
                end
            end
        end
        return {
            message = localize('k_val_up'),
            colour = G.C.MONEY
        }
    end
    G.GAME.bankrupt_at = 0 - card.ability.extra.debt
end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = 0 - card.ability.extra.debt
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = 0
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_gift" },
        { name = "j_credit_card"}
    }, cost = 4, result_joker = "j_fuseforce_rewards_card"
}

SMODS.Joker {
    key = "masters_degree",
    name = "Master's Degree",
    rarity = "fuse_fusion",
    cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "ace", "chips", "enhancements", "generation", "rank"},
    atlas = "fuseforce_jokers",
    pos = {x = 4, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
        extra = {
            chips = 25,
            mult = 5,
			joker1 = "j_certificate",
			joker2 = "j_scholar"
        }
    },
    loc_vars = function(self,info_queue,card)
    return {
        vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
    calculate = function(self,card,context)
        if context.first_hand_drawn then
            local cen_pool = {}
                for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                        cen_pool[#cen_pool + 1] = enhancement_center
                    end
                end
            local enhancement = pseudorandom_element(cen_pool, 'degree')
            local _card = SMODS.create_card { set = "Base", rank = 'Ace', enhancement = enhancement.key, area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            _card.playing_card = G.playing_card
            table.insert(G.playing_cards, _card)

        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:emplace(_card)
                _card:start_materialize()
                G.GAME.blind:debuff_card(_card)
                G.hand:sort()
                if context.blueprint_card then
                    context.blueprint_card:juice_up()
                else
                    card:juice_up()
                end
                SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                save_run()
                return true
            end
        }))

        return nil, true -- This is for Joker retrigger purposes
    end
    if context.individual and context.cardarea == G.play then
        if context.other_card:get_id() == 14 then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end
end,
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_certificate" },
        { name = "j_scholar"}
    }, cost = 8, result_joker = "j_fuseforce_masters_degree"
}

local Cardset_price = Card.set_cost
function Card:set_cost()
    Cardset_price(self)
    if (
        (self.ability.set == 'Planet' or self.ability.set == 'Tarot') or 
        (self.ability.set == 'Booster' and (self.ability.name:find('Celestial') or self.ability.name:find('Arcana')))) 
        and #find_joker('j_fuseforce_soothsayer') > 0 then self.cost = 0 end
end

SMODS.Joker {
    key = "soothsayer",
    Name = "Soothsayer",
    rarity = "fuse_fusion",
    cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"tarot", "planet", "passive", "generation"},
    atlas = "fuseforce_jokers",
    pos = {x = 5, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
		extra = {
			joker1 = "j_astronomer",
			joker2 = "j_cartomancer"
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
        if context.setting_blind and not card.getting_sliced then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'soothsayer')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end}))   
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                    return true
                end)}))
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'soothsayer')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))   
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})                       
                        return true
                    end)}))
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_astronomer" },
        { name = "j_cartomancer"}
    }, cost = 8, result_joker = "j_fuseforce_soothsayer"
}

local refisface = Card.is_face
function Card:is_face(from_boss)
    if self.debuff and not from_boss then return end
    return refisface(self, from_boss) or (self:get_id() and (next(SMODS.find_card("j_fuseforce_prosopagnosia")) or next(SMODS.find_card("j_fuseforce_sticker")) ) )
end

SMODS.Joker {
    key = "prosopagnosia",
    name = "Prosopagnosia",
    rarity = "fuse_fusion",
    cost = 15,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"modify_card", "discard", "passive", "face", "economy"},
    atlas = "fuseforce_jokers",
    pos = {x = 6, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
        extra = {
            dollars = 2,
			joker1 = "j_pareidolia",
			joker2 = "j_faceless"
        }
    },
    loc_vars = function(self,info_queue,card)
    return {
        vars = {
            card.ability.extra.dollars,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
    calculate = function(self, card, context)
        if context.discard then
            ease_dollars(card.ability.extra.dollars)
            return {
                message = localize('$')..card.ability.extra.dollars,
                colour = G.C.MONEY,
                card = card
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_pareidolia" },
        { name = "j_faceless"}
    }, cost = 6, result_joker = "j_fuseforce_prosopagnosia"
}

SMODS.Joker {
    key = "energy_drink",
    name = "Energy Drink",
    rarity = "fuse_fusion",
    cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	attributes = {"food", "hand_type", "chips", "scaling"},
    atlas = "fuseforce_jokers",
    pos = {x = 8, y = 0},
    artist_credits = {'Minus'},
    config = {
        extra = {
            chips = 0,
            chip_mod = 3,
            chips_mod = 30,
			joker1 = "j_runner",
			joker2 = "j_ice_cream"
        }
    },
    loc_vars = function(self,info_queue,card)
    return {
        vars = {
            card.ability.extra.chips,
            card.ability.extra.chip_mod,
            card.ability.extra.chips_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.before and not context.blueprint and not context.retrigger_joker and next(context.poker_hands['Straight']) then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    card = card
                }
            elseif context.after and not context.blueprint and not context.retrigger_joker then
                if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then 
                    card_eval_status_text(card,'extra', nil, nil, nil, {message = localize('k_drank_ex')})
                card.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function() 
                        local edition = card.edition and card.edition.key or nil
                        local stickers = {}
                        for k, v in pairs(SMODS.Stickers) do
                            if card.ability[k] then
                                table.insert(stickers, k)
                            end
                        end

                        card:start_dissolve()
                        local new_joker = SMODS.create_card({area = G.jokers, set = 'Joker', key = 'j_runner', edition = edition, stickers = stickers})
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                        new_joker:start_materialize()
                        return true
                    end}))
                else
                    card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                    return {
                        message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.chip_mod}},
                        colour = G.C.CHIPS
                    }
                end
            elseif context.joker_main then
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chip_mod = card.ability.extra.chips, 
                    colour = G.C.CHIPS
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_runner", carry_stat = "chips" },
        { name = "j_ice_cream"}
    }, cost = 10, result_joker = "j_fuseforce_energy_drink"
}

SMODS.Joker {
    key = "boxer_shorts",
    name = "Boxer Shorts",
    rarity = "fuse_fusion",
    cost = 16,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"mult", "hand_type", "chips", "scaling"},
    atlas = "fuseforce_jokers",
    pos = {x = 7, y = 0},
    artist_credits = {'LunaAstraCassiopeia'},
    config = {
        extra = {
            mult = 0,
            chips = 0,
            chip_mod = 9,
            mult_mod = 4,
			joker1 = "j_trousers",
			joker2 = "j_square"
        }
    },
    loc_vars = function(self,info_queue,card)
    return {
        vars = {
            card.ability.extra.mult,
            card.ability.extra.chips,
            card.ability.extra.chip_mod,
            card.ability.extra.mult_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.before and not context.blueprint and not context.retrigger_joker and (next(context.poker_hands['Two Pair']) or next(context.poker_hands['Full House'])) and #context.full_hand == 4 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.PURPLE,
                    card = card
                }
            elseif context.joker_main then
                card_eval_status_text(context.blueprint_card or card, 'jokers', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}, colour = G.C.MULT})
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chips = card.ability.extra.chips, 
                    mult = card.ability.extra.mult,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_trousers", carry_stat = "mult" },
        { name = "j_square", carry_stat = "chips"}
    }, cost = 6, result_joker = "j_fuseforce_boxer_shorts"
}

SMODS.Joker {
    key = "over_and_out",
    Name = "Over and Out",
    rarity = "fuse_fusion",
    cost = 16,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "xmult", "passive", "ten", "four", "chips", "xchips", "rank", "hands"},
    atlas = "fuseforce_jokers",
    pos = {x = 9, y = 0},
    artist_credits = {'Minus'},
    config = {
        extra = {
            chips = 10,
            mult = 4,
            xchips = 1.1,
            xmult = 1.4,
			joker1 = "j_walkie_talkie",
			joker2 = "j_acrobat"
        }
    },
    loc_vars = function(self,info_queue,card)
    return {
        vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.xchips,
            card.ability.extra.xmult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
        }
    }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 10 or context.other_card:get_id() == 4) then
            if G.GAME.current_round.hands_left == 0 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    xchips = card.ability.extra.xchips,
                    x_mult = card.ability.extra.xmult,
                    card = card
                }
            else
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
        if context.modify_scoring_hand and (context.other_card:get_id() == 10 or context.other_card:get_id() == 4) and not context.blueprint and not context.retrigger_joker then
            return {
                add_to_hand = true
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_walkie_talkie" },
        { name = "j_acrobat" }
    }, cost = 6, result_joker = "j_fuseforce_over_and_out"
}

SMODS.Joker {
	key = "sweet_theatre_combo",
	name = "Sweet Theatre Combo",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	attributes = {"mult", "food", "chips"},
	atlas = "fuseforce_jokers",
	pos = { x = 0, y = 1 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
    		mult = 30,
			chips = 150,
			count = 5,
			joker1 = "j_popcorn",
			joker2 = "j_ice_cream"
    		}
		},
    loc_vars = function(self, info_queue, card)
    return {
		vars = { 
			card.ability.extra.mult,
			card.ability.extra.chips,
			card.ability.extra.count, 
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
    	if context.end_of_round and not (context.individual or context.repetition or context.blueprint or context.retrigger_joker) then
    	    card.ability.extra.count = card.ability.extra.count-1
        	if card.ability.extra.count<=0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true
							end
						}))
                        return true
                    end
				}))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            end      
        end
			--if context.cardarea == G.jokers and not context.after and not context.before then
			if context.joker_main then
                return {
    				mult = card.ability.extra.mult,
    				chips = card.ability.extra.chips,
        	        card = card
    			}
    		end
		end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_popcorn" },
		{ name = "j_ice_cream" },
	}, cost = 10, result_joker = "j_fuseforce_sweet_theatre_combo"
}

SMODS.Joker {
	key = "bribery_clown",
	name = "Lucid Dreaming",
	rarity = "fuse_fusion",
	cost = 17,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"mult", "scaling", "tarot", "generation"},
	atlas = "fuseforce_jokers",
	pos = { x = 1, y = 1 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			mult = 0,
			mult_add = 5,
			joker1 = "j_hallucination",
			joker2 = "j_red_card"
    	}
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = { 
    		card.ability.extra.mult,
			card.ability.extra.mult_add, 
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    	end,
    calculate = function(self, card, context)
    	if context.skipping_booster and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_add}},
                        colour = G.C.RED,}) 
                        return true
                    end
			}))
		end
			if context.open_booster then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local tarot = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'hal')
                                tarot:add_to_deck()
                                G.consumeables:emplace(tarot)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)
					}))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                end
            end
            if context.joker_main then
                return {
    				mult = card.ability.extra.mult,
    			}
    		end
    	end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_hallucination" },
		{ name = "j_red_card", carry_stat = "mult" },
	}, cost = 8, result_joker = "j_fuseforce_bribery_clown"
}

SMODS.Joker {
	key = "moorstone",
	name = "Moorstone",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"full_deck", "enhancements", "chips", "generation"},
	atlas = "fuseforce_jokers",
	pos = { x = 2, y = 1 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
			chips_add = 40,
			chips = 0,
			countdown = 2,
			count = 0,
			joker1 = "j_marble",
			joker2 = "j_stone"
    	}
	},
    loc_vars = function(self, info_queue, card)
	info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
    return {
		vars = { 
    		card.ability.extra.chips_add,
			card.ability.extra.chips,
			card.ability.extra.countdown,
			card.ability.extra.count,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.stone_tally = 0
    	    if G.playing_cards then
                for k, v in pairs(G.playing_cards) do
                    if v.config.center == G.P_CENTERS.m_stone then card.ability.stone_tally = card.ability.stone_tally+1 end
                end
            end
    	    card.ability.extra.chips = card.ability.extra.chips_add*(card.ability.stone_tally or 0)
    	end,
    calculate = function(self, card, context)
    	if context.individual and context.cardarea == G.play and
    	context.other_card.ability.effect == 'Stone Card' and not (context.blueprint_card or card).getting_sliced then
    		card.ability.extra.countdown = card.ability.extra.countdown - 1
			card.ability.extra.count = card.ability.extra.count + 1
    		    if card.ability.extra.count >= 2 then
    		        card.ability.extra.count = card.ability.extra.count - 2
    		        card.ability.extra.countdown = card.ability.extra.countdown + 2
    		        G.E_MANAGER:add_event(Event({
                        func = function() 
                            local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                            local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_stone, {playing_card = G.playing_card})
                            card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                            card:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, card)
                            G.hand:emplace(card)
                            return true
                        end
					}))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_stone'), colour = G.C.SECONDARY_SET.Enhanced})
                    playing_card_joker_effects({true})
    		    end
    		end
    		
    		--if context.cardarea == G.jokers and not context.after and not context.before then
			if context.joker_main then
    			card.ability.stone_tally = 0
                for k, v in pairs(G.playing_cards) do
                    if v.config.center == G.P_CENTERS.m_stone then card.ability.stone_tally = card.ability.stone_tally+1 end
                end
                card.ability.extra.chips = card.ability.extra.chips_add*(card.ability.stone_tally or 0)
                if card.ability.stone_tally > 0 then
                    return {
                        message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                        chips = card.ability.extra.chips, 
                        colour = G.C.CHIPS
                    }
                end
    		end
    	end
}		

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_marble" },
		{ name = "j_stone" },
	}, cost = 10, result_joker = "j_fuseforce_moorstone"
}

SMODS.Joker {
	key = "oscar_best_actor",
	name = "Masquerade",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"retrigger", "face"},
	atlas = "fuseforce_jokers",
	pos = { x = 3, y = 1 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			count = 1,
    	    joker1 = "j_sock_and_buskin",
			joker2 = "j_mime"
    	}
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = { 
			card.ability.extra.count,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)	
    	if context.repetition then
			if context.cardarea == G.play then
				--if true or (context.other_card:is_face()) then
				if context.other_card:is_face() then
					return {
 						message = localize('k_again_ex'),
						repetitions = card.ability.extra.count,
						card = card
                    }
                end
            end
            if context.cardarea == G.hand then
                if (next(context.card_effects[1]) or #context.card_effects > 1) then
                    if context.other_card:is_face() then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.count*2,
                            card = card
                        }
                    elseif not context.other_card:is_face() then
                        return {
                            message = localize('k_again_ex'),
                            repetitions = card.ability.extra.count,
                            card = card
                        }
                    end
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_sock_and_buskin" },
		{ name = "j_mime" },
	}, cost = 7, result_joker = "j_fuseforce_oscar_best_actor"
}

SMODS.Joker {
	key = "optimist",
	name = "Optimist",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"hand_size", "discard", "passive", "hands"},
	atlas = "fuseforce_jokers",
	pos = { x = 4, y = 1 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
			hand_size = 2,
			hands = -1,
			discards = 3,
			joker1 = "j_troubadour",
			joker2 = "j_merry_andy"
    	}
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = { 
			card.ability.extra.hand_size,
			card.ability.extra.hands,
			card.ability.extra.discards,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
add_to_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
		ease_hands_played(card.ability.extra.hands)
        ease_discard(card.ability.extra.discards)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
		G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
		ease_hands_played(-1*card.ability.extra.hands)
        ease_discard(-1*card.ability.extra.discards)
        G.hand:change_size(-1*card.ability.extra.hand_size)
    end,
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_troubadour" },
		{ name = "j_merry_andy" },
	}, cost = 7, result_joker = "j_fuseforce_optimist"
}

SMODS.Joker {
	key = "fight_a_bull",
	name = "Horse",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "chips"},
	atlas = "fuseforce_jokers",
	pos = { x = 5, y = 1 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			mult = 0,
			chips = 0,
			mult_add = 2,
			chips_add = 8,
			joker1 = "j_bull",
			joker2 = "j_bootstraps"
    	}
	},
    loc_vars = function(self, info_queue, card)
	card.ability.extra.mult = card.ability.extra.mult_add * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/3))
    card.ability.extra.chips = card.ability.extra.chips_add * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/3))
    return {
		vars = { 
			card.ability.extra.mult,
			card.ability.extra.chips,
			card.ability.extra.mult_add,
			card.ability.extra.chips_add,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
		--if context.cardarea == G.jokers and not context.after and not context.before then
		if context.joker_main then
            card.ability.extra.mult = card.ability.extra.mult_add * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/3))
    		card.ability.extra.chips = card.ability.extra.chips_add * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/3))
                return {
    				--message = localize{type='variable',key='sweet_theatre_combo',vars={card.ability.extra.mult,card.ability.extra.chips}},
    				mult = card.ability.extra.mult,
    				chips = card.ability.extra.chips,
    			}
    		end
    	end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_bull" },
		{ name = "j_bootstraps" },
	}, cost = 9, result_joker = "j_fuseforce_fight_a_bull"
}

SMODS.Joker {
	key = "melancholy_phantom",
	name = "Melancholy Phantom",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"xmult", "chips", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 5 },
	soul_pos = { x = 6, y = 6,
        draw = function(card, scale_mod, rotate_mod)
            card.hover_tilt = card.hover_tilt * 1.5
            card.children.floating_sprite:draw_shader('hologram', nil, card.ARGS.send_to_shader, nil,
                card.children.center, 2 * scale_mod, 2 * rotate_mod)
            card.hover_tilt = card.hover_tilt / 1.5
        end
    },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			x_mult = 1,
			chips = 52,
			joker1 = "j_blue_joker",
			joker2 = "j_hologram"
    	}
	},
    loc_vars = function(self, info_queue, card)
	card.ability.extra.chips = 20 +(card.ability.extra.x_mult*32)
	return {
		vars = { 
			card.ability.extra.x_mult,
			card.ability.extra.chips,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
		--if context.cardarea == G.jokers and not context.after and not context.before then
		if context.joker_main then
            return {
    				--message = localize{type='variable', key='melancholy_phantom', vars={card.ability.extra.x_mult,card.ability.extra.chips}},
    				xmult = card.ability.extra.x_mult,
    				chips = card.ability.extra.chips,
    			}
    		end
		if context.playing_card_added and not card.getting_sliced then
        		if not context.blueprint and not context.retrigger_joker and context.cards and context.cards[1] then
                    card.ability.extra.x_mult = card.ability.extra.x_mult + #context.cards*0.25
                    --card.ability.extra.chips = card.ability.extra.chips + #context.cards*8
                    --card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'melancholy_phantom', vars = {card.ability.extra.x_mult,card.ability.extra.chips}}})
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                end
            end
    	end	
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_blue_joker" },
		{ name = "j_hologram", carry_stat = "x_mult" },
	}, cost = 6, result_joker = "j_fuseforce_melancholy_phantom"
}

SMODS.Joker {
	key = "solar_flare_joker",
	name = "Solar Flare Joker",
	rarity = "fuse_fusion",
	cost = 23,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chance", "hand_type", "discard", "space"},
	atlas = "fuseforce_jokers",
	pos = { x = 7, y = 1 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
			odds = 2,
			joker1 = "j_space",
			joker2 = "j_burnt"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = { 
			''..(G.GAME and G.GAME.probabilities.normal or 1),
			card.ability.extra.odds,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
		if context.pre_discard then
                if pseudorandom('solar_radiation') < G.GAME.probabilities.normal/card.ability.extra.odds and not context.hook then
                local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
                    level_up_hand(context.blueprint_card or card, text, nil, 1)
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                end
            end
    		
    		if context.cardarea == G.jokers  and context.before then
                if pseudorandom('solar_radiation') < G.GAME.probabilities.normal/card.ability.extra.odds then
                    return {
                        card = card,
                        level_up = true,
                        message = localize('k_level_up_ex')
                    }
                end
            end
    	end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_space" },
		{ name = "j_burnt" },
	}, cost = 10, result_joker = "j_fuseforce_solar_flare_joker"
}

SMODS.Joker {
	key = "blue_java",
	name = "Blue Java",
	rarity = "fuse_fusion",
	cost = 17,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "chance", "food", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 8, y = 1 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
			xmult_mod = 1,
			xmult = 7,
			odds = 6,
			joker1 = "j_ice_cream",
			joker2 = "j_cavendish"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = { 
			card.ability.extra.xmult,
			card.ability.extra.xmult_mod,
			''..(G.GAME and G.GAME.probabilities.normal or 1),
			card.ability.extra.odds,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
		--if context.after and not context.blueprint and not context.repetition and not context.individual then
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
		if context.end_of_round and context.game_over == false and not context.repetition and not context.retrigger_joker and not context.blueprint then
                if pseudorandom('hybrid_banana') < G.GAME.probabilities.normal/card.ability.extra.odds then
                    card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_mod
                    if card.ability.extra.xmult < 1 then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('tarot1')
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
                            message = localize('k_eaten_ex'),
                            colour = G.C.FILTER
                        }
                    end
                    return {
                        --message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                        xmult = card.ability.extra.xmult,
                    }
                end
            end
    	end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_ice_cream" },
		{ name = "j_cavendish" },
	}, cost = 8, result_joker = "j_fuseforce_blue_java"
}

SMODS.Joker {
	key = "serial_killer",
	name = "Serial Killer",
	rarity = "fuse_fusion",
	cost = 17,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"xmult", "destroy_card", "sell_value", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 9, y = 1 },
    artist_credits = {'gappie'},
    config = {
		extra = {	
			x_mult_mod = 0.5,
			x_mult = 1,
			mult = 0,
			joker1 = "j_ceremonial",
			joker2 = "j_madness"
    	}
	},
    loc_vars = function(self, info_queue, card)
		if card.ability.extra.mult > 0 then
				card.ability.extra.x_mult = card.ability.extra.mult/5 + card.ability.extra.x_mult
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
			if my_pos and G.jokers.cards[my_pos + 1] and not SMODS.is_eternal(G.jokers.cards[my_pos + 1], card) and not G.jokers.cards[my_pos + 1].getting_sliced then
                local sliced_card = G.jokers.cards[my_pos + 1]
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = (G.GAME.joker_buffer or 0) - 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.joker_buffer = 0
                        card.ability.extra.x_mult = card.ability.extra.x_mult + sliced_card.sell_cost * card.ability.extra.x_mult_mod
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
		{ name = "j_madness", carry_stat = "x_mult" },
	}, cost = 4, result_joker = "j_fuseforce_serial_killer"
}

SMODS.Joker {
	key = "minotaur",
	name = "Minotaur",
	rarity = "fuse_fusion",
	cost = 19,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chips", "scaling", "boss_blind"},
	atlas = "fuseforce_jokers",
	pos = { x = 0, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			chips = 0,
			chips_add = 2,
			joker1 = "j_bull",
			joker2 = "j_matador"
    	}
	},
    loc_vars = function(self, info_queue, card)
    card.ability.extra.chips = card.ability.extra.chips_add * math.max(0, (G.GAME.dollars or 0) + (G.GAME.dollar_buffer or 0))
    return {
		vars = {
			card.ability.extra.chips,
			card.ability.extra.chips_add,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
		if context.joker_main then
    		card.ability.extra.chips = card.ability.extra.chips_add * math.max(0, (G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
                if G.GAME.blind.boss then
                    return {
                        message = 'Boss Fight!',
                        chips = card.ability.extra.chips * 2,
                    }
                    elseif not G.GAME.blind.boss then
                    return {
                        chips = card.ability.extra.chips,
                    }
                end
    	end
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.repetition and not context.retrigger_joker and not context.blueprint then
            card.ability.extra.chips_add = card.ability.extra.chips_add + 2
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
            end
        end,
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_bull" },
		{ name = "j_matador" },
	}, cost = 6, result_joker = "j_fuseforce_minotaur"
}

SMODS.Joker {
	key = "time_keeper",
	name = "Time Keeper",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"discard", "chips", "scaling", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 2, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			chips = 3,
			dollars = 3,
			discards = 0,
            count = 3,
			joker1 = "j_blue_joker",
			joker2 = "j_delayed_grat"
    	},
        immutable = {
            max_discard_size_mod = 1000
        },
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = {
			card.ability.extra.chips,
            card.ability.extra.chips * ((G.deck and G.deck.cards) and #G.deck.cards or 52),
			card.ability.extra.dollars,
            card.ability.extra.discards,
            card.ability.extra.count,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        return G.GAME.current_round.discards_left > 0 and
            G.GAME.current_round.discards_left * card.ability.extra.dollars or nil
    end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                chips = card.ability.extra.chips * #G.deck.cards
            }
        end
        if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.discards_used == 0 then
            card.ability.extra.count = card.ability.extra.count -1
            if card.ability.extra.count <= 0 then
                card.ability.extra.discards = card.ability.extra.discards + 1
                card.ability.extra.count = 3
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(context.blueprint_card or card, "extra", nil, nil, nil, {
                            message = 'Patience',
                            colour = G.C.CHIPS,
                            message_card = card
                        })
                        return true
                    end,
                }))
            end
        end
        if (context.setting_blind and not card.getting_sliced and card.ability.extra.discards>0) or context.forcetrigger then
			G.E_MANAGER:add_event(Event({
				func = function()
					ease_discard(
						math.min(card.ability.immutable.max_discard_size_mod, card.ability.extra.discards)
					)
					return true
				end,
			}))
		end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_blue_joker" },
		{ name = "j_delayed_grat" },
	}, cost = 11, result_joker = "j_fuseforce_time_keeper"
}

SMODS.Joker {
	key = "four_inch_gap",
	name = "Four Inch Gap",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"hand_type", "passive"},
	atlas = "fuseforce_jokers",
	pos = { x = 3, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            selection_size = 1,
			joker1 = "j_four_fingers",
			joker2 = "j_shortcut"
    	}
	},
    add_to_deck = function(self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = (function()
            G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.selection_size
                if SMODS.change_play_limit and SMODS.change_discard_limit then
                    -- future proofing?
                    SMODS.change_play_limit(1)
                    SMODS.change_discard_limit(1)
                end
                return true
            end)
        }))
    end,
	remove_from_deck = function(self, card, from_debuff)
		G.hand:unhighlight_all()
	    G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = (function()
            G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - card.ability.extra.selection_size
                if SMODS.change_play_limit and SMODS.change_discard_limit then
                    -- future proofing?
                    SMODS.change_play_limit(-1)
                    SMODS.change_discard_limit(-1)
                end
                return true
            end)
        }))
    end,
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.selection_size,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
}

local smods_four_fingers_ref = SMODS.four_fingers
    function SMODS.four_fingers(hand_type)
        if next(SMODS.find_card('j_fuseforce_four_inch_gap')) then
            return 4
        end
    return smods_four_fingers_ref(hand_type)
end
local smods_shortcut_ref = SMODS.shortcut
    function SMODS.shortcut()
        if next(SMODS.find_card('j_fuseforce_four_inch_gap')) then
            return true
        end
    return smods_shortcut_ref()
end
--local athr = CardArea.add_to_highlighted
--function CardArea:add_to_highlighted(card, silent)
--	if self.config.type ~= 'shop' and self.config.type ~= 'joker' and self.config.type ~= 'consumeable' and (#SMODS.find_card("j_fuseforce_four_inch_gap") >= 1) then
--		local id = card:get_id()
--		local matches = 0
--		for i = 1, #self.highlighted do
--			if self.highlighted[i]:get_id() == id then
--				matches = matches + 1
--			end
--		end
--		if matches == 0 then
--			self.highlighted[#self.highlighted + 1] = card
--			card:highlight(true)
--			if not silent then play_sound('cardSlide1') end
--			self:parse_highlighted()
--			return
--		end
--	end
--	athr(self, card, silent)
--end
local hover = Card.hover
function Card:hover()
    hover(self)
    if self.config.center_key == 'j_fuseforce_four_inch_gap' and self.T.w == G.CARD_W and self.config.center.discovered then
        ease_value(self.T, 'w', -(self.T.w*0.25), nil, nil, nil, nil, 'elastic')
        --ease_value(self.T, 'h', self.T.h, nil, nil, nil, nil, 'elastic')
    end
end

local stop_hover = Card.stop_hover
function Card:stop_hover()
    stop_hover(self)
    if self.config.center_key == 'j_fuseforce_four_inch_gap' and self.T.w < G.CARD_W and self.config.center.discovered then
        ease_value(self.T, 'w', G.CARD_W - self.T.w)
        --ease_value(self.T, 'h', G.CARD_H - self.T.h)
    end
end

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_four_fingers" },
		{ name = "j_shortcut" },
	}, cost = 8, result_joker = "j_fuseforce_four_inch_gap"
}

local function reset_fuseforce_cavepainting_card()
    G.GAME.current_round.fuseforce_cavepainting_card = { suit = 'Spades' }
    local valid_cavepainting_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_cavepainting_cards[#valid_cavepainting_cards + 1] = playing_card
        end
    end
    local cavepainting_card = pseudorandom_element(valid_cavepainting_cards,
        'fuseforce_cavepainting' .. G.GAME.round_resets.ante)
    if cavepainting_card then
        G.GAME.current_round.fuseforce_cavepainting_card.suit = cavepainting_card.base.suit
    end
end

SMODS.Joker {
	key = "cavepainting",
	name = "Cave Painting",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "hand_type", "suit"},
	atlas = "fuseforce_jokers",
	pos = { x = 4, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            x_mult = 1.5,
            x_mult_flush = 2,
            type = 'Flush',
			joker1 = "j_ancient",
			joker2 = "j_smeared"
    	}
	},
	ability_name = "Cave Painting",
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.fuseforce_cavepainting_card or {}).suit or 'Spades'
		return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.x_mult_flush,
            localize(card.ability.extra.type, 'poker_hands'),
            localize(suit, 'suits_singular'),
            colours = { G.C.SUITS[suit] },
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(G.GAME.current_round.fuseforce_cavepainting_card.suit) then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
        if context.check_enhancement and context.other_card:is_suit(G.GAME.current_round.fuseforce_cavepainting_card.suit) and not context.blueprint and not context.retrigger_joker then
            return {
	            m_wild = true -- make cards function as wild cards
            }
        end
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                x_mult = card.ability.extra.x_mult_flush
            }
        end
    end
}

-- This changes variables globally each round
function SMODS.current_mod.reset_game_globals(run_start)
    reset_fuseforce_cavepainting_card()  -- See Castle
end

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_ancient" },
		{ name = "j_smeared" },
	}, cost = 7, result_joker = "j_fuseforce_cavepainting"
}

SMODS.Joker {
	key = "skipper",
	name = "Skipper",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "joker", "sell_value", "scaling", "skip", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 0, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            x_mult = 1,
            dollars = 2,
			joker1 = "j_swashbuckler",
			joker2 = "j_throwback"
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
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
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
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_swashbuckler" },
		{ name = "j_throwback" },
	}, cost = 8, result_joker = "j_fuseforce_skipper"
}

SMODS.Joker {
	key = "giant_shoulders",
	name = "Two Heads",
	rarity = "fuse_fusion",
	cost = 26,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"copying"},
	atlas = "fuseforce_jokers",
	pos = { x = 5, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            repetitions = 1,
			joker1 = "j_blueprint",
			joker2 = "j_brainstorm"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.repetitions,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
        if context.retrigger_joker_check and context.other_card and Card.is(context.other_card, Card) and (
        context.other_card.config.center.rarity == 5 or context.other_card.config.center.rarity == "fuse_fusion"
        or context.other_card.config.center.rarity == "fuseforce_gold_fusion"
        or context.other_card.config.center.rarity == "tsun_gold_fusion"
        ) then
            return {
                repetitions = card.ability.extra.repetitions,
                card = card,
                message = 'Again!'
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_blueprint" },
		{ name = "j_brainstorm" },
	}, cost = 6, result_joker = "j_fuseforce_giant_shoulders"
}

SMODS.Joker {
	key = "ivy",
	name = "Ivy",
	rarity = "fuse_fusion",
	cost = 19,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "modify_card", "enhancements", "chips", "generation"},
	atlas = "fuseforce_jokers",
	pos = { x = 2, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            x_mult = 1.5,
            chips = 50,
			joker1 = "j_flower_pot",
			joker2 = "j_marble"
    	}
	},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
		return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.chips,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
          if context.setting_blind then
            local stone_card = SMODS.create_card { set = "Base", enhancement = "m_stone", area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            stone_card.playing_card = G.playing_card
            table.insert(G.playing_cards, stone_card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    stone_card:start_materialize({ G.C.SECONDARY_SET.Enhanced })
                    G.play:emplace(stone_card)
                    return true
                end
            }))
            return {
                message = localize('k_plus_stone'),
                colour = G.C.SECONDARY_SET.Enhanced,
                func = function() -- This is for timing purposes, everything here runs after the message
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            return true
                        end
                    }))
                    draw_card(G.play, G.deck, 90, 'up')
                    SMODS.calculate_context({ playing_card_added = true, cards = { stone_card } })
                end
            }
        end
        if context.before and not context.blueprint and not context.retrigger_joker then
            local stones = 0
            local has_edition = card.edition
            for _, scored_card in ipairs(context.scoring_hand) do
                if next(SMODS.get_enhancements(scored_card)) then
                    if SMODS.has_enhancement(scored_card, 'm_stone') then
                        stones = stones + 1
                        --context.scored_card.ability.perma_bonus = (context.scored_card.ability.perma_bonus or 0) + card.ability.extra.chips
                        scored_card:set_ability('m_wild', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
        end
                if stones > 0 then
                    return {
                        message = 'Wild'
                    }
                end
            end
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_wild') then
            return {
                chips = card.ability.extra.chips,
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_flower_pot" },
		{ name = "j_marble" },
	}, cost = 7, result_joker = "j_fuseforce_ivy"
}

SMODS.Joker {
	key = "dye_pack",
	name = "Dye Pack",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"destroy_card", "discard", "hands", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 3, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			hands = 3,
            dollars = 3,
			joker1 = "j_burglar",
			joker2 = "j_trading"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.hands,
			card.ability.extra.dollars,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
  if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_hands_played(card.ability.extra.hands)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } },
                        context.blueprint_card or card)
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
        if context.first_hand_drawn and not context.blueprint and not context.retrigger_joker then
            local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
        end
        
        if context.pre_discard and G.GAME.current_round.discards_used <= 0 then
            return {
                dollars = card.ability.extra.dollars
            }
        end
        if context.discard and not context.blueprint and not context.retrigger_joker then
            return {
                remove = true,
                delay = 0.45
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_burglar" },
		{ name = "j_trading" },
	}, cost = 6, result_joker = "j_fuseforce_dye_pack"
}

SMODS.Joker {
	key = "scratch",
	name = "Scratch",
	rarity = "fuse_fusion",
	cost = 23,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chance", "eight", "tarot", "generation", "rank", "editions"},
	atlas = "fuseforce_jokers",
	pos = { x = 4, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			odds = 8,
            dollars = 8,
			joker1 = "j_vagabond",
			joker2 = "j_8_ball"
    	}
	},
    loc_vars = function(self, info_queue, card)
		local numerator,
        denominator = SMODS.get_probability_vars(card, 2, card.ability.extra.odds, 'scratch')
	return {
		vars = {
			numerator,
			denominator,
            card.ability.extra.dollars,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
    --    if context.before and context.cardarea == G.play then
        if context.before or (context.individual and context.cardarea == G.play and (context.other_card:get_id() == 8)) and G.GAME.dollars <= card.ability.extra.dollars then
            if SMODS.pseudorandom_probability(card, 'scratch', 2, card.ability.extra.odds) then
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Tarot',
                                        edition = 'e_negative',
                                        key_append = 'scratch' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    return true
                                end)
                            }))
                        end
                    },
                }
            else
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    return {
                        extra = {
                            message = localize('k_plus_tarot'),
                            message_card = card,
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            key_append = 'scratch' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                        }
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                end
            end
        end

        if context.before or (context.individual and context.cardarea == G.play and (context.other_card:get_id() == 8)) and G.GAME.dollars > card.ability.extra.dollars then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and SMODS.pseudorandom_probability(card, 'scratch', 2, card.ability.extra.odds) then
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = 'Tarot',
                                        key_append = 'scratch' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    },
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_vagabond" },
		{ name = "j_8_ball" },
	}, cost = 10, result_joker = "j_fuseforce_scratch"
}

SMODS.Joker {
	key = "black_hearted",
	name = "Black Hearted",
	rarity = "fuse_fusion",
	cost = 21,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"xmult", "suit", "hearts", "diamonds", "spades", "clubs", "modify_card", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 7, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 1,
            x_mult_red = 0.2,
			joker1 = "j_vampire",
			joker2 = "j_blackboard"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.x_mult+1,
			card.ability.extra.x_mult_red,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
    if context.before and not context.blueprint and not context.retrigger_joker then
            local hearts = {}
            local diamonds = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_suit("Hearts") and not scored_card.debuff and not scored_card.vampired then
                    hearts[#hearts + 1] = scored_card
                    scored_card.vampired = true
                    assert(SMODS.change_base(scored_card, 'Spades'))
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card.vampired = nil
                            return true
                        end
                    }))
                end
                if scored_card:is_suit("Diamonds") and not scored_card.debuff and not scored_card.vampired then
                    diamonds[#diamonds + 1] = scored_card
                    scored_card.vampired = true
                    assert(SMODS.change_base(scored_card, 'Clubs'))
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card.vampired = nil
                            return true
                        end
                    }))
                end
            end
            if #hearts > 0 or #diamonds > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.x_mult_red * #hearts) + (card.ability.extra.x_mult_red * #diamonds)
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult+1 } },
                    colour = G.C.MULT
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult+1
            }
        end
    end,
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_vampire", carry_stat = "x_mult" },
		{ name = "j_blackboard" },
	}, cost = 8, result_joker = "j_fuseforce_black_hearted"
}

SMODS.Joker {
	key = "cut_and_pasted",
	name = "Cut and Pasted Joker",
	rarity = "fuse_fusion",
	cost = 19,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"joker_slot", "mult", "xmult", "retrigger", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 4, y = 4 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			mult = 1,
			mult_gain = 1,
			joker1 = "j_hanging_chad",
			joker2 = "j_stencil"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.mult,
			card.ability.extra.mult_gain,
            G.jokers and math.max(1, (G.jokers.config.card_limit - #G.jokers.cards) + #SMODS.find_card("j_fuseforce_cut_and_pasted", true)) or 1,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if context.joker_main then
            return {
                x_mult = math.max(1,
                    (G.jokers.config.card_limit - #G.jokers.cards) + #SMODS.find_card("j_fuseforce_cut_and_pasted", true)
                )
            }
        end
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
            return {
                mult = card.ability.extra.mult,
                --repetitions = card.ability.extra.repetitions
                repetitions = math.max(1,
                    (G.GAME.starting_params.play_limit - #G.play.cards)
            )
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_hanging_chad" },
		{ name = "j_stencil" },
	}, cost = 7, result_joker = "j_fuseforce_cut_and_pasted"
}

SMODS.Joker {
	key = "alloy",
	name = "Alloy Joker",
	rarity = "fuse_fusion",
	cost = 13,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "enhancements", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 1, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 1.5,
			dollars = 3,
			joker1 = "j_ticket",
			joker2 = "j_steel_joker"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.dollars,
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
end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_ticket" },
		{ name = "j_steel_joker" },
	}, cost = 6, result_joker = "j_fuseforce_alloy"
}

SMODS.Joker {
	key = "midas_hand",
	name = "Midas Hand",
	rarity = "fuse_fusion",
	cost = 23,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "hand_size", "rank", "king", "modify_card", "enhancements", "face"},
	atlas = "fuseforce_jokers",
	pos = { x = 2, y = 4 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 1.5,
			hand_size = 1,
			hand_size_buffer = 0,
			joker1 = "j_midas_mask",
			joker2 = "j_baron"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local midas_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_gold') and playing_card:get_id() == 13 then
                    midas_tally = midas_tally + 1
                end
            end
        end
	return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.hand_size,
            card.ability.extra.hand_size * math.max(0,math.floor(midas_tally/3)),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size_buffer)
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 13 then
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
        if context.before and not context.blueprint and not context.retrigger_joker then
            local faces = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    faces = faces + 1
                    scored_card:set_ability('m_gold', nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if faces > 0 then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY
                }
            end
        end
        if context.joker_main and not context.blueprint and not context.retrigger_joker then
            local midas_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_gold') and playing_card:get_id() == 13 then
                    midas_tally = midas_tally + 1
                end
            end
            if card.ability.extra.hand_size_buffer ~= card.ability.extra.hand_size * math.max(0,math.floor(midas_tally/3)) then
                G.hand:change_size(-card.ability.extra.hand_size_buffer)
                card.ability.extra.hand_size_buffer = (card.ability.extra.hand_size * math.max(0,math.floor(midas_tally/3)))
                return {
                    G.hand:change_size(card.ability.extra.hand_size * math.max(0,math.floor(midas_tally/3)))
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_midas_mask" },
		{ name = "j_baron" },
	}, cost = 8, result_joker = "j_fuseforce_midas_hand"
}

SMODS.Joker {
	key = "stew_and_dumplings",
	name = "Stew and Dumplings",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "food", "discard", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 3, y = 4 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 2,
			x_mult_mod = 0.01,
			joker1 = "j_ramen",
			joker2 = "j_mystic_summit"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.x_mult_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.discard and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult_mod } },
                colour = G.C.RED,
                delay = 0.2
            }
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
		{ name = "j_ramen", carry_stat = "x_mult" },
		{ name = "j_mystic_summit" },
	}, cost = 6, result_joker = "j_fuseforce_stew_and_dumplings"
}

SMODS.Joker {
	key = "water_bottle",
	name = "Dry Jokes are Thirsty Work",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"two", "three", "four", "five", "rank", "retrigger", "food", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 9, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			repetitions = 2,
			hands_left = 50,
			joker1 = "j_hack",
			joker2 = "j_selzer"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local hack = 0
	return {
		vars = {
			card.ability.extra.repetitions,
			card.ability.extra.hands_left,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.before and not context.blueprint and not context.retrigger_joker then
            hack = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() <= 5 and not SMODS.has_no_rank(scored_card) and not scored_card.debuff then
                    hack = 1
                end
            end
            if hack > 0 then
                return {
                    message = 'dry',
                    colour = G.C.CHIPS
                }
            end
        end

        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
        if context.after and not context.blueprint and hack == 0 then
            if card.ability.extra.hands_left - #context.full_hand <= 0 then
                card_eval_status_text(card,'extra', nil, nil, nil, {message = localize('k_drank_ex')})
                card.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function() 
                        --local edition = card.edition and card.edition.key or nil
                        --local stickers = {}
                        --for k, v in pairs(SMODS.Stickers) do
                        --    if card.ability[k] then
                        --        table.insert(stickers, k)
                        --    end
                        --end
                        card:start_dissolve()
                        --local new_joker = SMODS.create_card({area = G.jokers, set = 'Joker', key = 'j_hack', edition = edition, stickers = stickers})
                        --new_joker:add_to_deck()
                        --G.jokers:emplace(new_joker)
                        --new_joker:start_materialize()
                        return true
                end}))
            else
                card.ability.extra.hands_left = card.ability.extra.hands_left - #context.full_hand
                return {
                    message = card.ability.extra.hands_left .. '',
                    colour = G.C.CHIPS
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_hack", },
		{ name = "j_selzer" },
	}, cost = 10, result_joker = "j_fuseforce_water_bottle"
}

SMODS.Joker {
    key = "kintsugi",
    name = "Kintsugi",
    rarity = "fuse_fusion",
    cost = 20,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "suit", "full_deck", "enhancements"},
    atlas = "fuseforce_jokers",
    pos = {x = 8, y = 2},
    artist_credits = {'Minus'},
    config = {
		extra = {
            xmult = 1.5,
            xmult_mod = 0.2,
            joker1 = "j_flower_pot", 
            joker2 = "j_seeing_double"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local wild_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_wild') then
                    wild_tally = wild_tally + 1
                end
            end
        end
	return {
		vars = {
            card.ability.extra.xmult,
            card.ability.extra.xmult_mod,
            1 + card.ability.extra.xmult_mod * wild_tally,
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
        if context.joker_main then
            local wild_tally = 0
                for _, playing_card in ipairs(G.playing_cards) do
                    if SMODS.has_enhancement(playing_card, 'm_wild') then
                        wild_tally = wild_tally + 1
                    end
                end
            --if #context.scoring_hand > 1 then
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
			--end
			if suits['Hearts'] and suits['Diamonds'] and suits['Spades'] and suits['Clubs'] then
				return {
					xmult = card.ability.extra.xmult * 4 + card.ability.extra.xmult_mod * wild_tally
				}
			elseif (suits['Spades'] and suits['Clubs'] and suits['Hearts'] and not suits['Diamonds']) or (suits['Diamonds'] and suits['Clubs'] and suits['Hearts'] and not suits['Spades']) or (suits['Spades'] and suits['Clubs'] and suits['Diamonds'] and not suits['Hearts']) or (suits['Diamonds'] and suits['Spades'] and suits['Hearts'] and not suits['Clubs']) then
				return {
					xmult = card.ability.extra.xmult * 3 + card.ability.extra.xmult_mod * wild_tally
				}
			elseif (suits['Hearts'] and suits['Diamonds'] and not suits['Spades'] and not suits['Clubs']) or (suits['Spades'] and suits['Clubs'] and not suits['Hearts'] and not suits['Diamonds']) or (suits['Hearts'] and suits['Spades'] and not suits['Clubs'] and not suits['Diamonds']) or (suits['Spades'] and suits['Diamonds'] and not suits['Hearts'] and not suits['Clubs']) or (suits['Hearts'] and suits['Clubs'] and not suits['Spades'] and not suits['Diamonds']) or (suits['Clubs'] and suits['Diamonds'] and not suits['Hearts'] and not suits['Spades']) then
				return {
					xmult = card.ability.extra.xmult * 2 + card.ability.extra.xmult_mod * wild_tally
				}
			elseif (suits['Hearts'] and not suits['Clubs'] and not suits['Spades'] and not suits['Diamonds']) or (suits['Diamonds'] and not suits['Clubs'] and not suits['Hearts'] and not suits['Spades']) or (suits['Spades'] and not suits['Clubs'] and not suits['Diamonds'] and not suits['Hearts']) or (suits['Clubs'] and not suits['Spades'] and not suits['Hearts'] and not suits['Diamonds']) then
				return {
					xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod * wild_tally
				}
			else
                return {
                    xmult = 1 + card.ability.extra.xmult_mod * wild_tally
                }
            end
		end
    end
}

FusionJokers.fusions:register_fusion {
    jokers = {
        { name = "j_flower_pot" },
        { name = "j_seeing_double"}
    }, cost = 8, result_joker = "j_fuseforce_kintsugi"
}

SMODS.Joker {
    key = "greener_joker",
    name = "Greener Joker",
    rarity = "fuse_fusion",
    cost = 20,
	unlocked = true,
	discovered = false,
    blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "suit", "discard", "scaling"},
    atlas = "fuseforce_jokers",
    pos = {x = 7, y = 3},
    artist_credits = {'Minus'},
    config = {
		extra = {
            mult = 0,
            mult_mod = 5,
            joker1 = "j_flower_pot", 
            joker2 = "j_green_joker"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.mult,
            card.ability.extra.mult_mod,
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
        if context.before and not context.blueprint and not context.retrigger_joker then
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
			if suits['Hearts'] and suits['Diamonds'] and suits['Spades'] and suits['Clubs'] then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * 4
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * 4 } }
            }
			elseif (suits['Spades'] and suits['Clubs'] and suits['Hearts'] and not suits['Diamonds']) or (suits['Diamonds'] and suits['Clubs'] and suits['Hearts'] and not suits['Spades']) or (suits['Spades'] and suits['Clubs'] and suits['Diamonds'] and not suits['Hearts']) or (suits['Diamonds'] and suits['Spades'] and suits['Hearts'] and not suits['Clubs']) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * 3
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * 3 } }
            }
			elseif (suits['Hearts'] and suits['Diamonds'] and not suits['Spades'] and not suits['Clubs']) or (suits['Spades'] and suits['Clubs'] and not suits['Hearts'] and not suits['Diamonds']) or (suits['Hearts'] and suits['Spades'] and not suits['Clubs'] and not suits['Diamonds']) or (suits['Spades'] and suits['Diamonds'] and not suits['Hearts'] and not suits['Clubs']) or (suits['Hearts'] and suits['Clubs'] and not suits['Spades'] and not suits['Diamonds']) or (suits['Clubs'] and suits['Diamonds'] and not suits['Hearts'] and not suits['Spades']) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * 2
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * 2 } }
            }
			elseif (suits['Hearts'] and not suits['Clubs'] and not suits['Spades'] and not suits['Diamonds']) or (suits['Diamonds'] and not suits['Clubs'] and not suits['Hearts'] and not suits['Spades']) or (suits['Spades'] and not suits['Clubs'] and not suits['Diamonds'] and not suits['Hearts']) or (suits['Clubs'] and not suits['Spades'] and not suits['Hearts'] and not suits['Diamonds']) then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * 1
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * 1 } }
            }
			end
        end
        if context.discard and context.other_card == context.full_hand[#context.full_hand] and not context.blueprint and not context.retrigger_joker and card.ability.extra.mult > 0 then
			local suits = {}
                for _, _card in pairs(context.full_hand) do
                    suits[not SMODS.has_no_suit(_card) and _card.base.suit] = true
                    if SMODS.has_any_suit(_card) and not SMODS.has_enhancement(_card, 'm_wild') then
                        suits['Hearts'] = true
                        suits['Diamonds'] = true
                        suits['Spades'] = true
                        suits['Clubs'] = true
                    end
                end
			if suits['Hearts'] and suits['Diamonds'] and suits['Spades'] and suits['Clubs'] then
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod * 4
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod * 4 } }
            }
			elseif (suits['Spades'] and suits['Clubs'] and suits['Hearts'] and not suits['Diamonds']) or (suits['Diamonds'] and suits['Clubs'] and suits['Hearts'] and not suits['Spades']) or (suits['Spades'] and suits['Clubs'] and suits['Diamonds'] and not suits['Hearts']) or (suits['Diamonds'] and suits['Spades'] and suits['Hearts'] and not suits['Clubs']) then
				card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod * 3
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod * 3 } }
            }
			elseif (suits['Hearts'] and suits['Diamonds'] and not suits['Spades'] and not suits['Clubs']) or (suits['Spades'] and suits['Clubs'] and not suits['Hearts'] and not suits['Diamonds']) or (suits['Hearts'] and suits['Spades'] and not suits['Clubs'] and not suits['Diamonds']) or (suits['Spades'] and suits['Diamonds'] and not suits['Hearts'] and not suits['Clubs']) or (suits['Hearts'] and suits['Clubs'] and not suits['Spades'] and not suits['Diamonds']) or (suits['Clubs'] and suits['Diamonds'] and not suits['Hearts'] and not suits['Spades']) then
				card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod * 2
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod * 2 } }
            }
			elseif (suits['Hearts'] and not suits['Clubs'] and not suits['Spades'] and not suits['Diamonds']) or (suits['Diamonds'] and not suits['Clubs'] and not suits['Hearts'] and not suits['Spades']) or (suits['Spades'] and not suits['Clubs'] and not suits['Diamonds'] and not suits['Hearts']) or (suits['Clubs'] and not suits['Spades'] and not suits['Hearts'] and not suits['Diamonds']) then
				card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod * 1
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod * 1 } }
            }
			end
        end
        if context.drawing_cards and card.ability.extra.mult <= 0 then
            card.ability.extra.mult = 0
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
        { name = "j_flower_pot" },
        { name = "j_green_joker", carry_stat = "mult"}
    }, cost = 8, result_joker = "j_fuseforce_greener_joker"
}

SMODS.Joker {
	key = "paranormal",
	name = "Paranormal Joker",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "xmult", "tarot", "spectral", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 5, y = 4 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			mult_mod = 2,
			xmult_mod = 0.4,
			joker1 = "j_fortune_teller",
			joker2 = "j_sixth_sense"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.mult_mod,
            card.ability.extra.mult_mod * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0),
			card.ability.extra.xmult_mod,
            1 + card.ability.extra.xmult_mod * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            if context.consumeable.ability.set == "Tarot" then
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { G.GAME.consumeable_usage_total.tarot * card.ability.extra.mult_mod } },
                }
            elseif context.consumeable.ability.set == "Spectral" then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { 1 + (G.GAME.consumeable_usage_total.spectral * card.ability.extra.xmult_mod) } },
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult_mod * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0),
                xmult = 1 + card.ability.extra.xmult_mod * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0)
            }
        end
    end,
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_fortune_teller", },
		{ name = "j_sixth_sense" },
	}, cost = 8, result_joker = "j_fuseforce_paranormal"
}

SMODS.Joker {
	key = "black_soul",
	name = "Black Soul",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"ace", "hand_type", "tarot", "spectral", "generation", "rank"},
	atlas = "fuseforce_jokers",
	pos = { x = 5, y = 5 },
    soul_pos = { x = 5, y = 6 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			poker_hand1 = 'Straight Flush',
			poker_hand2 = 'Straight',
			joker1 = "j_superposition",
			joker2 = "j_seance"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			localize(card.ability.extra.poker_hand1, 'poker_hands'),
			localize(card.ability.extra.poker_hand2, 'poker_hands'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.joker_main and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local ace_check = false
            local royal_check = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:get_id() == 14 then
                    ace_check = true
                end
                if context.scoring_hand[i]:get_id() == 13 or context.scoring_hand[i]:get_id() == 12 then
                    royal_check = true
                    break
                end
            end
            if ace_check and royal_check and next(context.poker_hands[card.ability.extra.poker_hand1]) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                if SMODS.pseudorandom_probability(card, 'fuseforce_black_soul', 1, 4) then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                key = 'c_soul',
                                key_append = 'fuseforce_black_soul' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                key = 'c_black_hole',
                                key_append = 'fuseforce_black_soul' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                end
                return {
                    message = 'Black Soul',
                    colour = G.C.RARITY.Legendary,
                }
            elseif next(context.poker_hands[card.ability.extra.poker_hand1]) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'fuseforce_black_soul' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            elseif ace_check and next(context.poker_hands[card.ability.extra.poker_hand2]) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'fuseforce_black_soul' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_superposition", },
		{ name = "j_seance" },
	}, cost = 9, result_joker = "j_fuseforce_black_soul"
}
--Minus here, I entirely stole Maratby's code. Comment text after this line is also stolen from Maratby.
---List of Cryptid Stake Keys, allows the sticker_inquisition function to default to Gold if Splash's Stake Sticker is any Cryptid Stake
---I am not doing this for other mods. Cryptid's Stakes are all above Gold (tmk) and the mod is popular enough to add support for it.
Gtsun_Cryptid_Stakelist = {
	"pink",
	"brown",
	"yellow",
	"jade",
	"cyan",
	"gray",
	"crimson",
	"diamond",
	"amber",
	"bronze",
	"quartz",
	"ruby",
	"glass",
	"sapphire",
	"emerald",
	"platinum",
	"verdant",
	"ember",
	"dawn",
	"horizon",
	"blossom",
	"azure",
	"ascendant",

	---Sometimes they have the cry_ prefix so I'm adding both to cover all bases
	"cry_pink",
	"cry_brown",
	"cry_yellow",
	"cry_jade",
	"cry_cyan",
	"cry_gray",
	"cry_crimson",
	"cry_diamond",
	"cry_amber",
	"cry_bronze",
	"cry_quartz",
	"cry_ruby",
	"cry_glass",
	"cry_sapphire",
	"cry_emerald",
	"cry_platinum",
	"cry_verdant",
	"cry_ember",
	"cry_dawn",
	"cry_horizon",
	"cry_blossom",
	"cry_azure",
	"cry_ascendant"
}
---NOBODY EXPECTS THE STICKER INQUISITION
---Returns a sticker rank value which lets me check if the sticker for said center is above a certain stake rather than being equal to a certain stake
function sticker_inquisition(the_center)
	local sticker = get_joker_win_sticker(the_center)
	local rank = 0
	if sticker == "white" then
		rank = 1
	elseif sticker == "red" then
		rank = 2
	elseif sticker == "green" then
		rank = 3
	elseif sticker == "black" then
		rank = 4
	elseif sticker == "blue" then
		rank = 5
	elseif sticker == "purple" then
		rank = 6
	elseif sticker == "orange" then
		rank = 7
	elseif sticker == "gold" then
		rank = 8
	end
	for index, value in pairs(Gtsun_Cryptid_Stakelist) do
		if sticker == value then
			rank = 8
		end
	end
	return rank
end

-- Minus here again! Okay now this bit of code here is stolen from Ortalab.
-- Function modifies the amount of joker slots with an animation

function modify_joker_slot_count(amount)
    G.CONTROLLER.locks.no_space = true
    G.jokers.config.card_limit = G.jokers.config.card_limit + amount
    attention_text({scale = 0.9, text = localize(amount > 0 and 'fuseforce_joker_slot' or 'fuseforce_joker_slot_minus'), hold = 0.9, align = 'cm',
        cover = G.jokers, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.2)})
    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:juice_up(0.15)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.06*G.SETTINGS.GAMESPEED,
        blockable = false,
        blocking = false,
        func = function() play_sound('negative', 0.76, 0.4); return true end
    }))
    play_sound('tarot2', 1, 0.4)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = 0.5*G.SETTINGS.GAMESPEED, 
        blockable = false, 
        blocking = false,
        func = function() G.CONTROLLER.locks.no_space = nil; return true end
    }))
end

-- and for consumables
function modify_consumable_slot_count(amount)
    G.CONTROLLER.locks.no_space = true
    G.consumeables.config.card_limit = G.consumeables.config.card_limit + amount
    --attention_text({scale = 0.9, text = (amount>0 and '+' or '') .. amount .. localize((amount > 1 or amount < -1) and 'fuseforce_consumable_slots' or 'fuseforce_consumable_slot'), hold = 0.9, align = 'cm',
    attention_text({scale = 0.9, text = localize(amount > 0 and 'fuseforce_consumable_slot' or 'fuseforce_consumable_slot_minus'), hold = 0.9, align = 'cm',
        cover = G.consumeables, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.2)})
    for i = 1, #G.consumeables.cards do
        G.consumeables.cards[i]:juice_up(0.15)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.06*G.SETTINGS.GAMESPEED,
        blockable = false,
        blocking = false,
        func = function() play_sound('whoosh1', 0.76, 0.4); return true end
    }))
    play_sound('tarot2', 1, 0.4)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = 0.5*G.SETTINGS.GAMESPEED, 
        blockable = false, 
        blocking = false,
        func = function() G.CONTROLLER.locks.no_space = nil; return true end
    }))
end

SMODS.Joker {
	key = "bargaining_chips",
	name = "Bargaining Chips",
	rarity = "fuse_fusion",
	cost = 16,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"joker_slot", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 4 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			count = 6,
			raise = 0,
			slots = 1,
		    stickerkey = "none",
		    sticker = 0,
			joker1 = "j_mr_bones",
			joker2 = "j_loyalty_card"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.count,
			card.ability.extra.raise,
			card.ability.extra.slots,
            card.ability.extra.stickerkey,
            math.max(0,math.floor((card.ability.extra.sticker) / 2.3)),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.extra.sticker = sticker_inquisition(G.P_CENTERS.j_fuseforce_bargaining_chips)
		card.ability.extra.stickerkey = get_joker_win_sticker(G.P_CENTERS.j_fuseforce_bargaining_chips)
	end,
    add_to_deck = function (self, card, from_debuff)
        modify_joker_slot_count(1)
        if card.ability.extra.sticker == 3 or card.ability.extra.sticker == 4 then
			card.ability.extra.count = card.ability.extra.count - 1
        elseif card.ability.extra.sticker == 5 or card.ability.extra.sticker == 6 then
			card.ability.extra.count = card.ability.extra.count - 2
        elseif card.ability.extra.sticker == 7 or card.ability.extra.sticker == 8 then
			card.ability.extra.count = card.ability.extra.count - 3
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        modify_joker_slot_count(-card.ability.extra.slots)
    end,
	calculate = function(self, card, context)
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if G.GAME.chips / G.GAME.blind.chips >= 1.25 then -- See note about Talisman compatibility on the wiki
                if card.ability.extra.raise >= card.ability.extra.count - 1 then
                    modify_joker_slot_count(1)
                    card.ability.extra.slots = card.ability.extra.slots + 1
                    card.ability.extra.raise = 0
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('negative')
                            --card:start_dissolve()
                            return {
                                message = 'I bet my soul!',
                                colour = G.C.DARK_EDITION
                            }
                        end
                    }))
                else
                    card.ability.extra.raise = card.ability.extra.raise + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('chips2')
                            --card:start_dissolve()
                            return {
                                message = 'Raise',
                                colour = G.C.DARK_EDITION
                            }
                        end
                    }))
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_mr_bones", },
		{ name = "j_loyalty_card" },
	}, cost = 6, result_joker = "j_fuseforce_bargaining_chips"
}

SMODS.Joker {
	key = "giant_beanstalk",
	name = "Giant Beanstalk",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "jack", "discard", "reset", "rank", "hand_size", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 7, y = 4 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			xmult = 1,
            xmult_mod = 0.5,
			hand_size = 0,
			joker1 = "j_turtle_bean",
			joker2 = "j_hit_the_road"
    	}
	},
    loc_vars = function(self, info_queue, card)
        local jacked = {}
	return {
		vars = {
			card.ability.extra.xmult,
            card.ability.extra.xmult_mod,
			card.ability.extra.hand_size,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
	calculate = function(self, card, context)
        if context.discard and not context.blueprint and not context.retrigger_joker and
            not context.other_card.debuff and context.other_card:get_id() == 11 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            card.ability.extra.hand_size = card.ability.extra.hand_size + 1
            G.hand:change_size(1)
            jacked = 1
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                colour = G.C.RED,
                delay = 0.45
            }
        end
        if context.drawing_cards and jacked == 1 and not context.blueprint and not context.retrigger_joker then
            jacked = 0
            G.E_MANAGER:add_event(Event({
				func = function()
					ease_discard(1)
					return true
				end,
			}))
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker and card.ability.extra.xmult > 1 then
            card.ability.extra.xmult = 1
            G.hand:change_size(-card.ability.extra.hand_size)
            card.ability.extra.hand_size = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_turtle_bean", },
		{ name = "j_hit_the_road" },
	}, cost = 8, result_joker = "j_fuseforce_giant_beanstalk"
}

SMODS.Joker {
	key = "smurf",
	name = "Smurf Joker",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	attributes = {"two", "chips", "xchips", "rank", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 8, y = 4 },
    display_size = { w = 71 * 0.7, h = 95 * 0.7 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			chips = 0,
            chips_mod = 12,
			chips_deck = 0.2,
			joker1 = "j_wee",
			joker2 = "j_blue_joker"
    	}
	},
    loc_vars = function(self, info_queue, card)
        local two_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 2 then
                    two_tally = two_tally + 1
                end
            end
        end
	return {
		vars = {
			card.ability.extra.chips,
            card.ability.extra.chips_mod,
			card.ability.extra.chips_deck,
            1 + card.ability.extra.chips_deck * two_tally,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                message_card = card
            }
        end
        if context.joker_main then
            local two_tally = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 2 and not context.blueprint and not context.retrigger_joker then
                    two_tally = two_tally + 1
                end
            end
            return {
                chips = card.ability.extra.chips,
                xchips = 1 + card.ability.extra.chips_deck * two_tally
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_wee", carry_stat = "chips" },
		{ name = "j_blue_joker" },
	}, cost = 9, result_joker = "j_fuseforce_smurf"
}

SMODS.Joker {
	key = "fused",
	name = "Amalgamult",
	rarity = "fuse_fusion",
	cost = 14,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"chance", "mult", "xmult", "chips", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 2 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			joker1 = "j_joker",
			joker2 = "j_misprint"
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
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, 'fused', 1, 4, 'fused_joker', true) then
                return {
                    chips = 8
                }
            elseif SMODS.pseudorandom_probability(card, 'fused', 1, 3, 'fused_joker', true) then
                return {
                    mult = 6
                }
            elseif SMODS.pseudorandom_probability(card, 'fused', 1, 2, 'fused_joker', true) then
                return {
                    dollars = 4
                }
            else
                return {
                    xmult = 2
                }
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_joker" },
		{ name = "j_misprint" },
	}, cost = 8, result_joker = "j_fuseforce_fused"
}

SMODS.Joker {
	key = "card_collection",
	name = "Card Collection",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"joker", "generation"},
	atlas = "fuseforce_jokers",
	pos = { x = 9, y = 4 },
    artist_credits = {'Minus'},
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    config = {
		extra = {
			creates_uncommon = 2,
            creates_rare = 1,
			joker1 = "j_riff_raff",
			joker2 = "j_baseball"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.creates_uncommon,
            card.ability.extra.creates_rare,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(card.ability.extra.creates_uncommon,
                G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            --if G.jokers.config.card_limit == #G.jokers.cards + G.GAME.joker_buffer + 1 then
            if G.GAME.blind.boss then
                G.GAME.joker_buffer = G.GAME.joker_buffer + card.ability.extra.creates_rare
                G.E_MANAGER:add_event(Event({
                    func = function()
                        --for _ = 1, jokers_to_create do
                            SMODS.add_card {
                                set = 'Joker',
                                rarity = 'Rare',
                                key_append = 'card_collection' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.joker_buffer = 0
                        --end
                        return true
                    end
                }))
            else
                G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _ = 1, jokers_to_create do
                            SMODS.add_card {
                                set = 'Joker',
                                rarity = 'Uncommon',
                                key_append = 'card_collection' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                            }
                            G.GAME.joker_buffer = 0
                        end
                        return true
                    end
                }))
            end
            return {
                message = localize('k_plus_joker'),
                colour = G.C.BLUE,
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_riff_raff" },
		{ name = "j_baseball" },
	}, cost = 8, result_joker = "j_fuseforce_card_collection"
}

SMODS.Joker {
	key = "chancer",
	name = "Chancer",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mod_chance", "full_deck", "six", "nine", "rank", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 8, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			dollars = 1,
            chance = 2,
            six_nine = 0,
			joker1 = "j_cloud_9",
			joker2 = "j_oops"
    	}
	},
    loc_vars = function(self, info_queue, card)
        local six_nine_tally = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_id() == 6 or playing_card:get_id() == 9 then
                    six_nine_tally = six_nine_tally + 1
                end
            end
        end
	return {
		vars = {
			card.ability.extra.dollars,
            card.ability.extra.dollars * six_nine_tally,
            localize{type = 'variable', key = (card.ability.extra.six_nine == 1 and 'chancer_active' or 'chancer_inactive')},
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        local six_nine_tally = 0
        for _, playing_card in ipairs(G.playing_cards) do
            if playing_card:get_id() == 6 or playing_card:get_id() == 9 then
                six_nine_tally = six_nine_tally + 1
            end
        end
        return six_nine_tally > 0 and card.ability.extra.dollars * six_nine_tally or nil
    end,
	calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint and not context.retrigger_joker then
            return {
                numerator = context.numerator * (card.ability.extra.chance + card.ability.extra.six_nine)
            }
        end
        if context.after and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.six_nine = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 6 or scored_card:get_id() == 9 then
                    card.ability.extra.six_nine = 1
                end
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_cloud_9" },
		{ name = "j_oops" },
	}, cost = 9, result_joker = "j_fuseforce_chancer"
}

SMODS.Joker {
	key = "sticker",
	name = "Sticker Joker",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "modify_card", "passive", "face"},
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 1 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 1.5,
			joker1 = "j_pareidolia",
			joker2 = "j_photograph"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.x_mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card ~= context.scoring_hand[1] then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_pareidolia" },
		{ name = "j_photograph" },
	}, cost = 12, result_joker = "j_fuseforce_sticker"
}

SMODS.Joker {
	key = "golden_calf",
	name = "Golden Calf",
	rarity = "fuse_fusion",
	cost = 21,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"xmult", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 5, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 1,
            x_mult_mod = 0.25,
			joker1 = "j_golden",
			joker2 = "j_campfire"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.x_mult_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.selling_card and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            return {
                message = localize('k_upgrade_ex')
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.x_mult > 1 then
                card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.x_mult_mod
                return {
                    message = '"More!"',
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
		{ name = "j_golden" },
		{ name = "j_campfire", carry_stat = "x_mult" },
	}, cost = 6, result_joker = "j_fuseforce_golden_calf"
}

SMODS.Joker {
	key = "shadowman",
	name = "Shadowman",
	rarity = "fuse_fusion",
	cost = 18,
	unlocked = true,
	discovered = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"passive", "editions"},
	atlas = "fuseforce_jokers",
	pos = { x = 1, y = 2 },
    artist_credits = {'Minus'},
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    config = {
		extra = {
			joker1 = "j_ring_master",
			joker2 = "j_invisible"
    	},
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
        if context.modify_shop_card and not context.blueprint and not context.retrigger_joker then
            local shop_card = context.card
            if shop_card and not shop_card.edition and shop_card.ability.set == 'Joker' then
                for _, owned in ipairs(G.jokers.cards) do
                    if (owned and owned.config and owned.config.center and shop_card.config.center.key == owned.config.center.key) or
                    (owned and owned.config and owned.config.center and not string.find(owned.config.center.key, "j_tsun_", 1, true) and
                    (owned.config.center.config.rarity == 5
                    or owned.config.center.rarity == "fuse_fusion"
                    or owned.config.center.rarity == "fuseforce_gold_fusion"
                    or owned.config.center.rarity == "tsun_gold_fusion")
                    and (
                    shop_card.config.center.key == owned.ability.extra.joker1
                    or shop_card.config.center.key == owned.ability.extra.joker2
                    or shop_card.config.center.key == owned.ability.extra.joker3)) then
                        shop_card:set_edition("e_negative", true)
                        shop_card.ability.couponed = true
                        shop_card:set_cost()
                        return true
                    end
                end
            end
        end
    end
}

local smods_showman_ref = SMODS.showman
function SMODS.showman(card_key)
    if next(SMODS.find_card('j_fuseforce_shadowman')) then
        return true
    end
    return smods_showman_ref(card_key)
end

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_ring_master" },
		{ name = "j_invisible" },
	}, cost = 5, result_joker = "j_fuseforce_shadowman"
}

SMODS.Joker {
	key = "gargoyle",
	name = "Gargoyle",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"full_deck", "mult", "xmult", "enhancements"},
	atlas = "fuseforce_jokers",
	pos = { x = 9, y = 3 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			mult = 1,
			x_mult = 2,
			joker1 = "j_idol",
			joker2 = "j_stone"
    	}
	},
    loc_vars = function(self, info_queue, card)
	local stone_tally = 0
    if G.playing_cards then
        for _, playing_card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                stone_tally = stone_tally + 1
            end
        end
    end
    return {
		vars = { 
    		card.ability.extra.mult,
			card.ability.extra.mult * stone_tally,
			card.ability.extra.x_mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
    	if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_stone') then
	    local stone_tally = 0
    		for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_stone') then
                    stone_tally = stone_tally + 1
                end
            end
        return {
            mult = card.ability.extra.mult * stone_tally,
            x_mult = card.ability.extra.x_mult
        }
        end
    end
}		

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_idol" },
		{ name = "j_stone" },
	}, cost = 8, result_joker = "j_fuseforce_gargoyle"
}

SMODS.Joker {
	key = "ratio_road",
	name = "Ratio Road",
	rarity = "fuse_fusion",
	cost = 25,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"ace", "two", "three", "five", "eight", "rank", "mult", "xmult", "full_deck", "enhancements"},
	atlas = "fuseforce_jokers",
	pos = { x = 0, y = 8 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			mult = 1,
			x_mult = 1,
			joker1 = "j_drivers_license",
			joker2 = "j_fibonacci"
    	}
	},
    loc_vars = function(self, info_queue, card)
	local enhanced_tally = 0
    for _, playing_card in pairs(G.playing_cards or {}) do
        if next(SMODS.get_enhancements(playing_card)) then
                enhanced_tally = enhanced_tally + 1
        end
    end
    return {
		vars = { 
    		card.ability.extra.mult,
			card.ability.extra.mult * enhanced_tally,
			card.ability.extra.x_mult,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
    	if context.individual and context.cardarea == G.play then
	        local enhanced_tally = 0
            for _, playing_card in pairs(G.playing_cards) do
                if next(SMODS.get_enhancements(playing_card)) then
                    enhanced_tally = enhanced_tally + 1
                end
            end
            if context.other_card:get_id() == 2 or
                context.other_card:get_id() == 3 or
                context.other_card:get_id() == 5 or
                context.other_card:get_id() == 8 or
                context.other_card:get_id() == 14 then
                return {
                    mult = card.ability.extra.mult * enhanced_tally
                }
            end
        end
        if context.joker_main then
	        local enhanced_tally = 0
            for _, playing_card in pairs(G.playing_cards) do
                if next(SMODS.get_enhancements(playing_card)) then
                    enhanced_tally = enhanced_tally + 1
                end
            end
            if enhanced_tally >= 144 then
                card.ability.extra.xmult = 8
            elseif enhanced_tally >= 89 then
                card.ability.extra.xmult = 7
            elseif enhanced_tally >= 55 then
                card.ability.extra.xmult = 6
            elseif enhanced_tally >= 34 then
                card.ability.extra.xmult = 5
            elseif enhanced_tally >= 21 then
                card.ability.extra.xmult = 4
            elseif enhanced_tally >= 13 then
                card.ability.extra.xmult = 3
            elseif enhanced_tally >= 8 then
                card.ability.extra.xmult = 2
            end
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}		

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_drivers_license" },
		{ name = "j_fibonacci" },
	}, cost = 10, result_joker = "j_fuseforce_ratio_road"
}

SMODS.Joker {
	key = "ransom",
	name = "Ransom Note",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"hand_type", "discard", "rank", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 4, y = 8 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			dollars = 5,
			poker_hand = 'High Card',
			id = '14',
			rank = 'Ace',
			joker1 = "j_mail",
			joker2 = "j_todo_list"
    	}
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = { 
    		card.ability.extra.dollars,
			localize(card.ability.extra.poker_hand, 'poker_hands'),
            localize(card.ability.extra.rank, 'ranks'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
    	if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local _poker_hands = {}
            local ranks = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_rank(playing_card) then
                    ranks[#ranks + 1] = playing_card
                end
            end
            local rank_card = pseudorandom_element(ranks, 'fuseforce_ransom')
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'fuseforce_ransom')
                if rank_card then
                    card.ability.extra.rank = rank_card.base.value
                    card.ability.extra.id = rank_card.base.id
                end
            return {
                message = localize('k_reset')
            }
        end
        if (context.discard or (context.individual and context.cardarea == G.play)) and not context.other_card.debuff and context.other_card:get_id() == card.ability.extra.id then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            if context.scoring_name == card.ability.extra.poker_hand or G.FUNCS.get_poker_hand_info(G.hand.highlighted) == card.ability.extra.poker_hand then
                return {
                    dollars = card.ability.extra.dollars * 2,
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
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        local ranks = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_rank(playing_card) then
                    ranks[#ranks + 1] = playing_card
                end
            end
        end
        local rank_card = pseudorandom_element(ranks, 'fuseforce_ransom')
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'fuseforce_ransom')
        if rank_card then
            card.ability.extra.rank = rank_card.base.value
            card.ability.extra.id = rank_card.base.id
        end
    end
}		

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_mail" },
		{ name = "j_todo_list" },
	}, cost = 12, result_joker = "j_fuseforce_ransom"
}

SMODS.Joker {
	key = "unlucky_cat",
	name = "Unlucky Cat",
	rarity = "fuse_fusion",
	cost = 22,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mod_chance", "xmult", "enhancements", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 5, y = 8 },
    artist_credits = {'Minus'},
    config = {
		extra = {	
			x_mult = 1,
			x_mult_lucky = 0.25,
			x_mult_wheel = 0.50,
			x_mult_glass = 0.75,
			joker1 = "j_glass",
			joker2 = "j_lucky_cat"
    	}
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = {
			card.ability.extra.x_mult,
			card.ability.extra.x_mult_lucky,
			card.ability.extra.x_mult_wheel,
			card.ability.extra.x_mult_glass,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint and not context.retrigger_joker then
            return {
                numerator = context.numerator * 2
            }
        end
    	if context.individual and context.cardarea == G.play and context.other_card.lucky_trigger and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_lucky
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
        if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
            local glass_cards = 0
            for _, removed_card in ipairs(context.removed) do
                if removed_card.shattered then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                -- See note about SMODS Scaling Manipulation on the wiki
                                card.ability.extra.x_mult = card.ability.extra.x_mult +
                                    card.ability.extra.x_mult_glass * glass_cards
                                return true
                            end
                        }))
                        SMODS.calculate_effect(
                            {
                                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult +
                                card.ability.extra.x_mult_glass * glass_cards } }
                            }, card)
                        return true
                    end
                }))
                return nil, true -- This is for Joker retrigger purposes
            end
        end
        --if context.using_consumeable and not context.blueprint and context.consumeable.config.center.key == 'c_hanged_man' then
        if context.using_consumeable and not context.blueprint and not context.retrigger_joker then
            local glass_cards = 0
            for _, removed_card in ipairs(G.hand.highlighted) do
                if SMODS.has_enhancement(removed_card, 'm_glass') then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult +
                    card.ability.extra.x_mult_glass * glass_cards
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
                }
            end
        end
        if context.identifier and context.identifier == "wheel_of_fortune" and context.pseudorandom_result and context.result and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_wheel
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
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
		{ name = "j_glass", merge_stat = "x_mult" },
		{ name = "j_lucky_cat", merge_stat = "x_mult" },
	}, cost = 10, merged_stat = "x_mult", result_joker = "j_fuseforce_unlucky_cat"
}

SMODS.Joker {
	key = "sand",
	name = "Sand Joker",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"mult", "xmult", "enhancements", "scaling"},
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 8 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            mult = 5,
			x_mult = 1,
			x_mult_mod = 1,
			joker1 = "j_glass",
			joker2 = "j_erosion"
    	}
	},
    loc_vars = function(self, info_queue, card)
    return {
		vars = {
			card.ability.extra.mult,
			card.ability.extra.mult * card.ability.extra.x_mult,
			card.ability.extra.x_mult,
			card.ability.extra.x_mult_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
            local glass_cards = 0
            for _, removed_card in ipairs(context.removed) do
                if removed_card.shattered then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                card.ability.extra.x_mult = card.ability.extra.x_mult +
                                    card.ability.extra.x_mult_mod * glass_cards
                                return true
                            end
                        }))
                        SMODS.calculate_effect(
                            {
                                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult +
                                card.ability.extra.x_mult_mod * glass_cards } }
                            }, card)
                        return true
                    end
                }))
                return nil, true -- This is for Joker retrigger purposes
            end
        end
        --if context.using_consumeable and not context.blueprint and context.consumeable.config.center.key == 'c_hanged_man' then
        if context.using_consumeable and not context.blueprint and not context.retrigger_joker then
            local glass_cards = 0
            for _, removed_card in ipairs(G.hand.highlighted) do
                if SMODS.has_enhancement(removed_card, 'm_glass') then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then
                card.ability.extra.x_mult = card.ability.extra.x_mult +
                    card.ability.extra.x_mult_mod * glass_cards
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * card.ability.extra.x_mult,
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}		

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_glass", carry_stat = "x_mult" },
		{ name = "j_erosion" },
	}, cost = 8, result_joker = "j_fuseforce_sand"
}

SMODS.Joker {
	key = "assassin",
	name = "Assassin",
	rarity = "fuse_fusion",
	cost = 20,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	attributes = {"discard", "face", "suit", "mult", "chips", "scaling", "economy"},
	atlas = "fuseforce_jokers",
	pos = { x = 8, y = 8 },
    artist_credits = {'Minus'},
    config = {
		extra = {
			chips = 0,
			chips_mod = 3,
			mult = 0,
			mult_mod = 1,
			dollars = 5,
			count = 3,
            suit = 'Spades',
			joker1 = "j_faceless",
			joker2 = "j_castle"
    	}
	},
    loc_vars = function(self, info_queue, card)
    local suit = card.ability.extra.suit
    return {
		vars = {
    		card.ability.extra.chips,
    		card.ability.extra.chips_mod,
    		card.ability.extra.mult,
    		card.ability.extra.mult_mod,
    		card.ability.extra.dollars,
    		card.ability.extra.dollars * 2,
    		card.ability.extra.count,
			localize(suit, 'suits_singular'),
            colours = { G.C.SUITS[suit] },
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
		}
	}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if G.playing_cards then
            local valid_assassin_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) then
                    valid_assassin_cards[#valid_assassin_cards + 1] = playing_card
                end
            end
            local assassin_card = pseudorandom_element(valid_assassin_cards, 'fuseforce_assassin')
            if assassin_card then
                card.ability.extra.suit = assassin_card.base.suit
            end
        end
    end,
    calculate = function(self, card, context)
    	if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint and not context.retrigger_joker then
            local valid_assassin_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) then
                    valid_assassin_cards[#valid_assassin_cards + 1] = playing_card
                end
            end
            local assassin_card = pseudorandom_element(valid_assassin_cards, 'fuseforce_assassin')
                if assassin_card then
                    card.ability.extra.suit = assassin_card.base.suit
                end
--            return {
--                message = localize('k_reset')
--            }
        end
        if context.discard then
            if context.other_card:is_suit(card.ability.extra.suit) and context.other_card:is_face() and not context.blueprint and not context.retrigger_joker and not context.other_card.debuff then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                card:juice_up()
--                return {
--                    message = localize('k_upgrade_ex'),
--                    colour = G.C.MULT
--                }
            end
            if (context.other_card:is_suit(card.ability.extra.suit) or context.other_card:is_face()) and not context.blueprint and not context.retrigger_joker and not context.other_card.debuff then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
                card:juice_up()
--                return {
--                    message = localize('k_upgrade_ex'),
--                    colour = G.C.CHIPS
--                }
            end
            if context.other_card == context.full_hand[#context.full_hand] then
                local face_cards = 0
                local suit_cards = 0
                local suit_face_cards = 0
                for _, discarded_card in ipairs(context.full_hand) do
                    if discarded_card:is_face() and discarded_card:is_suit(card.ability.extra.suit) then
                        suit_face_cards = suit_face_cards + 1
                    elseif discarded_card:is_face() and not discarded_card:is_suit(card.ability.extra.suit) then
                        face_cards = face_cards + 1
                    elseif discarded_card:is_suit(card.ability.extra.suit) and not discarded_card:is_face() then
                        suit_cards = suit_cards + 1
                    end
                end
                if suit_face_cards >= card.ability.extra.count then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars * 2
                    return {
                        dollars = card.ability.extra.dollars * 2,
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
                elseif suit_face_cards + face_cards + suit_cards >= card.ability.extra.count then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                    return {
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
		{ name = "j_faceless" },
		{ name = "j_castle", carry_stat = "chips" },
	}, cost = 10, result_joker = "j_fuseforce_assassin"
}

--Triple Fusions

SMODS.Joker {
	key = "rgb",
	name = "RGB Joker",
	rarity = "fuse_fusion",
	cost = 25,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "fuseforce_jokers",
	pos = { x = 6, y = 7 },
    artist_credits = {'gappie'},
    config = {
		extra = {
            chips = 0,
            chips_mod = 3,
            mult = 0,
            mult_mod = 2,
            xchips = 1,
            xchips_mod = 0.2,
            xmult = 1,
            xmult_mod = 0.2,
			joker1 = "j_red_card",
			joker2 = "j_green_joker",
			joker3 = "j_blue_joker"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.chips_mod,
            card.ability.extra.mult,
            card.ability.extra.mult_mod,
            card.ability.extra.xchips,
            card.ability.extra.xchips_mod,
            card.ability.extra.xmult,
            card.ability.extra.xmult_mod,
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}
		}
	}
    end,
	calculate = function(self, card, context)
        if context.discard and card.ability.extra.mult > 0 and not context.blueprint and not context.retrigger_joker and context.other_card == context.full_hand[#context.full_hand] then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_mod
            return {
                message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_mod } },
                colour = G.C.RED
            }
        end
        if context.before and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod } }
            }
        end
        if context.discard and card.ability.extra.chips > 0  and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_mod
            --return true
            --return {
            --    message = localize { type = 'variable', key = 'a_chips_minus', vars = { card.ability.extra.chips_mod } },
            --    colour = G.C.BLUE
            --}
        end
        if context.individual and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            return true
        end
        if context.skipping_booster and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult_mod } },
                colour = G.C.RED
            }
        end
        if context.open_booster and not context.blueprint and not context.retrigger_joker then
            card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_mod
            return {
                message = localize { type = 'variable', key = 'a_xchips', vars = { card.ability.extra.xchips_mod } },
                colour = G.C.BLUE
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xchips = card.ability.extra.xchips,
                xmult = card.ability.extra.xmult
            }
        end
        if context.drawing_cards and not context.blueprint and not context.retrigger_joker then
            if card.ability.extra.mult <= 0 then
                card.ability.extra.mult = 0
            end
            if card.ability.extra.chips <= 0 then
                card.ability.extra.chips = 0
            end
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_red_card", merge_stat = "mult" },
		{ name = "j_green_joker", merge_stat = "mult" },
		{ name = "j_blue_joker" },
	}, cost = 11, merged_stat = "mult", result_joker = "j_fuseforce_rgb"
}

SMODS.Joker {
	key = "vain",
	name = "Vain Joker",
	rarity = "fuse_fusion",
	cost = 25,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "fuseforce_jokers",
	pos = { x = 0, y = 7 },
    soul_pos = { x = 5, y = 7 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            type = 'Pair',
            type2 = 'Five of a Kind',
            chips = 50,
            mult = 8,
            xmult = 2,
            dollars = 1,
			joker1 = "j_sly",
			joker2 = "j_jolly",
			joker3 = "j_duo"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played),
            localize(card.ability.extra.type, 'poker_hands'),
            localize(card.ability.extra.type2, 'poker_hands'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played) or nil
    end,
	calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_sly" },
		{ name = "j_jolly" },
		{ name = "j_duo" },
	}, cost = 11, result_joker = "j_fuseforce_vain"
}

SMODS.Joker {
	key = "fruity",
	name = "Fruity Joker",
	rarity = "fuse_fusion",
	cost = 27,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "fuseforce_jokers",
	pos = { x = 1, y = 7 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            type = 'Three of a Kind',
            type2 = 'Full House',
            chips = 100,
            mult = 12,
            xmult = 3,
            dollars = 2,
			joker1 = "j_wily",
			joker2 = "j_zany",
			joker3 = "j_trio"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played),
            localize(card.ability.extra.type, 'poker_hands'),
            localize(card.ability.extra.type2, 'poker_hands'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played) or nil
    end,
	calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_wily" },
		{ name = "j_zany" },
		{ name = "j_trio" },
	}, cost = 11, result_joker = "j_fuseforce_fruity"
}

SMODS.Joker {
	key = "twotwo",
	name = "Twotwo Joker",
	rarity = "fuse_fusion",
	cost = 27,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "fuseforce_jokers",
	pos = { x = 2, y = 7 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            type = 'Two Pair',
            type2 = 'Four of a Kind',
            chips = 80,
            mult = 10,
            xmult = 4,
            dollars = 1,
			joker1 = "j_clever",
			joker2 = "j_mad",
			joker3 = "j_family"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played),
            localize(card.ability.extra.type, 'poker_hands'),
            localize(card.ability.extra.type2, 'poker_hands'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played) or nil
    end,
	calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type or card.ability.extra.type2]) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_clever" },
		{ name = "j_mad" },
		{ name = "j_family" },
	}, cost = 11, result_joker = "j_fuseforce_twotwo"
}

SMODS.Joker {
	key = "straight_man",
	name = "The Straight Man",
	rarity = "fuse_fusion",
	cost = 27,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "fuseforce_jokers",
	pos = { x = 3, y = 7 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            type = 'Straight',
            type2 = 'Straight Flush',
            chips = 100,
            mult = 12,
            xmult = 3,
            dollars = 2,
			joker1 = "j_devious",
			joker2 = "j_crazy",
			joker3 = "j_order"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played),
            localize(card.ability.extra.type, 'poker_hands'),
            localize(card.ability.extra.type2, 'poker_hands'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played) or nil
    end,
	calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_devious" },
		{ name = "j_crazy" },
		{ name = "j_order" },
	}, cost = 11, result_joker = "j_fuseforce_straight_man"
}

SMODS.Joker {
	key = "flushed",
	name = "Flushed Joker",
	rarity = "fuse_fusion",
	cost = 27,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "fuseforce_jokers",
	pos = { x = 4, y = 7 },
    artist_credits = {'Minus'},
    config = {
		extra = {
            type = 'Flush',
            type2 = 'Flush House',
            chips = 80,
            mult = 10,
            xmult = 2,
            dollars = 1,
			joker1 = "j_crafty",
			joker2 = "j_droll",
			joker3 = "j_tribe"
    	}
	},
    loc_vars = function(self, info_queue, card)
	return {
		vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.xmult,
            card.ability.extra.dollars,
            card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played),
            localize(card.ability.extra.type, 'poker_hands'),
            localize(card.ability.extra.type2, 'poker_hands'),
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker3, set = 'Joker'}
		}
	}
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars * (G.GAME.hands[card.ability.extra.type].played + G.GAME.hands[card.ability.extra.type2].played) or nil
    end,
	calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands[card.ability.extra.type]) then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FusionJokers.fusions:register_fusion {
	jokers = {
		{ name = "j_crafty" },
		{ name = "j_droll" },
		{ name = "j_tribe" },
	}, cost = 11, result_joker = "j_fuseforce_flushed"
}

--Gold Fusions

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
    artist_credits = {'Minus'},
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
    artist_credits = {'Minus'},
    config = {
		extra = {
			x_mult = 1,
            x_mult_mod = 0.25,
            odds = 10,
            c_slots = 0,
            j_slots = 0,
			joker1 = "j_fuseforce_golden_calf",
			joker2 = "j_ceremonial"
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
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'},
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
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
                    message = '"More!"',
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
    artist_credits = {'Minus'},
    config = {
		extra = {
            x_mult = 1,
            dollars = 2,
            tally = 0,
			joker1 = "j_fuseforce_skipper",
			joker2 = "j_splash"
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
    		localize{type = 'name_text', key = card.ability.extra.joker1, set = 'Joker'}, 
    		localize{type = 'name_text', key = card.ability.extra.joker2, set = 'Joker'}
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
