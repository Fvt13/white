/*
Slimecrossing Mobs
	Mobs and effects added by the slimecrossing system.
	Collected here for clarity.
*/

//Slime transformation power - Burning Black
/obj/effect/proc_holder/spell/targeted/shapeshift/slimeform
	name = "Трансформация в слизь"
	desc = "Трансформируйся из человека в слизь и наоборот!"
	action_icon_state = "transformslime"
	cooldown_min = 0
	charge_max = 0
	invocation_type = "none"
	shapeshift_type = /mob/living/simple_animal/slime/transformedslime
	convert_damage = TRUE
	convert_damage_type = CLONE
	var/remove_on_restore = FALSE

/obj/effect/proc_holder/spell/targeted/shapeshift/slimeform/Restore(mob/living/M)
	if(remove_on_restore)
		if(M.mind)
			M.mind.RemoveSpell(src)
	return ..()

//Transformed slime - Burning Black
/mob/living/simple_animal/slime/transformedslime

/mob/living/simple_animal/slime/transformedslime/Reproduce() //Just in case.
	to_chat(src, span_warning("Не могу ???..."))
	return

//Slime corgi - Chilling Pink
/mob/living/simple_animal/pet/dog/corgi/puppy/slime
	name = "слизневый щенок корги"
	real_name = "slime corgi puppy"
	desc = "Невероятно милый щенок корги из розовой слизи."
	icon_state = "slime_puppy"
	icon_living = "slime_puppy"
	icon_dead = "slime_puppy_dead"
	nofur = TRUE
	gold_core_spawnable = NO_SPAWN
	speak_emote = list("пузырит", "напузыривает", "пузыгавкает")
	emote_hear = list("пузырит!", "пузырится.", "брызгается!")
	emote_see = list("смазывает всё слизью.", "шлёпает.", "покачивается!")
