/obj/projectile/bullet/reusable/foam_dart
	name = "дротик из пены"
	desc = "Я надеюсь ты надел очки."
	damage = 0 // It's a damn toy.
	damage_type = OXY
	nodamage = TRUE
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foamdart_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart
	range = 10
	var/modified = FALSE
	var/obj/item/pen/pen = null

/obj/projectile/bullet/reusable/foam_dart/handle_drop()
	if(dropped)
		return
	var/turf/T = get_turf(src)
	if(iswallturf(T))
		for(var/turf/W in locs) // try to find non wall turfs to drop in
			if(!iswallturf(W))
				T = W
				break
	dropped = 1
	var/obj/item/ammo_casing/caseless/foam_dart/newcasing = new ammo_type(T)
	newcasing.modified = modified
	var/obj/projectile/bullet/reusable/foam_dart/newdart = newcasing.loaded_projectile
	newdart.modified = modified
	if(modified)
		newdart.damage = 5
		newdart.nodamage = FALSE
	newdart.damage_type = damage_type
	if(pen)
		newdart.pen = pen
		pen.forceMove(newdart)
		pen = null
	newdart.update_icon()


/obj/projectile/bullet/reusable/foam_dart/Destroy()
	pen = null
	return ..()

/obj/projectile/bullet/reusable/foam_dart/riot
	name = "утяжелённый дротик из пены"
	icon_state = "foamdart_riot_proj"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/riot
	nodamage = FALSE
	stamina = 25
