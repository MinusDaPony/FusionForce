return {
	["misc"] = {
		["dictionary"] = {
			["k_drunk_ex"] = "Drunk!",
			["k_fuseforce_gold_fusion"] = "Gold Fusion",
			["k_both_compat"] = "left & right",
			["k_left_compat"] = "left twice",
			["k_right_compat"] = "right twice",
			["k_fuseforce_joker_slot"] = "+1 Joker slot!",
			["k_fuseforce_joker_slot_minus"] = "lost Joker slots",
			["k_fuseforce_consumable_slot"] = "+1 Consumable slot!",
			["k_fuseforce_consumable_slot_minus"] = "lost slots",
			["k_plus_tarot_spectral"] = "+1 Both",
			},
		["v_dictionary"] = {
			["chancer_active"] = "tripled!",
			["chancer_inactive"] = "doubled",
			},
		},
	["descriptions"] = {
		["Back"] = {
			["b_fuseforce_fusiondeck"] = {
				["name"] = "Fusion Deck",
				["text"] = {
					"{C:attention}+#1#{} Joker slots",
					"Debuffs all non",
					"{X:money,C:white}Fusion{} Jokers",
					"Joker slots reduced by",
					"each {X:money,C:white}Fusion{} Joker",
				},
			},
			["b_fuseforce_minusdeck"] = {
				["name"] = "Minus Deck",
				["text"] = {
					"Start with {X:money,C:white,T:v_fuseforce_fusion_coupon}#1#{} and a {C:spectral,T:c_fuseforce_shadow}#2#",
					"{s:0.2} ",
					"Shadows can now be used on",
					"{X:money,C:white}Fusions{} to make them {C:dark_edition}Negative",
				},
			},
		},
		["Sleeve"] = {
			["sleeve_fuseforce_minussleeve"] = {
				["name"] = "Minus Sleeve",
				["text"] = {
					"Start with {X:money,C:white,T:v_fuseforce_fusion_coupon}#1#{} and a {C:spectral,T:c_fuseforce_shadow}#2#",
					"{s:0.2} ",
					"Shadows can now be used on",
					"{X:money,C:white}Fusions{} to make them {C:dark_edition}Negative",
				},
			},
			["sleeve_fuseforce_minussleeve_alt"] = {
				["name"] = "Minus Sleeve",
				["text"] = {
					"Start with a {C:spectral,T:c_fuseforce_shadow}#2#",
					"and {X:money,C:white,T:v_fuseforce_fusion_coupon2}#1#",
					"{s:0.2} ",
					"Shadows can now be used on",
					"{X:money,C:white}Fusions{} to make them {C:dark_edition}Negative",
				},
			},
		},
		["Partner"] = {
			["pnr_fuseforce_offer"] = {
				["name"] = "Offer",
				["text"] = {
					"Can go up to",
					"{C:red}-$#1#{} in debt",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Rewards Card{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_offer_1"] = {
				["name"] = "Offer",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"your {C:red}debt{} is halved",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Rewards Card{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_shh"] = {
				["name"] = "Shh!",
				["text"] = {
					"Click to pay {C:money}$#1#{} to",
					"give {C:chips}+#2#{} Chips and",
					"{C:mult}+#3#{} Mult for +1 round",
					"Currently lasts {C:attention}#4#{} rounds",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Sweet Theatre Combo{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_shh_1"] = {
				["name"] = "Shh!",
				["text"] = {
					"Click to pay {C:money}$#1#{} to",
					"make {C:attention}Sweet Theatre Combo",
					"last for one extra round",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Sweet Theatre Combo{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_neigh"] = {
				["name"] = "Neigh",
				["text"] = {
					"Gives {C:chips}+#1#{} Chips",
					"and {C:mult}+#2#{} Mult for",
					"every {C:money}$#4#{} you have",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Horse{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_neigh_1"] = {
				["name"] = "Neigh",
				["text"] = {
					"Gives {C:blue}+#3#{} Hands for",
					"every {C:money}$#4#{} you have",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Horse{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_prizes"] = {
				["name"] = "Prizes",
				["text"] = {
					"Every #1# {C:green}Rerolls",
					"spawns a {C:attention}Showman",
					"or {C:attention}Invisible Joker",
					"in the shop",
					"{C:inactive}(Currently #2# out of #1#)",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Shadowman{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_prizes_1"] = {
				["name"] = "Prizes",
				["text"] = {
					"Get free {C:green}Rerolls",
					"per shop equal to",
					"owned {C:dark_edition}Negative{} Jokers",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Shadowman{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_suitable"] = {
				["name"] = "Suitable",
				["text"] = {
					"Click to pay {C:money}$#1#{} to",
					"cycle your suit",
					"altering {C:tarot}Tarot{} card",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Black Hearted{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_magnetize"] = {
				["name"] = "Magnetize",
				["text"] = {
					"Create a {C:tarot}Devil{} or {C:tarot}Chariot",
					"card when blind selected",
					"{C:inactive}(Must have room)",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Alloy Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_magnetize_1"] = {
				["name"] = "Magnetize",
				["text"] = {
					"{C:attention}2{} random {C:attention}playing cards{} in your deck",
					"get enhanced when the blind is selected",
					"One becomes {C:money}Gold{} and one becomes {C:inactive}Steel",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Alloy Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_magnetize_2"] = {
				["name"] = "{C:money}Magnetize",
				["text"] = {
					"{C:attention}4{} random {C:attention}playing cards{} in your deck",
					"get enhanced when blind is selected",
					"Two become {C:money}Gold{} and two become {C:inactive}Steel",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Electrum Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_touch"] = {
				["name"] = "Touch",
				["text"] = {
					"Click to pay {C:money}$#1#{} to change",
					"the {C:attention}enhancement{} of the",
					"selected Playing Card",
					"{s:1.2}into {s:1.2,C:money}Gold",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Midas Hand{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_touch_1"] = {
				["name"] = "Touch",
				["text"] = {
					"Click to change the",
					"{C:attention}enhancement{} of the",
					"selected Playing Card",
					"{s:1.2}into {s:1.2,C:money}Gold",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Midas Hand{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_shrink"] = {
				["name"] = "Shrink",
				["text"] = {
					"Click to pay {C:money}$#1#{} to",
					"decrease rank of",
					"{C:attention}1{} selected card",
					"by {C:attention}1{} down to a",
					"minimum of {C:blue}2",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Amalgamult{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_teamwork"] = {
				["name"] = "Teamwork",
				["text"] = {
					"Gives {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult for",
					"each {X:money,C:white}Fusion{} Joker",
					"that you own",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Amalgamult{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_teamwork_1"] = {
				["name"] = "Teamwork",
				["text"] = {
					"Gives {C:chips}+#1#{} Chips and",
					"{C:mult}+#2#{} Mult for",
					"each {X:money,C:white}Fusion{} Joker",
					"that you own",
					"{s:0.2} ",
					"{C:attention}Amalgamult{} triggers",
					"all four effects",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Amalgamult{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_nice"] = {
				["name"] = "Nice",
				["text"] = {
					"{C:green}#3# in #1#{} chance to create",
					"a {C:tarot}Tarot{} card and also",
					"{C:green}#3# in #2#{} chance to create a",
					"{C:spectral}Spectral{} card when blind selected",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Chancer{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_nice_1"] = {
				["name"] = "Nice",
				["text"] = {
					"{C:attention}#1#{} and {C:attention}#2#{} card always score",
					"{C:green}#3# in #1#{} chance to create",
					"a {C:tarot}Tarot{} card and also",
					"{C:green}#3# in #2#{} chance to create a",
					"{C:spectral}Spectral{} card when blind selected",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Chancer{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_nice_2"] = {
				["name"] = "Nice",
				["text"] = {
					"{C:attention}#1#{}s & {C:attention}#2#{}s give {C:red}#3#{} Mult from chance",
					"{C:green}#3# in #1#{} chance to create",
					"a {C:tarot}Tarot{} card and also",
					"{C:green}#3# in #2#{} chance to create a",
					"{C:spectral}Spectral{} card when blind selected",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Chancer{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_lucky_break"] = {
				["name"] = "Lucky Break",
				["text"] = {
					"{C:green}#1# in #2#{} chance for",
					"{C:attention}7{}s to become {C:attention}Lucky",
					"and {C:attention}Kings{} to become",
					"{C:attention}Glass{} when scored",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Unlucky Cat{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_lucky_break_1"] = {
				["name"] = "Lucky Break",
				["text"] = {
					"{C:green}#1# in #2#{} chance for",
					"{C:attention}7{}s to become {C:attention}Lucky",
					"and generate 1 {C:attention}Magician",
					"{s:0.2} ",
					"and {C:attention}Kings{} to become",
					"{C:attention}Glass{} and generate 1",
					"{C:attention}Justice{} when scored",
					"{C:inactive}(Must have room)",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Unlucky Cat{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_front"] = {
				["name"] = "Front",
				["text"] = {
					"{C:attention}First{} played card is",
					"considered a {C:attention}Face{} card",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Sticker Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_front_1"] = {
				["name"] = "Front",
				["text"] = {
					"{C:attention}Kings{}, {C:attention}Queens{}, and {C:attention}Jacks{}",
					"give {X:mult,C:white}X#1#{} Mult when scored",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Sticker Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_fistbump"] = {
				["name"] = "Fistbump",
				["text"] = {
					"Gives {C:attention}+#1#{} Hand if",
					"{C:attention}First Hand{} has only",
					"{C:blue}Odd{}/{C:red}Even{} scoring cards",
					"Swaps each blind",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Dynamic Duo{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_fistbump_1"] = {
				["name"] = "Fistbump",
				["text"] = {
					"Gives {C:attention}+#1#{} Hand if",
					"{C:attention}First Hand{} has only",
					"{C:red}Even{} scoring cards",
					"Swaps each blind",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Dynamic Duo{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_fistbump_2"] = {
				["name"] = "Fistbump",
				["text"] = {
					"Gives {C:attention}+#1#{} Hand if",
					"{C:attention}First Hand{} has only",
					"{C:blue}Odd{} scoring cards",
					"Swaps each blind",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Dynamic Duo{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_fistbump_3"] = {
				["name"] = "Fistbump",
				["text"] = {
					"Gives {C:attention}+#1#{} Hand if",
					"{C:attention}First Hand{} has only",
					"{C:blue}Number{} scoring cards",
					"Swaps each blind",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Dynamic Duo{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_indecision"] = {
				["name"] = "Indecision",
				["text"] = {
					"{C:blue}+#1#{} Hand Size",
					"{C:attention}Flips{} after each blind",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Flip-Flop{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_indecision_1"] = {
				["name"] = "Indecision",
				["text"] = {
					"{C:red}+#1#{} Discards",
					"{C:attention}Flips{} after each blind",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Flip-Flop{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_forget"] = {
				["name"] = "Forget",
				["text"] = {
					"Click with a selected joker to",
					"remove and store {C:dark_edition}Negative{},",
					"or apply stored {C:dark_edition}Negative{} to it",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Dementia Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_forget_1"] = {
				["name"] = "Forget",
				["text"] = {
					"Click with a selected joker to",
					"remove and store {C:dark_edition}Negative{},",
					"or apply stored {C:dark_edition}Negative{} to it",
					"{s:0.2} ",
					"{C:dark_edition}Negative{} Jokers sold earn an extra",
					"{C:money}$#1#{} and increase hand size by {C:attention}#2#",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Dementia Joker{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_onward"] = {
				["name"] = "Onward",
				["text"] = {
					"{C:chips}+#2#{} Chips per hand played",
					"{C:chips}-#2#{} Chips per discard",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
					"Chips are multiplied",
					"by remaining {C:red}discards{}",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Flag Bearer{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_emote"] = {
				["name"] = "Emote",
				["text"] = {
					"Scored {C:attention}10{}s",
					"turn into {C:attention}Jacks",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Uncanny Face{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
			["pnr_fuseforce_emote_1"] = {
				["name"] = "Emote",
				["text"] = {
					"Scored {C:attention}Aces{} and {C:attention}10{}s",
					"turn into {C:attention}Jacks",
				},
				["unlock"] = {
					"Win a run with",
					"{C:attention}Uncanny Face{} on",
					"{C:attention}Gold Stake{} difficulty",
				},
			},
		},
		["Ortalab Artist"] = {
			['gappie'] = {
				["text"] = {
					"Gappie",
				}
			},
			['minus'] = {
				["text"] = {
					"Minus",
				}
			},
			['luna'] = {
				["text"] = {
					"Iwas_alwaysLuna",
				}
			},
			['itayfeder'] = {
				["text"] = {
					"itayfeder",
				}
			},
		},
		["Joker"] = {
			["j_fuseforce_clairvoyant"] = {
				["name"] = "Clairvoyant",
				["text"] = {
					"Create a {C:spectral}Spectral{} card",
					"if played hand contains",
					"a {C:attention}Six{} and a {C:attention}Straight",
					"{C:inactive}(Must have room)",
					"{C:inactive}(#1# + #2#)"
				},
			},
			["j_fuseforce_power_pop"] = {
				["name"] = "Power Pop",
				["text"] = {
					"When {C:attention}Blind{} is skipped,",
					"create a copy of",
					"the gained {C:attention}tag{}",
					"Gains {C:white,X:mult}X#2#{} Mult per",
					"{C:attention}Blind{} skipped this run",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_reach_the_stars"] = {
				["name"] = "Reach the Stars",
				["text"] = {
					"Cards {C:attention}held in hand{}",
					"give {C:mult}Mult{} equal to",
					"their {C:attention}rank{}",
					"{s:0.8,C:inactive}(#1# + #2#)"
				},
			},
			["j_fuseforce_rewards_card"] = {
				["name"] = "Rewards Card",
				["text"] = {
					"Go up to {C:red}-$#2#{} in debt",
					"Adds {C:money}$#1#{} of {C:attention}sell value{} to every",
					"owned {C:attention}Joker{} and {C:attention}Consumable{}",
					"Debt is equal to sell value of",
					"all owned {C:attention}Jokers{} added up",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_masters_degree"] = {
				["name"] = "Master's Degree",
				["text"] = {
					"When round begins, add a",
					"random {C:attention}Ace{} to hand",
					"Scored {C:attention}Aces{} give",
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
					"and gain a random {C:attention}seal",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_soothsayer"] = {
				["name"] = "Soothsayer",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"create a random {C:planet}Planet{}",
					"and {C:tarot}Tarot{} card",
					"{s:0.2} ",
					"{C:planet}Celestial Packs{}, {C:tarot}Arcana Packs",
					"{C:planet}Planet{}, and {C:tarot}Tarot{} cards,",
					"are all {C:attention}free",
					"{C:inactive}(#1# + #2#)"
				},
			},
			["j_fuseforce_prosopagnosia"] = {
				["name"] = "Prosopagnosia",
				["text"] = {
					"All cards count as",
					"{C:attention}face{} cards",
					"Earn {C:money}$#1#{} for each",
					"discarded {C:attention}face{} card",
					"{C:inactive}(#2# + #3#)"
				},
			},
			["j_fuseforce_energy_drink"] = {
				["name"] = "Energy Drink",
				["text"] = {
					"Gains {C:chips}+#3#{} Chips if played",
					"hand contains a {C:attention}Straight",
					"{C:chips}-#2#{} Chips for every hand played",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_boxer_shorts"] = {
				["name"] = "Boxer Shorts",
				["text"] = {
					"Gains {C:chips}+#3#{} Chips",
					"and {C:mult}+#4#{} Mult if",
					"played hand is a {C:attention}Two Pair{}",
					"with exactly {C:attention}4{} cards",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips and {C:mult}+#1#{C:inactive} Mult)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_over_and_out"] = {
				["name"] = "Over and Out",
				["text"] = {
					"Each played {C:attention}10{} or {C:attention}4{} gives",
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult when scored,",
					"On {C:attention}final hand{} of round they also",
					"give {C:white,X:chips}X#3#0{} Chips and {C:white,X:mult}X#4#{} Mult,",
					"{C:attention}10{} and {C:attention}4{} card always score",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_sweet_theatre_combo"] = {
				["name"] = "Sweet Theatre Combo",
				["text"] = {
					"Gives {C:chips}+#2#{} Chips",
    					"and {C:mult}+#1#{} Mult",
    					"Destroyed after",
    					"{C:attention}#3#{} rounds",
    					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_bribery_clown"] = {
				["name"] = "Lucid Dreaming",
				["text"] = {
					"Create a {C:tarot}Tarot{} card when",
					"any {C:attention}Booster Pack{} is opened",
					"Gains {C:red}+#2#{} Mult when any",
					"{C:attention}Booster Pack{} is skipped",
					"{C:inactive}(Must have room)",
					"{C:inactive}(Currently {C:red}+#1#{C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_moorstone"] = {
				["name"] = "Moorstone",
				["text"] = {
					"Gains {C:chips}+#1#{} Chips for each",
					"{C:attention}Stone Card{} in full deck",
					"After playing {C:attention}#3#{} more",
					"{C:attention}Stone{} cards, add",
					"a {C:attention}Stone{} card to deck",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_oscar_best_actor"] = {
				["name"] = "Masquerade",
				["text"] = {
					"{C:attention}Held in hand{} abilities",
					"and played {C:attention}face{} cards",
					"all retrigger {C:attention}#1#{} times",
					"{C:attention}Held in hand face card",
					"abilities retrigger again",
					"{C:inactive}(#2# + #3#)"
				},
			},
			["j_fuseforce_optimist"] = {
				["name"] = "Optimist",
				["text"] = {
					"{C:attention}+#1#{} hand size",
					"{C:blue}#2#{} hands per round",
					"{C:red}+#3#{} discards",
					"{s:0.8,C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_fight_a_bull"] = {
				["name"] = "Horse",
				["text"] = {
					"Gives {C:mult}+#3#{} Mult",
					"and {C:chips}+#4#{} Chips",
					"for every {C:money}$3{} you have",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_melancholy_phantom"] = {
				["name"] = "Melancholy Phantom",
				["text"] = {
					"Gains {X:mult,C:white}X0.25{} Mult and {C:chips}+8",
					"Chips per {C:attention}playing card",
					"added to your deck",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_solar_flare_joker"] = {
				["name"] = "Solar Flare Joker",
				["text"] = {
					"{C:green}#1# in #2#{} chance to upgrade",
					"level of played {C:attention}poker hand{}",
					"and {C:attention}discarded poker hand",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_blue_java"] = {
				["name"] = "Blue Java",
				["text"] = {
					"{X:mult,C:white}X#1#{} Mult{}, {C:green}#3# in #4#{}",
					"chance to decrease",
					"by {X:mult,C:white}X#2#{} Mult",
					"at the end of a round",
					"{s:0.9,C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_serial_killer"] = {
				["name"] = "Serial Killer",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"tries to destroy the {C:attention}Joker{} on",
					"the right to gain {X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_minotaur"] = {
				["name"] = "Minotaur",
				["text"] = {
					"{C:chips}+#2#{} Chips for every {C:money}$1{} you have",
					"Doubles these chips during {C:attention}Boss Blind",
					"Gains {C:chips}+2{} more when {C:attention}Boss Blind{} defeated",
					"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_time_keeper"] = {
				["name"] = "Time Keeper",
				["text"] = {
					"Gives {C:chips}+#1#{} Chips for each",
					"card left in {C:attention}deck",
					"Earn {C:money}$#3#{} per unused {C:attention}discard",
					"{s:0.2} ",
					"Gain {C:red}+1 discard{} if {C:attention}#5#{} rounds",
					"end with no discards used",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
					"{C:inactive}(Currently {C:red}+#4#{C:inactive} Discards)",
					"{s:0.8,C:inactive}(#6# + #7#)"
				},
			},
			["j_fuseforce_four_inch_gap"] = {
				["name"] = "Four Inch Gap",
				["text"] = {
					"{C:attention}Flushes{} and {C:attention}Straights{}",
					"can be made with {C:attention}4{} cards",
					"{C:attention}Straights{} can have",
					"gaps of {C:attention}1{} rank",
					"{C:attention}#1#{} extra card can be",
					"{C:attention}selected{} for hands",
					"{C:inactive}(#2# + #3#)"
				},
			},
			["j_fuseforce_cavepainting"] = {
				["name"] = "Cave Painting",
				["text"] = {
					"{X:mult,C:white}X#2#{} Mult if played",
					"hand contains a {C:attention}#3#",
					"{s:0.2} ",
					"{V:1}#4#{} suit gives {X:mult,C:white}X#1#",
					"Mult when scored,",
					"and counts as all suits",
					"{s:0.8}suit changes at end of round",
					"{s:0.8,C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_skipper"] = {
				["name"] = "Skipper",
				["text"] = {
					"Adds a fifth of the",
					"sell value of all other",
					"owned {C:attention}Jokers{} to {X:mult,C:white}XMult",
					"Gains {X:mult,C:white}X0.25{} Mult",
					"per {C:attention}Blind{} skipped this run",
					"{C:money}$#2#{} when skipping a {C:attention}blind",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_two_heads"] = {
				["name"] = "Two Heads",
				["text"] = {
					"{C:inactive}are better than one",
					"Copies abilities of",
					"{C:attention}Joker{} to the left",
					"and to the right",
					"Copies twice if only",
					"one {C:green}compatible{} Joker",
					"{s:0.9,C:inactive}(#3# + #2#)"
				},
			},
			["j_fuseforce_giant_shoulders"] = {
				["name"] = "Two Heads",
				["text"] = {
					"{C:inactive}are better than one",
					"Retrigger all other",
					"{X:money,C:white}Fusion{} Jokers",
					"{C:attention}#1#{} times",
					"{s:0.9,C:inactive}(#3# + #2#)"
				},
			},
			["j_fuseforce_ivy"] = {
				["name"] = "Ivy",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"add one {C:attention}Stone{} card to deck",
					"Played {C:attention}Stone{} cards become {C:attention}Wild{} cards",
					"Each {C:attention}Wild card played gives",
					"{C:chips}+#2#{} Chips{} and {X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_dye_pack"] = {
				["name"] = "Dye Pack",
				["text"] = {
					"Gain {C:blue}+#1#{} Hands when",
					"{C:attention}Blind{} is selected,",
					"First {C:attention}discard{} each",
					"round earns {C:money}$#2#",
					"Discards {C:red}destroy{} cards",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_scratch"] = {
				["name"] = "Scratch",
				["text"] = {
					"{C:green}#1# in #2#{} chance to create",
					"a {C:tarot}Tarot{} card when hand played",
					"{C:green}8 in 8{} if at {C:money}$#3#{} or less",
					"then {C:green}#1# in #2#{} chance to create",
					"a {C:dark_edition}Negative{} {C:tarot}Tarot{} card instead",
					"Each {C:attention}8{} played retriggers this",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_black_hearted"] = {
				["name"] = "Black Hearted",
				["text"] = {
					"This Joker gains {X:mult,C:white}X#2#{} Mult per",
					"scoring {C:hearts}Light {C:diamonds}Suit{} card played",
					"Changes the card's suit from {C:hearts}Hearts",
					"to {C:spades}Spades{} and {C:diamonds}Diamonds{} to {C:clubs}Clubs",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_cut_and_pasted"] = {
				["name"] = "Cut and Pasted Joker",
				["text"] = {
					"{C:attention}First{} played card gives {C:mult}#1#{} Mult and is",
					"retriggered for each card not selected",
					"Gains {C:mult}#2#{} Mult per {C:attention}Joker{} sold",
					"Gives {X:red,C:white}X1{} Mult per empty {C:attention}Joker{} slot",
					"{s:0.9,C:inactive}(This Joker counts as an empty slot)",
					"{C:inactive}(Currently {X:red,C:white}X#3#{C:inactive} Mult)",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_alloy"] = {
				["name"] = "Alloy Joker",
				["text"] = {
					"Each {C:attention}Gold{} card gives",
					"{X:mult,C:white}X#1#{} Mult while in hand",
					"{C:money}$#2#{} per {C:attention}Steel{} card held",
					"in hand at end of round",
					"{s:0.8,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_midas_hand"] = {
				["name"] = "Midas Hand",
				["text"] = {
					"All played {C:attention}face{} cards become",
					"{C:attention}Gold{} cards when scored",
					"Each {C:attention}King{} held in hand",
					"gives {X:mult,C:white}X#1#{} Mult",
					"Gain {C:red}#2#{} hand size for every",
					"3 {C:attention}Gold Kings{} in your deck",
					"{C:inactive}(Currently {C:red}#3#{C:inactive} Hand Size)",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_stew_and_dumplings"] = {
				["name"] = "Stew and Dumplings",
				["text"] = {
					"{X:mult,C:white}X#1#{} Mult,",
					"gains {X:mult,C:white}X#2#{} Mult",
					"per {C:attention}card{} discarded",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_water_bottle"] = {
				["name"] = "{s:0.7}Dry Jokes are Thirsty Work",
				["text"] = {
					"For the next {C:attention}#2#{} cards,",
					"all played cards are",
					"retriggered {C:attention}#1#{} times",
					"Count does not decrease",
					"if scoring hand contains",
					"a {C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_kintsugi"] = {
				["name"] = "Kintsugi",
				["text"] = {
					"Gives {X:mult,C:white}X#2#{} Mult",
					"per {C:attention}Wild Card in",
					"your {C:attention}full deck{} and",
					"gives {X:mult,C:white}X#1#{} Mult per",
					"Suit in {C:attention}Played Hand",
					"{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
					"{s:0.8,C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_greener_joker"] = {
				["name"] = "Greener Joker",
				["text"] = {
					"{C:mult}+#2#{} Mult {V:1}per {V:2}suit",
					"in hand played",
					"{C:mult}-#2#{} Mult {V:3}per {V:4}suit",
					"in discarded hand",
					"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)",
					"{s:0.8,C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_paranormal"] = {
				["name"] = "Paranormal Joker",
				["text"] = {
					"Gains {C:red}+#1#{} Mult per",
					"{C:purple}Tarot{} card used this run",
					"and {X:mult,C:white}X#3#{} Mult per",
					"{C:spectral}Spectral{} card used this run",
					"{C:inactive}(Currently {C:red}+#2#{C:inactive} and {X:mult,C:white}X#4#{C:inactive} Mult)",
					"{s:0.9,C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_black_soul"] = {
				["name"] = "Black Soul",
				["text"] = {
					"If poker hand is a {C:attention}#1#",
					"create a random {C:spectral}Spectral{} card",
					"{s:0.2} ",
					"Create a {C:tarot}Tarot{} card if poker hand",
					"contains an {C:attention}Ace{} and a {C:attention}#2#",
					"{s:0.2} ",
					"But if poker hand is a {C:attention}Royal Flush",
					"{C:green}#3# in #4#{} chance to create a {C:legendary}Soul",
					"otherwise a {C:legendary}Black Hole{} is created",
					"{C:inactive}(Must have room)",
					"{s:0.9,C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_bargaining_chips"] = {
				["name"] = "Bargaining Chips",
				["text"] = {
					"For every {C:attention}#1#{} blinds",
					"beaten by at least",
					"{C:attention}25%{} over the target,",
					"gain {C:dark_edition}+1 Joker Slot",
					"{C:inactive}({C:attention}#2# {C:inactive}out of #1# blinds beaten",
					"{C:inactive}and {C:dark_edition}#3# {C:inactive}gained joker slots)",
					"{s:0.9,C:inactive}(The {s:0.9,C:attention}#4# {s:0.9,C:inactive}stake sticker on this",
					"{s:0.9,C:inactive}decreases blinds needed by {s:0.9,C:attention}#5#{s:0.9,C:inactive})",
					"{C:inactive}(#6# + #7#)"
				},
			},
			["j_fuseforce_giant_beanstalk"] = {
				["name"] = "Giant Beanstalk",
				["text"] = {
					"Gains {C:blue}+1{} Hand Size",
					"and {X:mult,C:white}X#2#{} Mult for each",
					"{C:attention}Jack{} discarded this round",
					"Discarding a {C:attention}Jack{}",
					"gives {C:attention}+1 discard",
					"{C:inactive}(Currently {C:blue}+#3#{C:inactive} Hand Size and {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_smurf"] = {
				["name"] = "Smurf Joker",
				["text"] = {
					"Gains {C:chips}+#2#{} Chips when",
					"each played {C:attention}2{} is scored,",
					"Gives {X:chips,C:white}X#3#{} Chips for",
					"each {C:attention}2{} in your {C:attention}full deck",
					"{s:0.8,C:inactive}(Currently {s:0.8,C:chips}+#1#{s:0.8,C:inactive} and {s:0.8,X:chips,C:white}X#4#{s:0.8,C:inactive} Chips)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_fused"] = {
				["name"] = "Amalgamult",
				["text"] = {
					"Gives {C:blue}+8{} Chips or {C:red}+6",
					"Mult or {C:money}$4{} or {X:mult,C:white}X2{} Mult",
					"{C:inactive}(#1# + #2#)"
				},
			},
			["j_fuseforce_card_collection"] = {
				["name"] = "Card Collection",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"create #1# {C:green}Uncommon {C:attention}Jokers",
					"Or create #2# {C:red}Rare {C:attention}Joker",
					"instead against a {C:attention}Boss Blind",
					"{C:inactive}(Must have room)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_chancer"] = {
				["name"] = "Chancer",
				["text"] = {
					"Earn {C:money}$#1#{} for each {C:attention}6{} and {C:attention}9{} in",
					"your {C:attention}full deck{} at end of round",
					"Doubles all {C:attention}listed {C:green}probabilities",
					"{s:0.9}Triples if last hand contained {s:0.9,C:attention}6{s:0.9} or {s:0.9,C:attention}9",
					"{C:inactive}(Currently {C:money}$#2#{C:inactive} and chance {C:green}#3#{C:inactive})",
					"{C:inactive}(#5# + #4#)"
				},
			},
			["j_fuseforce_sticker"] = {
				["name"] = "Sticker Joker",
				["text"] = {
					"All cards are considered {C:attention}face{} cards",
					"Played cards other than the",
					"first give {X:mult,C:white}X#1#{} Mult when scored",
					"{C:inactive}(#2# + #3#)"
				},
			},
			["j_fuseforce_golden_calf"] = {
				["name"] = "Golden Calf",
				["text"] = {
					"This Joker gains {X:mult,C:white}X#2#{} Mult",
					"for each card {C:attention}sold{}, loses",
					"{X:mult,C:white}X#2#{} Mult per {C:attention}Round Played",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_shadowman"] = {
				["name"] = "Shadowman",
				["text"] = {
					"{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{},",
					"and {C:spectral}Spectral{} cards may",
					"appear multiple times",
					"{C:attention}Joker{} cards you already have",
					"including {X:money,C:white}fusion{} components",
					"appear {C:dark_edition}Negative{} in the shop",
					"{s:0.9,C:inactive}(#1# + #2#)"
				},
			},
			["j_fuseforce_gargoyle"] = {
				["name"] = "Gargoyle",
				["text"] = {
					"Each played {C:attention}Stone{} card",
					"gives {C:mult}+#1#{} Mult for",
					"every {C:attention}Stone{} card in",
					"your {C:attention}Full Deck{} and",
					"{X:mult,C:white}X#3#{} Mult when scored",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_ratio_road"] = {
				["name"] = "Ratio Road",
				["text"] = {
					"Each played {C:attention}Ace{}, {C:attention}2{}, {C:attention}3{}, {C:attention}5{}, or {C:attention}8",
					"gives {C:mult}+#1#{} Mult for each Enhanced",
					"card in your full deck when scored",
					"Gives {X:mult,C:white}X#3#{} Mult which increments",
					"up by {X:mult,C:white}X1{} after you have {C:attention}#4#",
					"Enhanced cards in your full deck,",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_ransom"] = {
				["name"] = "Ransom Note",
				["text"] = {
					"Earn {C:money}$#1#{} for each scoring or discarded {C:attention}#3#",
					"Earn twice as much if {C:attention}poker hand{} is a {C:attention}#2#",
					"Hand and rank changes every round",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_unlucky_cat"] = {
				["name"] = "Unlucky Cat",
				["text"] = {
					"{s:0.9}Doubles all {s:0.9,C:attention}listed {s:0.9,C:green}probabilities",
					"Gains {X:mult,C:white}X#2#{} Mult every",
					"time a {C:attention}Lucky{} card",
					"{C:green}successfully{} triggers,",
					"{X:mult,C:white}X#3#{} Mult every time",
					"{C:attention}Wheel of Fortune",
					"is {C:green}successful{},",
					"and {X:mult,C:white}X#4#{} Mult for",
					"every {C:attention}Glass Card",
					"that is destroyed",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_sand"] = {
				["name"] = "Sand Joker",
				["text"] = {
					"Gains {C:mult}+#1#{} and {X:mult,C:white}X#4#{} Mult for",
					"every {C:attention}Glass Card destroyed",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} and {X:mult,C:white}X#3#{C:inactive} Mult)",
					"{C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_assassin"] = {
				["name"] = "Assassin",
				["text"] = {
					"When discarding {C:attention}#6#{} or more cards, gain {C:chips}+#2#{} Chips",
					"and {C:money}$#4#{} if at least {C:attention}#6#{} are a {V:1}#7#{} or {C:attention}face{} card,",
					"or {C:chips}+#3#{} Chips and {C:money}$#5#{} if {V:1}#7# {C:chips}and {C:attention}face{} cards",
					"{s:0.9,C:inactive}(Suit changes every round. Currently {s:0.9,C:chips}+#1#{s:0.9,C:inactive} Chips)",
					"{C:inactive}(#8# + #9#)"
				},
			},
			["j_fuseforce_hybrid"] = {
				["name"] = "Hybrid Fusion",
				["text"] = {
					"Only for the {C:attention}first hand{} of each round:",
					"If the played hand is only {C:attention}#3#{} card, add #1#",
					"permanent copy to deck and draw it to hand",
					"{C:attention}#4#{} cards, adds a copy of the first card with",
					"the {C:blue}enhancement/edition/seal{} of the second",
					"{C:attention}#5#{} cards, gives {C:mult}+#2#{} Mult",
					"{C:attention}4{} or more and all played cards are {C:red}destroyed",
					"{C:inactive}(#6# + #7#)"
				},
			},
			["j_fuseforce_lighthouse"] = {
				["name"] = "Lighthouse",
				["text"] = {
					"Every {C:attention}played card{} counts in scoring",
					"Gains {X:mult,C:white}X#2#{} Mult per {C:attention}consecutive",
					"hand played while playing",
					"your most played {C:attention}poker hand",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_card_shark"] = {
				["name"] = "Card Shark",
				["text"] = {
					"Every {C:attention}played card{} counts in scoring",
					"Gives {X:mult,C:white}X#1#{} Mult",
					"Earns {C:money}$#2#{} for each time {C:attention}hand{} has",
					"been played and gives another",
					"{X:mult,C:white}X#1#{} Mult if played poker {C:attention}hand",
					"has already been played this {C:attention}round",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_rgb"] = {
				["name"] = "{C:red}R{C:green}G{C:blue}B{} Joker",
				["text"] = {
					"{s:0.9}Gains {s:0.9,C:chips}+#2#{s:0.9} Chips for every card scored",
					"{s:0.9}Loses {s:0.9,C:chips}-#2#{s:0.9} Chips for every card discarded",
					"{s:0.9}Gains {s:0.9,C:mult}+#4#{s:0.9} Mult for every hand played",
					"{s:0.9}Loses {s:0.9,C:mult}-#4#{s:0.9} Mult for every hand discarded",
					"{s:0.9}Gains {s:0.9,X:chips,C:white}X#6#{s:0.9} Chips for every booster opened",
					"{s:0.9}Gains {s:0.9,X:mult,C:white}X#8#{s:0.9} Mult for every booster skipped",
					"{C:inactive}(Currently {C:chips}#1#{C:inactive} and {X:chips,C:white}X#5#{C:inactive} Chips)",
					"{C:inactive}(Currently {C:mult}#3#{C:inactive} and {X:mult,C:white}X#7#{C:inactive} Mult)",
					"{s:0.8,C:inactive}(#9# + #10# + #11#)"
				},
			},
			["j_fuseforce_vain"] = {
				["name"] = "Vain Joker",
				["text"] = {
					"{C:chips}+#1#{} Chips, {C:red}+#2#{} and {X:mult,C:white}X#3#{} Mult if",
					"played hand contains a {C:attention}#6#",
					"{s:0.2} ",
					"At end of round, earn {C:money}$#4#{} for each",
					"{C:attention}#6#{} and {C:attention}#7#{} played",
					"{s:1.2,C:inactive}(Currently {s:1.2,C:money}$#5#{s:1.2,C:inactive})",
					"{s:0.9,C:inactive}(#8# + #9# + #10#)"
				},
			},
			["j_fuseforce_fruity"] = {
				["name"] = "Fruity Joker",
				["text"] = {
					"{C:chips}+#1#{} Chips, {C:red}+#2#{} and {X:mult,C:white}X#3#{} Mult if",
					"played hand contains a {C:attention}#6#",
					"{s:0.2} ",
					"At end of round, earn {C:money}$#4#{} for each",
					"{C:attention}#6#{} and {C:attention}#7#{} played",
					"{s:1.2,C:inactive}(Currently {s:1.2,C:money}$#5#{s:1.2,C:inactive})",
					"{s:0.9,C:inactive}(#8# + #9# + #10#)"
				},
			},
			["j_fuseforce_twotwo"] = {
				["name"] = "Twotwo Joker",
				["text"] = {
					"{C:chips}+#1#{} Chips, {C:red}+#2#{} and {X:mult,C:white}X#3#{} Mult if",
					"played hand contains either",
					"a {C:attention}#6#{} or a {C:attention}#7#",
					"{s:0.2} ",
					"At end of round, earn {C:money}$#4#{} for each",
					"{C:attention}#6#{} and {C:attention}#7#{} played",
					"{s:1.2,C:inactive}(Currently {s:1.2,C:money}$#5#{s:1.2,C:inactive})",
					"{s:0.9,C:inactive}(#8# + #9# + #10#)"
				},
			},
			["j_fuseforce_straight_man"] = {
				["name"] = "The Straight Man",
				["text"] = {
					"{C:chips}+#1#{} Chips, {C:red}+#2#{} and {X:mult,C:white}X#3#{} Mult if",
					"played hand contains a {C:attention}#6#",
					"{s:0.2} ",
					"At end of round, earn {C:money}$#4#{} for each",
					"{C:attention}#6#{} and {C:attention}#7#{} played",
					"{s:1.2,C:inactive}(Currently {s:1.2,C:money}$#5#{s:1.2,C:inactive})",
					"{s:0.8,C:inactive}(#8# + #9# + #10#)"
				},
			},
			["j_fuseforce_flushed"] = {
				["name"] = "Flushed Joker",
				["text"] = {
					"{C:chips}+#1#{} Chips, {C:red}+#2#{} and {X:mult,C:white}X#3#{} Mult if",
					"played hand contains a {C:attention}#6#",
					"{s:0.2} ",
					"At end of round, earn {C:money}$#4#{} for each",
					"{C:attention}#6#{} and {C:attention}#7#{} played",
					"{s:1.2,C:inactive}(Currently {s:1.2,C:money}$#5#{s:1.2,C:inactive})",
					"{s:0.8,C:inactive}(#8# + #9# + #10#)"
				},
			},
			["j_fuseforce_gold_alloy"] = {
				["name"] = "{C:money}Electrum Joker",
				["text"] = {
					"Each {C:attention}Gold{} card held",
					"in hand gives {X:mult,C:white}X#1#{} Mult",
					"Earn {C:money}$#2#{} per {C:attention}Steel{} card",
					"held in hand at end of round",
					"{C:money}Played {C:attention}Gold{C:money} or {C:attention}Steel{C:money} cards",
					"{C:money}will earn $#4# when scored",
					"{C:money}Gives {X:mult,C:white}X#3# {C:money} Mult for each {C:attention}Gold",
					"{C:money}and {C:attention}Steel{C:money} card in your full deck",
					"{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult)",
					"{C:inactive}(#6# + #7#)"
				},
			},
			["j_fuseforce_gold_golden_calf"] = {
				["name"] = "{C:money}Golden Calf",
				["text"] = {
					"This Joker gains {X:mult,C:white}X#2#",
					"Mult for each card {C:attention}sold",
					"Loses {X:mult,C:white}X#2#{} Mult per {C:attention}Round Played",
					"{C:green}#3# in #4#{C:money} chance to gain {C:dark_edition}+1 Joker Slot",
					"{C:money}or {C:attention}+1 Consumable Slot{C:money} when one is sold",
					"{s:1.2,C:inactive}(Currently {s:1.2,X:mult,C:white} X#1# {s:1.2,C:inactive} Mult)",
					"{s:0.8,C:inactive}(Currently gained {s:0.8,C:dark_edition}#6# {s:0.8,C:inactive}joker and {s:0.8,C:attention}#5# {s:0.8,C:inactive}consumable slots)",
					"{C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_gold_serial_killer"] = {
				["name"] = "{C:money}Serial Killer",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"tries to destroy the {C:attention}Joker{} on",
					"the right to gain {X:mult,C:white}X#1#{} Mult",
					"{C:money} multiplied by its sell value",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_gold_skipper"] = {
				["name"] = "{C:tsun_gradient_gold}Skipper",
				["text"] = {
					"Adds a fifth of the sell value of",
					"all other owned {C:attention}Jokers{} to Mult",
					"{s:0.9}Gains {s:0.9,X:mult,C:white}X0.25{s:0.9} Mult per {s:0.9,C:attention}Blind{s:0.9} skipped this run",
					"Gain {C:money}$#2#{} when skipping a {C:attention}Blind",
					"{C:tsun_gold4}Every played card counts in scoring",
					"{C:tsun_gold4}Every 5 extra played cards",
					"{C:tsun_gold4}increases blind skip count",
					"{s:0.9,C:inactive}(Currently {s:0.9,C:attention}#3#{s:0.9,C:inactive} out of {s:0.9,C:attention}5{s:0.9,C:inactive} extra cards played)",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{C:inactive}(#4# + #5#)"
				},
			},
			["j_fuseforce_orta_diamonddemon"] = {
				["name"] = "Diamond Demon",
				["text"] = {
					"Each {V:1}#1#{} scored has",
					"a {C:green}#3# in #4#{} chance to give",
					"Chips equal to your money",
					"{V:1}#2#{} held in hand",
					"give {C:money}$#5#{} when hand played",
					"{s:0.8,C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_orta_heartmimic"] = {
				["name"] = "Heart Mimic",
				["text"] = {
					"Before a {V:1}#1#{} scores,",
					"held {V:1}#5#{} have a",
					"{C:green}#2# in #3#{} chance to give",
					"{s:1.2,X:mult,C:white}X#4#{} {s:1.2}Mult",
					"{s:0.8,C:inactive}(#6# + #7#)"
				},
			},
			["j_fuseforce_orta_spadeslime"] = {
				["name"] = "Spade Slime",
				["text"] = {
					"played cards with",
					"{V:1}#1#{} suit give",
					"{C:chips}+#3#{} Chips when scored",
					"and permanently gains",
					"{C:chips}+#4#{} Chips for each",
					"{V:1}#1#{} held in hand",
					"{s:0.8,C:inactive}(#5# + #6#)"
				},
			},
			["j_fuseforce_orta_clubzombie"] = {
				["name"] = "Club Zombie",
				["text"] = {
					"Each {V:1}#1#{} held in",
					"hand gives {C:chips}+#3#{} Chips",
					"and gives {C:mult}+#4#{} Mult",
					"{s:0.8,C:inactive}(Abstemious + #6#)"
				},
			},
			["j_fuseforce_orta_blinded_by_science"] = {
				["name"] = "Blinded By Science",
				["text"] = {
					"{C:blue}+#1#{} Chips and {C:red}+#3#{} Mult,",
					"loses {C:blue}#2#{} Chips and gains {C:red}1{} Mult for each",
					"time {C:attention}poker hand{} has been played this run",
					"Gains {X:mult,C:white}X#5#{} Mult per {C:ortalab_zodiac}Zodiac{} activated",
					"{C:inactive}(Currently {C:white,X:mult}X#4#{C:inactive}) (#6# + #7#)"
				},
			},
			["j_fuseforce_orta_dangerous_duo"] = {
				["name"] = "Dangerous Duo",
				["text"] = {
					"{X:blue,C:white}X#1#{} Chips if played hand",
					'contains {V:3}#5#{} and {V:4}#6#',
					"{X:red,C:white}X#2#{} Mult if played hand",
					'contains {V:1}#3#{} and {V:2}#4#',
					"{C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_orta_insider_trader"] = {
				["name"] = "Insider Trader Joker",
				["text"] = {
					"Gain {C:money}$#1#{} when shop is rerolled",
					"Payout increases by {C:money}$#2#{} when",
					"shop is left without {C:green}rerolling",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_orta_green_eugene"] = {
				["name"] = "Green Eugene",
				["text"] = {
					"{X:blue,C:white}X#1#{} Chips and {X:red,C:white}X#2#{} Mult",
					"if {C:attention}poker hand{} contains a",
					'{V:1}#3#{}, {V:2}#4#{},',
					'{V:3}#5#{}, and a {V:4}#6#',
					"{C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_orta_physicist"] = {
				["name"] = "Physicist",
				["text"] = {
					"{C:blue}+#1#{} hand size and",
					"{C:red}+#2#{} discard each round",
					"Lose {C:blue}1{} hand size and",
					"gain {C:red}1{} discard if a",
					"discard is used this round",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_orta_art_heist"] = {
				["name"] = "Art Heist",
				["text"] = {
					"{C:chips}+#1#{} Chips for each",
					"{C:attention}Joker{} and {C:tarot}Consumable{} card",
					"Gains {C:attention}+#4#{} Consumable slot",
					"per #5# consumables used",
					"{s:0.8,C:inactive}(Currently {s:0.8,C:attention}+#3#{s:0.8,C:inactive} slots and #6#/#5# towards another)",
					"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
					"{C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_orta_perfidy"] = {
				["name"] = "Perfidy",
				["text"] = {
					'{C:blue}-#5#{} Chips, {C:red}+#2#{} Mult after hand played',
					'{C:blue}+#1#{} Chips, {C:red}-#6#{} Mult after discard',
					'{C:inactive}(Currently {C:blue}#3#{C:inactive} Chips, {C:red}#4#{C:inactive} Mult)',
					"{C:inactive}(#7# + #8#)"
				},
			},
			["j_fuseforce_orta_tagger"] = {
				["name"] = "Tagger",
				["text"] = {
					"Does {C:attention}something{} with",
					"{C:chips}hands"
				},
			},
			["j_fuseforce_orta_necromancer"] = {
				["name"] = "Lich",
				["text"] = {
					"{C:dark_edition}+1{} Joker slots",
					"Effect is permanent if sold",
					"during a {C:attention}Boss Blind",
					"{C:inactive}(#1# + #2#)"
				},
			},
		},
		["Spectral"] = {
			["c_fuseforce_shadow"] = {
				["name"] = "Shadow",
				["text"] = {
					"Destroys {C:attention}rightmost{} Joker",
					"Create a random Joker",
					"that can fuse with",
					"the {C:attention}selected{} Joker"
				},
			},
		},
		["Voucher"] = {
			["v_fuseforce_fusion_coupon"] = {
				["name"] = "Beyond Limits",
				["text"] = {
					"{C:attention}Fusion{} costs are",
					"reduced by {C:money}#1#%{}",
					"{X:money,C:white}Fusion{} Jokers can no",
					"longer be {C:attention}perishable"
				},
			},
			["v_fuseforce_fusion_coupon2"] = {
				["name"] = "Even Further",
				["text"] = {
					"{C:attention}Fusion{} costs are",
					"reduced by {C:money}#1#%{}",
					"{X:money,C:white}Fusion{} Jokers can",
					"no longer be {C:attention}rental"
				},
			},
		},
	},
}
