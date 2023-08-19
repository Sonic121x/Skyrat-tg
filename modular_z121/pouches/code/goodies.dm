/datum/supply_pack/goody/generic_pouch
        name = "小型口袋"
        desc = "内含一个能装 2 个小物品的小型口袋, 用来方便的装东西"
        cost = PAYCHECK_CREW * 6
        contains = list(
            /obj/item/storage/pouch/generic_pouch
        )

/datum/supply_pack/goody/expanded_pouch
        name = "扩容口袋"
        desc = "内含一个能装 3 个小物品中型口袋, 拥有更大的容量"
        cost = PAYCHECK_CREW * 6 * 1.5
        contains = list(
            /obj/item/storage/pouch/expanded_pouch
        )

/datum/supply_pack/goody/carrying_pouch
        name = "载重口袋"
        desc = "内含一个能装 2 个物品的载重口袋, 但能容纳 1 个普通物品"
        cost = PAYCHECK_CREW * 6 * 1.5
        contains = list(
            /obj/item/storage/pouch/carrying_pouch
        )
