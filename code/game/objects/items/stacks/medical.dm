/obj/item/stack/medical
	name = "медипак"
	var/skloname = "медипак"
	singular_name = "медипак"
	icon = 'icons/obj/stack_objects.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	var/self_delay = 50
	var/other_delay = 0
	var/repeating = FALSE
	var/experience_given = 1

/obj/item/stack/medical/attack(mob/living/M, mob/user)
	. = ..()
	try_heal(M, user)


/obj/item/stack/medical/proc/try_heal(mob/living/M, mob/user, silent = FALSE)
	if(!M.can_inject(user, TRUE))
		return
	if(M == user)
		if(!silent)
			user.visible_message("<span class='notice'><b>[user]</b> начинает применять <b>[skloname]</b> на себе...</span>", "<span class='notice'>Начинаю применять <b>[skloname]</b> на себе...</span>")
		if(!do_mob(user, M, self_delay, extra_checks=CALLBACK(M, /mob/living/proc/can_inject, user, TRUE)))
			return
	else if(other_delay)
		if(!silent)
			user.visible_message("<span class='notice'><b>[user]</b> начинает прмиенять <b>[skloname]</b> на <b>[M]</b>.</span>", "<span class='notice'>Начинаю применять <b>[skloname]</b> на <b>[M]</b>...</span>")
		if(!do_mob(user, M, other_delay, extra_checks=CALLBACK(M, /mob/living/proc/can_inject, user, TRUE)))
			return

	if(heal(M, user))
		user?.mind.adjust_experience(/datum/skill/medical, experience_given)
		log_combat(user, M, "healed", src.name)
		use(1)
		if(repeating && amount > 0)
			try_heal(M, user, TRUE)

/obj/item/stack/medical/proc/heal(mob/living/M, mob/user)
	return

/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		to_chat(user, "<span class='warning'>А у <b>[C]</b> совсем отсутствует <b>[ru_exam_parse_zone(parse_zone(user.zone_selected))]</b>!</span>")
		return
	if(affecting.status != BODYPART_ORGANIC) //Limb must be organic to be healed - RR
		to_chat(user, "<span class='warning'><b>[src]</b> не будет работать на механической конечности!</span>")
		return
	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message("<span class='green'><b>[user]</b> применяет <b>[skloname]</b> на <b>[ru_parse_zone(affecting.name)] [C]</b>.</span>", "<span class='green'>Применяю <b>[skloname]</b> на <b>[ru_parse_zone(affecting.name)] [C]</b>.</span>")
		var/brute2heal = brute
		var/burn2heal = burn
		var/skill_mod = user?.mind?.get_skill_modifier(/datum/skill/medical, SKILL_SPEED_MODIFIER)
		if(skill_mod)
			brute2heal *= (2-skill_mod)
			burn2heal *= (2-skill_mod)
		if(affecting.heal_damage(brute2heal, burn2heal))
			C.update_damage_overlays()
		return TRUE
	to_chat(user, "<span class='warning'><b>[capitalize(affecting.name)] [C]</b> не может быть вылечена при помощи [src]!</span>")


/obj/item/stack/medical/bruise_pack
	name = "гель и пластыри"
	singular_name = "гель и пластыри"
	skloname = "гель и пластыри"
	desc = "Терапевтический гель и пластыри, предназначенные для лечения травм."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	var/heal_brute = 40
	self_delay = 20
	grind_results = list(/datum/reagent/medicine/C2/libital = 10)

/obj/item/stack/medical/bruise_pack/heal(mob/living/M, mob/user)
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'><b>[M]</b> совсем мёртв! Одним пластырем тут не обойтись.</span>")
		return
	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>Не могу использовать <b>[src]</b> на <b>[M]</b>!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'><b>[M]</b> и так в полном здравии.</span>")
			return FALSE
		user.visible_message("<span class='green'><b>[user]</b> применяет <b>гель и пластыри</b> на <b>[M]</b>.</span>", "<span class='green'>Применяю <b>гель и пластыри</b> на <b>[M]</b>.</span>")
		M.heal_bodypart_damage((heal_brute/2))
		return TRUE
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, 0)
	to_chat(user, "<span class='warning'>Не могу лечить <b>[M]</b> при помощи <b>геля и бинтов</b>!</span>")

/obj/item/stack/medical/bruise_pack/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is bludgeoning [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (BRUTELOSS)

/obj/item/stack/medical/gauze
	name = "медицинский бинт"
	skloname = "медицинский бинт"
	desc = "Рулон эластичной ткани, который чрезвычайно эффективен при остановке кровотечения, но не заживает раны."
	gender = PLURAL
	singular_name = "медицинская марля"
	icon_state = "gauze"
	var/stop_bleeding = 1800
	self_delay = 20
	max_amount = 12
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = 100

/obj/item/stack/medical/gauze/twelve
	amount = 12

/obj/item/stack/medical/gauze/heal(mob/living/M, mob/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.bleedsuppress && H.bleed_rate) //so you can't stack bleed suppression
			H.suppress_bloodloss(stop_bleeding)
			to_chat(user, "<span class='notice'>Останавливаю кровотечение у <b>[M]</b>!</span>")
			return TRUE
	to_chat(user, "<span class='warning'>Не могу использовать <b>[src]</b> на <b>[M]</b>!</span>")

/obj/item/stack/medical/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>На как минимум два кусочка бинта!</span>")
			return
		new /obj/item/stack/sheet/cloth(user.drop_location())
		user.visible_message("<span class='notice'><b>[user]</b> нарезает <b>[src]</b> на куски ткани при помощи <b>[I]</b>.</span>", \
					 "<span class='notice'>Нарезаю <b>[src]</b> на куски ткани при помощи <b>[I]</b>.</span>", \
					 "<span class='hear'>Слышу как что-то режет ткань.</span>")
		use(2)
	else
		return ..()

/obj/item/stack/medical/gauze/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] begins tightening \the [src] around [user.p_their()] neck! It looks like [user.p_they()] forgot how to use medical supplies!</span>")
	return OXYLOSS

/obj/item/stack/medical/gauze/improvised
	name = "импровизированный бинт"
	skloname = "импровизированный бинт"
	singular_name = "импровизированный бинт"
	desc = "Рулон ткани грубо отрезан от чего-то, что может остановить кровотечение, но не заживает раны."
	stop_bleeding = 900

/obj/item/stack/medical/gauze/cyborg
	custom_materials = null
	is_cyborg = 1
	cost = 250

/obj/item/stack/medical/ointment
	name = "мазь"
	skloname = "мазь"
	desc = "Используется для лечения этих неприятных ожоговых ран."
	gender = FEMALE
	singular_name = "мазь"
	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	var/heal_burn = 40
	self_delay = 20
	grind_results = list(/datum/reagent/medicine/C2/lenturi = 10)

/obj/item/stack/medical/ointment/heal(mob/living/M, mob/user)
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'><b>[M]</b> совсем мёртв! Одной мазью тут не обойтись.</span>")
		return
	if(iscarbon(M))
		return heal_carbon(M, user, 0, heal_burn)
	to_chat(user, "<span class='warning'>Не могу лечить <b>[M]</b> при помощи <b>мази</b>!</span>")

/obj/item/stack/medical/ointment/suicide_act(mob/living/user)
	user.visible_message("<span class='suicide'>[user] is squeezing \the [src] into [user.p_their()] mouth! [user.p_do(TRUE)]n't [user.p_they()] know that stuff is toxic?</span>")
	return TOXLOSS

/obj/item/stack/medical/suture
	name = "хирургическая нить"
	skloname = "хирургическую нить"
	desc = "Стерильные швы используются для герметизации порезов и разрывов."
	gender = FEMALE
	singular_name = "нить"
	icon_state = "suture"
	self_delay = 30
	other_delay = 10
	amount = 15
	max_amount = 15
	repeating = TRUE
	var/heal_brute = 10
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)

/obj/item/stack/medical/suture/medicated
	name = "лечебная хирургическая нить"
	skloname = "лечебную хирургическую нить"
	icon_state = "suture_purp"
	desc = "Нить, наполненная лекарственными средствами, ускоряющими заживление раны на обработанной ране."
	heal_brute = 15
	grind_results = list(/datum/reagent/medicine/polypyr = 2)

/obj/item/stack/medical/suture/heal(mob/living/M, mob/user)
	. = ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'><b>[M]</b> совсем мёртв! Одной иглой тут не обойтись.</span>")
		return
	if(iscarbon(M))
		return heal_carbon(M, user, heal_brute, 0)
	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>Не могу использовать <b>хирургическую нить</b> на <b>[M]</b>!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'><b>[M]</b> в полном здравии.</span>")
			return FALSE
		user.visible_message("<span class='green'><b>[user]</b> применяет <b>хирургическую нить</b> на <b>[M]</b>.</span>", "<span class='green'>Применяю <b>хирургическую нить</b> на <b>[M]</b>.</span>")
		M.heal_bodypart_damage(heal_brute)
		return TRUE

	to_chat(user, "<span class='warning'>Не могу лечить <b>[M]</b> при помощи <b>хирургической нити</b>!</span>")

/obj/item/stack/medical/mesh
	name = "регенеративная сетка"
	skloname = "регенеративную сетку"
	desc = "Бактериостатическая сетка используется для прижигания ожогов."
	gender = PLURAL
	singular_name = "регенеративная сетка"
	icon_state = "regen_mesh"
	self_delay = 30
	other_delay = 10
	amount = 15
	max_amount = 15
	repeating = TRUE
	var/heal_burn = 10
	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)

/obj/item/stack/medical/mesh/Initialize()
	. = ..()
	if(amount == max_amount)	 //only seal full mesh packs
		is_open = FALSE
		update_icon()

/obj/item/stack/medical/mesh/update_icon_state()
	if(!is_open)
		icon_state = "regen_mesh_closed"
	else
		return ..()

/obj/item/stack/medical/mesh/heal(mob/living/M, mob/user)
	. = ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'><b>[M]</b> совсем мёртв! Одной сеткой тут не обойтись.</span>")
		return
	if(iscarbon(M))
		return heal_carbon(M, user, 0, heal_burn)
	to_chat(user, "<span class='warning'>Не могу лечить <b>[M]</b> при помощи <b>регенеративной сетки</b>!</span>")


/obj/item/stack/medical/mesh/try_heal(mob/living/M, mob/user, silent = FALSE)
	if(!is_open)
		to_chat(user, "<span class='warning'>Надо бы открыть <b>[src]</b> сначала.</span>")
		return
	. = ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		to_chat(user, "<span class='warning'>Надо бы открыть <b>[src]</b> сначала.</span>")
		return
	. = ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user)
	if(!is_open & user.get_inactive_held_item() == src)
		to_chat(user, "<span class='warning'>Надо бы открыть <b>[src]</b> сначала.</span>")
		return
	. = ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, "<span class='notice'>Открываю стерильную упаковку сетки.</span>")
		update_icon()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	. = ..()

/obj/item/stack/medical/mesh/advanced
	name = "продвинутая регенеративная сетка"
	skloname = "продвинутую регенеративную сетку"
	desc = "Передовая сетка из экстрактов алоэ и стерилизующих химикатов, используемых для лечения ожогов."

	gender = FEMALE
	singular_name = "продвинутая регенеративная сетка"
	icon_state = "aloe_mesh"
	heal_burn = 15
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)

/obj/item/stack/medical/mesh/advanced/update_icon_state()
	if(!is_open)
		icon_state = "aloe_mesh_closed"
	else
		return ..()

/obj/item/stack/medical/aloe
	name = "крем алоэ"
	skloname = "крем алоэ"
	desc = "Целебную пасту можно наносить на раны."

	icon_state = "aloe_paste"
	self_delay = 20
	other_delay = 10
	novariants = TRUE
	amount = 20
	max_amount = 20
	var/heal = 3
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)

/obj/item/stack/medical/aloe/heal(mob/living/M, mob/user)
	. = ..()
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'><b>[M]</b> совсем мёртв! Одной сеткой тут не обойтись.</span>")
		return FALSE
	if(iscarbon(M))
		return heal_carbon(M, user, heal, heal)
	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>Не могу использовать <b>[src]</b> на <b>[M]</b>!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'><b>[M]</b> в полном здравии.</span>")
			return FALSE
		user.visible_message("<span class='green'><b>[user]</b> применяет <b>крем алоэ</b> на <b>[M]</b>.</span>", "<span class='green'>Применяю <b>крем алоэ</b> на <b>[M]</b>.</span>")
		M.heal_bodypart_damage(heal, heal)
		return TRUE

	to_chat(user, "<span class='warning'>Не могу лечить <b>[M]</b> при помощи <b>крема алоэ</b>!</span>")


	/*
	The idea is for these medical devices to work like a hybrid of the old brute packs and tend wounds,
	they heal a little at a time, have reduced healing density and does not allow for rapid healing while in combat.
	However they provice graunular control of where the healing is directed, this makes them better for curing work-related cuts and scrapes.

	The interesting limb targeting mechanic is retained and i still believe they will be a viable choice, especially when healing others in the field.
	 */
