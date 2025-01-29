library TrueEnding4ENDPart2 initializer init needs Cinematic, MirrorEntranceEvent
    globals
        private timer TimeLimit = CreateTimer()
        private timer FinalTimer = CreateTimer()
        private timerdialog TLDialog
        private unit PinkMushroom
        public trigger Trigger
        private tick tk
        private unit array BlackUnit
        private unit SnowMan = null
        private constant string NAME = "|cffff7f27주황버섯|r"
        private constant string NAME2 = "|cffff7f27다른 주황버섯|r"
        private constant string PINK_NAME = "|cffE45AAF분홍버섯|r"
        private rect ENDING_RECT
        private unit EndingBackground
        public boolean EllinEnding = false
    endglobals

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
                    call SetUnitPosition( OrangeMushroom[i], GetRectMinX(gg_rct_TrueEndingRect5)+(128*(i-1)), GetRectCenterY(gg_rct_TrueEndingRect5) )
                    call SetUnitPosition( BackGroundUnits[i], GetRectMinX(gg_rct_TrueEndingRect5)+(128*(i-1)), GetRectCenterY(gg_rct_TrueEndingRect5) )
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                endif
            set i = i + 1
            endloop
            loop
                exitwhen i > PLAYER_MAXINUM
                    if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                        call SetUnitPosition( OrangeMushroom[i], GetRectMinX(gg_rct_TrueEndingRect5)+(128*(i-1)), GetRectCenterY(gg_rct_TrueEndingRect5) )
                        call SetUnitPosition( BackGroundUnits[i], GetRectMinX(gg_rct_TrueEndingRect5)+(128*(i-1)), GetRectCenterY(gg_rct_TrueEndingRect5) )
                    endif
                set i = i + 1
                endloop
            call Inventory_ShowSkinInventoryButton.evaluate(false)
            call CinematicModeBJ( true, GetPlayersAll() )
            call CinematicFilterGenericBJ( 1.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 100.00, 100, 100, 100, 0 )
        elseif tk.data == 1 then
            call Cinematic_Start(5)
            call tk.start(1, false, function CMTTick)
        elseif tk.data == 2 then
            call PanCameraToTimed(24000, -29680, 0)
            call BackGroundChange('h001')
            set BackgroundMusic = gg_snd_EllinRainy
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call tk.start(1, false, function CMTTick)
        elseif tk.data == 3 then
            call DisplayTimedTextToForce( GetPlayersAll(), 1.60,"　　　　　　" + NAME + ": 여긴 1-1?? 처음이잖아??" )
            call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 100 )
        elseif tk.data == 4 then
            set i = 2
            loop
                exitwhen i > PLAYER_MAXINUM
                    if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                        call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                    endif
                set i = i + 1
                endloop
                call DisplayTimedTextToForce( GetPlayersAll(), 1.60,"　　　　　　" + NAME2 + ": 야, 시작하자마자 자버리면 어떡해? 빠져가지고" )
        elseif tk.data == 5 then
            call DisplayTimedTextToForce( GetPlayersAll(), 1.60,"　　　　　　" + NAME + ": (시발 뭐지? 꿈이였나?)" )
        elseif tk.data == 6 then
            call DisplayTimedTextToForce( GetPlayersAll(), 1.60,"　　　　　　" + NAME + ": (좋지 않은 꿈이었어..)" )
        elseif tk.data == 7 then
            call DisplayTimedTextToForce( GetPlayersAll(), 1.60,"　　　　　　" + NAME + ": 미안, 지금 바로 출발하자!!" )
        elseif tk.data == 8 then
            call DisplayTimedTextToForce( GetPlayersAll(), 4.00, "　　　　　　※ 숨겨진 열쇠를 찾아 포탈에 들어가세요!" )
            call tk.start(3, false, function CMTTick)
        elseif tk.data == 9 then
            set FinalStage = true
            set Ending3 = false
            call MultiboardSetItemValueBJ( Status.Borad, 1, 1, "컨티뉴(Continues):" )
            call Status.SetContinues(0)
            call MultiboardSetItemValueBJ( Status.Borad, 1, 3, "탈출인원(Escapers):" )
            call Inventory_ShowSkinInventoryButton.evaluate(true)
            call CinematicModeBJ( false, GetPlayersAll() )
            set Stage_Loading = false
            call Cinematic_End()
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call Status.SetLevel(12, 9)
            call Status.SetContinues(1)
            call Status.SetEscapers(0)
            call Key_keyMap.ResetBlocks(12, 9)
            call tk.destroy()
            return
        endif
        set tk.data = tk.data + 1
    endfunction
    
    private function CMTTick2 takes nothing returns nothing
        local integer i = 1
        local real px = 25400
        local real py = -29480
        local string name
        
        call tk.start(4.0, false, function CMTTick2)
        if tk.data == 0 then
            //call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
        elseif tk.data == 1 then
            set Stage_Loading = true
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    //call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 75, 75, 75, 50, 75, 75, 75, 50 )
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                    set gravity[i] = 0
                    call SetUnitPosition( OrangeMushroom[i], GetRectMinX(gg_rct_EndingStartRect3)+(128*(i-1)), GetRectCenterY(gg_rct_EndingStartRect3) )
                    call SetUnitPosition( BackGroundUnits[i], GetRectMinX(gg_rct_EndingStartRect3)+(128*(i-1)), GetRectCenterY(gg_rct_EndingStartRect3) )
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                    if Player(i-1) == GetLocalPlayer() then
                        call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                    endif
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(22592, 9216, 0)
        elseif tk.data == 2 then
                call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 100 )
                if MirrorEntranceEvent_GetLeverValue() == 12 then
                    call MsgPrint(NAME + ": 야 이 배신자 새끼들아!!")
                else
                    call MsgPrint(NotEscapersName() + ": 야 이 배신자 새끼들아!!")
                endif
        elseif tk.data == 3 then
            if MirrorEntranceEvent_GetLeverValue() == 12 then
                call MsgPrint(NAME + ": 나만 빼고 소개팅 가는거야?")
            else
                call MsgPrint(NotEscapersName() + ": 나만 빼고 소개팅 가는거야?")
            endif
        elseif tk.data == 4 then
            if MirrorEntranceEvent_GetLeverValue() == 12 then
                call MsgPrint(NAME + ": ...")
            else
                call MsgPrint(NotEscapersName() + ": ...")
            endif
        elseif tk.data == 5 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call StartSound(gg_snd_OM_lightdown)
            if MirrorEntranceEvent_GetLeverValue() == 12 then
                call MsgPrint(NAME + ": ...")
            else
                call MsgPrint(NotEscapersName() + ": ...")
            endif
            call tk.start(1.0, false, function CMTTick2)
        elseif tk.data == 6 then
            loop
                exitwhen i > PLAYER_MAXINUM
                call DzSetUnitModel( OrangeMushroom[i], "war3mapImported\\PinkMushroom.mdx")
                set i = i + 1
                endloop
                call StartSound(gg_snd_Morph001)
        elseif tk.data == 7 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 100, 100, 0, 0, 0, 0, 100 )
            call StartSound(gg_snd_OM_lightdown)
            call StopSound( gg_snd_EllinRainy, false, false )
        elseif tk.data == 8 then
            call tk.pause()
            if MirrorEntranceEvent_GetLeverValue() == 12 then
                call MirrorHiddenEvent_ThirdMessage.execute(tk, function CMTTick2)
            else
                call StartSound(gg_snd_OM_GayBar)
                call MsgPrint(NotEscapersName() + ": 정체를 들킨건가..")
                call tk.start(2, false, function CMTTick2)
            endif
        elseif tk.data == 9 then
            call MsgPrint(NotEscapersName() + ": ...")
            call tk.start(2, false, function CMTTick2)
            call StartSound(gg_snd_OM_lightdown)
        elseif tk.data == 10 then
            call MsgPrint(NotEscapersName() + ": 반드시...")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2000.0, 0.2)
            call StartSound(gg_snd_OM_lightdown)
            call tk.start(2, false, function CMTTick2)
        elseif tk.data == 11 then
            call MsgPrint(NotEscapersName() + ": 반드시!!!")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1800.0, 0.2)
            call StartSound(gg_snd_OM_lightdown)
            call tk.start(2, false, function CMTTick2)
        elseif tk.data == 12 then
            call MsgPrint(NotEscapersName() + ": 따먹고 말겠다!!!!!!!")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1700.0, 0.2)
            call StartSound(gg_snd_OM_lightdown)
            call tk.start(2, false, function CMTTick2)
        elseif tk.data == 13 then
            call MsgPrint(NotEscapersName() + ": 주!!")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1500.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 30.19, 30.19, 0.00, 100, 20.19, 20.19, 0.00 )
            call tk.start(0.5, false, function CMTTick2)
        elseif tk.data == 14 then
            call MsgPrint(NotEscapersName() + ": 황!!")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1400.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 30.19, 30.19, 0.00, 100, 20.19, 20.19, 0.00 )
            call tk.start(0.5, false, function CMTTick2)
        elseif tk.data == 15 then
            call MsgPrint(NotEscapersName() + ": 버!!")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1300.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 30.19, 30.19, 0.00, 100, 20.19, 20.19, 0.00 )
            call tk.start(0.5, false, function CMTTick2)
        elseif tk.data == 16 then
            call MsgPrint(NotEscapersName() + ": 섯!!")
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1200.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 30.19, 30.19, 0.00, 100, 20.19, 20.19, 0.00 )
            call tk.start(0.5, false, function CMTTick2)
        elseif tk.data == 16 then
            call StopSound( BackgroundMusic, false, true )
            call tk.start(0.5, false, function CMTTick2)
        elseif tk.data == 17 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call MsgPrint(NotEscapersName() + ": AAAAANGG♥♥♥!!")
            call StartSound(gg_snd_AAAng001)
            call tk.start(4.0, false, function CMTTick2)
        elseif tk.data == 18 then
            call StopSound(gg_snd_OM_GayBar, false, false)
            call StartSound(gg_snd_OM_EndingSound3)
            call EndingMsgPrint("제작: 2p4p, JungHun 원작자: z1z1z1")
        elseif tk.data == 19 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Rainy Ellin Forest")
        elseif tk.data == 20 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Electric Six - Gay Bar")
        elseif tk.data == 21 then
            call EndingMsgPrint("스프라이트 출처: https://www.spriters-resource.com/")
        elseif tk.data == 22 then
            call EndingMsgPrint("PS: 이제 시작되는 주황버섯의 소개팅.. 과연 어떻게 될까요?")
        elseif tk.data == 23 then
            call EndingMsgPrint("Thank You")
            call tk.start(6.0, false, function CMTTick2)
        elseif tk.data == 24 then
            call ClearTextMessages()
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set name = StringCase(GetPlayerName(Player(i - 1)), false)
                    if TrueEnding3_CaveEnding == true then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "IceCave")
                    endif
                endif
                set i = i + 1
            endloop
            call tk.start(6.0, false, function CMTTick2)
        else
            call tk.destroy()
            
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call CustomVictoryBJ( Player(i-1), true, true )
                endif
            set i = i + 1
            endloop
            
            return
        endif
        set tk.data = tk.data + 1
    endfunction

    private function Main takes nothing returns nothing
        if FinalStage == false then
            call StopSound( BackgroundMusic, false, true )
            set tk = tick.create(0)
            call Cinematic_Start(2)
            call tk.start(3.0, false, function CMTTick)
        else
            call CinematicFilterGenericBJ( 1.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 100.00, 100, 100, 100, 0 )
            call Inventory_ShowSkinInventoryButton.evaluate(false)
            call CinematicModeBJ( true, GetPlayersAll() )
            set tk = tick.create(0)
            call Cinematic_Start(3)
            call tk.start(0.0, false, function CMTTick2)
            call DestroyTrigger( GetTriggeringTrigger() )
        endif
    endfunction
    
    private function init takes nothing returns nothing
        set ENDING_RECT = gg_rct_TrueEndingRect5
        set Trigger = CreateTrigger()
        call TriggerRegisterTimerExpireEvent(Trigger, TimeLimit)
        call TriggerAddAction( Trigger, function Main )
    endfunction
endlibrary