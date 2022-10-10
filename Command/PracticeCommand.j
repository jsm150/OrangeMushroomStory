scope PracticeCommand initializer Init
    globals
        private trigger Trigger
    endglobals

    private function IsWorldClearBy takes integer i returns boolean
        return User_UserList[i].GetClearCountByWorldId(Status.World) >= 1
    endfunction

    private function Action takes nothing returns nothing
        local string s = StringCase(GetEventPlayerChatString(), false)
        local integer i = GetPlayerId(GetTriggerPlayer()) + 1
        local integer j
        local integer world
        local integer stage
        local integer keyType
        
        if i != HostNumber then
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 재시작 권한을 가진 플레이어만 사용 가능한 명령어 입니다.")
            return
        endif

        if SubString(s, 0, 2) == "-n" then
            set world = S2I(JNStringSplit(s, " ", 1))
            set stage = S2I(JNStringSplit(s, " ", 2))
            if world <= 0 or stage <= 0 or stage > 8 then
                return
            endif

            set Status.World = world
            set Status.Level = stage - 1 
            call Stage_Clear(1)
            
            //! runtextmacro for("set j = 0", "j < PLAYER_MAXINUM")
                if GetPlayerSlotState(Player(j)) == PLAYER_SLOT_STATE_PLAYING and ArrowKey_MJump[j + 1] and IsWorldClearBy(j) == false then
                    set ArrowKey_MJump[j + 1] = false
                    call DisplayTimedTextToPlayer(Player(j), 0, 0, 60, "|cffFFFC00※ 해당 월드를 클리어 하지 않아 무한점프가 해제되었습니다.|r")
                endif
            //! runtextmacro for_end("set j = j + 1")
        elseif SubString(s, 0, 2) == "-c" and JNStringContains(s, "-code") == false then
            call Status.SetContinues(S2I(SubString(s, 2, 6)))
        elseif s == "-q" then
            if PersonPlayer() != 1 then
                call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "|cffFFFC00※ 혼자 플레이 할때만 사용 가능합니다.|r")
                return
            endif
            
            if IsWorldClearBy(i - 1) == false then
                call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "|cffFFFC00※ 해당 월드를 먼저 클리어 해주십시오.|r")
                return
            endif

            set ArrowKey_MJump[i] = true
            call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "※ 무한점프 모드를 실행합니다!|r")
        elseif s == "-w" and ArrowKey_MJump[i] then
            set ArrowKey_MJump[i] = false
            call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "※ 무한점프 모드가 해제되었습니다.|r")
        elseif SubString(s, 0, 2) == "-k" then
            if PersonPlayer() != 1 then
                call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "|cffFFFC00※ 혼자 플레이 할때만 사용 가능합니다.|r")
                return
            endif

            if IsWorldClearBy(i - 1) == false then
                call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 60, "|cffFFFC00※ 해당 월드를 먼저 클리어 해주십시오.|r")
                return
            endif

            if S2I(JNStringSplit(s, " ", 1)) == 1 then
                set keyType = Key_RED_KEY_ID
            elseif S2I(JNStringSplit(s, " ", 1)) == 2 then
                set keyType = Key_YELLOW_KEY_ID
            elseif S2I(JNStringSplit(s, " ", 1)) == 3 then
                set keyType = Key_BLUE_KEY_ID
            elseif S2I(JNStringSplit(s, " ", 1)) == 4 then
                set keyType = Key_WHITE_KEY_ID
            else
                return
            endif
            call Key_keyMap.Execute(Status.World, Status.Level, keyType)
        endif
    endfunction

    private function AddQuest takes nothing returns nothing
        local string s = "● 방장 명령어\n"
        set s = s + "-c 숫자\n"
        set s = s + "컨티뉴를 숫자 만큼 설정합니다.\n"
        set s = s + "ex) -c 100\n"
        set s = s + "\n"
        set s = s + "-n 숫자(월드) 숫자(스테이지)\n"
        set s = s + "해당 월드의 스테이지로 이동합니다.\n"
        set s = s + "월드 숫자표는 F9의 월드 번호를 참고하여 주십시오.\n"
        set s = s + "ex) -n 10 2 = 사막 3-2\n"
        set s = s + "\n"
        set s = s + "-q\n"
        set s = s + "무한 점프 모드로 설정합니다.\n"
        set s = s + "혼자 플레이 할때만 가능합니다.\n"
        set s = s + "해당 월드를 클리어 해야 사용할 수 있습니다.\n"
        set s = s + "해당 월드를 클리어 하지 않았을 경우 자동으로 해제됩니다.\n"
        set s = s + "\n"
        set s = s + "-w\n"
        set s = s + "무한 점프 모드를 해제합니다.\n"
        set s = s + "\n"
        set s = s + "-k 숫자(열쇠)\n"
        set s = s + "번호에 맞는 열쇠를 작동 시킵니다.\n"
        set s = s + "혼자 플레이 할때만 가능합니다.\n"
        set s = s + "해당 월드를 클리어 해야 사용할 수 있습니다.\n"
        set s = s + "빨강 : 1, 노랑 : 2, 파랑 : 3, 횐색 : 4\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "|cffFF0202연습모드 명령어|r", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
        set s = "--- 월드 번호 ---:\n"
        set s = s + "  집 앞마당 : 1\n"
        set s = s + "  옥스포드 : 2\n"
        set s = s + "  핑크 핑크 : 3\n"
        set s = s + "  도시 : 4\n"
        set s = s + "  발렌타인 데이 : 5\n"
        set s = s + "  해변 : 6\n"
        set s = s + "  펩시 : 7\n"
        set s = s + "  월드 첼린지 : 8\n"
        set s = s + "  카페 : 9\n"
        set s = s + "  사막 : 10\n"
        set s = s + "  엘린 숲 : 11\n"
        set s = s + "  얼음 동굴 : 12\n"
        set s = s + "  깊은 산속 : 13\n"
        set s = s + "  월드 첼린지II : 14\n"
        call CreateQuestBJ( bj_QUESTTYPE_REQ_DISCOVERED, "|cffFF0202월드 번호|r", s, "ReplaceableTextures\\CommandButtons\\BTNs_OrangeMushroomIcon.blp" )
    endfunction

    private function Main takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer i

        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            call TriggerRegisterPlayerChatEvent( t, Player(i), "-", false )
        //! runtextmacro for_end("set i = i + 1")
        call TriggerAddAction( t, function Action )

        call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
        call AddQuest()
        set PracticeMode = true

        call BJDebugMsg("|cffFF0202※ 연습모드를 실행합니다.|r")
        call BJDebugMsg("|cffFF0202※ 자세한건 F9를 확인해 주십시오.|r")

        call DestroyTrigger(GetTriggeringTrigger())
        set t = null
    endfunction

    public function Execute takes integer i returns nothing
        if Status.World != 1 or Status.Level != 1 then
            call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 10, "※ 1-1에서만 사용할 수 있습니다.")
            return
        endif

        if i != HostNumber then
            call DisplayTimedTextToPlayer(Player(i - 1), 0, 0, 5, "※ 재시작 권한을 가진 플레이어만 사용 가능한 명령어 입니다.")
            return
        endif

        call TriggerExecute(Trigger)
    endfunction

    private function Init takes nothing returns nothing
        set Trigger = CreateTrigger()
        call TriggerAddAction(Trigger, function Main)
    endfunction
endscope