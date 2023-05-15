library TrueEnding4END initializer Init needs Cinematic
    globals
        public trigger Trigger
        private tick tk
        private unit SnowMan = null
        private constant string NAME = "|cffff7f27주황버섯|r"
        private constant string SNOW_NAME = "|cff006bf5눈사람|r"
        private constant string SNOW_PINK_NAME = "|cffE45AAF눈사람|r"
        private constant string PINK_NAME = "|cffE45AAF분홍버섯|r"
        private constant string BLACK_NAME = "|cff282828블랙|r"
        private constant string STRANGER_NAME = "|cff00ff22???|r"
        private rect ENDING_RECT
        private unit EndingBackground
    endglobals

    private function MsgPrint takes string s returns nothing
        call ClearTextMessages()
        call BJDebugMsg("　　　　　　" + s )
    endfunction
    
    private function EndingMsgPrint takes string s returns nothing
        call ClearTextMessages()
        call BJDebugMsg("　　　　　　　　　　　　　" + s )
        call BJDebugMsg("|cffffffff" )
        call BJDebugMsg("|cffffffff" )
        call BJDebugMsg("|cffffffff" )
        call BJDebugMsg("|cffffffff" )
        call BJDebugMsg("|cffffffff" )
        call BJDebugMsg("|cffffffff" )
    endfunction
    
    private function ViewFilter takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if EndingFiltering[i] == false and GetLocalPlayer() == Player(i-1) then
                call DisplayCineFilter(true)
            endif
        set i = i + 1
        endloop
    endfunction
    
    private function RemoveMissile takes nothing returns nothing
        call GroupRemoveUnit(BossMissileGroup, GetEnumUnit())
        call RemoveUnit(GetEnumUnit())
    endfunction

    private function CMTTick takes nothing returns nothing
        local integer i = 1
        local string name
        
        call tk.start(4.0, false, function CMTTick)
        if tk.data == 0 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                endif
            set i = i + 1
            endloop
            call Inventory_ShowSkinInventoryButton.evaluate(false)
            call CinematicModeBJ( true, GetPlayersAll() )
            call CinematicFilterGenericBJ( 1.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 100.00, 100, 100, 100, 0 )
        elseif tk.data == 1 then
            call Cinematic_Start(5)
            set GameAllOver = true
            call CinematicFilterGenericBJ( 1.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 0, 0, 0, 0 )
        elseif tk.data == 2 then
            call PanCameraToTimed(3712, -29100, 0)
            call StartSound(gg_snd_KirbysEpicYarn)
            call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 100 )
            set SnowMan = CreateUnit(Player(11), 'ehip', 3840, -29248, 270 )
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                    set gravity[i] = 0
                    set SteppedPlayer[i] = 0
                    if GetUnitTypeId(OrangeMushroom[i]) != OrangeMushroomType[i] then
                        set MorphState[i] = false
                        call RemoveUnit(OrangeMushroom[i])
                        set OrangeMushroom[i] = CreateUnit(Player(i-1), OrangeMushroomType[i], GetRectMinX(ENDING_RECT)+(128*(i-1)), GetRectCenterY(ENDING_RECT), 270 )
                        call SetUnitBlendTime(OrangeMushroom[i], 0.00)
                    elseif GravityChanger_State == true then
                        call RemoveUnit(OrangeMushroom[i])
                        set OrangeMushroom[i] = CreateUnit(Player(i-1), OrangeMushroomType[i], GetRectMinX(ENDING_RECT)+(128*(i-1)), GetRectCenterY(ENDING_RECT), 270 )
                        call SetUnitBlendTime(OrangeMushroom[i], 0.00)
                    else
                        call SetUnitPosition( OrangeMushroom[i], GetRectMinX(ENDING_RECT)+(128*(i-1)), GetRectCenterY(ENDING_RECT) )
                    endif
                    call SetUnitPosition( BackGroundUnits[i], 3712, -28800 )
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                    if Player(i-1) == GetLocalPlayer() then
                        call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                    endif
                    set Observer_State[i] = false
                    set LevelClearState[i] = false
                    set Observer_ViewNumber[i] = 0
                    call UnitRemoveAbility( OrangeMushroom[i], 'Aloc' )
                    call ShowUnitShow(OrangeMushroom[i])
                    call UnitAddAbility( OrangeMushroom[i], 'Aloc' )
                    call SetTextTagVisibility(NameTextTag[i], true)
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                    if i > 1 then
                        call CreateUnit(Player(11), 'ehip', 3840+(160*(i-1)), -29248, 270 )
                    endif
                endif
            set i = i + 1
            endloop
            call tk.start(5.0, false, function CMTTick)
        elseif tk.data == 3 then
            call MsgPrint(NAME + ": 휴... 덕분에 영고라인에서 벗어났어.")
        elseif tk.data == 4 then
            call MsgPrint(SNOW_NAME + ": 이제 정리됐으니 소개팅을 시작해볼까요?")
        elseif tk.data == 5 then
            call MsgPrint(NAME + ": 좋아! 모두 이쪽으로....")
            call tk.start(1, false, function CMTTick)
        elseif tk.data == 6 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call StartSound(gg_snd_OM_lightdown)
            call StopSound( gg_snd_KirbysEpicYarn, false, false )
            call MsgPrint(NAME + ": ..?")
        elseif tk.data == 7 then
            call MsgPrint(NAME + ": 뭐야!! 불이 또 꺼졌다고?")
            call tk.start(2, false, function CMTTick)
        elseif tk.data == 8 then
            call MsgPrint(NAME + ": 도대체 이게 무슨..")
            call tk.start(1, false, function CMTTick)
        elseif tk.data == 9 then
            call StartSound(gg_snd_OM_lightdown)
            call MsgPrint(STRANGER_NAME + " : ..어나!!")
            call tk.start(1, false, function CMTTick)
        elseif tk.data == 10 then
             call MsgPrint(NAME + ": ??")
        elseif tk.data == 11 then
            call StartSound(gg_snd_OM_lightdown)
            call MsgPrint(STRANGER_NAME + " : 야!! 일어나!!")
            call tk.start(2, false, function CMTTick)
        elseif tk.data == 12 then
            call MsgPrint(NAME + " : 이게 무슨 소리야??")
            call tk.start(2, false, function CMTTick)
        elseif tk.data == 13 then
            call StartSound(gg_snd_OM_lightdown)
            call MsgPrint(STRANGER_NAME + " : 소개팅 하러 가야지!!!")
            set FinalStage = false
            call tk.start(2, false, function CMTTick)
        elseif tk.data == 14 then
            call StopSound( BackgroundMusic, false, true )
            call TriggerExecute( TrueEnding4ENDPart2_Trigger )
        endif
        set tk.data = tk.data + 1
    endfunction

    private function Main takes nothing returns nothing
        local integer i = 1
       
        set BossKill = true
        call ForGroup(BossMissileGroup, function RemoveMissile)
        call KillUnit(BlackBoss)
        call StartSound(gg_snd_AAAng001)
        call CameraSetSourceNoise(0, 0)
        call StopSound( BackgroundMusic, false, true )
        set tk = tick.create(0)
        call tk.start(3.0, false, function CMTTick)
    endfunction

    private function SpecialRectOpen takes nothing returns nothing
        call DestroyTrigger(GetTriggeringTrigger())
        call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
        call SetTerrainType(27520, -29408, UnTerrain, -1, 1, 0)
        call SetTerrainType(27520 + 128, -29408, UnTerrain, -1, 1, 0)
        call SetTerrainType(27520, -29408 - 128, UnTerrain, -1, 1, 0)
        call SetTerrainType(27520 + 128, -29408 - 128, UnTerrain, -1, 1, 0)
        call SetDoodadAnimation(27584, -29504, 128.00, 'D00A', false, "stand", false)
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()

        set ENDING_RECT = gg_rct_TrueEndingRect4
        set Trigger = CreateTrigger()
        call TriggerAddAction( Trigger, function Main )

        call TriggerRegisterEnterRectSimple(t, gg_rct_TrueEndingEvent1)
        call TriggerAddAction(t, function SpecialRectOpen)

        set t = null
    endfunction
endlibrary