/mob/living/simple_animal/butterfly
	name = "butterfly"
	desc = "A colorful butterfly, how'd it get up here?"
	icon_state = "butterfly"
	icon_living = "butterfly"
	icon_dead = "butterfly_dead"
	turns_per_move = 1
	response_help_continuous = "shoos"
	response_help_simple = "shoo"
	response_disarm_continuous = "brushes aside"
	response_disarm_simple = "brush aside"
	response_harm_continuous = "squashes"
	response_harm_simple = "squash"
	speak_emote = list("порхает")
	maxHealth = 2
	health = 2
	harm_intent_damage = 1
	friendly_verb_continuous = "nudges"
	friendly_verb_simple = "nudge"
	density = FALSE
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "трепетает"
	verb_ask = "трепетает вопросительно"
	verb_exclaim = "трепетает интенсивно"
	verb_yell = "трепетает интенсивно"

/mob/living/simple_animal/butterfly/Initialize()
	. = ..()
	AddElement(/datum/element/simple_flying)
	var/newcolor = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)

/mob/living/simple_animal/butterfly/bee_friendly()
	return TRUE //treaty signed at the Beeneeva convention
