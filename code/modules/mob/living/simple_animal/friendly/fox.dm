//Foxxy
/mob/living/simple_animal/pet/fox
	name = "fox"
	desc = "It's a fox."
	icon = 'icons/mob/pets.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ак-Ак","Ак-Ак-Ак-Акауууу","Гав","Аууу","Чууу")
	speak_emote = list("лиснявит", "гавкает")
	emote_hear = list("воет.","гавкает.")
	emote_see = list("качает головой.", "чешется.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/meat/slab = 3)
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	gold_core_spawnable = FRIENDLY_SPAWN
	can_be_held = TRUE
	held_state = "fox"
	pet_bonus = TRUE
	pet_bonus_emote = "pants and yaps happily!"
	///In the case 'melee_damage_upper' is somehow raised above 0
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE

	footstep_type = FOOTSTEP_MOB_CLAW

//Captain fox
/mob/living/simple_animal/pet/fox/renault
	name = "Renault"
	desc = "Renault, the Captain's trustworthy fox."
	gender = FEMALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE
