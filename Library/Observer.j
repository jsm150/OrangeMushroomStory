library Observer needs Stage
    globals
        boolean array LevelClearState
        public boolean array State
        public integer array ViewNumber
    endglobals
    
    public function Change takes integer i, boolean left returns nothing
        local integer j = ViewNumber[i]
        local integer k = 0
        
        if left == true then
            loop
                if j <= 1 then
                    set j = PLAYER_MAXINUM
                else
                    set j = j - 1
                endif
                set k = k + 1
                if k > PLAYER_MAXINUM then
                    return
                endif
            exitwhen GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[j] == false and i != j
            endloop
        else
            loop
                if j >= PLAYER_MAXINUM then
                    set j = 1
                else
                    set j = j + 1
                endif
                set k = k + 1
                if k > PLAYER_MAXINUM then
                    return
                endif
            exitwhen GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING and LevelClearState[j] == false and i != j
            endloop
        endif
        if Player(i-1) == GetLocalPlayer() then
            call SetUnitVertexColorBJ( BackGroundUnits[ViewNumber[i]], 0.00, 0.00, 0.00, 100 )
        endif
        set ViewNumber[i] = j
        if Player(i-1) == GetLocalPlayer() then
            call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
            call SetUnitVertexColorBJ( BackGroundUnits[j], 100.00, 100.00, 100.00, 0 )
        endif
        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 1, TeamColor[j] + GetPlayerName(Player(j-1)) + "|r님을 관전합니다.")
    endfunction
    
    public function End takes integer i returns nothing
        if Player(i-1) == GetLocalPlayer() then
            call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
            call SetUnitVertexColorBJ( BackGroundUnits[ViewNumber[i]], 0.00, 0.00, 0.00, 100 )
        endif
        set State[i] = false
        set ViewNumber[i] = 0
        call ShowUnitShow(OrangeMushroom[i])
        call SetTextTagVisibility(NameTextTag[i], true)
    endfunction
    
    public function Start takes integer i returns nothing 
        local real x
        local real y
        set LevelClearState[i] = true
        set State[i] = true
        set SteppedPlayer[i] = 0
        call Status.SetEscapers(Status.Portal+1)
        if GravityChanger_State == true then
            set x = GetUnitX(OrangeMushroom[i])
            set y = GetUnitY(OrangeMushroom[i])
            call RemoveUnit(OrangeMushroom[i])
            set OrangeMushroom[i] = CreateUnit(Player(i-1), OrangeMushroomType[i], x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[i], 0.00)
        endif
        call ShowUnit(OrangeMushroom[i], false)
        call ShowUnit(OrangeMushroomSkin[i], false)
        call ShowUnit(OrangeMushroomFloorSkin[i], false)
        call SetTextTagVisibility(NameTextTag[i], false)
        if FinalStage == true then
            if FinalStage == true and Ending3 == true then
                if Status.Portal >= PersonPlayer() then
                    call Status.SetContinues(0)
                    call TriggerExecute( Stage_Restart )
                endif
            else
                if Status.Portal >= PersonPlayer()-1 then
                    if Status.World == 6 then
                        call TriggerExecute( TrueEnding_Trigger )
                    elseif Status.World == 7 then
                        call TriggerExecute( TrueEnding2_Trigger )
                    elseif TrueEnding3_CaveEnding then
                        call TriggerExecute( TrueEnding4ENDPart2_Trigger )
                    endif
                else
                    call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 좌우 방향키로 다른 플레이어를 관전할 수 있습니다.")
                endif
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 좌우 방향키로 다른 플레이어를 관전할 수 있습니다.")
            endif
        else
            if Status.Portal >= PersonPlayer() then
                if PracticeMode then
                    call BJDebugMsg("|cffFFFC00※ 연습모드는 클리어를 할 수 없습니다!|r")
                else
                    call Stage_Clear(1)
                endif
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 10, "※ 좌우 방향키로 다른 플레이어를 관전할 수 있습니다.")
            endif
        endif
    endfunction
endlibrary