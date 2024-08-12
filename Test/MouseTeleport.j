library MouseTeleport initializer Init needs MouseTeleportUI
    globals
        public boolean array State[8]
        public integer Number = 0
    endglobals

    public function MouseClick takes real mx, real my returns nothing
        local player p = DzGetTriggerKeyPlayer()
        if State[GetPlayerId(p) + 1] then
            if GetLocalPlayer() == p then
                call DzSyncData("mouse", R2S(DzGetMouseTerrainX()) + ", " /*
                */ + R2S(DzGetMouseTerrainY()) + ", " /*
                */ + R2S(mx) + ", " /*
                */ + R2S(my))
            endif
        endif
    endfunction

    private function Teleport takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerSyncPlayer()) + 1
        local string s = DzGetTriggerSyncData()
        local real x = S2R(JNStringSplit(s,", ",0))
        local real y = S2R(JNStringSplit(s,", ",1))
        local real mx = S2R(JNStringSplit(s,", ",2))
        local real my = S2R(JNStringSplit(s,", ",3))
        local location topLeft = MouseTeleportUI_TopLeft()
        local location bottomRight = MouseTeleportUI_BottomRight()

        if mx >= GetLocationX(topLeft) and mx <= GetLocationX(bottomRight) /* 
            */ and my >= GetLocationY(bottomRight) and my <= GetLocationY(topLeft) then
            return
        endif
        
        if Number == 0 then
            call SetUnitPosition( OrangeMushroom[i], x, y )
            call SetUnitPosition( BackGroundUnits[i], x, y )
        else
            call SetUnitPosition( OrangeMushroom[PLAYER_MAXINUM + Number], x, y )
        endif

        call RemoveLocation(topLeft)
        call RemoveLocation(bottomRight)
        
        set topLeft = null
        set bottomRight = null
    endfunction
    
    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterSyncData(t, "mouse", false)
        call TriggerAddAction(t, function Teleport)
        
        set t = null
    endfunction
endlibrary