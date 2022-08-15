library TrueEnding2 initializer init needs Cinematic
    globals
        public trigger Trigger
        private tick tk
        private timer TimeLimit = CreateTimer()
        private timer FinalTimer = CreateTimer()
        private timerdialog TLDialog
        private unit PinkMushroom
        private unit array BlackUnit
        private rect ENDING_RECT
        private constant string NAME = "|cffff7f27주황버섯|r"
        private constant string PINK_NAME = "|cffE45AAF분홍버섯|r"
        private constant string BLACK_NAME = "|cff282828블랙|r"
        private constant string BLACK_NAME2 = "|cff282828또 다른 블랙|r"
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
        local real py = -24804
        
        call tk.start(4.0, false, function CMTTick)
        if tk.data == 0 then
            call CinematicFilterGenericBJ( 3.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 0, 0, 0, 0 )
            call tk.start(4.0, false, function CMTTick)
        elseif tk.data == 1 then
            call StartSound(gg_snd_KirbysEpicYarn)
            call PanCameraToTimed(13888, py, 0)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0)
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                    set gravity[i] = 0
                    set SteppedPlayer[i] = 0
                    if GravityChanger_State == true then
                        call RemoveUnit(OrangeMushroom[i])
                        set OrangeMushroom[i] = CreateUnit(Player(i-1), OrangeMushroomType[i], GetRectMinX(ENDING_RECT)+(128*(i-1)), GetRectCenterY(ENDING_RECT), 270 )
                        call SetUnitBlendTime(OrangeMushroom[i], 0.00)
                    else
                        call SetUnitPosition( OrangeMushroom[i], GetRectMinX(ENDING_RECT)+(128*(i-1)), GetRectCenterY(ENDING_RECT) )
                    endif
                    call SetUnitPosition( BackGroundUnits[i], 14400, py )
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
        elseif tk.data == 2 then
            call MsgPrint(NAME + ": 후... 이전 소개팅들은 최악이였어.")
        elseif tk.data == 3 then
            call MsgPrint(NAME + ": 그래서 이번엔 상대방이나 약속 장소도 전부 다르게 했지!")
        elseif tk.data == 4 then
            call MsgPrint(PINK_NAME + ": 저기요?")
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 5 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(15232, py, 3)
            set PinkMushroom = CreateUnit(Player(11), 'ucry', 15232, -25120, 270 )
        elseif tk.data == 6 then
            call MsgPrint(PINK_NAME + ": 혹시 주황버섯씨 맞으신가요?")
        elseif tk.data == 7 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = true
                    call SetUnitMoveAnimation(OrangeMushroom[i], "Walk Second")
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(14592, py, 1)
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
            call PanCameraToTimed(15232, py, 1)
            call MsgPrint(PINK_NAME + ": 맞아요. 혼자선 도저히 도착할 수 없는 길이더군요.")
        elseif tk.data == 10 then
            call MsgPrint(PINK_NAME + ": 그래도 다행히 일행분들의 도움으로 도착할 수 있었답니다.")
        elseif tk.data == 11 then
            call PanCameraToTimed(14592, py, 0.5)
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
            set BlackUnit[1] = CreateUnit(Player(11), 'hgry', 13504, -24832, 270 )
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
            call PanCameraToTimed(13632, -24832, 3)
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
            loop
            exitwhen i > PersonPlayer()-2
                if i == 1 then
                    set BlackUnit[i+1] = CreateUnit(Player(11), 'hgry', 12928, -24832, 270 )
                elseif i == 2 then
                    set BlackUnit[i+1] = CreateUnit(Player(11), 'hgry', 13248, -24192, 270 )
                elseif i == 3 then
                    set BlackUnit[i+1] = CreateUnit(Player(11), 'hgry', 14080, -24192, 270 )
                elseif i == 4 then
                    set BlackUnit[i+1] = CreateUnit(Player(11), 'hgry', 13312, -25536, 270 )
                elseif i == 5 then
                    set BlackUnit[i+1] = CreateUnit(Player(11), 'hgry', 13952, -25536, 270 )
                endif
            set i = i + 1
            endloop
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0.5)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 100.00 )
            call StartSound(gg_snd_OM_GayBar)
            call PanCameraToTimed(13760, py, 0.5)
            call MsgPrint(NAME + ": 젠장! 저 녀석들 또 왔잖아?")
        elseif tk.data == 21 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call MsgPrint(NAME + ": 분홍버섯씨 도망가세요! 이분들은 위험한...")
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 22 then
            call PanCameraToTimed(15232, -25120, 1)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1500.0, 1.0)
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 50.19, 50.19, 100.00, 100, 50.19, 50.19, 0.00 )
            call SetUnitAnimation( PinkMushroom, "Stand Upgrade First" )
            call MsgPrint(PINK_NAME + ": 무슨 소리하시는거에요? 주황버섯씨♥")
        elseif tk.data == 23 then
            call MsgPrint(PINK_NAME + ": 이분들이 제 일행이에요. 전혀 위험하지 않답니다^^")
        elseif tk.data == 24 then
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 50.19, 50.19, 0.00, 0.00, 0, 0, 0.00 )
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(13504, -24832, 1.5)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 1.5)
            call MsgPrint(BLACK_NAME + ": 이봐 이봐♂ 이번에는 같이 온 일행에 대해서 확인하지 않았다구?♂")
        elseif tk.data == 25 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1000.0, 3.0)
            call MsgPrint(BLACK_NAME + ": 그러니... 이번에도 절륜한 소개팅을 시작해보자구.B.O.Y♂")
        elseif tk.data == 26 then
            call PanCameraToTimed(14592, py, 1)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 1.0)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0, 0, 0.00, 0.00, 0, 0, 100.00 )
            call MsgPrint(NAME + ": 야이... 너희 변태 행위를 소개팅으로 미화하지 말라고 미친놈들아!")
        elseif tk.data == 27 then
            call MsgPrint(NAME + ": 우린 그저 여자친구를 사귀고 싶을 뿐인데")
        elseif tk.data == 28 then
            call MsgPrint(NAME + ": 그게 그렇게 어려운거야?")
        elseif tk.data == 29 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(15232, -25120, 1)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2000.0, 1.0)
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 50.19, 50.19, 100.00, 100, 50.19, 50.19, 0.00 )
            call MsgPrint(PINK_NAME + ": 네 어려워요. 그러니까 현실을 받아들이세요♥")
        elseif tk.data == 30 then
            call MsgPrint(NAME + ": 시발.")
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 31 then
            call MsgPrint(PINK_NAME + ": 아무튼 주황버섯씨?")
        elseif tk.data == 32 then
            call CameraSetSourceNoise(20, 100000)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1850.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 50.19, 50.19, 0.00, 100, 40.19, 40.19, 0.00 )
            call MsgPrint(PINK_NAME + ": 사")
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 33 then
            call CameraSetSourceNoise(40, 100000)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 40.19, 40.19, 0.00, 100, 30.19, 30.19, 0.00 )
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1600.0, 0.2)
            call MsgPrint(PINK_NAME + ": 사.랑")
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 34 then
            call CameraSetSourceNoise(60, 100000)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 30.19, 30.19, 0.00, 100, 20.19, 20.19, 0.00 )
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1450.0, 0.2)
            call MsgPrint(PINK_NAME + ": 사.랑.해")
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 35 then
            call CameraSetSourceNoise(80, 100000)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 20.19, 20.19, 0.00, 100, 10.19, 10.19, 0.00 )
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1300.0, 0.2)
            call MsgPrint(PINK_NAME + ": 사.랑.해.요♥♥♥♥♥♥♥♥♥♥")
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 36 then
            call CameraSetSourceNoise(0, 0)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 10.19, 10.19, 0.00, 100, 10.19, 10.19, 100.00 )
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0.5)
            call PanCameraToTimed(15232, py, 0.5)
            call MsgPrint(NAME + ": (젠장... 이제 어떻해야 하지?)")
        elseif tk.data == 37 then
            call MsgPrint(NAME + ": (그래! 저기로 탈출하는거야!)")
            call PanCameraToTimed(16128, -24928, 1)
        elseif tk.data == 38 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = true
                    call SetUnitMoveAnimation(OrangeMushroom[i], "Walk Second")
                endif
            set i = i + 1
            endloop
            call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 0 )
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 39 then
            call ClearTextMessages()
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = false
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call StopSound( gg_snd_OM_GayBar, false, true )
        elseif tk.data == 40 then
            call RemoveUnit(PinkMushroom)
            loop
            exitwhen BlackUnit[i] == null
                call RemoveUnit(BlackUnit[i])
            set i = i + 1
            endloop
            call StartSound(gg_snd_door_open)
            call tk.start(5.5, false, function CMTTick)
        elseif tk.data == 41 then
            call CameraSetSourceNoise(80, 100000)
            call SetDoodadAnimation(12288, -27584, 128.00, 'IOpr', false, "Spell", false)
            call StartSound(gg_snd_knock001)
            call CinematicFilterGenericBJ( 4.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 100 )
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitPosition( OrangeMushroom[i], GetRectMinX(gg_rct_EndingStartRect2)+(128*(i-1)), GetRectCenterY(gg_rct_EndingStartRect2) )
                    call SetUnitPosition( BackGroundUnits[i], GetRectMinX(gg_rct_EndingStartRect2)+(128*(i-1)), GetRectCenterY(gg_rct_EndingStartRect2) )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(12544, -27648, 0)
            call StopSound( gg_snd_OM_GayBar, false, true )
            call tk.start(1.8, false, function CMTTick)
        elseif tk.data == 42 then
            call CameraSetSourceNoise(0, 0)
            call tk.start(2.2, false, function CMTTick)
        elseif tk.data == 43 then
            call CameraSetSourceNoise(80, 100000)
            call SetDoodadAnimation(12288, -27584, 128.00, 'IOpr', false, "Spell", false)
            call StartSound(gg_snd_knock001)
            call MsgPrint(NAME + ": 정신나간 새끼들... 저렇게까지 끈질길 줄이야.")
            call tk.start(1.8, false, function CMTTick)
        elseif tk.data == 44 then
            call CameraSetSourceNoise(0, 0)
            call tk.start(2.2, false, function CMTTick)
        elseif tk.data == 45 then
            call CameraSetSourceNoise(80, 100000)
            call SetDoodadAnimation(12288, -27584, 128.00, 'IOpr', false, "Spell", false)
            call StartSound(gg_snd_knock001)
            call MsgPrint(NAME + ": 일단 빨리 여기서 벗어나야 겠어.")
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call tk.start(1.8, false, function CMTTick)
        elseif tk.data == 46 then
            call CameraSetSourceNoise(0, 0)
            call tk.start(2.2, false, function CMTTick)
        elseif tk.data == 47 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and GetLocalPlayer() == Player(i-1) then
                    call PanCameraToTimed(GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i])+128, 1)
                endif
            set i = i + 1
            endloop
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 48 then
            call ClearTextMessages()
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "　　　　　　※ 제한 시간안에 탈출하세요!" )
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 49 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "　　　　　　※ 시간 안에 탈출하지 못하거나 최후의 1인은 순결을 잃게 됩니다!" )
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 50 then
            set FinalStage = true
            call SkinFrame_ShowSkinInventoryButton.evaluate(true)
            call CinematicModeBJ( false, GetPlayersAll() )
            set Stage_Loading = false
            call Cinematic_End()
            set BackgroundMusic = gg_snd_Waterflame_Swirl01
            call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
            call Status.SetLevel(6, 9)
            call Status.SetEscapers(0)
            call TimerStart(TimeLimit, 150.00, false, null)
            set TLDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call tk.destroy()
            return
        endif
        set tk.data = tk.data + 1
    endfunction
    
    private function CMTTick2 takes nothing returns nothing
        local integer i = 1
        local real px = 13376
        local real py = -19200
        local string name
        
        call tk.start(4.0, false, function CMTTick2)
        if tk.data == 0 then
            call CinematicFilterGenericBJ( 1.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 0 )
        elseif tk.data == 1 then
            set Stage_Loading = true
            call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 100 )
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                    set gravity[i] = 0
                    call SetUnitPosition( OrangeMushroom[i], GetRectMinX(gg_rct_EndingStartRect2)+(128*(i-1)), GetRectCenterY(gg_rct_EndingStartRect2) )
                    call SetUnitPosition( BackGroundUnits[i], GetRectMinX(gg_rct_EndingStartRect2)+(128*(i-1)), GetRectCenterY(gg_rct_EndingStartRect2) )
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                    if Player(i-1) == GetLocalPlayer() then
                        call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                    endif
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(12544, -27648, 0)
        elseif tk.data == 2 then
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 아니... 아무도 탈출하지 못했단 말이야?")
            elseif Status.Portal == 1 then
                call MsgPrint(NotEscapersName() + ": 야이 배신자 새끼야!")
            else
                call MsgPrint(NotEscapersName() + ": 야이 배신자 새끼들아!")
            endif
        elseif tk.data == 3 then
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 젠장... 이러다가 당하는거 아냐?")
            else
                call MsgPrint(NotEscapersName() + ": 여태까지 협동해놓고 이렇게 버리기야?")
            endif
        elseif tk.data == 4 then
            call SetSoundVolume(BackgroundMusic, 30)
            call CameraSetSourceNoise(80, 100000)
            call SetDoodadAnimation(12288, -27584, 128.00, 'IOpr', false, "Spell", false)
            call StartSound(gg_snd_knock001)
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 아 안 돼...")
            else
                call MsgPrint(NotEscapersName() + ": 아 안 돼...")
            endif
            call tk.start(1.5, false, function CMTTick2)
        elseif tk.data == 5 then
            call SetDoodadAnimation(64, -19328, 128.00, 'IOpr', false, "Death", false)
            call CameraSetSourceNoise(0, 0)
            call StopSound( gg_snd_knock001, false, false )
            call StopSound( BackgroundMusic, false, false )
            call StartSound(gg_snd_GateEpicDeath)
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
        elseif tk.data == 6 then
            call MsgPrint(PINK_NAME + ": 주황버섯씨?")
        elseif tk.data == 7 then
            set PinkMushroom = CreateUnit(Player(11), 'ucry', 12512, -27808, 270 )
            call SetUnitBlendTime(PinkMushroom, 0.00)
            call SetUnitAnimation( PinkMushroom, "Stand Upgrade Second" )
            loop
            exitwhen i > PersonPlayer()-1
                if i == 1 then
                    set BlackUnit[i] = CreateUnit(Player(11), 'hgry', 12032, -27520, 270 )
                elseif i == 2 then
                    set BlackUnit[i] = CreateUnit(Player(11), 'hgry', 12288, -27008, 270 )
                elseif i == 3 then
                    set BlackUnit[i] = CreateUnit(Player(11), 'hgry', 12288, -28160, 270 )
                elseif i == 4 then
                    set BlackUnit[i] = CreateUnit(Player(11), 'hmpr', 13824, -27520, 270 )
                elseif i == 5 then
                    set BlackUnit[i] = CreateUnit(Player(11), 'hmpr', 13440, -27008, 270 )
                elseif i == 6 then
                    set BlackUnit[i] = CreateUnit(Player(11), 'hmpr', 13440, -28160, 270 )
                endif
            set i = i + 1
            endloop
            call StartSound(gg_snd_OM_GayBar)
            call MsgPrint(PINK_NAME + ": 찾.았.다♥")
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 100, 100, 0, 0, 0, 0, 100 )
            call StartSound(gg_snd_OM_lightdown)
        elseif tk.data == 8 then
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 으아아아아아 시발!! 제발 살려줘 부탁이야!!!")
            elseif PersonPlayer()-Status.Portal == 1 then
                call MsgPrint(NotEscapersName() + ": 으아아아아아 시발!! 나 말고 도망간 애들이나 노리란 말이야!")
            elseif Status.Portal == 1 then
                call MsgPrint(NotEscapersName() + ": 으아아아아아 시발!! 우리 말고 도망간 놈이나 노리란 말이야!")
            else
                call MsgPrint(NotEscapersName() + ": 으아아아아아 시발!! 우리 말고 도망간 애들이나 노리란 말이야!")
            endif
        elseif tk.data == 9 then
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0, 0, 100.00, 0.00, 0, 0, 0.00 )
            call PanCameraToTimed(12032, -27520, 1)
            call MsgPrint(BLACK_NAME + ": No no... 눈 앞에 애피타이저를 그냥 지나칠 순 없잖아?♂")
            if Status.Portal == 0 then
                set tk.data = 12
            endif
        elseif tk.data == 10 then
            call PanCameraToTimed(12544, -27648, 1)
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0, 0, 0.00, 0.00, 0, 0, 100.00 )
            call MsgPrint(PINK_NAME + ": 흠... 일단 소개팅을 시작하기전에")
        elseif tk.data == 11 then
            call MsgPrint(PINK_NAME + ": 도망친 동료분들에게 현 상황의 소감을 전달할 기회를 드릴게요.")
        elseif tk.data == 12 then
            set FinalMsg = true
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == false then
                    call SkinFrame_ShowSkinInventoryButton.evaluate(true)
                    call CinematicModeBJ( false, bj_FORCE_PLAYER[i-1] )
                endif
            set i = i + 1
            endloop
            call ClearTextMessages()
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "　　　　　　" + NotEscapersName() + " 님의 최후의 발언을 들어봅시다." )
            call TimerStart(FinalTimer, 15.00, false, null)
            set TLDialog = CreateTimerDialogBJ( FinalTimer, "최후의 발언 시간" )
            call tk.start(15.0, false, function CMTTick2)
            call SetCameraBounds(12544, -27648, 12544, -27648, 12544, -27648, 12544, -27648)
        elseif tk.data == 13 then
            if FinalMsg == true then
                call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0)
                set FinalMsg = false
                loop
                exitwhen i > PLAYER_MAXINUM
                    if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[i] == false then
                        call SkinFrame_ShowSkinInventoryButton.evaluate(false)
                        call CinematicModeBJ( true, bj_FORCE_PLAYER[i-1] )
                    endif
                set i = i + 1
                endloop
                call DestroyTimerDialog(TLDialog)
            else
                call PanCameraToTimed(12544, -27648, 1)
                call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0, 0, 0.00, 0.00, 0, 0, 100.00 )
            endif
            call MsgPrint(PINK_NAME + ": |cffff0000자... 그럼 " + I2S(PersonPlayer()-Status.Portal) +"대" + I2S(PersonPlayer()) + "의 소개팅을 시작해볼까요?|r")
        elseif tk.data == 14 then
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 0 )
            call MsgPrint(PINK_NAME + ": |cffff0000순식간에 홍콩으로 보내드리죠♥|r")
        elseif tk.data == 15 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            call StartSound(gg_snd_OM_Chezic)
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 으악...")
            else
                call MsgPrint(NotEscapersName() + ": 으악...")
            endif
            call StartSound(gg_snd_OM_GladosNo)
            call tk.start(1.0, false, function CMTTick2)
        elseif tk.data == 16 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            call StartSound(gg_snd_Insertion001)
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 안 돼...")
            else
                call MsgPrint(NotEscapersName() + ": 안 돼...")
            endif
            call tk.start(0.7, false, function CMTTick2)
        elseif tk.data == 17 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            call StopSound(gg_snd_OM_Chezic, false, false)
            call StartSound(gg_snd_OM_Chezic)
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": ...안 돼")
            else
                call MsgPrint(NotEscapersName() + ": ...안 돼")
            endif
            call tk.start(0.5, false, function CMTTick2)
        elseif tk.data >= 18 and tk.data <= 58 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 80-((tk.data-18)*2), 40.00-(tk.data-18), 40.00-(tk.data-18), 0, 0, 0, 0, 0 )
            if ModuloInteger(tk.data, 2) == 0 then
                call StopSound(gg_snd_Insertion001, false, false)
                call StartSound(gg_snd_Insertion001)
                call SetSoundVolumeBJ( gg_snd_Insertion001, 100-((tk.data-18)*2) )
            else
                call StopSound(gg_snd_OM_Chezic, false, false)
                call StartSound(gg_snd_OM_Chezic)
                call SetSoundOffsetBJ( 0.05, gg_snd_OM_Chezic )
                call SetSoundVolumeBJ( gg_snd_OM_Chezic, 100-((tk.data-18)*2) )
            endif
            if Status.Portal == 0 then
                call MsgPrint(NAME + ": 안 돼!!!!!!!!!!!!!!!!!!!!!!!!!!")
            else
                call MsgPrint(NotEscapersName() + ": 안 돼!!!!!!!!!!!!!!!!!!!!!!!!!!")
            endif
            call SetSoundVolumeBJ( gg_snd_OM_GayBar, 100-((tk.data-18)*2) )
            call tk.start(0.15, false, function CMTTick2)
        elseif tk.data == 59 then
            call StopSound(gg_snd_OM_GayBar, false, false)
            call tk.start(5.0, false, function CMTTick2)
        elseif tk.data == 60 then
            call StartSound(gg_snd_OM_EndingSound3)
            call EndingMsgPrint("제작: z1z1z1")
        elseif tk.data == 61 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Kirby's Epic Yarn - Rainbow Falls")
        elseif tk.data == 62 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Electric Six - Gay Bar")
        elseif tk.data == 63 then
            call EndingMsgPrint("스프라이트 출처: https://www.spriters-resource.com/")
        elseif tk.data == 64 then
            call EndingMsgPrint("PS: 결말이 똑같아서 실망이라고요? 어차피 달라져도 결과는 같아요...")
        elseif tk.data == 65 then
            call EndingMsgPrint("Thank You")
            call tk.start(6.0, false, function CMTTick2)
        elseif tk.data == 66 then
            call ClearTextMessages()
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set name = StringCase(GetPlayerName(Player(i - 1)), false)
                    call User_IncWorldClearCount.evaluate(name, "Beach")
                    call User_UserList[i - 1].Deposit(300)
                    call JNObjectCharacterSetInt(name, "GoldLeaf", User_UserList[i - 1].GoldLeaf.ToInt())

                    if GetLocalPlayer() == Player(i-1) then
                        if JNObjectCharacterServerConnectCheck() then
                            call JNObjectCharacterSave(mapId, name, secretKey, clearListName)
                            call BJDebugMsg("　　　　　　|cffFFFC00※ 서버에 코드가 저장되었습니다! ※|r")
                        else
                            call BJDebugMsg("　　　　　　|cffFF0202※ 서버에 저장하는데 실패하였습니다. ※|r")
                            call BJDebugMsg("　　　　　　|cffFF0202※ 현재 버전이 최신버전인지 확인해 주십시오.|r")
                        endif
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
            call PauseTimer(TimeLimit)
            call SkinFrame_ShowSkinInventoryButton.evaluate(false)
            call CinematicModeBJ( true, GetPlayersAll() )
            call DestroyTimerDialog(TLDialog)
            set tk = tick.create(0)
            call Cinematic_Start(3)
            call tk.start(0.0, false, function CMTTick2)
            call DestroyTrigger( GetTriggeringTrigger() )
        endif
    endfunction
    
    private function init takes nothing returns nothing
        set ENDING_RECT = gg_rct_TrueEndingRect2
        set Trigger = CreateTrigger()
        call TriggerRegisterTimerExpireEvent(Trigger, TimeLimit)
        call TriggerAddAction( Trigger, function Main )
    endfunction
endlibrary