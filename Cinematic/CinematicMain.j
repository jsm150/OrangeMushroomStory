library Cinematic // initializer init
    globals
        boolean CinematicMode = false
        integer CinematicCount = 0
    endglobals
    
    public function Start takes integer count returns nothing
        set CinematicMode = true
        set CinematicCount = count
    endfunction
    
    public function End takes nothing returns nothing
        set CinematicMode = false
        set CinematicCount = 0
    endfunction
    /*
    private function Main takes nothing returns nothing
        set CinematicMode = true
    endfunction
    
    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Main )
    endfunction*/
endlibrary