library EndingSkip initializer Init
    globals
        private trigger T
        private integer Count = 0
        private tick Tk
        private integer SkipPoint
        private integer SetUp = 5
    endglobals

    
    public function Ready takes tick tk, integer skipPoint returns nothing
        call BJDebugMsg("　　　　　　엔딩을 스킵하려면 호스트 플레이어가 ESC를 5번 눌러주세요!" )
        call EnableTrigger(T)
        set Tk = tk
        set SkipPoint = skipPoint
    endfunction

    public function Disable takes nothing returns nothing
        call DestroyTrigger(T)
    endfunction

    private function Main takes nothing returns nothing
        if GetPlayerId(GetTriggerPlayer())+1 != HostNumber then
            return
        endif

        set Count = Count + 1
        if Count == SetUp then
            call BJDebugMsg("　　　　　　|cffFF0202※ 엔딩을 스킵합니다!|r" )
            set Tk.data = SkipPoint
            call DestroyTrigger(T)
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