library HiddenEvent initializer init
    globals
        public region array Rects
        
        private rect array CompareRect
        private integer CountInt = 0
    endglobals
    
    private function Main takes nothing returns nothing
        local integer i = 1
        local integer j = 1
        local integer p = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        loop
        exitwhen CompareRect[i] == null
            if GetTriggeringRegion() == Rects[i] and GetTriggerUnit() == OrangeMushroom[p] then
                loop
                    exitwhen j > PLAYER_MAXINUM
                    if IsUnitInRegion(Rects[j], OrangeMushroom[j]) == false then
                        return
                    endif
                    set j = j + 1
                endloop
                call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
                call SetDoodadAnimation(6144, -29120, 128.00, 'LOxx', false, "stand ready", false)
                call DestroyTrigger( GetTriggeringTrigger() )
                return
            endif
        set i = i + 1
        endloop
    endfunction

    private function Main2 takes nothing returns nothing
        local integer i = 1
        local integer p = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        loop
            exitwhen i > PLAYER_MAXINUM
            // exitwhen i > 2
            if GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i - 1 and IsUnitInRegion(Rects[i + 7], OrangeMushroom[i]) == false then
                return
            endif
            set i = i + 1
        endloop

        call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
        call SetDoodadAnimation(13295, -31512, 128.00, 'LOxx', false, "stand work", false)
        call DestroyTrigger( GetTriggeringTrigger() )
    endfunction
    
    private function SetRect takes trigger t, rect r returns nothing
        set CountInt = CountInt + 1
        set Rects[CountInt] = CreateRegion()
        call RegionAddRect( Rects[CountInt], r )
        set CompareRect[CountInt] = r
        call TriggerRegisterEnterRegion(t, Rects[CountInt], null)
    endfunction

    private function Main3 takes nothing returns nothing
        local integer i = 1
        local integer p = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        
        loop
            exitwhen i > PLAYER_MAXINUM
            //exitwhen i > 1
            if GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i - 1 and IsUnitInRegion(Rects[i + 7], OrangeMushroom[i]) == false then
                return
            endif
            set i = i + 1
        endloop

        call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
        call SetDoodadAnimation(22880, 27600, 128.00, 'LOxx', false, "stand first", false)
        call SetDoodadAnimation(22880 + 512, 27600, 128.00, 'LOxx', false, "stand second", false)
        call SetDoodadAnimation(22880 + 1024, 27600, 128.00, 'LOxx', false, "stand third", false)
        call DestroyTrigger( GetTriggeringTrigger() )
    endfunction

    private function SetRect2 takes trigger t, rect r returns nothing
        set CountInt = CountInt + 1
        set Rects[CountInt] = CreateRegion()
        call RegionAddRect( Rects[CountInt], r )
        set CompareRect[CountInt] = r
        call TriggerRegisterEnterRegion(t, Rects[CountInt], null)
    endfunction
    
    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call SetRect(t, gg_rct_HiddenEvent001)
        call SetRect(t, gg_rct_HiddenEvent002)
        call SetRect(t, gg_rct_HiddenEvent003)
        call SetRect(t, gg_rct_HiddenEvent004)
        call SetRect(t, gg_rct_HiddenEvent005)
        call SetRect(t, gg_rct_HiddenEvent006)
        call SetRect(t, gg_rct_HiddenEvent007)
        call TriggerAddAction( t, function Main )

        set t = CreateTrigger()
        call SetRect(t, gg_rct_MazeHiddenEvent001)
        call SetRect(t, gg_rct_MazeHiddenEvent002)
        call SetRect(t, gg_rct_MazeHiddenEvent003)
        call SetRect(t, gg_rct_MazeHiddenEvent004)
        call SetRect(t, gg_rct_MazeHiddenEvent005)
        call SetRect(t, gg_rct_MazeHiddenEvent006)
        call SetRect(t, gg_rct_MazeHiddenEvent007)
        call TriggerAddAction( t, function Main2 )

        set t = CreateTrigger()
        call SetRect2(t, gg_rct_World2Event001)
        call SetRect2(t, gg_rct_World2Event002)
        call SetRect2(t, gg_rct_World2Event003)
        call SetRect2(t, gg_rct_World2Event004)
        call SetRect2(t, gg_rct_World2Event005)
        call SetRect2(t, gg_rct_World2Event006)
        call SetRect2(t, gg_rct_World2Event007)
        call TriggerAddAction( t, function Main3 )

        set t = null
    endfunction
endlibrary