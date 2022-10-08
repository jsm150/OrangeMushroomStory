scope ArrowKey initializer init
    globals
        public boolean array MJump
    endglobals

    private function KeyAnimation takes unit u, string s1, string s2 returns nothing
        local string temp
        
        if s2 == "First" then
            set temp = "Second"
        else
            set temp = "First"
        endif
        
        if GravityChanger_Loading == false then
            if s1 == "Walk" then
                if GravityChanger_State == false then
                    call SetUnitMoveAnimation(u, s1 + " " + s2)
                else
                    call SetUnitMoveAnimation(u, s1 + " " + temp)
                endif
            elseif GetUnitTypeId(u) == 'orai' then
                if GravityChanger_State == false then
                    call SetUnitAnimation( u, "Stand " + s2 )
                else
                    call SetUnitAnimation( u, "Stand " + temp )
                endif
            else
                if GravityChanger_State == false then
                    call SetUnitAnimation( u, s1 + " " + s2 )
                else
                    call SetUnitAnimation( u, s1 + " " + temp )
                endif
            endif
        endif
        
        
        set u = null
    endfunction
    
    private function LeftMain takes integer i, real x, real y returns nothing
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)
        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set LeftArrow[i] = true
            set Direction[i] = "Left"
            if pet != 0 then
                call pet.GoLeft()
            endif
            if (gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false) then
                call KeyAnimation( OrangeMushroom[i], "Walk", "First" )
                if pet != 0 then
                    call KeyAnimation( pet.Unit, "Walk", "First" )
                endif
            else
                call KeyAnimation( OrangeMushroom[i], "Spell", "First" )
                if pet != 0 then
                    call KeyAnimation( pet.Unit, "Spell", "First" )
                endif
            endif
            call SpecialDownStateEnd(i)
        endif
    endfunction
    
    private function RightMain takes integer i, real x, real y returns nothing
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)
        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set RightArrow[i] = true
            if pet != 0 then
                call pet.GoRight()
            endif
            if LeftArrow[i] == false then
                set Direction[i] = "Right"
                if (gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false) then
                    call KeyAnimation( OrangeMushroom[i], "Walk", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Walk", "Second" )
                    endif
                else
                    call KeyAnimation( OrangeMushroom[i], "Spell", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Spell", "Second" )
                    endif
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
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)
        
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
                        call KeyAnimation( OrangeMushroom[i], "Spell", "First" )
                        if pet != 0 then
                            call KeyAnimation( pet.Unit, "Spell", "First" )
                        endif
                    elseif Direction[i] == "Right" then
                        call KeyAnimation( OrangeMushroom[i], "Spell", "Second" )
                        if pet != 0 then
                            call KeyAnimation( pet.Unit, "Spell", "Second" )
                        endif
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
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)

        set DownArrow[i] = true
        if Stage_Loading == false and Observer_State[i] == false and GravityChanger_Loading == false then
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
                                call KeyAnimation( OrangeMushroom[i], "Stand Ready", "First" )
                                if pet != 0 then
                                    call KeyAnimation( pet.Unit, "Stand Ready", "First" )
                                endif
                                call MushmomEyeEffect(i)
                            elseif Direction[i] == "Right" then
                                call KeyAnimation( OrangeMushroom[i], "Stand Ready", "Second" )
                                if pet != 0 then
                                    call KeyAnimation( pet.Unit, "Stand Ready", "Second" )
                                endif
                                call MushmomEyeEffect(i)
                            endif
                        endif
                    elseif IsUnitInRegion(Rect_Cafe, OrangeMushroom[i]) == true then
                        if HiddenCode[5] == true then
                            set Stage_HiddenPortalCount[6] = Stage_HiddenPortalCount[6] + 1
                            call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                            call Observer_Start(i)
                        endif
                    elseif IsUnitInRegion(Rect_Pyramid, OrangeMushroom[i]) == true then
                        if HiddenCode[6] == true then
                            set Stage_HiddenPortalCount[7] = Stage_HiddenPortalCount[7] + 1
                            call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                            call Observer_Start(i)
                        endif
                    elseif IsUnitInRegion(Rect_RandomPortal, OrangeMushroom[i]) == true then
                        set Stage_HiddenPortalCount[9] = Stage_HiddenPortalCount[9] + 1
                        call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                        call Observer_Start(i)
                    elseif IsUnitInRegion(Rect_Cave, OrangeMushroom[i]) == true then
                        if HiddenCode[8] == true then
                            set Stage_HiddenPortalCount[10] = Stage_HiddenPortalCount[10] + 1
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
                                call KeyAnimation( OrangeMushroom[i], "Stand Ready", "First" )
                                if pet != 0 then
                                    call KeyAnimation( pet.Unit, "Stand Ready", "First" )
                                endif
                                call MushmomEyeEffect(i)
                            elseif Direction[i] == "Right" then
                                call KeyAnimation( OrangeMushroom[i], "Stand Ready", "Second" )
                                if pet != 0 then
                                    call KeyAnimation( pet.Unit, "Stand Ready", "Second" )
                                endif
                                call MushmomEyeEffect(i)
                            endif
                        endif
                    else
                        call CreateUnit(Player(i-1), 'hrif', x, y-60, 90 )
                        call Observer_Start(i)
                    endif
                elseif GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY]) == 'o000' and IsUnitInRegion(TeleportStone_Region, OrangeMushroom[i]) == false and IsUnitInRegion(TeleportMoon_Region, OrangeMushroom[i]) == false then
                    call BlinChange(Frame_MainPlayerY, 'o001')
                elseif GetUnitTypeId(OrangeMushroom[Frame_MainPlayerY]) == 'o001' and IsUnitInRegion(TeleportStone_Region, OrangeMushroom[i]) == false and IsUnitInRegion(TeleportMoon_Region, OrangeMushroom[i]) == false then
                    call BlinChange(Frame_MainPlayerY, 'o000')
                else
                    if LeftArrow[i] == false and RightArrow[i] == false and GravityChanger_Loading == false then
                        if Direction[i] == "Left" then
                            call KeyAnimation( OrangeMushroom[i], "Stand Ready", "First" )
                            if pet != 0 then
                                call KeyAnimation( pet.Unit, "Stand Ready", "First" )
                            endif
                        elseif Direction[i] == "Right" then
                            call KeyAnimation( OrangeMushroom[i], "Stand Ready", "Second" )
                            if pet != 0 then
                                call KeyAnimation( pet.Unit, "Stand Ready", "Second" )
                            endif
                        endif
                        call SpecialDownStateStart(i)
                        call HiddenWord_Main(i)
                    endif
                endif
            elseif GetUnitTypeId(OrangeMushroom[i]) == 'orai' then
                set gravity[i] = -8.00
            endif
            
            call TeleportStone_Main(i)
            call TeleportMoon_Main(i)

            if ((IsUnitInRegion(TeleportStone_Region, OrangeMushroom[i]) == false and IsUnitInRegion(TeleportMoon_Region, OrangeMushroom[i]) == false) or Frame_MainPlayerY == 0) and Status.World == 11 or (Status.World == 14 and Status.Level == 2) then
                call ShortTeleport_Main(i, x, y)
            endif
        endif
    endfunction
    
    private function ReleaseLeftMain takes integer i, real x, real y returns nothing
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)

        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set LeftArrow[i] = false
            call SpecialDownStateEnd(i)
            if RightArrow[i] == true then
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false then
                    call KeyAnimation( OrangeMushroom[i], "Walk", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Walk", "Second" )
                    endif
                else
                    call KeyAnimation( OrangeMushroom[i], "Spell", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Spell", "Second" )
                    endif
                endif
                set Direction[i] = "Right"
            else
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false and Landing[i] == true then
                    set Landing[i] = false
                    call KeyAnimation( OrangeMushroom[i], "Stand", "First" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Stand", "First" )
                    endif
                else
                    set Landing[i] = true
                    call KeyAnimation( OrangeMushroom[i], "Spell", "First" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Spell", "First" )
                    endif
                endif
                set Direction[i] = "Left"
            endif
        endif
    endfunction
    
    private function ReleaseRightMain takes integer i, real x, real y returns nothing
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)

        if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' and GetUnitTypeId(OrangeMushroom[i]) != 'o000' and GetUnitTypeId(OrangeMushroom[i]) != 'o001' then
            set RightArrow[i] = false
                        call SpecialDownStateEnd(i)
            if LeftArrow[i] == true then
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false then
                    call KeyAnimation( OrangeMushroom[i], "Walk", "First" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Walk", "First" )
                    endif
                else
                    call KeyAnimation( OrangeMushroom[i], "Spell", "First" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Spell", "First" )
                    endif
                endif
                set Direction[i] = "Left"
            else
                if gravity[i] < 0 and MushroomMoving_RectCondition(i, x, y, 40, "DownWidth") == false and Landing[i] == true then
                    set Landing[i] = false
                    call KeyAnimation( OrangeMushroom[i], "Stand", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Stand", "Second" )
                    endif
                else
                    set Landing[i] = true
                    call KeyAnimation( OrangeMushroom[i], "Spell", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Spell", "Second" )
                    endif
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
        local Decorate_PetSkin pet = Decorate_GetPetSkin(i - 1)
        
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
                    call KeyAnimation( OrangeMushroom[i], "Stand", "First" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Stand", "First" )
                    endif
                elseif Direction[i] == "Right" then
                    call KeyAnimation( OrangeMushroom[i], "Stand", "Second" )
                    if pet != 0 then
                        call KeyAnimation( pet.Unit, "Stand", "Second" )
                    endif
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
