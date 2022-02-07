library GameTime initializer init
    globals
        public integer Hour = 0
        public integer Minute = 0
        public integer Second = 0
    endglobals
    
    public function Check takes nothing returns nothing
        local integer j = GetPlayerId(GetTriggerPlayer()) + 1
        
        call DisplayTimedTextToPlayer(Player(j - 1), 0, 0, 5, "※ 플레이 타임 : " + I2S(Hour) +"시간 " + I2S(Minute) + "분 " + I2S(Second) + "초") 
    endfunction
    
    private function Main takes nothing returns nothing
        set Second = Second + 1
        if Second >= 60 then
            set Second = 0
            set Minute = Minute + 1
            if Minute >= 60 then
                set Minute = 0
                set Hour = Hour + 1
            endif
        endif
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        
        call TriggerRegisterTimerEvent(t, 1.00, true)
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endlibrary


