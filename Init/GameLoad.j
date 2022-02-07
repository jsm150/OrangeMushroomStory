scope GameLoad initializer init
    private function Main takes nothing returns nothing
        call PauseGame(true)
        call PauseGame(false)
        call PauseGame(true)
        call PauseGame(false)
        call PauseGame(true)
        call PauseGame(false)
        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 게임 불러오기로 플레이시 오류가 일어날 가능성이 있습니다." )
        call SetSoundPitch(gg_snd_FREE_BGM_OMG_Hello_01, 1.2)
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call TriggerRegisterGameEvent(t, EVENT_GAME_LOADED)
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endscope