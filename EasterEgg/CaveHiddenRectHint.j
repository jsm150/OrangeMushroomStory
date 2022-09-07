library CaveHiddenRectHint initializer Init
    globals
        public rect array Rectlist

        private region array Region
        private integer Index = 0
        private rect array DownArrow
    endglobals

    private function Action takes nothing returns nothing
        local integer i = 0
        loop
            exitwhen i >= Index
            if GetTriggeringRegion() == Region[i] and MushroomType(GetUnitTypeId(GetTriggerUnit())) then
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(Rectlist[i]), GetRectCenterY(Rectlist[i]) ))
                call SetDoodadAnimation(GetRectMinX(DownArrow[i]), GetRectMaxY(DownArrow[i]), 128.00, 'YOf3', false, "stand", false)
                call CreateUnit(Player(11), 'h005', GetRectCenterX(Rectlist[i]), GetRectCenterY(Rectlist[i]), 270 )
                call RemoveRegion(Region[i])
                set Region[i] = null
                return
            endif
            set i = i + 1
        endloop
    endfunction

    private function HideDownArrow takes nothing returns nothing
        local integer i = 0
        loop
            exitwhen i >= Index
            call SetDoodadAnimation(GetRectMinX(DownArrow[i]), GetRectMaxY(DownArrow[i]), 128.00, 'YOf3', false, "death", false)
            set i = i + 1
        endloop
    endfunction

    private function SetRect takes trigger t, rect r1, rect r2 returns nothing
        set Region[Index] = CreateRegion()
        call RegionAddRect(Region[Index], r1)

        set Rectlist[Index] = r1
        set DownArrow[Index] = r2

        call TriggerRegisterEnterRegion(t, Region[Index], null)
        set Index = Index + 1
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call SetRect(t, gg_rct_CaveHintTeleport001_in, gg_rct_HideDownArrow001)
        call SetRect(t, gg_rct_CaveHintTeleport002_in, gg_rct_HideDownArrow002)
        call SetRect(t, gg_rct_CaveHintTeleport003_in, gg_rct_HideDownArrow003)
        call SetRect(t, gg_rct_CaveHintTeleport004_in, gg_rct_HideDownArrow004)
        call SetRect(t, gg_rct_CaveHintTeleport005_in, gg_rct_HideDownArrow005)
        call SetRect(t, gg_rct_CaveHintTeleport006_in, gg_rct_HideDownArrow006)
        call SetRect(t, gg_rct_CaveHintTeleport007_in, gg_rct_HideDownArrow007)
        call SetRect(t, gg_rct_HiddenSkinTeleport001_in, gg_rct_HideDownArrow008)
        
        call TriggerAddAction(t, function Action)
        
        call HideDownArrow()

        set t = null
    endfunction

endlibrary