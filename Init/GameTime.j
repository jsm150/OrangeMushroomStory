library GameTime initializer init
    globals
        private integer Hour = 0
        private integer Minute = 0
    endglobals
    
    private function Main takes nothing returns nothing
        set Minute = Minute + 1
        if Minute >= 60 then
            set Minute = 0
            set Hour = Hour + 1
        endif

        call Status.SetPlayTime(Hour, Minute)
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        
        call TriggerRegisterTimerEvent(t, 60, true)
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endlibrary


