function Trig_FinalMsg_Actions takes nothing returns nothing
    local integer i = GetPlayerId(GetTriggerPlayer())+1
    
    if FinalMsg == true then
        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[i] + GetPlayerName(Player(i-1)) + ": |r" + GetEventPlayerChatString() )
    endif
endfunction

function InitTrig_FinalMsg takes nothing returns nothing
    local trigger t = CreateTrigger()
    local integer i = 1
        
    loop
    exitwhen i > PLAYER_MAXINUM
        call TriggerRegisterPlayerChatEvent( t, Player(i-1), "", false )
    set i = i + 1
    endloop
    call TriggerAddAction( t, function Trig_FinalMsg_Actions )
    
    set t = null
endfunction

