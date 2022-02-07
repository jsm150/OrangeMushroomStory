scope PlayerLeave initializer init
    public function Main takes integer i returns nothing
        local integer j = 1
        
        set SteppedPlayer[i] = 0
        call RemoveUnit(OrangeMushroom[i])
        call RemoveUnit(BackGroundUnits[i])
        call DestroyTextTag(NameTextTag[i])
        set Status.Leave = true
        if LevelClearState[i] == true then
            set Status.Portal = Status.Portal - 1
        endif
        call Status.SetEscapers(Status.Portal)
        if FinalStage == true then
            if Status.Portal >= PersonPlayer()-2 then
                if Status.World == 6 then
                    call TriggerExecute( TrueEnding_Trigger )
                elseif Status.World == 7 then
                    call TriggerExecute( TrueEnding2_Trigger )
                elseif TrueEnding3_CaveEnding then
                    call TriggerExecute( TrueEnding4ENDPart2_Trigger )
                endif
            endif
        else
            if Status.Portal >= PersonPlayer()-1 then
                if PracticeMode then
                    call BJDebugMsg("|cffFFFC00※ 연습모드는 클리어를 할 수 없습니다!|r")
                else
                    call Stage_Clear(1)
                endif
            endif
        endif
        set OrangeMushroom[i] = null
        set BackGroundUnits[i] = null
        set NameTextTag[i] = null
        
        loop
        exitwhen j > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING and Observer_ViewNumber[j] == i and Status.Portal < PersonPlayer()-1 then
                call DisplayTimedTextToPlayer(Player(j-1), 0, 0, 5, "※ 관전 중인 플레이어가 나갔으므로 다른 플레이어를 관전합니다.")
                call Observer_Change(j, false)
            endif
        set j = j + 1
        endloop
        if HostNumber == i then
            set j = 1
            loop
            exitwhen j > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING and HostNumber != j then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 재시작 권한을 가진 플레이어가 나가서 " + TeamColor[j] + GetPlayerName(Player(j-1)) + "|r 님이 재시작 권한을 가지게 됩니다. (ESC로 사용)" )
                    set HostNumber = j
                    return
                endif
            set j = j + 1
            endloop
        endif
    endfunction
    
    private function Leave takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1

        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[i] + GetPlayerName(Player(i-1)) + "|r" + "님이 게임을 떠났습니다." )
        call Main(i)
    endfunction

    private function GenerateFatal takes nothing returns nothing
        // 없는 파일을 띄워서 페이탈을 발생.
        debug if false then
            call CinematicFadeBJ( bj_CINEFADETYPE_FADEOUTIN, 2, "dvwe48asd1vaw7ea.blp", 0, 0, 0, 0 )
        debug endif
    endfunction

    private function AddLeaveAction takes nothing returns nothing
        call DzFrameSetScriptByCode(DzFrameFindByName("QuitButton", 0), JN_FRAMEEVENT_CONTROL_CLICK, function GenerateFatal, false)
        call DzFrameSetScriptByCode(DzFrameFindByName("GameResultQuitButton", 0), JN_FRAMEEVENT_CONTROL_CLICK, function GenerateFatal, false)
        call DzFrameSetScriptByCode(DzFrameFindByName("UnresponsiveDisconnectButton", 0), JN_FRAMEEVENT_CONTROL_CLICK, function GenerateFatal, false)
    endfunction

    private function init takes nothing returns nothing
        local integer i = 1
        local trigger t = CreateTrigger()
        
        loop
        exitwhen i > PLAYER_MAXINUM
            call TriggerRegisterPlayerEvent(t, Player(i-1), EVENT_PLAYER_LEAVE)
        set i = i + 1
        endloop
        call TriggerAddAction( t, function Leave )

        set t = CreateTrigger()
        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function AddLeaveAction )
        
        set t = null
    endfunction
endscope

