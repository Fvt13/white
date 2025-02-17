/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit."
	gender = PLURAL
	icon = 'icons/mob/cult.dmi'
	icon_state = "shade_cult"
	icon_living = "shade_cult"
	mob_biotypes = MOB_SPIRIT
	maxHealth = 40
	health = 40
	healable = 0
	speak_emote = list("шипит")
	emote_hear = list("вопит.","визжит.")
	response_help_continuous = "puts their hand through"
	response_help_simple = "put your hand through"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "бьёт"
	response_harm_simple = "бьёт"
	speak_chance = 1
	melee_damage_lower = 5
	melee_damage_upper = 12
	attack_verb_continuous = "метафизически атакует"
	attack_verb_simple = "метафизически атакует"
	minbodytemp = 0
	maxbodytemp = INFINITY
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	speed = -1 //they don't have to lug a body made of runed metal around
	stop_automated_movement = 1
	faction = list("cult")
	status_flags = CANPUSH
	loot = list(/obj/item/ectoplasm)
	del_on_death = TRUE
	initial_language_holder = /datum/language_holder/construct
	ventcrawler = VENTCRAWLER_ALWAYS

	discovery_points = 1000

/mob/living/simple_animal/shade/Initialize()
	. = ..()
	AddElement(/datum/element/simple_flying)
	ADD_TRAIT(src, TRAIT_SPACEWALK, INNATE_TRAIT)

/mob/living/simple_animal/shade/death()
	if(deathmessage == initial(deathmessage))
		deathmessage = "lets out a contented sigh as [p_their()] form unwinds."
	..()

/mob/living/simple_animal/shade/canSuicide()
	if(istype(loc, /obj/item/soulstone)) //do not suicide inside the soulstone
		return FALSE
	return ..()

/mob/living/simple_animal/shade/attack_animal(mob/living/simple_animal/M)
	if(isconstruct(M))
		var/mob/living/simple_animal/hostile/construct/C = M
		if(!C.can_repair_constructs)
			return
		if(health < maxHealth)
			adjustHealth(-25)
			Beam(M,icon_state="sendbeam", time = 4)
			M.visible_message(span_danger("[M] heals \the <b>[src]</b>.") , \
					   span_cult("You heal <b>[src]</b>, leaving <b>[src]</b> at <b>[health]/[maxHealth]</b> health."))
		else
			to_chat(M, span_cult("You cannot heal <b>[src]</b>, as [p_theyre()] unharmed!"))
	else if(src != M)
		return ..()

/mob/living/simple_animal/shade/attackby(obj/item/O, mob/user, params)  //Marker -Agouri
	if(istype(O, /obj/item/soulstone))
		var/obj/item/soulstone/SS = O
		SS.transfer_soul("SHADE", src, user)
	else
		. = ..()
