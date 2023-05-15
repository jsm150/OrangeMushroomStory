library TrueEnding3END initializer init needs Cinematic
    globals
        boolean GameAllOver = false
        boolean BossKill = false
        boolean array EndingFiltering
        boolean EndingFilteringStart = false
        
        public boolean EllinEnding = false
        public trigger Trigger
        private tick tk
        private unit SnowMan = null
        private constant string NAME = "|cffff7f27주황버섯|r"
        private constant string SNOW_NAME = "|cff006bf5눈사람|r"
        private constant string SNOW_PINK_NAME = "|cffE45AAF눈사람|r"
        private constant string BLACK_NAME = "|cff282828블랙|r"
        private rect ENDING_RECT
        private unit EndingBackground
    endglobals

    private function MsgPrint takes string s returns nothing
        call ClearTextMessages()
        call BJDebugMsg("　　　　　　" + s )
    endfunction

    private function MsgPrint2 takes string s returns nothing
        call ClearTextMessages()
        call BJDebugMsg("　　　　　　※ ESC키를 누르면 화면을 가릴 수 있습니다." )
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
            call MsgPrint(NAME + ": 좋아! 모두 이쪽으로와!")
        elseif tk.data >= 6 and tk.data <= 25 then
            call tk.start(0.02, false, function CMTTick)
            call SetUnitX(SnowMan, GetUnitX(SnowMan)-10)
        elseif tk.data == 26 then
            call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 100, 100, 100, 100 )
            call StopSound( gg_snd_KirbysEpicYarn, false, false )
            call SetDoodadAnimationRect(gg_rct_MagicStone, 'LOcb', "Death", false)
            call StopSound(gg_snd_Morph001, false, false)
            call StartSound( gg_snd_Morph001 )
            call RemoveUnit(SnowMan)
            set SnowMan = CreateUnit(Player(11), 'nsnp', 3648, -29248, 270 )
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 27 then
            call MsgPrint(NAME + ": ......어?")
        elseif tk.data == 28 then
            call MsgPrint(SNOW_NAME + ": ......")
        elseif tk.data == 29 then
            call StartSound(gg_snd_SexyBGM001)
            call MsgPrint(SNOW_PINK_NAME + ": 이런♥ 들켰네요.")
        elseif tk.data == 30 then
            call MsgPrint(NAME + ": 으아아아아아아아악 이런 개 X발!!!")
            call tk.start(0.6, false, function CMTTick)
        elseif tk.data == 31 then
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0.00, 0.00, 0.00, 0.00, 0, 0, 0, 0 )
            call StartSound(gg_snd_GunSoundEffect001)
            call tk.start(2.5, false, function CMTTick)
        elseif tk.data == 32 then
            call ClearTextMessages()
            set EndingFilteringStart = true
            call MsgPrint("※ ESC키를 누르면 화면을 가릴 수 있습니다.")
            call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "war3mapImported\\DL.blp", 100.00, 100.00, 100.00, 0.00, 100, 100, 100, 0 )
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 33 then
            call MsgPrint2(SNOW_PINK_NAME + ": 자기야 속여서 미안해.")
        elseif tk.data == 34 then
            call SetCineFilterStartUV(0, 0, 1, 1)
            call SetCineFilterEndUV(0.05, 0.05, 0.95, 0.95)
            call SetCineFilterDuration(0.5)
            call ViewFilter()
            call MsgPrint2(SNOW_PINK_NAME + ": 그치만... 이러지 않으면 내게 관심도 없는 걸♥")
        elseif tk.data == 35 then
            call SetCineFilterStartUV(0.05, 0.05, 0.95, 0.95)
            call SetCineFilterEndUV(0.1, 0.1, 0.9, 0.9)
            call SetCineFilterDuration(0.5)
            call ViewFilter()
            call MsgPrint2(SNOW_PINK_NAME + ": 그래도 내 본 모습을 보기 전까진 좋았잖아?")
        elseif tk.data == 36 then
            call SetCineFilterStartUV(0.1, 0.1, 0.9, 0.9)
            call SetCineFilterEndUV(0.15, 0.2, 0.85, 0.9)
            call SetCineFilterDuration(0.5)
            call ViewFilter()
            call MsgPrint2(SNOW_PINK_NAME + ": 그래! 사람은 마음이 중요하다구!")
        elseif tk.data == 37 then
            call SetCineFilterStartUV(0.15, 0.2, 0.85, 0.9)
            call SetCineFilterEndUV(0.2, 0.3, 0.8, 0.9)
            call SetCineFilterDuration(0.5)
            call ViewFilter()
            call MsgPrint2(SNOW_PINK_NAME + ": ...주황버섯씨?")
        elseif tk.data == 38 then
            call SetCineFilterStartUV(0.2, 0.3, 0.8, 0.9)
            call SetCineFilterEndUV(0.3, 0.5, 0.7, 0.9)
            call SetCineFilterDuration(0.3)
            call ViewFilter()
            call MsgPrint2(SNOW_PINK_NAME + ": |cffff0000사랑해|r")
            call tk.start(1.0, false, function CMTTick)
        elseif tk.data == 39 then
            set EndingFilteringStart = false
            call SetCineFilterStartColor(255, 255, 255, 255)
            call SetCineFilterEndColor(0, 0, 0, 255)
            call SetCineFilterStartUV(0.3, 0.5, 0.7, 0.9)
            call SetCineFilterEndUV(0.5, 0.8, 0.5, 0.8)
            call SetCineFilterDuration(0.3)
            call ViewFilter()
            call StartSound(gg_snd_FucX)
            call StartSound(gg_snd_GunSoundEffect001)
        elseif tk.data == 40 then
            call EndingMsgPrint("제작: z1z1z1")
        elseif tk.data == 41 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Kirby's Epic Yarn - Rainbow Falls")
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 42 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Electric Six - Gay Bar")
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 43 then
            call EndingMsgPrint("엔딩중 사용된 BGM: Naruto - Sexiness")
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 44 then
            call EndingMsgPrint("스프라이트 출처: https://www.spriters-resource.com/")
            call tk.start(2.0, false, function CMTTick)
        elseif tk.data == 45 then
            call ClearTextMessages()
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    set name = StringCase(GetPlayerName(Player(i - 1)), false)

                    if SecretEnding == true then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "WorldChallenge")
                    elseif TrueEnding3_PyramidEnding == true then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "Desert")
                    elseif EllinEnding == true then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "Forest")
                    elseif SecretEnding2 == true then
                        call User_GameClearDataUpload.evaluate(i - 1, name, "WorldChallenge2")
                    else
                        call User_GameClearDataUpload.evaluate(i - 1, name, "Coke")
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
            
            return
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
    
    private function init takes nothing returns nothing
        set ENDING_RECT = gg_rct_TrueEndingRect4
        set Trigger = CreateTrigger()
        call TriggerAddAction( Trigger, function Main )
    endfunction
endlibrary