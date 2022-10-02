library TrueEnding3 initializer init needs Cinematic
    globals
        boolean SecretEnding = false
        boolean SecretEnding2 = false
        public boolean PyramidEnding = false
        public boolean CaveEnding = false
        boolean Ending3 = false
        public trigger Trigger
        private tick tk
        unit SnowMan = null
        unit BlackBoss = null
        private rect ENDING_RECT
        private constant string NAME = "|cffff7f27주황버섯|r"
        private constant string SNOW_NAME = "|cff006bf5눈사람|r"
        private constant string BLACK_NAME = "|cff282828블랙|r"
    endglobals

    private function MsgPrint takes string s returns nothing
        call ClearTextMessages()
        call BJDebugMsg("　　　　　　" + s )
    endfunction
    
    private function NotEscapersName takes nothing returns string
        local string s = ""
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == false then
                set s = s + TeamColor[i] + GetPlayerName(Player(i-1)) + "|r, "
            endif
        set i = i + 1
        endloop
        if s != "" then
            set s = SubString(s, 0, StringLength(s)-2)
        else
            set s = NAME
        endif
        return s
    endfunction
    
    private function EscapersName takes nothing returns string
        local string s = ""
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == true then
                set s = s + TeamColor[i] + GetPlayerName(Player(i-1)) + "|r, "
            endif
        set i = i + 1
        endloop
        set s = SubString(s, 0, StringLength(s)-2)
        return s
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
    
    private function CMTTick takes nothing returns nothing
        local integer i = 1
        local real px = 13376
        local real py = -30976
        
        call tk.start(4.0, false, function CMTTick)
        if tk.data == 0 then
            call CinematicFilterGenericBJ( 3.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 0, 0, 0, 0 )
            call tk.start(4.0, false, function CMTTick)
        elseif tk.data == 1 then
            call BackGroundChange('ebal')
            if TrueEnding3_CaveEnding == true then
                call BackGroundChange('h002')
            endif
            set SnowMan = CreateUnit(Player(11), 'ehip', 1152, -31168, 270 )
            call PanCameraToTimed(-192, py, 0)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0)
            call StartSound(gg_snd_KirbysEpicYarn)
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
                    call SetUnitPosition( BackGroundUnits[i], 192, py )
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
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            set GravityChanger_State = false
            call CinematicFilterGenericBJ( 5.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 100 )
            call tk.start(5.0, false, function CMTTick)
            //set tk.data = 33
        elseif tk.data == 2 then
            call MsgPrint(NAME + ": 후... 이전 소개팅들은 최악이였어.")
        elseif tk.data == 3 then
            call MsgPrint(NAME + ": 그래서 이번엔 상대방이나 약속 장소도 전부 다르게 했지!")
        elseif tk.data == 4 then
            call MsgPrint(SNOW_NAME + ": 저기요?")
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 5 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(640, py, 3)
            call SetUnitBlendTime(SnowMan, 0.00)
        elseif tk.data == 6 then
            call MsgPrint(SNOW_NAME + ": 혹시 주황버섯씨 맞으신가요?")
        elseif tk.data == 7 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = true
                    call SetUnitMoveAnimation(OrangeMushroom[i], "Walk Second")
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(192, py, 1)
            call tk.start(1.5, false, function CMTTick)
            call MsgPrint(NAME + ": 네! 맞아요! 그런데 오시는 길이 힘들지 않으셨어요?")
        elseif tk.data == 8 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = false
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call tk.start(2.5, false, function CMTTick)
        elseif tk.data == 9 then
            call PanCameraToTimed(640, py, 1)
            call MsgPrint(SNOW_NAME + ": 맞아요. 혼자선 도저히 도착할 수 없는 길이더군요.")
        elseif tk.data == 10 then
            call MsgPrint(SNOW_NAME + ": 그래도 다행히 일행분들의 도움으로 도착할 수 있었답니다.")
        elseif tk.data == 11 then
            call PanCameraToTimed(192, py, 0.5)
            call MsgPrint(NAME + ": 그런데 같이 온 일행분들은 어디계시...")
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 12 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call StartSound(gg_snd_OM_lightdown)
            call StopSound( gg_snd_KirbysEpicYarn, false, false )
            call MsgPrint(NAME + ": ..?")
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 13 then
            call MsgPrint(NAME + ": 잠깐만! 불이 또 꺼졌어!")
        elseif tk.data == 14 then
            call MsgPrint(NAME + ": 설마 또 그런 일이...")
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 15 then
            set BlackBoss = CreateUnit(Player(11), 'hgry', -512, -30848, 270 )
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 100, 100, 0, 0, 0, 0, 100 )
            call StartSound(gg_snd_OM_lightdown)
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 16 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(-512, -30848, 3)
            call tk.start(3.0, false, function CMTTick)
        elseif tk.data == 17 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2000.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 70.00 )
            call StartSound(gg_snd_DeepDarkFantasy)
            call MsgPrint(BLACK_NAME + ": Deep ♂")
            call tk.start(0.4, false, function CMTTick)
        elseif tk.data == 18 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1500.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 70.00, 0.00, 0, 0, 30.00 )
            call MsgPrint(BLACK_NAME + ": Dark ♂")
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 19 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1000.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 30.00, 0.00, 0, 0, 0.00 )
            call MsgPrint(BLACK_NAME + ": ♂ FANTASY ♂")
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 20 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0.5)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 100.00 )
            call StartSound(gg_snd_OM_GayBar)
            call PanCameraToTimed(192, py, 0.5)
            call MsgPrint(NAME + ": 젠장! 저 녀석들 또 왔잖아?")
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = true
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 21 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = false
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
        elseif tk.data == 22 then
            call MsgPrint(SNOW_NAME + ": 주황버섯씨... 저게 도데체 뭐죠? 제 일행은 아닌데...")
        elseif tk.data == 23 then
            call MsgPrint(NAME + ": 저 녀석이야! 매번 내 소개팅을 붕탁물로 바꿔버린다고!")
        elseif tk.data == 24 then
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0, 0, 100.00, 0.00, 0, 0, 0.00 )
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(-512, -30848, 1.5)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 1.5)
            call MsgPrint(BLACK_NAME + ": 매번 이렇게 될걸 알고서도 찾아오는걸 보면 너도... 즐기는거 아냐♂?")
        elseif tk.data == 25 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1000.0, 3.0)
            call MsgPrint(BLACK_NAME + ": 아무튼 펩시처럼 달콤하고♂ 어두운♂ 소개팅을 시작해보자구.B.O.Y♂")
        elseif tk.data == 26 then
            call PanCameraToTimed(640, py, 1)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 1.0)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0, 0, 0.00, 0.00, 0, 0, 100.00 )
            call MsgPrint(SNOW_NAME + ": ...잠깐 주황버섯씨! 왜 저런 펩시충한테 당해주러 갈려는거에요!")
        elseif tk.data == 27 then
            call MsgPrint(NAME + ": 틀렸어... 매번 저 녀석에게서 벗어날 수 없었다고!")
        elseif tk.data == 28 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call MsgPrint(SNOW_NAME + ": 걱정마요. 제게 생각이 있으니까요!")
        elseif tk.data == 29 then
            call PanCameraToTimed(768, -30848, 1.5)
            call SetUnitAnimation( SnowMan, "Stand Second" )
            call MsgPrint(SNOW_NAME + ": 오른편에 비석 보이시죠?")
        elseif tk.data == 30 then
            call MsgPrint(SNOW_NAME + ": 저 힘을 이용하면 이번엔 결과가 다를지도 몰라요.")
        elseif tk.data == 31 then
            call PanCameraToTimed(192, py, 1)
            call SetUnitAnimation( SnowMan, "Stand First" )
            call MsgPrint(NAME + ": 그러니까 저걸 이용해서 슈팅게임을 하란거지?")
        elseif tk.data == 32 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call MsgPrint(NAME + ": 좋아 한 번 해보자고!")
        elseif tk.data == 33 then
            call StopSound( gg_snd_OM_GayBar, false, true )
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 0 )
        elseif tk.data == 34 then
            call ClearTextMessages()
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 블랙의 공격을 피하면서 스톤볼 빔으로 공격하세요!" )
            //set BlackBoss = CreateUnit(Player(11), 'hgry', -512, -30848, 270 )
            call MultiboardSetItemValueBJ( Status.Borad, 1, 1, "보스 체력(Boss HP):" )
            call MultiboardSetItemValueBJ( Status.Borad, 2, 1, I2S(R2I(GetUnitState(BlackBoss, UNIT_STATE_LIFE))) + " / " + I2S(R2I(GetUnitState(BlackBoss, UNIT_STATE_MAX_LIFE))) )
            call RemoveUnit(SnowMan)
            call SetUnitUserData( BlackBoss, 0 )
            call SetUnitPosition( BlackBoss, -768, -30080 )
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 100 )
            set FinalStage = true
            call SkinFrame_ShowSkinInventoryButton.evaluate(true)
            call CinematicModeBJ( false, GetPlayersAll() )
            set Stage_Loading = false
            call Cinematic_End()
            set BackgroundMusic = gg_snd_WilliamTellOvertureRemixFull
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call Status.SetLevel(7, 9)
            call Status.SetEscapers(0)
            call MultiboardSetItemValueBJ( Status.Borad, 1, 3, "당한 인원(Gays):" )
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitPosition( BackGroundUnits[i], GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]) )
                endif
            set i = i + 1
            endloop
        endif
        set tk.data = tk.data + 1
    endfunction
    
    private function Main takes nothing returns nothing
        if FinalStage == false then
            set Ending3 = true
            call StopSound( BackgroundMusic, false, true )
            set tk = tick.create(0)
            call Cinematic_Start(4)
            call tk.start(3.0, false, function CMTTick)
        endif
    endfunction
    
    private function init takes nothing returns nothing
        set ENDING_RECT = gg_rct_TrueEndingRect3
        set Trigger = CreateTrigger()
        call TriggerAddAction( Trigger, function Main )
    endfunction
endlibrary