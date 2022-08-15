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
endlibrary