scope ConnectCheck initializer Init
    private function Main takes nothing returns nothing
        local integer i = 1
        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            if GetLocalPlayer() == Player(i - 1) then
                if JNObjectCharacterServerConnectCheck() == false then
                    call BJDebugMsg("|cffFFFC00※ 서버와의 연결에 실패하였습니다.|r")
                    call BJDebugMsg("|cffFFFC00※ 현재 버전이 최신버전인지 확인해 주십시오.|r")
                    call BJDebugMsg("|cffFFFC00※ https://m16tool.xyz/Game/OM150|r")
                endif
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction    

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()

        call TriggerRegisterTimerEvent(t, 30, true)
        call TriggerAddAction( t, function Main )
        set t = null
    endfunction
endscope