scope ArrowKey initializer init
    globals
        public boolean array MJump
    endglobals
    
    private function LeftMain takes integer i, real x, real y returns nothing
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)
        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set LeftArrow[i] = true
            set Direction[i] = "Left"
            if LeftArrow[i] == true and RightArrow[i] == true and DownArrow[i] == true then
                call Mirror_Main(i, Status.World, Status.Level)
            endif
            if pet != 0 then
                call pet.GoLeft()
            endif
            if (gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false) then
                call UnitMotion_LeftWalk(i)
            else
                call UnitMotion_LeftJump(i)
            endif
            call SpecialDownStateEnd(i)
        endif
    endfunction
    
    private function RightMain takes integer i, real x, real y returns nothing
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)
        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set RightArrow[i] = true
            if LeftArrow[i] == true and RightArrow[i] == true and DownArrow[i] == true then
                call Mirror_Main(i, Status.World, Status.Level)
            endif
            if pet != 0 then
                call pet.GoRight()
            endif
            if LeftArrow[i] == false then
                set Direction[i] = "Right"
                if (gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false) then
                    call UnitMotion_RightWalk(i)
                else
                    call UnitMotion_RightJump(i)
                endif
            endif
            call SpecialDownStateEnd(i)
        endif
    endfunction
    
    private function Left takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        if CinematicMode == false then
        if Observer_State[i] == false then
            if GravityChanger_State == false then
                call LeftMain(i, x, y)
            else
                call RightMain(i, x, y)
            endif
        else
            call Observer_Change(i, true)
        endif
        endif
    endfunction
    
    private function Right takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        if CinematicMode == false then
        if Observer_State[i] == false then
            if GravityChanger_State == false then
                call RightMain(i, x, y)
            else
                call LeftMain(i, x, y)
            endif
        else
            call Observer_Change(i, false)
        endif
        endif
    endfunction
    
    
    private function Up takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        set UpArrow[i] = true
        if GetUnitTypeId(OrangeMushroom[i]) != 'orai' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            if (MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false and Observer_State[i] == false and GravityChanger_Loading == false and FinalMsg == false) or IsUnitInRegion(Water_Rects, OrangeMushroom[i]) or MJump[i] then
                if (OrangeMushroomType[i] != 'nanw' and OrangeMushroomType[i] != 'n007' and OrangeMushroomType[i] != 'n008') or MorphState[i] == true then
                    if Water_State[i] == false and Player(i-1) == GetLocalPlayer() then
                        call StartSound( gg_snd_OM_Jump )
                    endif
                else
                    if Water_State[i] == false and Player(i-1) == GetLocalPlayer() then
                        call StopSound( gg_snd_MushmomJump001, false, false )
                        call StartSound( gg_snd_MushmomJump001 )
                    endif
                endif
                if MushroomMoving_RectCondition(i, x, y, 40,"UpWidth") then
                    set SteppedPlayer[i] = 0
                    set gravity[i] = 27.00
                    if Direction[i] == "Left" then
                        call UnitMotion_LeftJump(i)
                    elseif Direction[i] == "Right" then
                        call UnitMotion_RightJump(i)
                    endif
                endif
            endif
        elseif GetUnitTypeId(OrangeMushroom[i]) == 'orai' and DownArrow[i] == false then
            set gravity[i] = 8.00
        endif
    endfunction

    private function Down takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        local integer types
        local boolean mirrorApply = false

        set DownArrow[i] = true
        if Stage_Loading == false and Observer_State[i] == false and GravityChanger_Loading == false then

            if LeftArrow[i] == true and RightArrow[i] == true then
                set mirrorApply = Mirror_Main(i, Status.World, Status.Level)
            endif

            if mirrorApply == false then
                if MushroomMoving_RectCondition(i, x, y, 40,"DownWidth") == false then
                    if IsUnitInRegion(Rect_Portal, OrangeMushroom[i]) == true and MorphState[i] == false then
                        if IsUnitInRegion(Rect_Subway, OrangeMushroom[i]) == true then
                            if HiddenCode[0] == true then
                                set Stage_HiddenPortalCount[1] = Stage_HiddenPortalCount[1] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_WitchTower, OrangeMushroom[i]) == true then
                            if HiddenCode[1] == true then
                                set Stage_HiddenPortalCount[2] = Stage_HiddenPortalCount[2] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_Beach, OrangeMushroom[i]) == true then
                            if HiddenCode[2] == true then
                                set Stage_HiddenPortalCount[3] = Stage_HiddenPortalCount[3] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_Coke, OrangeMushroom[i]) == true then
                            if HiddenCode[3] == true then
                                set Stage_HiddenPortalCount[4] = Stage_HiddenPortalCount[4] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_SecretPortal, OrangeMushroom[i]) == true then
                            if HiddenCode[4] == true then
                                set Stage_HiddenPortalCount[5] = Stage_HiddenPortalCount[5] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            elseif HiddenCode[9] == true then
                                set Stage_HiddenPortalCount[11] = Stage_HiddenPortalCount[11] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            elseif HiddenCode[10] == true then
                                set Stage_HiddenPortalCount[12] = Stage_HiddenPortalCount[12] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            elseif LeftArrow[i] == false and RightArrow[i] == false then
                                if Direction[i] == "Left" then
                                    call UnitMotion_LeftDown(i)
                                    call MushmomEyeEffect(i)
                                elseif Direction[i] == "Right" then
                                    call UnitMotion_RightDown(i)
                                    call MushmomEyeEffect(i)
                                endif
                            endif
                        elseif IsUnitInRegion(Rect_Cafe, OrangeMushroom[i]) == true then
                            if HiddenCode[5] == true then
                                set Stage_HiddenPortalCount[6] = Stage_HiddenPortalCount[6] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_Harbor, OrangeMushroom[i]) == true then
                            if HiddenCode[13] == true then
                                set Stage_HiddenPortalCount[14] = Stage_HiddenPortalCount[14] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_Mirror, OrangeMushroom[i]) == true then
                            // if HiddenCode[14] == true then
                                set Stage_HiddenPortalCount[15] = Stage_HiddenPortalCount[15] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            // endif
                        elseif IsUnitInRegion(Rect_Pyramid, OrangeMushroom[i]) == true then
                            if HiddenCode[6] == true then
                                set Stage_HiddenPortalCount[7] = Stage_HiddenPortalCount[7] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_RandomPortal, OrangeMushroom[i]) == true then
                            if HiddenCode[11] == true then
                                set Stage_HiddenPortalCount[9] = Stage_HiddenPortalCount[9] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_Cave, OrangeMushroom[i]) == true then
                            if HiddenCode[8] == true then
                                set Stage_HiddenPortalCount[10] = Stage_HiddenPortalCount[10] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_DragonEgg, OrangeMushroom[i]) == true then
                            if HiddenCode[12] == true then
                                set Stage_HiddenPortalCount[13] = Stage_HiddenPortalCount[13] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            endif
                        elseif IsUnitInRegion(Rect_Ellinforest, OrangeMushroom[i]) == true then
                            if HiddenCode[7] == true then
                                set Stage_HiddenPortalCount[8] = Stage_HiddenPortalCount[8] + 1
                                call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                                call Observer_Start(i)
                            elseif LeftArrow[i] == false and RightArrow[i] == false then
                                if Direction[i] == "Left" then
                                    call UnitMotion_LeftDown(i)
                                    call MushmomEyeEffect(i)
                                elseif Direction[i] == "Right" then
                                    call UnitMotion_RightDown(i)
                                    call MushmomEyeEffect(i)
                                endif
                            endif
                        else
                            call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                            call Observer_Start(i)
                        endif
                    else
                        set Frame_MainPlayerY = 0
                        call MushroomMoving_RectCondition(i, x, y, 40, "DownWidthOM")
                        set types = GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY])
                        if IsUnitInRegion(TeleportStone_Region, OrangeMushroom[i]) == false and IsUnitInRegion(TeleportMoon_Region, OrangeMushroom[i]) == false and DragonStone_InUnit(OrangeMushroom[i]) == false then
                            if types == 'o000' then
                                call BlinChange(Frame_MainPlayerY, 'o001')
                            elseif types == 'o001' then
                                call BlinChange(Frame_MainPlayerY, 'o000')
                            elseif types == 'h00T' or types == 'h00S' then
                                call RashChange(Frame_MainPlayerY)
                            elseif types == 'o006' then
                                call Stage_BlockBoom.Action(OrangeMushroom[Frame_MainPlayerY], Frame_MainPlayerY)
                            elseif types == 'o005' and Cart_CanTakeOut(OrangeMushroom[Frame_MainPlayerY]) then
                                call Cart_TakeOut(OrangeMushroom[Frame_MainPlayerY], Frame_MainPlayerY)
                            endif
                        endif
                        
                        if LeftArrow[i] == false and RightArrow[i] == false and GravityChanger_Loading == false then
                            if Direction[i] == "Left" then
                                call UnitMotion_LeftDown(i)
                            elseif Direction[i] == "Right" then
                                call UnitMotion_RightDown(i)
                            endif
                            call SpecialDownStateStart(i)
                            call HiddenWord_Main(i)
                        endif
                        
                    endif
                    call DragonStone_Main(i, Status.World, Status.Level)
                elseif GetUnitTypeId(OrangeMushroom[i]) == 'orai' then
                    set gravity[i] = -8.00
                endif
                
                call TeleportStone_Main(i)
                call TeleportMoon_Main(i)
                call Mute_Main(i, Status.World, Status.Level)
    
                if ((IsUnitInRegion(TeleportStone_Region, OrangeMushroom[i]) == false and IsUnitInRegion(TeleportMoon_Region, OrangeMushroom[i]) == false) or Frame_MainPlayerY == 0) and Status.World == 11 or (Status.World == 14 and Status.Level == 2) then
                    call ShortTeleport_Main(i, x, y)
                endif
            endif

        endif
    endfunction
    
    private function ReleaseLeftMain takes integer i, real x, real y returns nothing

        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set LeftArrow[i] = false
            call SpecialDownStateEnd(i)
            if RightArrow[i] == true then
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false then
                    call UnitMotion_RightWalk(i)
                else
                    call UnitMotion_RightJump(i)
                endif
                set Direction[i] = "Right"
            else
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false and Landing[i] == true then
                    set Landing[i] = false
                    call UnitMotion_LeftStand(i)
                else
                    set Landing[i] = true
                    call UnitMotion_LeftJump(i)
                endif
                set Direction[i] = "Left"
            endif
        endif
    endfunction
    
    private function ReleaseRightMain takes integer i, real x, real y returns nothing

        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set RightArrow[i] = false
            call SpecialDownStateEnd(i)
            if LeftArrow[i] == true then
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false then
                    call UnitMotion_LeftWalk(i)
                else
                    call UnitMotion_LeftJump(i)
                endif
                set Direction[i] = "Left"
            else
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false and Landing[i] == true then
                    set Landing[i] = false
                    call UnitMotion_RightStand(i)
                else
                    set Landing[i] = true
                    call UnitMotion_RightJump(i)
                endif
                set Direction[i] = "Right"
            endif
        endif
    endfunction
    
    private function ReleaseLeft takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        if CinematicMode == false and Observer_State[i] == false then
            if GravityChanger_State == false then
                call ReleaseLeftMain(i, x, y)
            else
                call ReleaseRightMain(i, x, y)
            endif
        endif
    endfunction
    
    private function ReleaseRight takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        if CinematicMode == false and Observer_State[i] == false then
            if GravityChanger_State == false then
                call ReleaseRightMain(i, x, y)
            else
                call ReleaseLeftMain(i, x, y)
            endif
        endif
    endfunction
    
    private function ReleaseUp takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        
        set UpArrow[i] = false
        if GetUnitTypeId(OrangeMushroom[i]) == 'orai' then
            if DownArrow[i] == true then
                set gravity[i] = -8
            else
                set gravity[i] = 0
            endif
        endif
    endfunction
    
    private function ReleaseDown takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        
        set DownArrow[i] = false
        if GetUnitTypeId(OrangeMushroom[i]) == 'orai' then
            if UpArrow[i] == true then
                set gravity[i] = 8
            else
                set gravity[i] = 0
            endif
        else
            if LeftArrow[i] == false and RightArrow[i] == false and Stage_Loading == false and Observer_State[i] == false and MushroomMoving_RectCondition(i, x, y, 40,"DownWidth") == false and GravityChanger_Loading == false then
                if Direction[i] == "Left" then
                    call UnitMotion_LeftStand(i)
                elseif Direction[i] == "Right" then
                    call UnitMotion_RightStand(i)
                endif
            endif
            call SpecialDownStateEnd(i)
        endif
    endfunction

    private function init takes nothing returns nothing
        local integer i = 1
        local trigger array t
        
        set t[0] = CreateTrigger()
        set t[1] = CreateTrigger()
        set t[2] = CreateTrigger()
        set t[3] = CreateTrigger()
        set t[4] = CreateTrigger()
        set t[5] = CreateTrigger()
        set t[6] = CreateTrigger()
        set t[7] = CreateTrigger()
        loop
        exitwhen i > PLAYER_MAXINUM
            call TriggerRegisterPlayerEvent(t[0], Player(i-1), EVENT_PLAYER_ARROW_LEFT_DOWN)
            call TriggerRegisterPlayerEvent(t[1], Player(i-1), EVENT_PLAYER_ARROW_RIGHT_DOWN)
            call TriggerRegisterPlayerEvent(t[2], Player(i-1), EVENT_PLAYER_ARROW_UP_DOWN)
            call TriggerRegisterPlayerEvent(t[3], Player(i-1), EVENT_PLAYER_ARROW_DOWN_DOWN)
            call TriggerRegisterPlayerEvent(t[4], Player(i-1), EVENT_PLAYER_ARROW_LEFT_UP)
            call TriggerRegisterPlayerEvent(t[5], Player(i-1), EVENT_PLAYER_ARROW_RIGHT_UP)
            call TriggerRegisterPlayerEvent(t[6], Player(i-1), EVENT_PLAYER_ARROW_UP_UP)
            call TriggerRegisterPlayerEvent(t[7], Player(i-1), EVENT_PLAYER_ARROW_DOWN_UP)
        set i = i + 1
        endloop
        call TriggerAddAction( t[0], function Left )
        call TriggerAddAction( t[1], function Right )
        call TriggerAddAction( t[2], function Up )
        call TriggerAddAction( t[3], function Down )
        call TriggerAddAction( t[4], function ReleaseLeft )
        call TriggerAddAction( t[5], function ReleaseRight )
        call TriggerAddAction( t[6], function ReleaseUp )
        call TriggerAddAction( t[7], function ReleaseDown )
        set i = 0
        loop
        exitwhen i > 7
            set t[i] = null
        set i = i + 1
        endloop
    endfunction
endscope
