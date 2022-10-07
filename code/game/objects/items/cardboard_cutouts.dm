//Cardboard cutouts! They're man-shaped and can be colored with a crayon to look like a human in a certain outfit, although it's limited, discolored, and obvious to more than a cursory glance.
/obj/item/cardboard_cutout
	name = "纸板模型"
	desc = "一个大概的人形纸板模型，他是空白的"
	icon = 'icons/obj/art/cardboard_cutout.dmi'
	icon_state = "cutout_basic"
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FLAMMABLE
	/// Possible restyles for the cutout, add an entry in change_appearance() if you add to here
	var/list/possible_appearances = list()
	/// If the cutout is pushed over and has to be righted
	var/pushed_over = FALSE
	/// If the cutout actually appears as what it portray and not a discolored version
	var/deceptive = FALSE

/obj/item/cardboard_cutout/Initialize(mapload)
	. = ..()
	possible_appearances = sort_list(list(
		JOB_ASSISTANT = image(icon = src.icon, icon_state = "cutout_greytide"),
		"Clown" = image(icon = src.icon, icon_state = "cutout_clown"),
		"Mime" = image(icon = src.icon, icon_state = "cutout_mime"),
		"Traitor" = image(icon = src.icon, icon_state = "cutout_traitor"),
		"Nuke Op" = image(icon = src.icon, icon_state = "cutout_fluke"),
		"Cultist" = image(icon = src.icon, icon_state = "cutout_cultist"),
		"Clockwork Cultist" = image(icon = src.icon, icon_state = "cutout_servant"),
		"Revolutionary" = image(icon = src.icon, icon_state = "cutout_viva"),
		"Wizard" = image(icon = src.icon, icon_state = "cutout_wizard"),
		"Nightmare" = image(icon = src.icon, icon_state = "cutout_nightmare"),
		"Xenomorph" = image(icon = src.icon, icon_state = "cutout_fukken_xeno"),
		"Xenomorph Maid" = image(icon = src.icon, icon_state = "cutout_lusty"),
		"Ash Walker" = image(icon = src.icon, icon_state = "cutout_free_antag"),
		"Deathsquad Officer" = image(icon = src.icon, icon_state = "cutout_deathsquad"),
		"Ian" = image(icon = src.icon, icon_state = "cutout_ian"),
		"Slaughter Demon" = image(icon = 'icons/mob/simple/mob.dmi', icon_state = "daemon"),
		"Laughter Demon" = image(icon = 'icons/mob/simple/mob.dmi', icon_state = "bowmon"),
		"Private Security Officer" = image(icon = src.icon, icon_state = "cutout_ntsec")
	))

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/cardboard_cutout/attack_hand(mob/living/user, list/modifiers)
	if(!user.combat_mode || pushed_over)
		return ..()
	user.visible_message(span_warning("[user] pushes over [src]!"), span_danger("You push over [src]!"))
	playsound(src, 'sound/weapons/genhit.ogg', 50, TRUE)
	push_over()

/obj/item/cardboard_cutout/proc/push_over()
	name = initial(name)
	desc = "[initial(desc)] It's been pushed over."
	icon = initial(icon)
	icon_state = "cutout_pushed_over"
	remove_atom_colour(FIXED_COLOUR_PRIORITY)
	alpha = initial(alpha)
	pushed_over = TRUE

/obj/item/cardboard_cutout/attack_self(mob/living/user)
	if(!pushed_over)
		return
	to_chat(user, span_notice("You right [src]."))
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state) //This resets a cutout to its blank state - this is intentional to allow for resetting
	pushed_over = FALSE

/obj/item/cardboard_cutout/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/crayon))
		change_appearance(I, user)
		return
	// Why yes, this does closely resemble mob and object attack code.
	if(I.item_flags & NOBLUDGEON)
		return
	if(!I.force)
		playsound(loc, 'sound/weapons/tap.ogg', get_clamped_volume(), TRUE, -1)
	else if(I.hitsound)
		playsound(loc, I.hitsound, get_clamped_volume(), TRUE, -1)

	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)

	if(I.force)
		user.visible_message(span_danger("[user] hits [src] with [I]!"), \
			span_danger("You hit [src] with [I]!"))
		if(prob(I.force))
			push_over()

/obj/item/cardboard_cutout/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(istype(P, /obj/projectile/bullet/reusable))
		P.on_hit(src, 0, piercing_hit)
	visible_message(span_danger("[src] is hit by [P]!"))
	playsound(src, 'sound/weapons/slice.ogg', 50, TRUE)
	if(prob(P.damage))
		push_over()
	return BULLET_ACT_HIT

/**
 * change_appearance: Changes a skin of the cardboard cutout based on a user's choice
 *
 * Arguments:
 * * crayon The crayon used to change and recolor the cardboard cutout
 * * user The mob choosing a skin of the cardboard cutout
 */
/obj/item/cardboard_cutout/proc/change_appearance(obj/item/toy/crayon/crayon, mob/living/user)
	var/new_appearance = show_radial_menu(user, src, possible_appearances, custom_check = CALLBACK(src, .proc/check_menu, user, crayon), radius = 36, require_near = TRUE)
	if(!new_appearance)
		return FALSE
	if(!do_after(user, 1 SECONDS, src, timed_action_flags = IGNORE_HELD_ITEM))
		return FALSE
	if(!check_menu(user, crayon))
		return FALSE
	user.visible_message(span_notice("[user] gives [src] a new look."), span_notice("Voila! You give [src] a new look."))
	crayon.use_charges(1)
	crayon.check_empty(user)
	alpha = 255
	icon = initial(icon)
	if(!deceptive)
		add_atom_colour("#FFD7A7", FIXED_COLOUR_PRIORITY)
	switch(new_appearance)
		if(JOB_ASSISTANT)
			name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
			desc = "一个助手的纸板模型"
			icon_state = "cutout_greytide"
		if("Clown")
			name = pick(GLOB.clown_names)
			desc = "一个小丑的纸板模型，你觉得这个应该放置在角落里"
			icon_state = "cutout_clown"
		if("Mime")
			name = pick(GLOB.mime_names)
			desc = "...（一个哑剧的纸板模型）"
			icon_state = "cutout_mime"
		if("Traitor")
			name = "[pick("Unknown", "Captain")]"
			desc = "一个叛徒的纸板模型"
			icon_state = "cutout_traitor"
		if("Nuke Op")
			name = "[pick("Unknown", "COMMS", "Telecomms", "AI", "stealthy op", "STEALTH", "sneakybeaky", "MEDIC", "Medic")]"
			desc = "一个核行动的纸板模型"
			icon_state = "cutout_fluke"
		if("Cultist")
			name = "未知"
			desc = "一个邪教徒的纸板模型"
			icon_state = "cutout_cultist"
		if("Clockwork Cultist")
			name = "[pick(GLOB.first_names_male)] [pick(GLOB.last_names)]"
			desc = "一个钟表神的仆人的纸板模型"
			icon_state = "cutout_servant"
		if("Revolutionary")
			name = "未知"
			desc = "一个革命的纸板模型"
			icon_state = "cutout_viva"
		if("Wizard")
			name = "[pick(GLOB.wizard_first)], [pick(GLOB.wizard_second)]"
			desc = "一个巫师的纸板模型"
			icon_state = "cutout_wizard"
		if("Nightmare")
			name = "[pick(GLOB.nightmare_names)]"
			desc = "一个梦魇的纸板模型"
			icon_state = "cutout_nightmare"
		if("Xenomorph")
			name = "alien hunter ([rand(1, 999)])"
			desc = "一个异形的纸板模型"
			icon_state = "cutout_fukken_xeno"
			if(prob(25))
				alpha = 75 //Spooky sneaking!
		if("Xenomorph Maid")
			name = "lusty xenomorph maid ([rand(1, 999)])"
			desc = "一个元气满满的异形女仆的纸板模型"
			icon_state = "cutout_lusty"
		if("Ash Walker")
			name = lizard_name(pick(MALE, FEMALE))
			desc = "一个灰烬行者的纸板模型"
			icon_state = "cutout_free_antag"
		if("Deathsquad Officer")
			name = pick(GLOB.commando_names)
			desc = "一个敢死队指挥官的纸板模型"
			icon_state = "cutout_deathsquad"
		if("Ian")
			name = "伊恩"
			desc = "一个HoP心爱的柯基的纸板模型"
			icon_state = "cutout_ian"
		if("Slaughter Demon")
			name = "屠戮恶魔"
			desc = "一个屠戮恶魔的纸板模型"
			icon = 'icons/mob/simple/mob.dmi'
			icon_state = "daemon"
		if("Laughter Demon")
			name = "欢笑恶魔"
			desc = "一个欢笑恶魔的纸板模型"
			icon = 'icons/mob/simple/mob.dmi'
			icon_state = "bowmon"
		if("Private Security Officer")
			name = "私人安全官"
			desc = "一个私人安全官的纸板模型"
			icon_state = "cutout_ntsec"
		else
			return FALSE
	return TRUE

/**
 * check_menu: Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The mob interacting with a menu
 * * crayon The crayon used to interact with a menu
 */
/obj/item/cardboard_cutout/proc/check_menu(mob/living/user, obj/item/toy/crayon/crayon)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(pushed_over)
		to_chat(user, span_warning("Right [src] first!"))
		return FALSE
	if(!crayon || !user.is_holding(crayon))
		return FALSE
	if(crayon.check_empty(user))
		return FALSE
	if(crayon.is_capped)
		to_chat(user, span_warning("Take the cap off first!"))
		return FALSE
	return TRUE

/obj/item/cardboard_cutout/setDir(newdir)
	newdir = SOUTH
	return ..()

/obj/item/cardboard_cutout/adaptive //Purchased by Syndicate agents, these cutouts are indistinguishable from normal cutouts but aren't discolored when their appearance is changed
	deceptive = TRUE
