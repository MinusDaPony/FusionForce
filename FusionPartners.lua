

SMODS.Atlas{
    key = "fuseforce_partners",
    px = 46,
    py = 58,
    path = "Partners.png"
}

----Fusion Card compatibility with original partners (Doesn't work yet)
--SMODS.current_mod.calculate = function(self, context)
--    if G.GAME.selected_partner then
--        local fusion = false
--        if fusion == false and G.GAME.selected_partner == "pnr_partner_jimbo" then
--            fusion = true
--            local partner = next(SMODS.find_card(G.GAME.selected_partner))
--            partner.ability.link_config = {j_fuseforce_fused = 1, j_fuse_three_jimbos = 1}
--        end
--    end
--end

if fixed_and_working then
Partner_API.inject("pnr_partner_jimbo", "link_config", {j_fuse_three_jimbos = 1, j_fuseforce_fused = 1}, merge)
Partner_API.inject("pnr_partner_mute", "link_config", {j_fuseforce_oscar_best_actor = 1}, merge)
Partner_API.inject("pnr_partner_unite", "link_config", {j_fuseforce_reach_the_stars = 1}, merge)
Partner_API.inject("pnr_partner_hatch", "link_config", {j_fuse_golden_egg = 1, j_fuseforce_easter_egg = 1, j_fuseforce_legendary_poxy = 1}, merge)
Partner_API.inject("pnr_partner_steal", "link_config", {j_fuseforce_dye_pack = 1}, merge)
Partner_API.inject("pnr_partner_pale", "link_config", {j_fuseforce_prosopagnosia = 1, j_fuseforce_assassin = 1}, merge)
Partner_API.inject("pnr_partner_penalty", "link_config", {j_fuseforce_bribery_clown = 1, j_fuseforce_rgb = 1}, merge)
Partner_API.inject("pnr_partner_fantasy", "link_config", {j_fuseforce_bribery_clown = 1}, merge)
Partner_API.inject("pnr_partner_oracle", "link_config", {j_fuseforce_paranormal = 1}, merge)
Partner_API.inject("pnr_partner_finesse", "link_config", {j_fuse_flip_flop = 1, j_fuseforce_colour_guard = 1}, merge)
Partner_API.inject("pnr_partner_gilded", "link_config", {j_fuse_golden_egg = 1, j_fuseforce_golden_calf = 1, j_fuseforce_gold_golden_calf = 1, j_fuseforce_legendary_poxy = 1}, merge)
Partner_API.inject("pnr_partner_batter", "link_config", {j_fuseforce_card_collection = 1}, merge)
Partner_API.inject("pnr_partner_bargain", "link_config", {j_fuseforce_dye_pack = 1}, merge)
Partner_API.inject("pnr_partner_memory", "link_config", {j_fuse_collectible_chaos_card = 1}, merge)
Partner_API.inject("pnr_partner_stoke", "link_config", {j_fuseforce_golden_calf = 1, j_fuseforce_gold_golden_calf = 1}, merge)
Partner_API.inject("pnr_partner_verify", "link_config", {j_fuseforce_masters_degree = 1}, merge)
Partner_API.inject("pnr_partner_jump", "link_config", {j_fuseforce_power_pop = 1, j_fuseforce_skipper = 1, j_fuseforce_gold_skipper = 1, j_fuseforce_legendary_poxy = 1}, merge)
Partner_API.inject("pnr_partner_vote", "link_config", {j_fuseforce_cut_and_pasted = 1}, merge)
Partner_API.inject("pnr_partner_bleed", "link_config", {j_fuse_heart_paladin = 1}, merge)
Partner_API.inject("pnr_partner_andrew", "link_config", {j_fuseforce_optimist = 1}, merge)
Partner_API.inject("pnr_partner_thrill", "link_config", {j_fuseforce_comeback = 1}, merge)
Partner_API.inject("pnr_partner_napkin", "link_config", {j_fuseforce_two_heads = 1, j_fuseforce_gold_two_heads = 1}, merge)
Partner_API.inject("pnr_partner_valid", "link_config", {j_fuse_commercial_driver = 1, j_fuseforce_ratio_road = 1}, merge)
Partner_API.inject("pnr_partner_blaze", "link_config", {j_fuseforce_solar_flare_joker = 1, j_fuseforce_molotov_cocktail = 1}, merge)
end

Partner_API.Partner{
    key = "offer",
    name = "Offer Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 1, y = 0},
    config = {
        extra = {
            bankrupt_at = 10,
            active = 0
        }
    },
    link_config = {j_fuseforce_rewards_card = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.bankrupt_at,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local link_level = self:get_link_level()
            if link_level ~= 1 and card.ability.extra.active == 0 then
                G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.bankrupt_at
                card.ability.extra.active = 1
            end
            if link_level == 1 then
                if card.ability.extra.active == 1 then
                    G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.bankrupt_at
                    card.ability.extra.active = 0
                end
                if G.GAME.dollars < 0 then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + math.floor(G.GAME.dollars / -2)
                    return {
                        dollars = math.floor(G.GAME.dollars / -2),
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
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_rewards_card" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

Partner_API.Partner{
    key = "divine",
    name = "Divine",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 2, y = 0},
    config = {
        extra = {
            dollars = 1,
            active = 0
        }
    },
    link_config = {j_fuseforce_soothsayer = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.dollars,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.open_booster then
            local link_level = self:get_link_level()
            --local _card = context.booster
            if not link_level and (context.booster.kind == 'Celestial' or context.booster.kind == 'Arcana') then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
        if context.buying_card and not context.buying_self then
            local link_level = self:get_link_level()
            --local _card = context.card
            if not link_level and (context.card.ability.set == 'Planet' or context.card.ability.set == 'Tarot') then
                card.ability.extra.active = 1
            end
        end
        if context.money_altered and context.amount < 0 and card.ability.extra.active == 1 then
                card.ability.extra.active = 0
                return {
                    dollars = card.ability.extra.dollars
                }
        end
        if context.starting_shop then
            local link_level = self:get_link_level()
            if link_level == 1 then
                G.E_MANAGER:add_event(Event({func = function()
                    local arcana_key = "p_arcana_normal_"..(math.random(1, 4))
                    local planet_key = "p_celestial_normal_"..(math.random(1, 4))
                    local booster1 = Card(G.shop_booster.T.x+G.shop_booster.T.w/2, G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[arcana_key],
                    {bypass_discovery_center = true, bypass_discovery_ui = true})
                    local booster2 = Card(G.shop_booster.T.x+G.shop_booster.T.w/2, G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[planet_key],
                    {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(booster1, "Booster", G.shop_booster)
                    booster1:start_materialize()
                    G.shop_booster:emplace(booster1)
                    booster1.ability.couponed = true
                    booster1:set_cost()
                    create_shop_card_ui(booster2, "Booster", G.shop_booster)
                    booster2:start_materialize()
                    G.shop_booster:emplace(booster2)
                    booster2.ability.couponed = true
                    booster2:set_cost()
                return true end}))
                card_eval_status_text(card, "extra", nil, nil, nil, {message = localize("k_booster"), colour = G.C.PURPLE})
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_soothsayer" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end,
}

Partner_API.Partner{
    key = "shh",
    name = "Shh! Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 3, y = 0},
    config = {
        extra = {
            cost = 4,
            chips = 50,
            mult = 10,
            count = 0
        }
    },
    link_config = {j_fuseforce_sweet_theatre_combo = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.cost,
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.count
            }
        }
    end,
    calculate = function(self, card, context)
        if context.partner_click and (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) >= to_big(card.ability.extra.cost) then
            local link_level = self:get_link_level()
            if link_level == 1 then
                local combo = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].config.center.key == 'j_fuseforce_sweet_theatre_combo' then
                        combo = G.jokers.cards[i]
                        break
                    end
                end
                if combo then
                    ease_dollars(-card.ability.extra.cost)
                    combo.ability.extra.count = combo.ability.extra.count + 1
                    if combo.set_cost then
                        combo.ability.extra_value = (combo.ability.extra_value or 0) + (card.ability.extra.cost / 2)
                        combo:set_cost()
                    end
                end
            else
                ease_dollars(-card.ability.extra.cost)
                card.ability.extra.count = card.ability.extra.count + 1
            end
        end
        if context.joker_main and card.ability.extra.count > 0 then
            local link_level = self:get_link_level()
            if link_level ~= 1 then
                return {
                    chips = card.ability.extra.chips,
                    mult = card.ability.extra.mult
                }
            end
        end
        if context.end_of_round and context.game_over == false and card.ability.extra.count > 0 then
            local link_level = self:get_link_level()
            if link_level ~= 1 then
    	        card.ability.extra.count = card.ability.extra.count - 1
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_sweet_theatre_combo" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "build",
    name = "Build Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 4, y = 0},
    link_config = {j_fuseforce_moorstone = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local link_level = self:get_link_level()
            if not link_level and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    message = localize('k_plus_tarot'),
                    message_card = card,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                SMODS.add_card {
                                    area = G.consumeables,
                                    set = 'Tarot',
                                    key = 'c_tower',
                                    key_append = 'build' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                    end
                }
            end
            if link_level == 1 then
                local valid_cards = {}
                local stone_card = nil
                local stone_card2 = nil
                for _, playing_card in ipairs(G.playing_cards) do
                    if not next(SMODS.get_enhancements(playing_card)) then
                        valid_cards[#valid_cards + 1] = playing_card
                    end
                end
                if valid_cards and link_level == 1 then
                    stone_card = pseudorandom_element(valid_cards, 'marble')
                    stone_card2 = pseudorandom_element(valid_cards, 'stone')
                end
                if stone_card then
                    stone_card:set_ability('m_stone')
                end
                if stone_card2 then
                    stone_card2:set_ability('m_stone')
                end
            end
        end      
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_moorstone" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "neigh",
    name = "Neigh Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 0, y = 1},
    config = {
        extra = {
            chips = 10,
            mult = 2,
            hands = 1,
            dollars = 10
        }
    },
    link_config = {j_fuseforce_fight_a_bull = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.chips,
            card.ability.extra.mult,
            card.ability.extra.hands,
            card.ability.extra.dollars * (1 + (link_level or 0)),
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local link_level = self:get_link_level()
            if link_level == 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(card.ability.extra.hands * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/20)))
                        SMODS.calculate_effect(
                            { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } } }, card)
                        return true
                    end
                }))
                return nil, true -- This is for Joker retrigger purposes
            end
        end
        if context.joker_main then
            local link_level = self:get_link_level()
            if link_level ~= 1 then
                return {
                    chips = card.ability.extra.chips * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/10)),
                    mult = card.ability.extra.mult * math.max(0,math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/10)),
                }
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_fight_a_bull" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "prizes",
    name = "Prizes Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 2, y = 1},
    config = {
        extra = {
            rerolls = 10,
            count = 0,
            negs = 0
        }
    },
    link_config = {j_fuseforce_shadowman = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.rerolls,
            card.ability.extra.count
            }
        }
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            local link_level = self:get_link_level()
            card.ability.extra.negs = 0
            if link_level == 1 then
                for _, owned in ipairs(G.jokers and G.jokers.cards) do
                    if owned.edition and owned.edition.key == "e_negative" then
                        card.ability.extra.negs = card.ability.extra.negs + 1
                    end
                end
            end
            if card.ability.extra.negs >= 1 then
                SMODS.change_free_rerolls(card.ability.extra.negs)
            end
        end
        if context.ending_shop and card.ability.extra.negs >= 1 then
            SMODS.change_free_rerolls(-card.ability.extra.negs)
        end
        if context.reroll_shop then
            local link_level = self:get_link_level()
            if link_level ~= 1 then
                if card.ability.extra.count >= 9 then
                    local prize = 'j_invisible'
                    card.ability.extra.count = card.ability.extra.count - 9
                    if SMODS.pseudorandom_probability(card, 'shadow', 1, 2, 'prizes', true) then
                        prize = 'j_ring_master'
                    end
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                        play_sound('whoosh1')
                            local shop_joker = SMODS.add_card({
                                set = 'Joker',
                                area = G.shop_jokers,
                                key = prize
                            })
                            --G.shop_jokers:emplace(shop_joker)
                            create_shop_card_ui(shop_joker, 'Joker', G.shop_jokers)
                            shop_joker.for_sale = true
                            shop_joker.ability.couponed = false
                            shop_joker:set_cost()
                            return true
                        end
                    }))
                else
                    card.ability.extra.count = card.ability.extra.count + 1
                    if card.ability.extra.count == 9 then
                        local eval = function(card) return card.ability.extra.count == 9 and not G.RESET_JIGGLES end
                        juice_card_until(card, eval, true)
                    end
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_shadowman" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "hydra",
    name = "Hydra Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 1, y = 2},
    config = {
        extra = {
            jokers = 10,
            count = 0
        }
    },
    link_config = {j_fuseforce_two_heads = 1, j_fuseforce_gold_two_heads = 2},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 or link_level == 2 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.jokers - ((link_level or 0) * 2),
            card.ability.extra.count,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' then
        local link_level = self:get_link_level()
            if context.card.config.center.key == 'j_fuseforce_gold_two_heads' then
                modify_joker_slot_count(3)
            elseif context.card.config.center.key == 'j_fuseforce_two_heads' then
                modify_joker_slot_count(2)
            elseif context.card.config.center.key == 'j_blueprint' or context.card.config.center.key == 'j_brainstorm' then
                modify_joker_slot_count(1)
            else
                card.ability.extra.count = card.ability.extra.count + 1
                if card.ability.extra.count >= card.ability.extra.jokers - ((link_level or 0) * 2) then
                    card.ability.extra.count = card.ability.extra.count - (card.ability.extra.jokers - ((link_level or 0) * 2))
                    G.E_MANAGER:add_event(Event({
                        func = (function() 
                            add_tag(Tag("tag_buffoon"))
                            return true
                        end)
                    }))
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_two_heads" or v.key == "j_fuseforce_gold_two_heads" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "suitable",
    name = "Suitable Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 3, y = 2},
    config = {
        extra = {
            cost = 3
        }
    },
    link_config = {j_fuseforce_black_hearted = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    --if link_level == 1 then card.ability.extra.cost = 1 else card.ability.extra.cost = 3 end
        return {
            vars = {
            card.ability.extra.cost - (link_level or 0 * 2)
            }
        }
    end,
    calculate = function(self, card, context)
        if context.partner_click and #G.consumeables.highlighted == 1 then
            local suitor = G.consumeables.highlighted[1]
            local link_level = self:get_link_level()
            if (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) >= to_big(card.ability.extra.cost - (link_level * 2) or 0) then
                if suitor.config.center_key == 'c_star' then
                    ease_dollars(-card.ability.extra.cost - (link_level * 2) or 0)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function() 
                            local edition = suitor.edition and suitor.edition.key or nil
                            suitor:start_dissolve()
                            local new_suitor = SMODS.create_card({area = G.consumeables, set = 'Tarot', key = 'c_sun', edition = edition})
                            new_suitor:add_to_deck()
                            G.consumeables:emplace(new_suitor)
                            --new_suitor:start_materialize()
                            return true
                        end
                    }))
                elseif suitor.config.center_key == 'c_sun' then
                    ease_dollars(-card.ability.extra.cost - (link_level * 2) or 0)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function() 
                            local edition = suitor.edition and suitor.edition.key or nil
                            suitor:start_dissolve()
                            local new_suitor = SMODS.create_card({area = G.consumeables, set = 'Tarot', key = 'c_world', edition = edition})
                            new_suitor:add_to_deck()
                            G.consumeables:emplace(new_suitor)
                            --new_suitor:start_materialize()
                            return true
                        end
                    }))
                elseif suitor.config.center_key == 'c_world' then
                    ease_dollars(-card.ability.extra.cost - (link_level * 2) or 0)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function() 
                            local edition = suitor.edition and suitor.edition.key or nil
                            suitor:start_dissolve()
                            local new_suitor = SMODS.create_card({area = G.consumeables, set = 'Tarot', key = 'c_moon', edition = edition})
                            new_suitor:add_to_deck()
                            G.consumeables:emplace(new_suitor)
                            --new_suitor:start_materialize()
                            return true
                        end
                    }))
                elseif suitor.config.center_key == 'c_moon' then
                    ease_dollars(-card.ability.extra.cost - (link_level * 2) or 0)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function() 
                            local edition = suitor.edition and suitor.edition.key or nil
                            suitor:start_dissolve()
                            local new_suitor = SMODS.create_card({area = G.consumeables, set = 'Tarot', key = 'c_star', edition = edition})
                            new_suitor:add_to_deck()
                            G.consumeables:emplace(new_suitor)
                            --new_suitor:start_materialize()
                            return true
                        end
                    }))
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_black_hearted" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "magnetize",
    name = "Magnetize Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 4, y = 2},
    link_config = {j_fuseforce_alloy = 1, j_fuseforce_gold_alloy = 2},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 or link_level == 2 then key = key.."_"..link_level end
        return {
            key = key
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local link_level = self:get_link_level()
            if not link_level and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    message = localize('k_plus_tarot'),
                    message_card = card,
                    func = function() -- This is for timing purposes, everything here runs after the message
                        if SMODS.pseudorandom_probability(card, 'alloy', 1, 2, 'alloy', true) then
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        area = G.consumeables,
                                        set = 'Tarot',
                                        key = 'c_devil',
                                        key_append = 'alloy' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        else
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        area = G.consumeables,
                                        set = 'Tarot',
                                        key = 'c_chariot',
                                        key_append = 'alloy' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end)
                            }))
                        end
                    end
                }
            end
            if link_level == 1 or link_level == 2 then
                local valid_cards = {}
                local gold_card = nil
                local steel_card = nil
                local gold_card2 = nil
                local steel_card2 = nil
                for _, playing_card in ipairs(G.playing_cards) do
                    if not next(SMODS.get_enhancements(playing_card)) then
                        valid_cards[#valid_cards + 1] = playing_card
                    end
                end
                if valid_cards and link_level == 2 then
                    gold_card = pseudorandom_element(valid_cards, 'gold')
                    steel_card = pseudorandom_element(valid_cards, 'steel')
                    gold_card2 = pseudorandom_element(valid_cards, 'gold2')
                    steel_card2 = pseudorandom_element(valid_cards, 'steel2')
                end
                if valid_cards and link_level == 1 then
                    gold_card = pseudorandom_element(valid_cards, 'gold')
                    steel_card = pseudorandom_element(valid_cards, 'steel')
                end
                if gold_card then
                    gold_card:set_ability('m_gold')
                end
                if steel_card then
                    steel_card:set_ability('m_steel')
                end
                if gold_card2 then
                    gold_card2:set_ability('m_gold')
                end
                if steel_card2 then
                    steel_card2:set_ability('m_steel')
                end
            end
        end      
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_alloy" or v.key == "j_fuseforce_gold_alloy" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "touch",
    name = "Touch Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 0, y = 3},
    config = {
        extra = {
            cost = 2
        }
    },
    link_config = {j_fuseforce_midas_hand = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.cost
            }
        }
    end,
    calculate = function(self, card, context)
        if context.partner_click and #G.hand.highlighted == 1 then
            local playingcard = G.hand.highlighted[1]
            local link_level = self:get_link_level()
            if (next(SMODS.get_enhancements(playingcard)) and next(SMODS.get_enhancements(playingcard)) ~= "m_gold") and 
            (link_level or (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) >= to_big(card.ability.extra.cost)) then
                if not link_level then
                    ease_dollars(-card.ability.extra.cost)
                end
                local joker = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i].config.center.key == 'j_fuseforce_midas_joker' then
                        joker = G.jokers.cards[i]
                        break
                    end
                end
                if joker then
                    if SMODS.has_enhancement(playingcard, 'm_bonus') or SMODS.has_enhancement(playingcard, 'm_stone') or SMODS.has_enhancement(playingcard, 'm_steel') then
                        joker.ability.extra.chips = joker.ability.extra.chips + joker.ability.extra.chips_mod
                    elseif SMODS.has_enhancement(playingcard, 'm_mult') or SMODS.has_enhancement(playingcard, 'm_wild') or SMODS.has_enhancement(playingcard, 'm_glass') then
                        joker.ability.extra.mult = joker.ability.extra.mult + joker.ability.extra.mult_mod                        
                    else
                        joker.ability.extra.turned = joker.ability.extra.turned + 1
                        if joker.ability.extra.turned == joker.ability.extra.count then
                            joker.ability.extra.turned = 0
                            joker.ability.extra.dollars = joker.ability.extra.dollars + joker.ability.extra.dollars_mod
                        end
                    end
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function() 
                        playingcard:flip()
                        play_sound('card1')
                        playingcard:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                delay(0.2)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        playingcard:set_ability('m_gold')
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        playingcard:flip()
                        play_sound('tarot2', 1, 0.6)
                        playingcard:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        G.hand:unhighlight_all()
                        return true
                    end
                }))
                delay(0.5)
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_midas_hand" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "shrink",
    name = "Shrink Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 4, y = 3},
    config = {
        extra = {
            cost = 4
        }
    },
    link_config = {j_fuseforce_smurf = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
        return {
            vars = {
            card.ability.extra.cost * (2 - (link_level or 0))
            }
        }
    end,
    calculate = function(self, card, context)
        if context.partner_click and #G.hand.highlighted == 1 then
            local playingcard = G.hand.highlighted[1]
            local link_level = self:get_link_level()
            if (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) >= to_big(card.ability.extra.cost * (2 - (link_level or 0))) and playingcard:get_id() ~= 2 then
                ease_dollars(-card.ability.extra.cost * (2 - (link_level or 0)))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function() 
                        playingcard:flip()
                        play_sound('card1')
                        playingcard:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                delay(0.2)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        -- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
                        assert(SMODS.modify_rank(playingcard, -1))
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        playingcard:flip()
                        play_sound('tarot2', 1, 0.6)
                        playingcard:juice_up(0.3, 0.3)
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        G.hand:unhighlight_all()
                        return true
                    end
                }))
                delay(0.5)
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_smurf" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "teamwork",
    name = "Teamwork Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 0, y = 4},
    config = {
        extra = {
            chips = 25,
            mult = 4
        }
    },
    link_config = {j_fuseforce_fused = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.chips,
            card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local fusions = 0
            for _, owned in ipairs(G.jokers.cards) do
                if (owned.config.center.config.rarity == 5
                or owned.config.center.rarity == "fuse_fusion"
                or owned.config.center.rarity == "fuseforce_gold_fusion"
                or owned.config.center.rarity == "tsun_gold_fusion") then
                    fusions = fusions + 1
                end
            end
            if fusions >= 1 then
                return {
                    chips = card.ability.extra.chips * fusions,
                    mult = card.ability.extra.mult * fusions
                }
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_fused" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "nice",
    name = "Nice Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 1, y = 4},
    config = {
        extra = {
            six = 6,
            nine = 9
        }
    },
    link_config = {j_fuseforce_chancer = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    local tsun = 0
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.six, 'six')
    if link_level == 1 then
        for _, owned in ipairs(G.jokers.cards) do
            if string.find(owned.config.center.key, "j_tsun_", 1, true) then
                tsun = 1
            end
        end
        if next(SMODS.find_card('j_splash')) or tsun == 1 then
            key = key.."_"..link_level+1
        else
            key = key.."_"..link_level
        end
    end
        return {
            key = key,
            vars = {
            card.ability.extra.six,
            card.ability.extra.nine,
            numerator
            }
        }
    end,
    calculate = function(self, card, context)
        if context.ending_shop then
            local nice_consumeable = "Tarot"
            local nice_message = 'k_plus_tarot'
            if SMODS.pseudorandom_probability(card, 'consumeable', 1, 2, 'nice', true) then
                nice_consumeable = "Spectral"
                nice_message = 'k_plus_spectral'
            end
            if SMODS.pseudorandom_probability(card, 'nine', 1, card.ability.extra.nine, 'nice', false) then
                local nice_tag = "tag_charm"
                if SMODS.pseudorandom_probability(card, 'tag', 1, 2, 'nice', true) then
                    nice_tag = "tag_ethereal"
                end
                if SMODS.pseudorandom_probability(card, 'six', 1, card.ability.extra.six, 'nice', false) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    return {
                        extra = {
                            message = localize(nice_message),
                            message_card = card,
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = nice_consumeable,
                                            key_append = 'nice' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                        }
                                        add_tag(Tag(nice_tag))
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                else
                    G.E_MANAGER:add_event(Event({
                        func = (function() 
                            add_tag(Tag(nice_tag))
                            return true
                        end)
                    }))
                end
            elseif SMODS.pseudorandom_probability(card, 'six', 1, card.ability.extra.six, 'nice', false) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize(nice_message),
                        message_card = card,
                        func = function() -- This is for timing purposes, everything here runs after the message
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    SMODS.add_card {
                                        set = nice_consumeable,
                                        key_append = 'nice' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
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

        if context.modify_scoring_hand and (context.other_card:get_id() == 9 or context.other_card:get_id() == 6) then
            local link_level = self:get_link_level() or 0
            if link_level == 1 then
                return {
                    add_to_hand = true
                }
            end
        end
        
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 6 or context.other_card:get_id() == 9) then
            local link_level = self:get_link_level() or 0
            local tsun = 0
            for _, owned in ipairs(G.jokers.cards) do
                if string.find(owned.config.center.key, "j_tsun_", 1, true) then
                    tsun = 1
                end
            end
            if link_level == 1 and (next(SMODS.find_card('j_splash')) or tsun == 1) then
                local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.six, 'six')
                return {
                    mult = numerator
                }
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_chancer" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "lucky_break",
    name = "Lucky Break",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 2, y = 4},
    config = {
        extra = {
            odds = 2
        }
    },
    link_config = {j_fuseforce_unlucky_cat = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'meowcrash')
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            numerator,
            denominator
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before then
            local link_level = self:get_link_level()
            local seven = 0
            local thirteen = 0
            if SMODS.pseudorandom_probability(card, 'lucky_break', 1, card.ability.extra.odds, 'meowcrash', false) then
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card:get_id() == 7 then
                        seven = 1
                        scored_card:set_ability('m_lucky', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                    if scored_card:get_id() == 13 then
                        thirteen = 1
                        scored_card:set_ability('m_glass', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
                if link_level and seven == 1 and thirteen == 1 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit - 1 then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 2
                    return {
                        extra = {
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            --edition = 'e_negative',
                                            key = 'c_magician',
                                            area = G.consumeables,
                                            key_append = 'lucky_break' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                        }
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            --edition = 'e_negative',
                                            key = 'c_justice',
                                            area = G.consumeables,
                                            key_append = 'lucky_break' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                        }
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                elseif link_level and seven == 1 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    return {
                        extra = {
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            --edition = 'e_negative',
                                            key = 'c_magician',
                                            area = G.consumeables,
                                            key_append = 'lucky_break' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
                                        }
                                        G.GAME.consumeable_buffer = 0
                                        return true
                                    end)
                                }))
                            end
                        },
                    }
                end
                if link_level and thirteen == 1 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    return {
                        extra = {
                            func = function() -- This is for timing purposes, everything here runs after the message
                                G.E_MANAGER:add_event(Event({
                                    func = (function()
                                        SMODS.add_card {
                                            set = 'Tarot',
                                            --edition = 'e_negative',
                                            key = 'c_justice',
                                            area = G.consumeables,
                                            key_append = 'lucky_break' -- Optional, useful for manipulating the random seed and checking the source of the creation in `in_pool`.
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
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_unlucky_cat" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "front",
    name = "Front Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 3, y = 4},
    config = {
        extra = {
            xmult = 1.1
        }
    },
    link_config = {j_pareidolia = 1, j_fuseforce_prosopagnosia = 1, j_fuseforce_sticker = 2},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    local sticky = 0
    if link_level == 1 then key = key.."_1" end
    if link_level == 2 then key = key.."_1" sticky = 0.1 end
        return {
            key = key,
            vars = {
            card.ability.extra.xmult + sticky
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and (context.other_card:get_id() == 11 or context.other_card:get_id() == 12 or context.other_card:get_id() == 13) then
            local link_level = self:get_link_level()
            if link_level == 2 then
                return {
                    xmult = card.ability.extra.xmult + 0.1
                }
            elseif link_level == 1 then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuseforce_sticker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "fistbump",
    name = "Fistbump Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 1, y = 6},
    config = {
        extra = {
            hands = 1,
            flip = 0
        }
    },
    link_config = {j_fuse_dynamic_duo = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if card.ability.extra.flip == 1 or card.ability.extra.flip == 2 then key = "pnr_fuseforce_fistbump_"..card.ability.extra.flip end
    if link_level == 1 then key = "pnr_fuseforce_fistbump_3" end
        return {
            key = key,
            vars = {
            card.ability.extra.hands
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local link_level = self:get_link_level()
            if card.ability.extra.flip ~= 0 and link_level then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						card.ability.extra.flip = 0
						card:juice_up(1, 1)
						card.config.center.pos = {x = 1, y = 6}
						card:set_sprites(card.config.center)
                        return true;
                    end
                }))
            elseif card.ability.extra.flip == 0 and not link_level then
                if SMODS.pseudorandom_probability(card, 'fistbump', 1, 2, 'fistbump', true) then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                            card.ability.extra.flip = 2
                            card:juice_up(1, 1)
                            card.config.center.pos = {x = 2, y = 6}
                            card:set_sprites(card.config.center)
                            return true;
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                            card.ability.extra.flip = 1
                            card:juice_up(1, 1)
                            card.config.center.pos = {x = 0, y = 6}
                            card:set_sprites(card.config.center)
                            return true;
                        end
                    }))
                end
            elseif card.ability.extra.flip == 1 and not link_level then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						card.ability.extra.flip = 2
						card:juice_up(1, 1)
						card.config.center.pos = {x = 2, y = 6}
						card:set_sprites(card.config.center)
                        return true;
                    end
                }))
            elseif card.ability.extra.flip == 2 and not link_level then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						card.ability.extra.flip = 1
						card:juice_up(1, 1)
						card.config.center.pos = {x = 0, y = 6}
						card:set_sprites(card.config.center)
                        return true;
                    end
                }))
            end
        end
        if context.before and G.GAME.current_round.hands_played == 0 then
            local odd = 0
            local even = 0
            local face = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if (scored_card:get_id() == 11 or scored_card:get_id() == 12 or scored_card:get_id() == 13) and not scored_card.debuff then
                    face = 1
                end
                if (scored_card:get_id() == 10 or scored_card:get_id() == 8 or scored_card:get_id() == 6 or scored_card:get_id() == 4 or scored_card:get_id() == 2) and not scored_card.debuff then
                    even = 1
                end
                if (scored_card:get_id() == 9 or scored_card:get_id() == 7 or scored_card:get_id() == 5 or scored_card:get_id() == 3 or scored_card:get_id() == 14) and not scored_card.debuff then
                    odd = 1
                end
            end
            if (card.ability.extra.flip == 0 and face == 0) 
            or (card.ability.extra.flip == 1 and face == 0 and odd == 0 and even == 1) 
            or (card.ability.extra.flip == 2 and face == 0 and odd == 1 and even == 0) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(card.ability.extra.hands)
                        return true
                    end,
                }))
            end
        end
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(card, eval, true)
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuse_dynamic_duo" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "indecision",
    name = "Indecision Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 0, y = 5},
    config = {
        extra = {
            discards = 1,
            last = 0,
            flip = 0
        }
    },
    link_config = {j_fuse_flip_flop = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if card.ability.extra.flip == 1 then key = key.."_"..card.ability.extra.flip end
        return {
            key = key,
            vars = {
            card.ability.extra.discards * (1 + (link_level or 0)),
            }
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local link_level = self:get_link_level()
            if card.ability.extra.flip == 1 then
			G.E_MANAGER:add_event(Event({
				func = function()
                    ease_discard(card.ability.extra.discards * (1 + (link_level or 0)))
                    --card.ability.extra.last = card.ability.extra.discards * (1 + (link_level or 0))
					return true
				end,
			}))
            else
                G.hand:change_size(card.ability.extra.discards * (1 + (link_level or 0)))
                card.ability.extra.last = card.ability.extra.discards * (1 + (link_level or 0))
            end
        end
        if context.end_of_round and context.game_over == false and context.main_eval then
            if card.ability.extra.flip == 1 then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						card.ability.extra.flip = 0
						card:juice_up(1, 1)
						card.config.center.pos = {x = 0, y = 5}
						card:set_sprites(card.config.center)
                        return true;
                    end
                }))
            else
                G.hand:change_size(-card.ability.extra.last)
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						card.ability.extra.flip = 1
						card:juice_up(1, 1)
						card.config.center.pos = {x = 1, y = 5}
						card:set_sprites(card.config.center)
                        return true;
                    end
                }))
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuse_flip_flop" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "forget",
    name = "Forget Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 2, y = 5},
    config = {
        extra = {
            negative = 0,
            dollars = 10,
            hand_size = 1
        }
    },
    link_config = {j_fuse_dementia_joker = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.dollars,
            card.ability.extra.hand_size
            }
        }
    end,
    calculate = function(self, card, context)
        if context.partner_click and G.jokers and #G.jokers.highlighted == 1 then
            local joker = G.jokers.highlighted[1]
            if card.ability.extra.negative == 0 and joker.edition and joker.edition.key == "e_negative" then
                joker:set_edition({ negative = false })
                --self:set_edition({ negative = true })
                card.ability.extra.negative = 1
            elseif card.ability.extra.negative == 1 and not joker.edition then
                joker:set_edition({ negative = true })
                --self:set_edition({ negative = false })
                card.ability.extra.negative = 0
            end
        end
        if context.selling_card and context.card.edition and context.card.edition.key == "e_negative" then
            local link_level = self:get_link_level()
            if link_level == 1 then
                G.hand:change_size(card.ability.extra.hand_size)
                ease_dollars(card.ability.extra.dollars)
                return {
                    message = localize('$')..card.ability.extra.dollars,
                    colour = G.C.MONEY
                }
            end
        end
    end,
    draw = function(self, card, layer)
        if card.ability.extra.negative == 1 then
            card.children.center:draw_shader('negative', nil, card.ARGS.send_to_shader)
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuse_dementia_joker" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "onward",
    name = "Onward Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 3, y = 5},
    config = {
        extra = {
            chips = 0,
            chips_mod = 3,
            benefits = 1
        }
    },
    link_config = {j_fuse_flag_bearer = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    card.ability.extra.benefits = 1
    if link_level == 1 then card.ability.extra.benefits = 3 end
        return {
            vars = {
            card.ability.extra.chips,
            card.ability.extra.chips_mod * card.ability.extra.benefits
            }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == context.full_hand[#context.full_hand] then
--            local prev_chips = card.ability.extra.chips
            card.ability.extra.chips = math.max(0, card.ability.extra.chips - (card.ability.extra.chips_mod * card.ability.extra.benefits))
--            if card.ability.extra.chips ~= prev_chips then
--                return {
--                    message = localize{ type = "variable", key = "a_chips_minus", vars = { card.ability.extra.chips_mod * card.ability.extra.benefits } },
--                    colour = G.C.RED
--                }
--            end
-- Card becomes a nil value for no sane reason when it tries to read this code despite it reading it fine down below.
        end
        if context.before then
            card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chips_mod * card.ability.extra.benefits)
            return {
                message = localize{ type = "variable", key = "a_chips", vars = { card.ability.extra.chips_mod * card.ability.extra.benefits }},
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips * G.GAME.current_round.discards_left
            }
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuse_flag_bearer" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

Partner_API.Partner{
    key = "emote",
    name = "Emote Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 4, y = 5},
--    config = {
--        extra = {
--        }
--    },
    link_config = {j_fuse_uncanny_face = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
--            vars = {
--            }
        }
    end,
    calculate = function(self, card, context)
        if context.before then
            local link_level = self:get_link_level()
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 10 or scored_card:get_id() == 14 and link_level then
                    SMODS.change_base(scored_card, nil, 'Jack')
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end,
    check_for_unlock = function(self, args)
        for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
            if v.key == "j_fuse_uncanny_face" then
                if get_joker_win_sticker(v, true) >= 8 then
                    return true
                end
                break
            end
        end
    end
}

if special_day then
Partner_API.Partner{
    key = "birthday",
    name = "Birthday Partner",
    unlocked = false,
    discovered = true,
    atlas = "fuseforce_partners",
    pos = {x = 4, y = 6},
    config = {
        extra = {
            cost = 10
        }
    },
    link_config = {j_fuseforce_legendary_poxy = 1},
    loc_vars = function(self, info_queue, card)
    local link_level = self:get_link_level()
    local key = self.key
    if link_level == 1 then key = key.."_"..link_level end
        return {
            key = key,
            vars = {
            card.ability.extra.cost
            }
        }
    end,
    calculate = function(self, card, context)
        if context.partner_click and (to_big(G.GAME.dollars) - to_big(G.GAME.bankrupt_at)) >= to_big(card.ability.extra.cost) then
        local link_level = self:get_link_level()
        ease_dollars(-card.ability.extra.cost)
            if link_level then
                modify_joker_slot_count(1)
            end       
            if not link_level then
                local joker1 = "j_swashbuckler"
                local joker2 = "j_throwback"
                local joker3 = "j_egg"
                local joker4 = "j_golden"
                local joker5 = "j_fuseforce_skipper"
                local joker6 = "j_fuse_golden_egg"
                local set_joker = "j_egg"
                if next(SMODS.find_card('j_egg')) or next(SMODS.find_card('j_fuse_golden_egg')) and not next(SMODS.find_card('j_fuseforce_skipper')) then
                    if next(SMODS.find_card('j_golden')) or next(SMODS.find_card('j_fuse_golden_egg')) then
                        if next(SMODS.find_card('j_swashbuckler')) then
                            set_joker = "j_throwback"
                        else
                            set_joker = "j_swashbuckler"
                        end
                    else
                        set_joker = "j_golden"
                    end
                end                    
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                    play_sound('whoosh1')
                        local shop_joker = SMODS.add_card({
                            set = 'Joker',
                            area = G.shop_jokers,
                            key = set_joker
                        })
                        create_shop_card_ui(shop_joker, 'Joker', G.shop_jokers)
                        shop_joker.for_sale = true
                        shop_joker.ability.couponed = true
                        shop_joker:set_cost()
                        return true
                    end
                }))
            end
        end
    end,
    check_for_unlock = function(self, args)
        return true
    end
}
end