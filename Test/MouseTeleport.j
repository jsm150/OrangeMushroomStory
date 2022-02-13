library MouseTeleport initializer Init needs MouseClick
    globals
        public boolean array State[8]
        public integer Number = 0
    endglobals

    private function MouseClick takes nothing returns nothing
        local player p = DzGetTriggerKeyPlayer()
        if State[GetPlayerId(p) + 1] then
            if GetLocalPlayer() == p then
                call DzSyncData("mouse", R2S(DzGetMouseTerrainX())+", "+R2S(DzGetMouseTerrainY()))
            endif
        endif
    endfunction

    private function Teleport takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerSyncPlayer()) + 1
        local string s = DzGetTriggerSyncData()
        local real x = S2R(JNStringSplit(s,", ",0))
        local real y = S2R(JNStringSplit(s,", ",1))
        
        if Number == 0 then
            call SetUnitPosition( OrangeMushroom[i], x, y )
            call SetUnitPosition( BackGroundUnits[i], x, y )
        else
            call SetUnitPosition( OrangeMushroom[PLAYER_MAXINUM + Number], x, y )
        endif
    endfunction

    private function Main takes nothing returns nothing
        call MouseClick_AddDownAction(function MouseClick, true)
        call DestroyTrigger(GetTriggeringTrigger())
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterSyncData(t, "mouse", false)
        call TriggerAddAction(t, function Teleport)

        set t = CreateTrigger()
        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endlibrary