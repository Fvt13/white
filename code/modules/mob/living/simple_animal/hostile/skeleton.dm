/mob/living/simple_animal/hostile/skeleton
	name = "reanimated skeleton"
	desc = "A real bonefied skeleton, doesn't seem like it wants to socialize."
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton"
	gender = NEUTER
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	turns_per_move = 5
	speak_emote = list("гремит костями")
	emote_see = list("гремит костями")
	a_intent = INTENT_HARM
	maxHealth = 40
	health = 40
	speed = 1
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	minbodytemp = 0
	maxbodytemp = 1500
	healable = 0 //they're skeletons how would bruise packs help them??
	attack_verb_continuous = "режет"
	attack_verb_simple = "режет"
	attack_sound = 'sound/hallucinations/growl1.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 5
	robust_searching = 1
	stat_attack = HARD_CRIT
	faction = list("skeleton")
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	deathmessage = "collapses into a pile of bones!"
	del_on_death = 1
	loot = list(/obj/effect/decal/remains/human)

	discovery_points = 2000

	footstep_type = FOOTSTEP_MOB_SHOE

/mob/living/simple_animal/hostile/skeleton/eskimo
	name = "undead eskimo"
	desc = "The reanimated remains of some poor traveler."
	icon_state = "eskimo"
	icon_living = "eskimo"
	icon_dead = "eskimo_dead"
	maxHealth = 55
	health = 55
	weather_immunities = list(WEATHER_SNOW)
	melee_damage_lower = 17
	melee_damage_upper = 20
	deathmessage = "collapses into a pile of bones, its gear falling to the floor!"
	loot = list(/obj/effect/decal/remains/human,
				/obj/item/spear,
				/obj/item/clothing/shoes/winterboots,
				/obj/item/clothing/suit/hooded/wintercoat)


/mob/living/simple_animal/hostile/skeleton/templar
	name = "undead templar"
	desc = "The reanimated remains of a holy templar knight."
	icon_state = "templar"
	icon_living = "templar"
	icon_dead = "templar_dead"
	maxHealth = 150
	health = 150
	weather_immunities = list(WEATHER_SNOW)
	speed = 2
	speak_chance = 1
	speak = list("THE GODS WILL IT!","DEUS VULT!","REMOVE KABAB!")
	force_threshold = 10 //trying to simulate actually having armor
	obj_damage = 50
	melee_damage_lower = 25
	melee_damage_upper = 30
	deathmessage = "collapses into a pile of bones, its gear clanging as it hits the ground!"
	loot = list(/obj/effect/decal/remains/human,
				/obj/item/clothing/suit/armor/riot/chaplain,
				/obj/item/clothing/head/helmet/chaplain,
				/obj/item/claymore/weak{name = "holy sword"})

/mob/living/simple_animal/hostile/skeleton/ice
	name = "ice skeleton"
	desc = "A reanimated skeleton protected by a thick sheet of natural ice armor. Looks slow, though."
	speed = 5
	maxHealth = 75
	health = 75
	weather_immunities = list(WEATHER_SNOW)
	color = rgb(114,228,250)
	loot = list(/obj/effect/decal/remains/human{color = rgb(114,228,250)})

/mob/living/simple_animal/hostile/skeleton/plasmaminer
	name = "shambling miner"
	desc = "A plasma-soaked miner, their exposed limbs turned into a grossly incandescent bone seemingly made of plasma."
	icon_state = "plasma_miner"
	icon_living = "plasma_miner"
	icon_dead = "plasma_miner"
	maxHealth = 150
	health = 150
	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 20
	light_color = LIGHT_COLOR_PURPLE
	deathmessage = "collapses into a pile of bones, their suit dissolving among the plasma!"
	loot = list(/obj/effect/decal/remains/plasma)

/mob/living/simple_animal/hostile/skeleton/plasmaminer/jackhammer
	desc = "A plasma-soaked miner, their exposed limbs turned into a grossly incandescent bone seemingly made of plasma. They seem to still have their mining tool in their hand, gripping tightly."
	icon_state = "plasma_miner_tool"
	icon_living = "plasma_miner_tool"
	icon_dead = "plasma_miner_tool"
	maxHealth = 185
	health = 185
	harm_intent_damage = 15
	melee_damage_lower = 20
	melee_damage_upper = 25
	attack_verb_continuous = "пробивает"
	attack_verb_simple = "пробивает"
	attack_sound = 'sound/weapons/sonic_jackhammer.ogg'
	attack_vis_effect = null // jackhammer moment
	loot = list(/obj/effect/decal/remains/plasma, /obj/item/pickaxe/drill/jackhammer)

/mob/living/simple_animal/hostile/skeleton/plasmaminer/Initialize()
	. = ..()
	set_light(2)
