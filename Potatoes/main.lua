------------------------------------------------------------------------------------------------------------------------
SMODS.Atlas{
    key = 'jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Joker:take_ownership('joker',
    {
        loc_txt = {
            name = 'Jimbo',
            text = {
                "{C:mult}+4 {} Mult"
            }
        },
    },
    true
)

SMODS.Joker {
	key = 'Toolbox',
	loc_txt = {
		name = 'Toolbox',
		text = {
			"{T:e_negative,C:dark_edition}+#1#{} Joker slots"
		}
	},
	config = { extra = { card_limit = 2 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 1, y = 0 },
	cost = 6,
    blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.card_limit } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.card_limit
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.card_limit
	end
}

SMODS.Joker {
	key = 'amalgam',
	loc_txt = {
		name = 'Amalgam',
		text = {
			'{T:e_negative,C:dark_edition}#1#{} Joker Slots,',
            '{C:mult}+#2#{} Mult'
		}
	},
	config = { extra = { card_limit = -4, mult = 100 } },
	rarity = 3,
	atlas = 'jokers',
	pos = { x = 2, y = 1 },
	cost = 20,
    blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.card_limit, card.ability.extra.mult } }
	end,
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.card_limit
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.card_limit
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
            }
        end
    end
}

SMODS.Joker {
    key = 'baroness',
    loc_txt = {
        name = 'Baroness',
        text = {
            'Each {C:attention}Queen{} held in hand gives',
            '{X:mult,C:white} X#1#{} Mult'

        },
    },
    config = { extra = { Xmult = 1.5 } },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    atlas = 'jokers',
    pos = { x = 1, y = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if 
        context.individual 
        and not context.end_of_round 
        and context.cardarea == G.hand 
        and not context.before 
        and not context.after 
        and context.other_card:get_id() == 12 then
           return {
               x_mult = card.ability.extra.Xmult,
           }
            end
    end
}

SMODS.Joker{
    key = 'industry',
    loc_txt = {
        name = 'Industrialized',
        text = {
            'Every played {C:attention}card{} permanently gains',
            '{C:mult}+#1#{} Mult when scored'
        },
    },
    config = { extra = { perma_mult = 1 } },
    rarity = 2,
    cost = 10,
    blueprint_compat = true,
    atlas = 'jokers',
    pos = {x = 0, y = 1},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.perma_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.perma_mult
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                card = card
            }
        end
    end
}

SMODS.Joker{
    key = 'overclock',
    loc_txt = {
        name = 'Overclock',
        text = {
            'Cards scored gain {X:mult,C:white} X#1#{} Mult',
            '{C:inactive} (Ex. 1.1x to 1.2x etc....)'
        },
    },
    config = { extra = { perma_x_mult = 0.1 } },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    atlas = 'jokers',
    pos = {x = 2, y = 0},
    soul_pos = {x = 3, y = 0},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.perma_x_mult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult or 1
            context.other_card.ability.perma_x_mult = context.other_card.ability.perma_x_mult + card.ability.extra.perma_x_mult
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                card = card
            }
        end
    end
}

SMODS.Joker{
    key = 'imprison',
    loc_txt = {
        name = 'Imprisonment',
        text = {
            'Sell this card to make all Jokers',
            '{C:attention}eternal{}'
        },
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    atlas = 'jokers',
    pos = {x = 1, y = 2},
    calculate = function(self, card, context)
        if context.selling_self == true then
            local other_jokers = {}
            for k, v in pairs(G.jokers.cards) do
                if not v.ability.eternal then other_jokers[#other_jokers + 1] = v end
            end
            G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
                for k, v in pairs(other_jokers) do
                    if v ~= chosen_joker then 
                        v:set_eternal(true)
                    end
                end
                return true end }))
        end
    end
}

SMODS.Joker {
	key = 'mage',
	loc_txt = {
		name = 'The Mage',
		text = {
			"Retrigger all",
			"played cards with {C:hearts}Heart{} suit"
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 0, y = 3 },
	cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:is_suit("Hearts") then
                return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
            end
    end
end
}

SMODS.Joker {
	key = 'sword',
	loc_txt = {
		name = 'The Sword',
		text = {
			"Retrigger all",
			"played cards with {C:spades}Spade{} suit"
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 0, y = 2 },
	cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:is_suit("Spades") then
                return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
            end
    end
end
}

SMODS.Joker {
	key = 'shield',
	loc_txt = {
		name = 'The Shield',
		text = {
			"Retrigger all",
			"played cards with {C:diamonds}Diamond{} suit"
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 3, y = 2 },
	cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:is_suit("Diamonds") then
                return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
            end
    end
end
}

SMODS.Joker {
	key = 'club',
	loc_txt = {
		name = 'The Club',
		text = {
			"Retrigger all",
			"played cards with {C:clubs}Club{} suit"
		}
	},
	config = { extra = { repetitions = 1 } },
	rarity = 2,
	atlas = 'jokers',
	pos = { x = 0, y = 0 },
	cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:is_suit("Clubs") then
                return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
            end
    end
end
}

SMODS.Joker{
    key = 'snakeeyes',
    loc_txt = {
        name = 'Snake Eyes',
        text = {
            'Halves all {C:attention}listed{} {C:green}probablities{}',
            '{C:inactive}(ex: {C:green}2 in 3 {C:inactive}-> {C:green}1 in 3)'
        },
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    atlas = 'jokers',
    pos = {x = 3, y = 1},
    add_to_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v/2
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v*2
        end
    end
}

SMODS.Joker {
	key = 'sneaky',
	loc_txt = {
		name = 'Sneaky Jimbo',
		text = {
			'{C:chips}+#1# {} Chips'
		}
	},
	config = { extra = { chips = 25 } },
    rarity = 1,
	atlas = 'jokers',
	pos = { x = 2, y = 2 },
	cost = 2,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
}

SMODS.Joker{
    key = 'negative nancy',
    loc_txt = {
        name = 'Negative Nancy',
        text = {
            'If played hand is {C:attention}final hand{}',
            'random playing card held in hand becomes {T:e_negative,C:dark_edition}negative.{}',
            '{C:red}Card destroys itself after use{}'
        },
    },
    atlas = 'jokers',
    pos = {x = 0, y = 0},
    rarity = 3,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    calculate = function(self, card, context)
        if 
        G.GAME.current_round.hands_left == 0 
        and context.individual 
        and context.end_of_round 
        and context.cardarea == G.hand 
        and not context.before 
        and not context.after 
        and not context.during
        then
            local chosen_card = pseudorandom_element(G.hand.cards, pseudoseed('negative'))
            if context.other_card == chosen_card then
                chosen_card:set_edition({negative = true}, true)
                card:start_dissolve()
            end
    end
    end
}

SMODS.Joker {
	key = 'spectral',
	loc_txt = {
		name = 'Spectromancer',
		text = {
			'Create a {C:blue}Spectral{} card when {C:attention}blind{} is ',
            'selected'
		}
	},
    rarity = 3,
	atlas = 'jokers',
	pos = { x = 0, y = 0 },
	cost = 6,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                        local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'sea')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                    return true
                end)}))
        end
    end
}