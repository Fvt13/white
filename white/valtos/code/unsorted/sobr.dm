/datum/ert/omon
	roles = list(/datum/antagonist/ert/omon)
	leader_role = /datum/antagonist/ert/omon/leader
	teamsize = 7
	opendoors = FALSE
	rename_team = "ОМОН"
	mission = "Уничтожить террористов на станции."
	polldesc = "специальный отряд быстрого реагирования"

/datum/antagonist/ert/omon
	name = "ОМОН"
	outfit = /datum/outfit/omon
	random_names = TRUE
	role = "Отряд ОМОН"
	greentext_reward = 15

/datum/antagonist/ert/omon/leader
	name = "Лидер ОМОН"
	outfit = /datum/outfit/omon/leader
	role = "Лидер отряда ОМОН"
	leader = TRUE
	greentext_reward = 20

/datum/antagonist/ert/omon/New()
	. = ..()
	name_source = GLOB.last_names_slavic

/datum/antagonist/ert/omon/update_name()
	if(owner.current.gender == FEMALE)
		owner.current.fully_replace_character_name(owner.current.real_name,"[pick("Рядовой", "Ефрейтор", "Сержант")] [pick(name_source)]а")
	else
		owner.current.fully_replace_character_name(owner.current.real_name,"[pick("Рядовой", "Ефрейтор", "Сержант")] [pick(name_source)]")

/datum/antagonist/ert/omon/leader/update_name()
	if(owner.current.gender == FEMALE)
		owner.current.fully_replace_character_name(owner.current.real_name,"Лейтенант [pick(name_source)]а")
	else
		owner.current.fully_replace_character_name(owner.current.real_name,"Лейтенант [pick(name_source)]")

/datum/outfit/omon
	name = "ОМОН"

	uniform = /obj/item/clothing/under/rank/omon/telnajka
	suit = /obj/item/clothing/suit/armor/bulletproof/omon
	suit_store = /obj/item/melee/classic_baton/german
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/fingerless
	ears = /obj/item/radio/headset/headset_cent/alt
	head = /obj/item/clothing/head/beret/airborne
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/security/omon
	id = /obj/item/card/id/advanced/centcom

	id_trim = /datum/id_trim/centcom/omon

	implants = list(/obj/item/implant/sound_implant, /obj/item/implant/mindshield)

/datum/outfit/omon/pre_equip(mob/living/carbon/human/H)
	if (prob(10))
		back = /obj/item/shield/riot/flash
	else
		back = /obj/item/storage/backpack
		backpack_contents = list(/obj/item/storage/box/survival/engineer=1)
	if (prob(1))
		r_hand = /obj/item/gun/ballistic/rocketlauncher/unrestricted //I'm just a OMON with a rocket launcher
		l_hand = /obj/item/ammo_casing/caseless/rocket/weak

/datum/outfit/omon/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/headset_sec
	R.recalculateChannels()

	var/obj/item/card/id/W = H.wear_id
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/omon/leader
	name = "Лидер ОМОН"

	uniform = /obj/item/clothing/under/rank/omon/telnajka
	suit = /obj/item/clothing/suit/armor/bulletproof/omon
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/fingerless
	ears = /obj/item/radio/headset/headset_cent/alt
	head = /obj/item/clothing/head/beret/airborne
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/storage/belt/military/army/omon
	id = /obj/item/card/id/advanced/centcom

	id_trim = /datum/id_trim/centcom/omon/leader

	implants = list(/obj/item/implant/sound_implant, /obj/item/implant/mindshield)

/datum/outfit/omon/leader/pre_equip(mob/living/carbon/human/H)
	back = /obj/item/gun/ballistic/automatic/aksu74

/datum/outfit/omon/leader/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/hos
	R.recalculateChannels()
	var/obj/item/card/id/W = H.wear_id
	W.assignment = name
	W.registered_name = H.real_name
	W.update_label()

/obj/item/storage/belt/military/army/omon

/obj/item/storage/belt/military/army/omon/PopulateContents()
	new /obj/item/ammo_box/magazine/ak74m/orange(src)
	new /obj/item/ammo_box/magazine/ak74m/orange(src)
	new /obj/item/ammo_box/magazine/ak74m/orange(src)
	if(prob(40))
		new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	if(prob(80))
		new /obj/item/grenade/flashbang(src)
	if(prob(30))
		new /obj/item/grenade/syndieminibomb/concussion(src)

/obj/item/storage/belt/security/omon

/obj/item/storage/belt/security/omon/PopulateContents()
	new /obj/item/grenade/flashbang(src)
	new	/obj/item/grenade/stingbang(src)
	new /obj/item/restraints/handcuffs/cable/zipties(src)
	new /obj/item/restraints/handcuffs(src)

/proc/omon_request(text, mob/Sender)
	var/msg = copytext_char(sanitize(text), 1, MAX_MESSAGE_LEN)
	message_admins("[Sender.name] собирается вызвать ОМОН с миссией: [msg]")
	var/list/mob/dead/observer/candidates = poll_ghost_candidates("Хотите быть в мобильном отряде особого назначения?", "deathsquad", null)
	var/teamSpawned = FALSE

	if(candidates.len > 0)
		//Pick the (un)lucky players
		var/numagents = min(7, candidates.len)

		//Create team
		var/datum/team/ert/ert_team = new /datum/team/ert

		//Asign team objective
		var/datum/objective/missionobj = new
		missionobj.team = ert_team
		missionobj.explanation_text = msg
		missionobj.completed = TRUE
		missionobj.reward = 15
		ert_team.objectives += missionobj
		ert_team.mission = missionobj

		var/list/spawnpoints = GLOB.emergencyresponseteamspawn
		var/index = 0
		while(numagents && candidates.len)
			var/spawnloc = spawnpoints[index+1]
			//loop through spawnpoints one at a time
			index = (index + 1) % spawnpoints.len
			var/mob/dead/observer/chosen_candidate = pick(candidates)
			candidates -= chosen_candidate
			if(!chosen_candidate.key)
				continue

			//Spawn the body
			var/mob/living/carbon/human/ERTOperative = new /mob/living/carbon/human(spawnloc)
			chosen_candidate.client.prefs.copy_to(ERTOperative)
			ERTOperative.key = chosen_candidate.key

			//Give antag datum
			var/datum/antagonist/ert/ert_antag

			if(numagents == 1)
				ert_antag = new /datum/antagonist/ert/omon/leader
			else
				ert_antag = new /datum/antagonist/ert/omon

			ERTOperative.mind.add_antag_datum(ert_antag,ert_team)
			ERTOperative.mind.assigned_role = ert_antag.name

			//Logging and cleanup
			log_game("[key_name(ERTOperative)] has been selected as an [ert_antag.name]")
			numagents--
			teamSpawned++

		if (teamSpawned)
			message_admins("[Sender.name] вызывает ОМОН с миссией: [msg]")

		return TRUE
	else
		return FALSE

/obj/item/implant/sound_implant
	name = "звуковой имплант"
	activated = 0
	var/sound/forced_sound

/obj/item/implant/sound_implant/get_data()
	var/dat = {"<b>Имплант:</b><BR>
				<b>Название:</b> Пиздец?<BR>
				<b>Триггер:</b> Сдохнуть.<BR>
				"}
	return dat

/obj/item/implant/sound_implant/trigger(emote, mob/source)
	if(emote == "deathgasp")
		if(forced_sound)
			playsound(loc, forced_sound, 50, FALSE)
		else
			playsound(loc, "white/valtos/sounds/die[rand(1,4)].ogg", 75, FALSE)

/obj/item/implanter/sound_implant
	name = "имплантер (звуковой имплант)"
	imp_type = /obj/item/implant/sound_implant

/obj/item/implantcase/sound_implant
	name = "имплант - 'звуковой имплант'"
	desc = "Прикол."
	imp_type = /obj/item/implant/sound_implant
