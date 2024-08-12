library EndingSkip initializer Init
    globals
        private trigger T
        private integer Count = 0
        private tick Tk
        private integer SkipPoint
        private integer SetUp = 5
        private string Msg
    endglobals

    
    public function Ready takes tick tk, integer skipPoint, string msg returns nothing
        call EnableTrigger(T)
        set Count = 0
        set Tk = tk
        set SkipPoint = skipPoint
        set Msg = msg
    endfunction

    public function Disable takes nothing returns nothing
        call ClearTextMessages()
        call DisableTrigger(T)
    endfunction

    private function Main takes nothing returns nothing
        if GetPlayerId(GetTriggerPlayer())+1 != HostNumber then
            return
        endif

        set Count = Count + 1
        if Count == SetUp then
            call BJDebugMsg("　　　　　　|cffFF0202※ " + Msg + "|r" )
            set Tk.data = SkipPoint
            call DisableTrigger(T)
        endif
    endfunction

    private function Init takes nothing returns nothing
        local integer i = 1
        set T = CreateTrigger()

        loop
            exitwhen i > PLAYER_MAXINUM
            call TriggerRegisterPlayerEvent(T, Player(i-1), EVENT_PLAYER_END_CINEMATIC)
            set i = i + 1
        endloop

        call TriggerAddAction( T, function Main )
        call DisableTrigger(T)
    endfunction
endlibrary