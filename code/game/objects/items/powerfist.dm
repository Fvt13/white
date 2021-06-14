/obj/item/melee/powerfist
	name = "power-fist"
	desc = "A metal gauntlet with a piston-powered ram ontop for that extra 'ompfh' in your punch."
	icon_state = "powerfist"
	inhand_icon_state = "powerfist"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	flags_1 = CONDUCT_1
	attack_verb_continuous = list("вмазывает", "фистит", "очень сильно бьёт")
	attack_verb_simple = list("вмазывает", "фистит", "очень сильно бьёт")
	force = 20
	throwforce = 10
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 40)
	resistance_flags = FIRE_PROOF
	var/click_delay = 1.5
	var/fisto_setting = 1
	var/gasperfist = 3
	var/obj/item/tank/internals/tank = null //Tank used for the gauntlet's piston-ram.


/obj/item/melee/powerfist/examine(mob/user)
	. = ..()
	if(!in_range(user, src))
		. += "<hr><span class='notice'>You'll need to get closer to see any more.</span>"
		return
	if(tank)
		. += "<hr><span class='notice'>[icon2html(tank, user)] It has \a [tank] mounted onto it.</span>"


/obj/item/melee/powerfist/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/tank/internals))
		if(!tank)
			var/obj/item/tank/internals/IT = W
			if(IT.volume <= 3)
				to_chat(user, "<span class='warning'>\The [IT] is too small for <b>[src.name]</b>.</span>")
				return
			updateTank(W, 0, user)
	else if(W.tool_behaviour == TOOL_WRENCH)
		switch(fisto_setting)
			if(1)
				fisto_setting = 2
			if(2)
				fisto_setting = 3
			if(3)
				fisto_setting = 1
		W.play_tool_sound(src)
		to_chat(user, "<span class='notice'>You tweak <b>[src.name]</b>'s piston valve to [fisto_setting].</span>")
	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		if(tank)
			updateTank(tank, 1, user)

/obj/item/melee/powerfist/proc/updateTank(obj/item/tank/internals/thetank, removing = 0, mob/living/carbon/human/user)
	if(removing)
		if(!tank)
			to_chat(user, "<span class='notice'><b>[src.name]</b> currently has no tank attached to it.</span>")
			return
		to_chat(user, "<span class='notice'>You detach [thetank] from <b>[src.name]</b>.</span>")
		tank.forceMove(get_turf(user))
		user.put_in_hands(tank)
		tank = null
	if(!removing)
		if(tank)
			to_chat(user, "<span class='warning'><b>[src.name]</b> already has a tank.</span>")
			return
		if(!user.transferItemToLoc(thetank, src))
			return
		to_chat(user, "<span class='notice'>You hook [thetank] up to <b>[src.name]</b>.</span>")
		tank = thetank


/obj/item/melee/powerfist/attack(mob/living/target, mob/living/user)
	if(!tank)
		to_chat(user, "<span class='warning'><b>[src.name]</b> can't operate without a source of gas!</span>")
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>You don't want to harm other living beings!</span>")
		return
	var/datum/gas_mixture/gasused = tank.air_contents.remove(gasperfist * fisto_setting)
	var/turf/T = get_turf(src)
	if(!T)
		return
	T.assume_air(gasused)
	T.air_update_turf(FALSE, FALSE)
	if(!gasused)
		to_chat(user, "<span class='warning'><b>[src.name]</b>'s tank is empty!</span>")
		target.apply_damage((force / 5), BRUTE)
		playsound(loc, 'sound/weapons/punch1.ogg', 50, TRUE)
		target.visible_message("<span class='danger'>[user] powerfist lets out a dull thunk as [user.ru_who()] punch[user.p_es()] [target.name]!</span>", \
			"<span class='userdanger'>[user] punches you!</span>")
		return
	if(gasused.total_moles() < gasperfist * fisto_setting)
		to_chat(user, "<span class='warning'><b>[src.name]</b>'s piston-ram lets out a weak hiss, it needs more gas!</span>")
		playsound(loc, 'sound/weapons/punch4.ogg', 50, TRUE)
		target.apply_damage((force / 2), BRUTE)
		target.visible_message("<span class='danger'>[user] powerfist lets out a weak hiss as [user.ru_who()] punch[user.p_es()] [target.name]!</span>", \
			"<span class='userdanger'>[user] punch strikes with force!</span>")
		return

	target.apply_damage(force * fisto_setting, BRUTE, wound_bonus = CANT_WOUND)
	target.visible_message("<span class='danger'>[user] powerfist lets out a loud hiss as [user.ru_who()] punch[user.p_es()] [target.name]!</span>", \
		"<span class='userdanger'>You cry out in pain as [user] punch flings you backwards!</span>")
	new /obj/effect/temp_visual/kinetic_blast(target.loc)
	playsound(loc, 'sound/weapons/resonator_blast.ogg', 50, TRUE)
	playsound(loc, 'sound/weapons/genhit2.ogg', 50, TRUE)

	var/atom/throw_target = get_edge_target_turf(target, get_dir(src, get_step_away(target, src)))

	target.throw_at(throw_target, 5 * fisto_setting, 0.5 + (fisto_setting / 2))

	log_combat(user, target, "power fisted", src)

	user.changeNext_move(CLICK_CD_MELEE * click_delay)

	return
