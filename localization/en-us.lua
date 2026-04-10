return {
	["misc"] = {
		["dictionary"] = {
			["k_drunk_ex"] = "Drunk!",
			["k_fuseforce_gold_fusion"] = "Gold Fusion",
			["fuseforce_joker_slot"] = "+1 Joker slot!",
			["fuseforce_joker_slot_minus"] = "lost Joker slots",
			["fuseforce_consumable_slot"] = "+1 Consumable slot!",
			["fuseforce_consumable_slot_minus"] = "lost slots",
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
					"Start with +{C:money}$#1#{} and a {C:spectral,T:c_fuseforce_shadow}#2#",
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
					"Start with +{C:money}$#1#{} and a {C:spectral,T:c_fuseforce_shadow}#2#",
					"{s:0.2} ",
					"Shadows can now be used on",
					"{X:money,C:white}Fusions{} to make them {C:dark_edition}Negative",
				},
			},
		},
		["Ortalab Artist"] = {
			['gappie'] = {
				["text"] = {
					"Gappie",
				}
			},
			['Minus'] = {
				["text"] = {
					"Minus",
				}
			},
			['LunaAstraCassiopeia'] = {
				["text"] = {
					"LunaAstraCassiopeia",
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
					"Can go up to {C:red}-$#2#{}",
					"in {C:red}debt{}",
					"Adds {C:money}$#1#{} of {C:attention}sell value{}",
					"to all owned {C:attention}Jokers{}",
					"and {C:attention}Consumables{}",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_masters_degree"] = {
				["name"] = "Master's Degree",
				["text"] = {
					"When round begins, add",
					"a random {C:attention}Enhanced Ace{}",
					"to hand",
					"Scored {C:attention}Aces{} give",
					"{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_soothsayer"] = {
				["name"] = "Soothsayer",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"create a random {C:planet}Planet{}",
					"and {C:tarot}Tarot{} card",
					"All {C:planet}Planet{} and {C:tarot}Tarot{}",
					"cards are {C:attention}free",
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
					"Gains {C:chips}+#3#{} Chips",
					"if played hand is a",
					"{C:attention}Straight{}",
					"Loses {C:chips}#2#{} Chips",
					"per hand played",
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
					"Each played {C:attention}10{} or {C:attention}4{} give",
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
					"Gains {C:chips}+#1#{} Chips",
					"for each {C:attention}Stone Card{}",
					"in full deck",
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
					"Retrigger all",
					"{C:attention}held in hand{} abilities",
					"and played {C:attention}face{} cards",
					"{C:attention}#1#{} times",
					"Retrigger {C:attention}held in hand",
					"{C:attention}face card{} abilities again",
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
					"When {C:attention}Blind{} is selected, destroy",
					"{C:attention}Joker{} to the right and permanently",
					"add {C:money}#1#{} of its sell value as {X:mult,C:white}Mult",
					"{C:inactive}(Currently {X:mult,C:white} X#2# {} Mult)",
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
			["j_fuseforce_shadowman"] = {
				["name"] = "Shadowman",
				["text"] = {
					"{C:attention}Joker{}, {C:tarot}Tarot{}, {C:planet}Planet{},",
					"and {C:spectral}Spectral{} cards may",
					"appear multiple times",
					"{C:attention}Joker{} cards you already",
					"have will appear {C:dark_edition}Negative",
					"{s:0.9,C:inactive}(#1# + #2#)"
				},
			},
			["j_fuseforce_time_keeper"] = {
				["name"] = "Time Keeper",
				["text"] = {
					"Gives {C:chips}+#1#{} Chips for each",
					"card left in {C:attention}deck",
					"Earn {C:money}$#3#{} per unused {C:attention}discard",
					"{s:0.2} ",
					"Gain {C:red}+1 discard{}",
					"if {C:attention}#5#{} rounds end",
					"with no discards used",
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
					"selected for hands",
					"{C:inactive}(#2# + #3#)"
				},
			},
			["j_fuseforce_cavepainting"] = {
				["name"] = "Cave Painting",
				["text"] = {
					"{X:mult,C:white}X#2#{} Mult if played",
					"hand contains a {C:attention}#3#",
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
					"owned {C:attention}Jokers{} to Mult",
					"Gains {X:mult,C:white}X0.25{} Mult",
					"per {C:attention}Blind{} skipped this run",
					"{C:money}$#2#{} when skipping a {C:attention}blind",
					"{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
					"{s:0.9,C:inactive}(#3# + #4#)"
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
					"When {C:attention}Blind{} is selected, add one",
					"{C:attention}Stone{} card to deck. Played",
					"{C:attention}Stone{} cards become {C:attention}Wild{} cards, each {C:attention}Wild",
					"card played gives {C:chips}+#2#{} Chips{} and {X:mult,C:white}X#1#{} Mult",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_dye_pack"] = {
				["name"] = "Dye Pack",
				["text"] = {
					"Gain {C:blue}+#1#{} Hands when",
					"{C:attention}Blind{} is selected,",
					"first {C:attention}discard{} each",
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
					"scoring {C:hearts}Red {C:diamonds}Suit{} card played",
					"Changes the card's suit from {C:hearts}Hearts",
					"to {C:spades}Spades{} and {C:diamonds}Diamonds{} to {C:clubc}Clubs",
					"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
					"{C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_cut_and_pasted"] = {
				["name"] = "Cut and Pasted Joker",
				["text"] = {
					"{C:attention}First{} scored card",
					"gives {C:mult}#1#{} Mult and",
					"is retriggered once for",
					"each card not played",
					"Gains {C:mult}#2#{} Mult per",
					"{C:attention}Joker{} sold",
					"Gains {X:red,C:white}X1{} Mult",
					"per empty {C:attention}Joker{} slot",
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
					"for each {C:attention}Wild Card",
					"in your {C:attention}full deck",
					"And {X:mult,C:white}X#1#{} Mult for {V:1}Each",
					"{V:2}Suit{} in {V:3}Played {V:4}Hand",
					"{C:inactive}(Currently {X:mult,C:white} X#3# {C:inactive} Mult)",
					"{s:0.8,C:inactive}(#8# + #9#)"
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
					"If poker hand is a",
					"{C:attention}#1#{}, create a",
					"random {C:spectral}Spectral{} card.",
					"Create a {C:tarot}Tarot{} card if",
					"poker hand contains an",
					"{C:attention}Ace{} and a {C:attention}#2#{}.",
					"If poker hand is a",
					"{C:attention}Royal Flush{}, create a",
					"{C:legendary}Black Hole{} or {C:legendary}Soul",
					"{C:inactive}(Must have room)",
					"{s:0.9,C:inactive}(#3# + #4#)"
				},
			},
			["j_fuseforce_bargaining_chips"] = {
				["name"] = "Bargaining Chips",
				["text"] = {
					"For every {C:attention}#1#{} blinds",
					"beaten by at least",
					"{C:attention}25%{} over the target,",
					"gain {C:dark_edition}+1 Joker Slot{}",
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
					"{C:inactive}(Currently {C:money}$#2#{}{C:inactive} and chance {C:green}#3#{C:inactive})",
					"{C:inactive}(#5# + #4#)"
				},
			},
			["j_fuseforce_sticker"] = {
				["name"] = "Sticker Joker",
				["text"] = {
					"First played {C:attention}face{} card",
					"gives {X:mult,C:white}X#1#{} Mult",
					"when scored",
					"{s:0.1} ",
					"{s:0.9}Retrigger the {s:0.9,C:attention}first{s:0.9} played",
					"{s:0.9}card used in scoring {C:attention}#2#{}{s:0.9} extra times",
					"{s:0.2} ",
					"If all played cards are",
					"{C:attention}face{} cards, retrigger",
					"{C:attention}1{} extra time",
					"{C:inactive}(#3# + #4#)"
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
					"Earn {C:money}$#2#{} per {C:attention}Steel{}",
					"card held in hand at end of round",
					"{C:money}Played {C:attention}Metal {C:money}cards",
					"{C:money}earn $#4# when scored",
					"{C:money}Gives {X:mult,C:white}X#3# {C:money} Mult",
					"{C:money}for each {C:attention}Metal Card",
					"{C:money}in your {C:attention}full deck",
					"{C:inactive}(Currently {X:mult,C:white}X#5#{C:inactive} Mult)",
					"{s:0.8,C:inactive}(#6# + #7#)"
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
				["name"] = "Even Further Beyond",
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
