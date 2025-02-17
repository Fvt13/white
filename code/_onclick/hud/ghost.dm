/atom/movable/screen/ghost
	icon = 'icons/hud/screen_ghost.dmi'

/atom/movable/screen/ghost/MouseEntered()
	flick(icon_state + "_anim", src)

/atom/movable/screen/ghost/jumptomob
	name = "Перейти к"
	icon_state = "jumptomob"

/atom/movable/screen/ghost/jumptomob/Click()
	var/mob/dead/observer/G = usr
	G.jumptomob()

/atom/movable/screen/ghost/orbit
	name = "Следить"
	icon_state = "orbit"

/atom/movable/screen/ghost/orbit/Click()
	var/mob/dead/observer/G = usr
	G.follow()

/atom/movable/screen/ghost/reenter_corpse
	name = "Вернуться в тело"
	icon_state = "reenter_corpse"

/atom/movable/screen/ghost/reenter_corpse/Click()
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/atom/movable/screen/ghost/teleport
	name = "Телепорт"
	icon_state = "teleport"

/atom/movable/screen/ghost/teleport/Click()
	var/mob/dead/observer/G = usr
	G.dead_tele()

/atom/movable/screen/ghost/spawners
	name = "Меню перерождений"
	icon_state = "spawners"
	icon = 'white/baldenysh/icons/ui/midnight_extended.dmi'

/atom/movable/screen/ghost/spawners/Initialize(mapload)
	. = ..()
	update_count()

/atom/movable/screen/ghost/spawners/Click()
	var/mob/dead/observer/G = usr
	G.open_spawners_menu()

/atom/movable/screen/ghost/spawners/MouseEntered()
	. = ..()
	update_count()

/atom/movable/screen/ghost/spawners/proc/update_count()
	maptext = "<span class='maptext big'>[LAZYLEN(GLOB.mob_spawners)]</span>"

/atom/movable/screen/ghost/pai
	name = "Кандидат в пИИ"
	icon_state = "pai"
	icon = 'white/baldenysh/icons/ui/midnight_extended.dmi'

/atom/movable/screen/ghost/pai/Click()
	var/mob/dead/observer/G = usr
	G.register_pai()

/atom/movable/screen/ghost/minigames_menu
	name ="Мини-игры"
	icon_state = "minigames"

/atom/movable/screen/ghost/minigames_menu/Click()
	var/mob/dead/observer/observer = usr
	observer.open_minigames_menu()

/datum/hud/ghost/New(mob/owner)
	..()

	if(owner)
		add_multiz_buttons(owner)

	var/atom/movable/screen/using

	using = new /atom/movable/screen/ghost/jumptomob()
	using.screen_loc = ui_ghost_jumptomob
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/orbit()
	using.screen_loc = ui_ghost_orbit
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_reenter_corpse
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/teleport()
	using.screen_loc = ui_ghost_teleport
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/spawners()
	using.screen_loc = ui_ghost_spawners
	static_inventory += using

	using = new /atom/movable/screen/ghost/pai()
	using.screen_loc = ui_ghost_pai
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/ghost/minigames_menu()
	using.screen_loc = ui_ghost_minigames
	using.hud = src
	static_inventory += using

	using = new /atom/movable/screen/language_menu/ghost
	using.icon = ui_style
	using.hud = src
	static_inventory += using

/datum/hud/ghost/show_hud(version = 0, mob/viewmob)
	// don't show this HUD if observing; show the HUD of the observee
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		plane_masters_update()
		return FALSE

	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client.prefs?.ghost_hud)
		screenmob.client.screen -= static_inventory
	else
		screenmob.client.screen += static_inventory

//We should only see observed mob alerts.
/datum/hud/ghost/reorganize_alerts(mob/viewmob)
	var/mob/dead/observer/O = mymob
	if (istype(O) && O.observetarget)
		return
	. = ..()

