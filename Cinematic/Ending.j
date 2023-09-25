library Ending initializer init needs Cinematic, EndingSkip
    globals
        public trigger Trigger
        private tick tk
        private rect ENDING_RECT
        private constant string NAME = "|cffff7f27주황버섯|r"
        private constant string BLACK_NAME = "|cff282828블랙|r"
        private constant string BLACK_NAME2 = "|cff282828또 다른 블랙|r"
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
    
    private function CMTTick takes nothing returns nothing
        local integer i = 1
        local real px = 14848
        local real py = 6790
        local string name
        
        call tk.start(4.0, false, function CMTTick)
        if tk.data == 0 then
            call CinematicFilterGenericBJ( 1.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 0, 0, 0, 0 )
            call EndingSkip_Ready(tk, 87)
            call tk.start(5.5, false, function CMTTick)
        elseif tk.data == 1 then
            call EndingSkip_Disable()
            call StartSound(gg_snd_door_open)
            call PanCameraToTimed(px, py, 0)
            call BackGroundChange('hgyr')
            call tk.start(5.5, false, function CMTTick)
        elseif tk.data == 2 then
            call StartSound(gg_snd_TheRoost)
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0)
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set LeftArrow[i] = false
                    set RightArrow[i] = false
                    set gravity[i] = 0
                    set SteppedPlayer[i] = 0
                    call SetUnitPosition( OrangeMushroom[i], GetRectMinX(ENDING_RECT)+(128*(i-1)), GetRectCenterY(ENDING_RECT) )
                    call SetUnitPosition( BackGroundUnits[i], px, py )
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                    set Observer_State[i] = false
                    set LevelClearState[i] = false
                    set Observer_ViewNumber[i] = 0
                    call UnitRemoveAbility( OrangeMushroom[i], 'Aloc' )
                    call ShowUnitShow(OrangeMushroom[i])
                    call UnitAddAbility( OrangeMushroom[i], 'Aloc' )
                    call SetTextTagVisibility(NameTextTag[i], true)
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call CinematicFilterGenericBJ( 5.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 100 )
            call tk.start(5.0, false, function CMTTick)
        elseif tk.data == 3 then
            if Status.World == 4 then
                call MsgPrint(NAME + ": ...? 예전과 같은 장소인 것 같은데 기분 탓인가?")
            else
                call MsgPrint(NAME + ": 드디어 도착한건가?")
            endif
        elseif tk.data == 4 then
            if Status.World == 4 then
                call MsgPrint(NAME + ": 뭐... 아무튼 먼저 와 있겠다고 했는데")
            else
                call MsgPrint(NAME + ": 흠... 먼저 와 있겠다고 했는데")
            endif
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
        elseif tk.data == 5 then
            call MsgPrint(NAME + ": 왜 아무도 없는...")
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 6 then
            call MsgPrint(NAME + ": ?!")
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call StartSound(gg_snd_OM_lightdown)
            call StopSound( gg_snd_TheRoost, false, false )
            call tk.start(3.0, false, function CMTTick)
        elseif tk.data == 7 then
            call MsgPrint(NAME + ": 뭐야? 아무것도 안 보여!")
        elseif tk.data == 8 then
            call MsgPrint(NAME + ": 이게 도대체 무슨 일...")
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 9 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call CreateUnit(Player(11), 'hgry', 13824, 6784, 270 )
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 100, 100, 0, 0, 0, 0, 100 )
            call StartSound(gg_snd_OM_lightdown)
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 10 then
            call PanCameraToTimed(13824, 6784, 3)
            call tk.start(3.0, false, function CMTTick)
        elseif tk.data == 11 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2000.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 70.00 )
            call StartSound(gg_snd_DeepDarkFantasy)
            call MsgPrint(BLACK_NAME + ": Deep ♂")
            call tk.start(0.4, false, function CMTTick)
        elseif tk.data == 12 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1500.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 70.00, 0.00, 0, 0, 30.00 )
            call MsgPrint(BLACK_NAME + ": Dark ♂")
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 13 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1000.0, 0.2)
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 30.00, 0.00, 0, 0, 0.00 )
            call MsgPrint(BLACK_NAME + ": ♂ FANTASY ♂")
            call tk.start(1.5, false, function CMTTick)
        elseif tk.data == 14 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0.5)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 100.00 )
            call StartSound(gg_snd_OM_GayBar)
            call MsgPrint(NAME + ": 뭐... 뭐?!!야!!잠깐만!!!")
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = true
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(px, py, 0.5)
            call tk.start(0.8, false, function CMTTick)
        elseif tk.data == 15 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = false
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call tk.start(3.2, false, function CMTTick)
        elseif tk.data == 16 then
            call MsgPrint(NAME + ": 우린 임자가 있는 몸이야... 소개팅 약속이 있단 말이야!")
        elseif tk.data == 17 then
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 0.00 )
            call PanCameraToTimed(13824, 6784, 1)
            call MsgPrint(BLACK_NAME + ": 그런 것쯤은 알고 있어♥ 왜냐하면 소개팅 상대가 바로 나라구♂")
        elseif tk.data == 18 then
            call MsgPrint(BLACK_NAME + ": 그건 그렇고... 방금 네 입으로 임자가 나♂라는걸 증명하는 꼴이 됐군?")
        elseif tk.data == 19 then
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 100.00 )
            call PanCameraToTimed(px, py, 0.5)
            call MsgPrint(NAME + ": ...시발")
        elseif tk.data == 20 then
            if Status.World == 4 then
                call MsgPrint(NAME + ": 아니 시발 전보다 훨씬 고생에서 도착했는데")
            else
                call MsgPrint(NAME + ": 아니 시발. 우리가 바란 건 이게 아니었다고!")
            endif
        elseif tk.data == 21 then
            if Status.World == 4 then
                call MsgPrint(NAME + ": 왜 같은 결말이 나오는 거냐고!")
            else
                call MsgPrint(NAME + ": 우리가 널 위해 그 지랄을 한 줄 알아?")
            endif
        elseif tk.data == 22 then
            call PanCameraToTimed(13824, 6784, 1)
            if Status.World == 4 then
                call MsgPrint(BLACK_NAME + ": 이봐 이봐♂ 가는 길만 달라졌지 결국 목적지는 같다구?♥")
            else
                call MsgPrint(BLACK_NAME + ": 그러니까 만나기 전에 나에 대해 자세히 물어봤어야지♥")
            endif
        elseif tk.data == 23 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 1000.0, 3.0)
            call CinematicFilterGenericBJ( 3.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 0.00 )
            if Status.World == 4 then
                call MsgPrint(BLACK_NAME + ": 자 그럼... 다시 깊고 어두운 소개팅을 시작하지...")
            else
                call MsgPrint(BLACK_NAME + ": 자 그럼... 깊고 어두운 소개팅을 시작하지...")
            endif
            if PersonPlayer() <= 1 then
                set tk.data = 38
            endif
        elseif tk.data == 24 then
            call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 2500.0, 0.5)
            call PanCameraToTimed(px, py, 0.5)
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 100.00 )
            call MsgPrint(NAME + ": ...우리가 순순히 당할 것 같아?")
        elseif tk.data == 25 then
            call MsgPrint(NAME + ": 바로 도망가야...")
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 26 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = true
                    call SetUnitMoveAnimation(OrangeMushroom[i], "Walk Second")
                endif
            set i = i + 1
            endloop
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data == 27 then
            call StartSound(gg_snd_DeepDarkFantasy)
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set RightArrow[i] = false
                    set LeftArrow[i] = true
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call CreateUnit(Player(11), 'hmpr', 15872, 6784, 270 )
            call PanCameraToTimed(15872, 6784, 1)
            call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 100.00, 0.00, 0, 0, 0.00 )
            call MsgPrint(BLACK_NAME2 + ": 이봐 친구! 가죽클럽은 두 블럭 아래야!")
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 28 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set LeftArrow[i] = false
                    call SetUnitAnimation( OrangeMushroom[i], "Stand Second" )
                endif
            set i = i + 1
            endloop
            call tk.start(3.0, false, function CMTTick)
        elseif tk.data == 29 then
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call SetUnitAnimation( OrangeMushroom[i], "Stand First" )
                endif
            set i = i + 1
            endloop
            call PanCameraToTimed(px, py, 0.5)
            if Status.World == 4 then
                call MsgPrint(NAME + ": 아 잠깐만!!! 또 당하고 싶진 않단 말이야!")
            else
                call MsgPrint(NAME + ": 어??! 뭐야 혼자가 아니었어?")
            endif
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 0.00, 0.00, 0.00, 0, 0, 100.00 )
        elseif tk.data == 30 then
            if Status.World == 4 then
                call MsgPrint(BLACK_NAME + ": 그 부분에 대해선 걱정할 필요 없다구♂?")
            else
                call MsgPrint(BLACK_NAME + ": 이봐 이봐♥ 소개팅은 단둘이서 하는 거라구♂?")
            endif
        elseif tk.data == 31 then
            call StartSound(gg_snd_OM_LightEffct)
            if Status.World == 4 then
                call MsgPrint(BLACK_NAME + ": 이전과 전혀 다른 플레이를 할 거니까 말이야...")
            else
                call MsgPrint(BLACK_NAME + ": 당연히 우리도 인원 수를 맞춰야 하지 않겠어?")
            endif
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call tk.start(0.2, false, function CMTTick)
        elseif tk.data == 32 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 100 )
            call tk.start(0.2, false, function CMTTick)
        elseif tk.data == 33 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call tk.start(0.1, false, function CMTTick)
        elseif tk.data == 34 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 100 )
            call tk.start(0.1, false, function CMTTick)
        elseif tk.data == 35 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call tk.start(0.15, false, function CMTTick)
        elseif tk.data == 36 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 100 )
            call tk.start(0.05, false, function CMTTick)
        elseif tk.data == 37 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
            call tk.start(0.1, false, function CMTTick)
        elseif tk.data == 38 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 100 )
            loop
            exitwhen i > PersonPlayer()-2
                if i == 1 then
                    call CreateUnit(Player(11), 'hgry', 14336, 7168, 270 )
                elseif i == 2 then
                    call CreateUnit(Player(11), 'hmpr', 15360, 7168, 270 )
                elseif i == 3 then
                    call SetUnitFlyHeight(CreateUnit(Player(11), 'hgry', 14592, 6336, 270 ), 10, 0)
                elseif i == 4 then
                    call SetUnitFlyHeight(CreateUnit(Player(11), 'hmpr', 15104, 6336, 270 ), 10, 0)
                elseif i == 5 then
                    call CreateUnit(Player(11), 'hgry', 14848, 7424, 270 )
                endif
            set i = i + 1
            endloop
            call tk.start(3.0, false, function CMTTick)
        elseif tk.data == 39 then
            call CinematicFilterGenericBJ( 2.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 100, 0, 0, 0, 0 )
            call MsgPrint(BLACK_NAME + ": B.O.Y♂?")
        elseif tk.data == 40 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            if Status.World == 4 then
                call StartSound(gg_snd_Insertion001)
            else
                call StartSound(gg_snd_OM_Chezic)
            endif
            call MsgPrint(NAME + ": 으악 잠깐만!!!!")
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 41 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            if Status.World == 4 then
                call StartSound(gg_snd_Insertion001)
            else
                call StopSound(gg_snd_OM_Chezic, false, false)
                call StartSound(gg_snd_OM_Chezic)
            endif
            call MsgPrint(NAME + ": 뭐하는 거야!!!!")
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 42 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            if Status.World == 4 then
                call StartSound(gg_snd_Insertion001)
            else
                call StopSound(gg_snd_OM_Chezic, false, false)
                call StartSound(gg_snd_OM_Chezic)
            endif
            call MsgPrint(NAME + ": 안...돼")
            call StartSound(gg_snd_OM_GladosNo)
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 43 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            if Status.World == 4 then
                call StartSound(gg_snd_Insertion001)
            else
                call StopSound(gg_snd_OM_Chezic, false, false)
                call StartSound(gg_snd_OM_Chezic)
            endif
            call MsgPrint(NAME + ": 안 돼...")
            call tk.start(0.7, false, function CMTTick)
        elseif tk.data == 44 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100, 50.19, 50.19, 0, 0, 0, 0, 0 )
            if Status.World == 4 then
                call StartSound(gg_snd_Insertion001)
            else
                call StopSound(gg_snd_OM_Chezic, false, false)
                call StartSound(gg_snd_OM_Chezic)
            endif
            call MsgPrint(NAME + ": ...안 돼")
            call tk.start(0.5, false, function CMTTick)
        elseif tk.data >= 45 and tk.data <= 85 then
            call CinematicFilterGenericBJ( 0.20, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 80-((tk.data-45)*2), 40.00-(tk.data-45), 40.00-(tk.data-45), 0, 0, 0, 0, 0 )
            if Status.World == 4 then
                call StopSound(gg_snd_Insertion001, false, false)
                call StartSound(gg_snd_Insertion001)
                call SetSoundVolumeBJ( gg_snd_Insertion001, 100-((tk.data-45)*2) )
            else
                call StopSound(gg_snd_OM_Chezic, false, false)
                call StartSound(gg_snd_OM_Chezic)
                call SetSoundOffsetBJ( 0.05, gg_snd_OM_Chezic )
                call SetSoundVolumeBJ( gg_snd_OM_Chezic, 100-((tk.data-45)*2) )
            endif
            call MsgPrint(NAME + ": 안 돼!!!!!!!!!!!!!!!!!!!!!!!!!!")
            call SetSoundVolumeBJ( gg_snd_OM_GayBar, 100-((tk.data-45)*2) )
            call tk.start(0.15, false, function CMTTick)
        elseif tk.data == 86 then
            call StopSound(gg_snd_OM_GayBar, false, false)
            call tk.start(5.0, false, function CMTTick)
        elseif tk.data == 87 then
            call StartSound(gg_snd_OM_EndingSound)
            call EndingMsgPrint("제작: z1z1z1")
        elseif tk.data == 88 then
            call EndingMsgPrint("엔딩중 사용된 BGM: 동물의 숲 - TheRoost")
        elseif tk.data == 89 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Electric Six - Gay Bar")
        elseif tk.data == 90 then
            call EndingMsgPrint("스프라이트 출처: https://www.spriters-resource.com/")
        elseif tk.data == 91 then
            if Status.World == 4 then
                call EndingMsgPrint("PS: 피할 수 없으면 즐겨라 - 로버트 엘리엇")
            else
                call EndingMsgPrint("PS: 여러분의 눈 보호를 위해 몸체를 곰인형으로 만들었습니다!")
            endif
        elseif tk.data == 92 then
            call EndingMsgPrint("Thank You")
            call tk.start(6.0, false, function CMTTick)
        elseif tk.data == 93 then
            call ClearTextMessages()
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set name = StringCase(GetPlayerName(Player(i - 1)), false)

                    if RandomStage_isRandom == true then
                        if RandomStage_isHard then
                            call User_GameClearDataUpload.evaluate(i - 1, name, "HardRandom")
                        else
                            call User_GameClearDataUpload.evaluate(i - 1, name, "Random")
                        endif
                    elseif Status.World == 4 then
                        call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "　　　　　　" + TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님의 두 번째 비밀 코드: " + WorldKey_Code2[i] )
                        call User_GameClearDataUpload.evaluate(i - 1, name, "Subway")
                    elseif Status.World == 3 then
                        call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "　　　　　　" + TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님의 첫 번째 비밀 코드: " + WorldKey_Code[i] )
                        call User_GameClearDataUpload.evaluate(i - 1, name, "CaptainJack")
                    elseif Status.World == 9 then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "Cafe")
                    elseif Status.World == 13 then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "DownTown")
                    elseif Status.World == 15 then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "Refre")
                    endif
                endif
            set i = i + 1
            endloop
            call tk.start(6.0, false, function CMTTick)
        else
            call tk.destroy()
            
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call CustomVictoryBJ( Player(i-1), true, true )
                endif
            set i = i + 1
            endloop
            
            set i = 1
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and GetLocalPlayer() == Player(i-1) then
                    if Status.World == 4 then
                        call BJDebugMsg("　　　　　　" + TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님의 두 번째 비밀 코드: " + WorldKey_Code2[i] )
                    elseif Status.World == 3 then
                        call BJDebugMsg("　　　　　　" + TeamColor[i] + GetPlayerName(Player(i-1)) + "|r 님의 첫 번째 비밀 코드: " + WorldKey_Code[i] )
                    endif
                endif
            set i = i + 1
            endloop
            return
        endif
        set tk.data = tk.data + 1
    endfunction
    
    private function Main takes nothing returns nothing
        call DestroyTrigger( GetTriggeringTrigger() )
        call StopSound( BackgroundMusic, false, true )
        set tk = tick.create(0)
        call Cinematic_Start(1)
        call tk.start(3.0, false, function CMTTick)
    endfunction
    
    private function init takes nothing returns nothing
        set ENDING_RECT = gg_rct_EndingRect
        set Trigger = CreateTrigger()
        call TriggerAddAction( Trigger, function Main )
    endfunction
endlibrary

