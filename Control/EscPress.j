scope ESCKey initializer init
    private function Main takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer())+1

        if ItemStore_IsActivated(i - 1) or Inventory_IsActivated(i - 1) then
            call ItemStore_WindowOff(i - 1)
            call Inventory_WindowOff(i - 1)
            return
        endif

        if BossKill == false then
            if i == HostNumber then
                if Stage_Loading == false and GravityChanger_Loading == false then
                    if FinalStage == false then
                        call TriggerExecute( Stage_Restart )
                    else
                        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 현재 스테이지에서는 재시작 할 수 없습니다.")
                    endif
                endif
            elseif Command_KickVoting == true and i != Command_KickPlayer then
                if Command_KickState[i] == false then
                    set Command_KickState[i] = true
                    call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 찬성 투표를 하였습니다. (다시 ESC를 누르면 취소할 수 있습니다.)")
                else
                    set Command_KickState[i] = false
                    call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 반대 투표를 하였습니다. (다시 ESC를 누르면 찬성할 수 있습니다.)")
                endif
            endif
        elseif EndingFilteringStart == true then
            set EndingFiltering[i] = not(EndingFiltering[i])
            if EndingFiltering[i] == false then
                if GetLocalPlayer() == Player(i-1) then
                    call SetCineFilterTexture("war3mapImported\\DL.blp")
                    call SetCineFilterDuration(0)
                    call DisplayCineFilter(true)
                endif
            else
                if GetLocalPlayer() == Player(i-1) then
                    call SetCineFilterTexture("ReplaceableTextures\\CameraMasks\\Black_mask.blp")
                    call SetCineFilterDuration(0)
                    call DisplayCineFilter(true)
                endif
            endif
        endif
    endfunction
    
    private function init takes nothing returns nothing
        local integer i = 1
        local trigger t = CreateTrigger()
        
        loop
        exitwhen i > PLAYER_MAXINUM
            call TriggerRegisterPlayerEvent(t, Player(i-1), EVENT_PLAYER_END_CINEMATIC)
        set i = i + 1
        endloop
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endscope