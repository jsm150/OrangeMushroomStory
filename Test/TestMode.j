library TestMode initializer Init
    function Trig_testmode_Actions takes nothing returns nothing
        local integer i = 1
        if GetPlayerName(Player(0)) == "2p4p" then
            call DestroyTrigger( GetTriggeringTrigger() )
        elseif GetPlayerName(Player(0)) == "junghun" then
            call DestroyTrigger( GetTriggeringTrigger() )
        elseif GetPlayerName(Player(0)) == "orangemush" then
        else
            loop
            exitwhen i > PLAYER_MAXINUM
                call CustomDefeatBJ( Player(i-1), "테스트맵은 플레이할 수 없습니다." )
            set i = i + 1
            endloop
        endif
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterTimerEventSingle( t, 4 )
        call TriggerAddAction( t, function Trig_testmode_Actions )
    endfunction
endlibrary



