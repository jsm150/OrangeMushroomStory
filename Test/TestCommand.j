library Test initializer Init
    private function Trig_TestCommand_Actions takes nothing returns nothing    
        local integer ii = 1
        local integer i = 1
        local integer j = 1
        local real x
        local real y
        local string s = GetEventPlayerChatString()
        local integer keyType

        if s == "-init" then
            call BJDebugMsg(I2S(JNObjectCharacterInit(mapId, GetPlayerName(Player(0)), secretKey, clearListName)))
        elseif s == "-get" then
            call BJDebugMsg(I2S(JNObjectCharacterGetInt(GetPlayerName(Player(0)), "Test")))
            call BJDebugMsg(I2S(JNObjectCharacterGetInt(GetPlayerName(Player(0)), "ABC")))
            call BJDebugMsg(JNObjectCharacterGetString(GetPlayerName(Player(0)), "ABC"))
            if JNObjectCharacterGetBoolean(GetPlayerName(Player(0)), "ABC") then
                call BJDebugMsg("True")
            else
                call BJDebugMsg("False")    
            endif
        elseif s == "-save" then
            call BJDebugMsg(JNObjectCharacterSave(mapId, GetPlayerName(Player(0)), secretKey, clearListName))
        elseif SubString(s, 0, 2) == "-k" then
            if S2I(SubString(s, 2, 3)) == 1 then
                set keyType = Key_RED_KEY_ID
            elseif S2I(SubString(s, 2, 3)) == 2 then
                set keyType = Key_YELLOW_KEY_ID
            elseif S2I(SubString(s, 2, 3)) == 3 then
                set keyType = Key_BLUE_KEY_ID
            elseif S2I(SubString(s, 2, 3)) == 4 then
                set keyType = Key_WHITE_KEY_ID
            else
                return
            endif
            call Key_keyMap.Execute(Status.World, Status.Level, keyType)

        elseif SubString(s, 0, 2) == "-l" then
            call Status.SetLevel(Status.World, Status.Level+(S2I(SubString(s, 2, 5))))
        elseif SubString(s, 0, 2) == "-q" then
            if JNStringLength(s) == 2 then
                set ii=1
                loop
                exitwhen ii == 8
                    set ArrowKey_MJump[ii] = true
                    set ii=ii+1
                endloop
            else
                set ArrowKey_MJump[S2I(SubString(s, 2, 3))] = true
            endif
        elseif SubString(s, 0, 2) == "-w" then
            if JNStringLength(s) == 2 then
                set ii=1
                loop
                exitwhen ii == 8
                    set ArrowKey_MJump[ii] = false
                    set ii=ii+1
                endloop
            else
                set ArrowKey_MJump[S2I(SubString(s, 2, 3))] = false
            endif
        elseif SubString(s, 0, 2) == "-t" then
            if JNStringLength(s) == 2 then
                loop
                    exitwhen i > PLAYER_MAXINUM
                    set MouseTeleport_State[i] = not(MouseTeleport_State[i])
                    set i = i + 1
                endloop
            else
                set MouseTeleport_State[S2I(SubString(s, 2, 3))] = not(MouseTeleport_State[S2I(SubString(s, 2, 3))])
            endif
        elseif SubString(s, 0, 2) == "-o" then
            set MouseTeleport_Number = S2I(SubString(s, 2, 3))
        elseif SubString(s, 0, 2) == "-n" then
            call Stage_Clear(S2I(SubString(s, 2, 5)))
        elseif SubString(s, 0, 2) == "-c" and JNStringContains(s, "-code") == false then
            call Status.SetContinues(S2I(SubString(s, 2, 5)))
        elseif SubString(s, 0, 2) == "-a" then
            call SetUnitAnimationByIndex( OrangeMushroom[i], S2I(SubString(s, 2, 3)) )
        elseif SubString(s, 0, 2) == "-g" then
            call User_UserList[0].Deposit(0, S2I(SubString(s, 2, 6)))
        endif
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterPlayerChatEvent( t, Player(0), "-", false )
        call TriggerAddAction( t, function Trig_TestCommand_Actions )
        set t = null
    endfunction

endlibrary
