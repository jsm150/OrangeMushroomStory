scope Command initializer init
    globals
        private tick tk
        private boolean CountDownState = false
        
        public boolean KickVoting = false
        public boolean array KickState
        public integer KickPlayer = 0
        public integer KickCooldown = 0
        public timer KickTimer = CreateTimer()
        public timerdialog KickTimerDL

        private dialog KickDialog
        private button array KickButton
        
        private dialog SkipDialog
        private button array SkipButton
        
        boolean array HiddenCode
        
        integer SecretWorldCount = 0
        integer SecretWorldCount2 = 0
        integer SecretWorldCount3 = 0
        
        boolean array SoundState
    endglobals

    private function CountDown takes nothing returns nothing
        call ClearTextMessages()
        if Stage_Loading == true or tk.data == -1 then
            set CountDownState = false
            if GravityChanger_Loading == false then
                call SetSoundVolume(BackgroundMusic, 127)
            endif
            call tk.destroy()
            return
        elseif tk.data > 0 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "　　　　------------ 카운트다운: (" + I2S(tk.data) + ") ------------" )
        elseif tk.data == 0 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "　　　　------------ END ------------" )
        endif
        call StartSound( gg_snd_BattleNetTick )
        set tk.data = tk.data - 1
    endfunction

    public function CountMain takes integer i, string s, boolean Eng returns nothing
        local integer time
            
        if i == HostNumber then
            if Eng == false then
                set time = S2I(SubString(s, 11, 13))
            else
                set time = S2I(SubString(s, 7, 9))
            endif
            if time >= 2 and time <= 10 then
                if CountDownState == false then
                    set CountDownState = true
                    call SetSoundVolume(BackgroundMusic, 80)
                    set tk = tick.create(time)
                    call tk.start(1.0, true, function CountDown)
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 시간은 2~10 사이의 수치만 가능합니다.")
            endif
        else
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 재시작 권한을 가진 플레이어만 사용 가능한 명령어 입니다.")
        endif
    endfunction

    private function EllinCode takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        if RectContainsUnit(gg_rct_Ellinforest, OrangeMushroom[i]) == true and HiddenCode[7] == false and i == HostNumber then
            set HiddenCode[7] = true
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Ellinforest), GetRectCenterY(gg_rct_Ellinforest) ))
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 엘린 숲 입구가 열렸습니다!|r" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 엘린 숲 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
            call CreateUnit(Player(11), 'n009', 7908, 846 - 32, 270 )
            call SetDoodadAnimation(6144, -448, 128.00, 'YOf3', false, "stand", false)
            if SecretWorldCount3 == 0 then
                set SecretWorldCount3 = SecretWorldCount3 + 1
            endif
        endif
    endfunction

    private function CodeMain takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        
        if RectContainsUnit(gg_rct_Subway, OrangeMushroom[i]) == true and HiddenCode[0] == false then
            if i == HostNumber then
                set HiddenCode[0] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Subway), GetRectCenterY(gg_rct_Subway) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 지하철 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 지하철 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
                if SecretWorldCount == 1 then
                    set SecretWorldCount = SecretWorldCount + 1
                endif
                if SecretWorldCount2 == 3 then
                    call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 100, 100, 100, 100 )
                    set HiddenCode[9] = true
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[7] + "※ 비밀 신호를 주자 동화책이 나타났습니다.|r" )
                    call CreateUnit(Player(11), 'n006', 6144, -128 - 32, 270 )
                    call SetDoodadAnimation(6144, -448, 128.00, 'YOf3', false, "stand", false)
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        endif
    endfunction

    private function CodeMain2 takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        
        if RectContainsUnit(gg_rct_WitchTower, OrangeMushroom[i]) == true and HiddenCode[1] == false then
            if i == HostNumber then
                set HiddenCode[1] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_WitchTower), GetRectCenterY(gg_rct_WitchTower) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 쿠키 포탈이 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 과자성 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
                if SecretWorldCount == 0 then
                    set SecretWorldCount = SecretWorldCount + 1
                endif
                if SecretWorldCount2 == 2 then
                    set SecretWorldCount2 = SecretWorldCount2 + 1
                endif
                if SecretWorldCount3 == 2 then
                    set SecretWorldCount3 = SecretWorldCount3 + 1
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        elseif RectContainsUnit(gg_rct_Beach, OrangeMushroom[i]) == true and HiddenCode[2] == false then
            if i == HostNumber then
                set HiddenCode[2] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Beach), GetRectCenterY(gg_rct_Beach) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 소라껍질 입구가 열렸습니다!|r" )
                if SecretWorldCount2 == 0 then
                    set SecretWorldCount2 = SecretWorldCount2 + 1
                endif
                if SecretWorldCount == 3 then
                    call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 100, 100, 100, 100 )
                    set HiddenCode[4] = true
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[1] + "※ 비밀 신호를 주자 빨간 풍선이 나타났습니다.|r" )
                    call CreateUnit(Player(11), 'nane', 6144, -128, 270 )
                    call PingMinimapEx(6144, -128, 5, 255, 255, 255, false)
                    call SetDoodadAnimation(6144, -448, 128.00, 'YOf3', false, "stand", false)
                else
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 소라껍질 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        elseif RectContainsUnit(gg_rct_Coke, OrangeMushroom[i]) == true and HiddenCode[3] == false then
            if i == HostNumber then
                set HiddenCode[3] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Coke), GetRectCenterY(gg_rct_Coke) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 코-크 플레이 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 코-크 플레이 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
                if SecretWorldCount == 2 then
                    set SecretWorldCount = SecretWorldCount + 1
                endif
                if SecretWorldCount2 == 1 then
                    set SecretWorldCount2 = SecretWorldCount2 + 1
                endif
                if SecretWorldCount3 == 3 then
                    call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.00, 100.00, 100.00, 0.00, 100, 100, 100, 100 )
                    set HiddenCode[10] = true
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[2] + "※ 비밀 신호를 주자 파란 풍선이 나타났습니다.|r" )
                    call CreateUnit(Player(11), 'n00A', 6144, -128, 270 )
                    call PingMinimapEx(6144, -128, 5, 255, 255, 255, false)
                    call SetDoodadAnimation(6144, -448, 128.00, 'YOf3', false, "stand", false)
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        elseif RectContainsUnit(gg_rct_Cafe, OrangeMushroom[i]) == true and HiddenCode[5] == false then
            if i == HostNumber then
                set HiddenCode[5] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Cafe), GetRectCenterY(gg_rct_Cafe) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 카페 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 카페 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        elseif RectContainsUnit(gg_rct_DragonEgg, OrangeMushroom[i]) == true and HiddenCode[12] == false then
            if i == HostNumber then
                set HiddenCode[12] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_DragonEgg), GetRectCenterY(gg_rct_DragonEgg) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 리프레 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 리프레 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        elseif RectContainsUnit(gg_rct_Pyramid, OrangeMushroom[i]) == true and HiddenCode[6] == false then
            if i == HostNumber then
                set HiddenCode[6] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_Pyramid), GetRectCenterY(gg_rct_Pyramid) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 사막 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 사막 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
                if SecretWorldCount3 == 1 then
                    set SecretWorldCount3 = SecretWorldCount3 + 1
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        elseif RectContainsUnit(gg_rct_RandomPortal, OrangeMushroom[i]) == true and HiddenCode[11] == false then
            if i == HostNumber then
                set HiddenCode[11] = true
                call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(gg_rct_RandomPortal), GetRectCenterY(gg_rct_RandomPortal) ))
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 랜덤 스테이지 입구가 열렸습니다!|r" )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 단 랜덤 스테이지 입구로 들어간 인원이 다른 포탈에 들어간 인원보다 적으면 기존 스테이지로 이동합니다.|r" )
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장(재시작 권한을 가진 사람)만 코드를 입력할 수 있습니다.")
            endif
        endif
    endfunction
    
    private function CustomDefeat takes player whichPlayer, string message returns nothing
        if AllowVictoryDefeat( PLAYER_GAME_RESULT_DEFEAT ) then
            call RemovePlayer( whichPlayer, PLAYER_GAME_RESULT_DEFEAT )
    
            if (GetPlayerController(whichPlayer) == MAP_CONTROL_USER) then
                call CustomDefeatDialogBJ( whichPlayer, message )
            endif
        endif
    endfunction

    private function CodeDialogCD takes nothing returns nothing
        local timer t = GetExpiredTimer()
        
        set KickCooldown = KickCooldown - 1
        if KickCooldown == 0 then
            call DestroyTimer(t)
        endif
        
        set t = null
    endfunction

    private function KickTimerMain takes nothing returns nothing
        local integer i = 1
        local integer yes = 0
        local integer no = 0
        
        set KickCooldown = 60
        call TimerStart(CreateTimer(), 1.00, true, function CodeDialogCD)
        call DestroyTimerDialog(KickTimerDL)
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and KickPlayer != i then
                if KickState[i] == true then
                    set yes = yes + 1
                else
                    set no = no + 1
                endif
            endif
        set i = i + 1
        endloop
        call ClearTextMessages()
        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "[투표 결과]" )
        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[2] + "찬성|r: " + I2S(yes) )
        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[1] + "반대|r: " + I2S(no) )
        if yes > no then
            if GetPlayerSlotState(Player(KickPlayer-1)) == PLAYER_SLOT_STATE_PLAYING then
                call CustomDefeat( Player(KickPlayer-1), "강퇴당하였습니다." )
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[KickPlayer] + GetPlayerName(Player(KickPlayer-1)) + "|r" + "님이 강퇴되었습니다." )
                call PlayerLeave_Main(KickPlayer)
            else
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "하지만 대상 플레이어가 이미 나가서 무효 처리되었습니다." )
            endif
        elseif yes < no then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "찬성 인원이 적어 무효 처리되었습니다." )
        else
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "찬성 인원과 반대 인원이 같아 무효 처리되었습니다." )
        endif
        set KickVoting = false
        set KickPlayer = 0
    endfunction
    
    private function KickDialogSelect takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local integer j = 1
        
        loop
        exitwhen j > PLAYER_MAXINUM
            if GetClickedButton() == KickButton[j] then
                set KickVoting = true
                set KickPlayer = j
                
                call TimerStart(KickTimer, 20.00, false, function KickTimerMain)
                set KickTimerDL = CreateTimerDialogBJ( KickTimer, "투표 종료" )
                
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ " + TeamColor[KickPlayer] + GetPlayerName(Player(KickPlayer-1)) + "|r" + "님의 강퇴 투표가 시작되었습니다." )
                set j = PLAYER_MAXINUM+1
            endif
        set j = j + 1
        endloop
        call DialogClear(KickDialog)
        
        if KickVoting == true then
            set j = 1
            loop
            exitwhen j > PLAYER_MAXINUM
                set KickState[j] = false
                if i == j then
                    set KickState[j] = true
                endif
                if GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING and i != j and KickPlayer != j then
                    call DisplayTimedTextToPlayer(Player(j-1), 0, 0, 5, "|cffff0000※ 당신은 ESC키를 눌러 찬성 투표를 할 수 있습니다. (투표는 익명 처리)|r")
                endif
            set j = j + 1
            endloop
        endif
    endfunction

    private function SoundSetting takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        
        if SoundState[i] == false then
            if Player(i-1) == GetLocalPlayer() then
                call StopSound( BackgroundMusic, false, true )
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 사운드를 정지합니다.")
            set SoundState[i] = true
        else
            if Player(i-1) == GetLocalPlayer() then
                call StartSound( BackgroundMusic )
            endif
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 사운드를 재생합니다.")
            set SoundState[i] = false
        endif
    endfunction

    private function KickMain takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local integer j = 1
        
        if i == HostNumber then
            if KickCooldown == 0 then
            if KickVoting == false then
                if FinalMsg == false and FinalStage == false then
                    if GetUnitTypeId(OrangeMushroom[i]) != 'ogru' and GetUnitTypeId(OrangeMushroom[i]) != 'otau' then
                        set LeftArrow[i] = false
                        set RightArrow[i] = false
                    endif
                    call DialogSetMessage(KickDialog,"Kick list")
                    loop
                    exitwhen j > PLAYER_MAXINUM
                        if GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING and i != j then
                            set KickButton[j] = DialogAddButton(KickDialog, TeamColor[j] + GetPlayerName(Player(j-1)), 0)
                        endif
                    set j = j + 1
                    endloop
                    set KickButton[0] = DialogAddButton(KickDialog, "취소 / Cancel", 0)
                    call DialogDisplay(Player(i-1), KickDialog, true)
                else
                    call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 지금은 사용할 수 없습니다.")
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 투표중에는 사용하실 수 없습니다.")
            endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ " + I2S(KickCooldown) + "초 후에 다시 사용하실 수 있습니다.")
            endif
        else
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 재시작 권한을 가진 플레이어만 사용 가능한 명령어 입니다.")
        endif
    endfunction
    
    public function OBSMain takes integer i returns nothing
        if Observer_State[i] == false then
            set Observer_State[i] = not(Observer_State[i])
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 좌우 방향키로 다른 플레이어를 관전할 수 있습니다. (다시 입력하면 종료)")
        elseif LevelClearState[i] == false then
            set Observer_State[i] = not(Observer_State[i])
            if Player(i-1) == GetLocalPlayer() then
                call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                call SetUnitVertexColorBJ( BackGroundUnits[Observer_ViewNumber[i]], 0.00, 0.00, 0.00, 100 )
            endif
            set Observer_ViewNumber[i] = 0
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 관전이 해제되었습니다.")
        else
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 이미 탈출한 상태에서는 관전을 해제할 수 없습니다.")
        endif
    endfunction

    private function SkipMain takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1
        local string s = StringCase(GetEventPlayerChatString(), false)
        
        if i == HostNumber then
            if Status.World == 1 and Status.Level == 1 and Stage_Loading == false then
                if s == "-스킵 " + StringCase(WorldKey_Code[i], false) or s == "-skip " + StringCase(WorldKey_Code[i], false) then
                    call DialogSetMessage(SkipDialog, "스킵 위치를 선택해주세요!")
                    call DialogDisplay(Player(i - 1), SkipDialog, true)
                else
                    call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 코드가 틀렸습니다. 첫번째 비밀코드를 입력해야 합니다.")
                    call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ (예: -스킵 ??? / -skip ???)")
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 1-1에서만 사용할 수 있습니다.")
            endif
        else
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장 권한을 가진 플레이어만 사용 가능한 명령어 입니다.")
        endif
    endfunction

    private function SkipDialogSelect takes nothing returns nothing
        local button selectButton = GetClickedButton()

        if selectButton == SkipButton[0] then
            set selectButton = null
            return
        elseif selectButton == SkipButton[2] then
            call Stage_Clear(7)
            call DisplayTimedTextToForce( GetPlayersAll(), 7.00, "※ 방장이 레벨을 스킵하였습니다." )
        elseif selectButton == SkipButton[1] then
            set Stage_WorldSkip = true
            call Stage_Clear(8)
        endif
        
        call DestroyTrigger(GetTriggeringTrigger())
        call DialogDestroy(SkipDialog)
        set selectButton = null
    endfunction

    private function Main takes nothing returns nothing
        local string s = StringCase(GetEventPlayerChatString(), false)
        local integer i = GetPlayerId(GetTriggerPlayer()) + 1
        
        if SubString(s, 0, 6) == "-count" then
            call CountMain(i, s, true)
        elseif SubString(s, 0, 10) == "-카운트" then
            call CountMain(i, s, false)
        elseif SubString(s, 0, 13) == "-진동끄기" then
            call StoneStatue_cameraControler.ShakeOff(GetPlayerId(GetTriggerPlayer()))
        elseif SubString(s, 0, 13) == "-진동켜기" then
            call StoneStatue_cameraControler.ShakeOn(GetPlayerId(GetTriggerPlayer()))
        elseif SubString(s, 0, 7) == "-음악" or SubString(s, 0, 6) == "-music" then
            call SoundSetting()
        elseif SubString(s, 0, 7) == "-강퇴" or SubString(s, 0, 5) == "-kick" then
            call KickMain()
        elseif s == "-관전" or s == "-obs" or s == "-observe" then
            call OBSMain(i)
        elseif SubString(s, 0, 7) == "-스킵" or SubString(s, 0, 5) == "-skip" then
            call SkipMain()
        elseif SubString(s, 0, 4) == "-" + StringCase(WorldKey_Code[GetPlayerId(GetTriggerPlayer())+1], false) and StringLength(s) == 4 then
            call CodeMain()
        elseif SubString(s, 0, 4) == "-" + StringCase(WorldKey_Code2[GetPlayerId(GetTriggerPlayer())+1], false) and StringLength(s) == 4 then
            call CodeMain2()
        elseif SubString(s, 0, 12) == "-ellinforest" and StringLength(s) == 12 then
            call EllinCode()
        elseif s == "-코드확인" then
            call User_PrintCode.execute(i - 1)
        elseif s == "-재선택" then
            call RandomStage_ReSelect()
        elseif s == "-연습모드" then
            call PracticeCommand_Execute.execute(i)
        elseif s == "-재연결" or s == "-rec" then
            call User_Reconnecting.evaluate(i - 1)
        elseif s == "-상점" or s == "-shop" then
            call ItemStore_ItemStoreUIList[i - 1].Show()
        elseif SubString(s, 0, 2) == "-p" and (GetPlayerName(GetTriggerPlayer()) == "2p4p" or StringCase(GetPlayerName(GetTriggerPlayer()), false) == "junghun" or StringCase(GetPlayerName(GetTriggerPlayer()), false) == "orangemush") then
            call RandomStage_PrintRandomStage(GetTriggerPlayer())
        endif
    endfunction

    private function SkipDialogInit takes nothing returns nothing
        local trigger t = CreateTrigger()

        set SkipDialog = DialogCreate()
        set SkipButton[1] = DialogAddButton(SkipDialog, "World 2: 옥스포드 / Level 8", 0)
        set SkipButton[2] = DialogAddButton(SkipDialog, "World 1: 집 앞마당 / Level 8", 0)
        set SkipButton[0] = DialogAddButton(SkipDialog, "취소 / Cancel", 0)

        call TriggerRegisterDialogEvent(t, SkipDialog)
        call TriggerAddAction(t, function SkipDialogSelect)
        
        set t = null
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM
            call TriggerRegisterPlayerChatEvent( t, Player(i-1), "-", false )
        set i = i + 1
        endloop
        call TriggerAddAction( t, function Main )
        
        set t = CreateTrigger()
        set KickDialog = DialogCreate()
        call TriggerRegisterDialogEvent( t, KickDialog )
        call TriggerAddAction( t, function KickDialogSelect )

        call SkipDialogInit()
        
        set t = null
    endfunction
endscope