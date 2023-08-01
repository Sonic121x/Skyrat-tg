/obj/machinery/vending/dorms
	name = "LustWish"
	desc = "A vending machine with various toys. Not for the faint of heart."
	icon_state = "lustwish"
	base_icon_state = "lustwish"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_structures/lustwish.dmi'
	light_mask = "lustwish-light-mask"
	age_restrictions = TRUE
	///Has the discount card been used on the vending machine?
	var/card_used = FALSE
	product_ads = "Try me!;Kinky!;Lewd and fun!;Hey you, yeah you... wanna take a look at my collection?;Come on, take a look!;Remember, always adhere to Nanotrasen corporate policy!;Don't forget to use protection!"
	vend_reply = "Enjoy!;We're glad to satisfy your desires!"

	//STUFF SOLD HERE//
	products = list(
					/obj/item/restraints/handcuffs/lewd = 8,
					/obj/item/clothing/head/domina_cap = 5,
					/obj/item/clothing/head/costume/kitty = 4,
					/obj/item/clothing/head/costume/rabbitears = 4,
					/obj/item/clothing/mask/muzzle/ring = 4,
					/obj/item/clothing/mask/muzzle/ball = 4,
					/obj/item/clothing/ears/kinky_headphones = 4,
					/obj/item/clothing/glasses/blindfold/kinky = 4,
					/obj/item/clothing/neck/kink_collar = 3,
					/obj/item/clothing/neck/human_petcollar = 8,
					/obj/item/clothing/neck/human_petcollar/locked/cow = 8,
					/obj/item/clothing/neck/human_petcollar/locked/bell = 8,
					/obj/item/clothing/neck/human_petcollar/locked/spike = 8,
					/obj/item/clothing/neck/human_petcollar/locked/cross = 3,
					/obj/item/clothing/neck/human_petcollar/choker = 4,
					/obj/item/clothing/neck/human_petcollar/thinchoker = 8,
					/obj/item/clothing/suit/corset = 2,
					/obj/item/clothing/under/misc/latex_catsuit = 1,
					/obj/item/clothing/head/costume/maidheadband = 1,
					/obj/item/clothing/under/costume/maid = 1,
					/obj/item/clothing/accessory/maidcorset = 1,
					/obj/item/clothing/gloves/maid = 1,
					/obj/item/clothing/neck/maid = 1,
					/obj/item/clothing/head/costume/skyrat/maid = 1,
					/obj/item/clothing/under/rank/civilian/janitor/maid = 1,
					/obj/item/clothing/accessory/maidapron = 1,
					/obj/item/clothing/under/costume/lewdmaid = 1,
					/obj/item/clothing/under/stripper_outfit = 2,
					/obj/item/clothing/under/misc/skyrat/gear_harness = 1,
					/obj/item/clothing/under/stripper_outfit = 4,
					/obj/item/clothing/under/costume/bunnylewd = 4,
					/obj/item/clothing/under/costume/bunnylewd/white = 4,
					/obj/item/clothing/gloves/latex_gloves = 2,
					/obj/item/clothing/gloves/evening = 2,
					/obj/item/clothing/shoes/latex_socks = 2,
					/obj/item/clothing/shoes/latex_heels = 1,
					/obj/item/clothing/shoes/latex_heels/domina_heels = 1,
					/obj/item/clothing/shoes/jackboots/knee = 1,
					//special
					/obj/item/clothing/glasses/nice_goggles = 1 //easter egg, don't touch plz)
					)
	contraband = list(
					/obj/item/electropack/shockcollar = 1
					)
	premium = list(
					/obj/item/clothing/under/pants/skyrat/chaps = 4,
					/obj/item/clothing/neck/human_petcollar/locked/holo = 3
					)

	refill_canister = /obj/item/vending_refill/lustwish
	payment_department = ACCOUNT_SRV
	default_price = 30
	extra_price = 250

//Changes the settings on the vendor, if the user uses the discount card.
/obj/machinery/vending/dorms/attackby(obj/item/used_item, mob/living/user, params)
	if(!istype(used_item, /obj/item/lustwish_discount))
		return ..()

	user.visible_message(span_boldnotice("Something changes in [src] with a loud clunk."))
	card_used = !card_used

	if(card_used)
		default_price = 0
		extra_price = 0

		return

	default_price = initial(default_price)
	extra_price = initial(extra_price)

///Performs checks to see if the user can change the color on the vending machine.
/obj/machinery/vending/dorms/proc/check_menu(mob/living/user, obj/item/multitool)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(!multitool || !user.is_holding(multitool))
		return FALSE

	return TRUE

/obj/machinery/vending/dorms/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()

/obj/machinery/vending/dorms/update_icon_state()
	..()
	if(machine_stat & BROKEN)
		icon_state = "[base_icon_state]-broken"
		return

	icon_state = "[base_icon_state][powered() ? null : "-off"]"

//Refill item
/obj/item/vending_refill/lustwish
	machine_name = "LustWish"
	icon_state = "lustwish_refill"
	icon = 'modular_skyrat/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
