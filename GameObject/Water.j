library Water initializer init
    globals
        private hashtable Hash = InitHashtable()
        public boolean array State
        public boolean array EffectState
        public region Rects
        public trigger Trigger
    endglobals
    
    private function EffectTimerEnd takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer id = GetHandleId(t)
        local integer i = LoadInteger(Hash, id, 0)
        
        call DestroyTimer(t)
        call FlushChildHashtable(Hash, GetHandleId(t))
        set EffectState[i] = false
        
        set t = null
    endfunction
    
    public function EffectTimer takes integer i returns nothing
        local timer t = CreateTimer()
        local integer id = GetHandleId(t)
        
        set EffectState[i] = true
        call SaveInteger(Hash, id, 0, i)
        call TimerStart(t, 0.2, false, function EffectTimerEnd)
        
        set t = null
    endfunction
    
    private function WaterEffect takes integer i returns nothing
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])+70
        
        if EffectState[i] == false then
            if Player(i-1) == GetLocalPlayer() then
                call StopSound(gg_snd_NagaBuildingCancel, false, false)
                call StartSound(gg_snd_NagaBuildingCancel)
            endif
            call DestroyEffect(AddSpecialEffect( "war3mapImported\\Splash.mdx", x, y ))
            call EffectTimer(i)
        endif
    endfunction
    
    private function WaterEffectAllCheck takes nothing returns nothing
        local integer i = 1
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])+90
        
        loop
        exitwhen i > PLAYER_MAXINUM
            call EffectTimer(i)
        set i = i + 1
        endloop
    endfunction
    
    private function WaterIn takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        local integer j = PLAYER_MAXINUM+1
        local integer types = GetUnitTypeId(GetTriggerUnit())
        
        if (MushroomType(types) or types == 'opeo' or types == 'ogru' or types == 'otau' or types == 'ohun' or types == 'ocat' or types == 'o006') then
            if i > PLAYER_MAXINUM then 
                loop
                exitwhen OrangeMushroom[j] == GetTriggerUnit() or Stage_BoxsCount < j-PLAYER_MAXINUM
                set j = j + 1
                endloop
                set i = j
            endif
            if State[i] == false then
                set State[i] = true
                call WaterEffect(i)
            endif
        endif
    endfunction
    
    private function WaterOut takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        local integer j = PLAYER_MAXINUM+1
        local integer types = GetUnitTypeId(GetTriggerUnit())
        
        if (MushroomType(types) or types == 'opeo' or types == 'ogru' or types == 'otau' or types == 'o006') then
            if i > PLAYER_MAXINUM then 
                loop
                exitwhen OrangeMushroom[j] == GetTriggerUnit() or Stage_BoxsCount < j-PLAYER_MAXINUM
                set j = j + 1
                endloop
                set i = j
            endif
            if State[i] == true then
                set State[i] = false
                call WaterEffect(i)
            endif
        endif
    endfunction
    
    private function init takes nothing returns nothing
        local integer i = 1
        local trigger t = CreateTrigger(  )
        
        set Rects = CreateRegion()
        call RegionAddRect( Rects, gg_rct_Water001 )
        call RegionAddRect( Rects, gg_rct_Water002 )
        call RegionAddRect( Rects, gg_rct_Water003 )
        call RegionAddRect( Rects, gg_rct_Water004 )
        call RegionAddRect( Rects, gg_rct_Water005 )
        call RegionAddRect( Rects, gg_rct_Water006 )
        call RegionAddRect( Rects, gg_rct_Water007 )
        call RegionAddRect( Rects, gg_rct_Water008 )
        call RegionAddRect( Rects, gg_rct_Water009 )
        call RegionAddRect( Rects, gg_rct_Water010 )
        call RegionAddRect( Rects, gg_rct_Water011 )
        call RegionAddRect( Rects, gg_rct_Water012 )
        call RegionAddRect( Rects, gg_rct_Water013 )
        call RegionAddRect( Rects, gg_rct_Water014 )
        call RegionAddRect( Rects, gg_rct_Water015 )
        call RegionAddRect( Rects, gg_rct_Water016 )
        call RegionAddRect( Rects, gg_rct_Water017 )
        call RegionAddRect( Rects, gg_rct_Water018 )
        call RegionAddRect( Rects, gg_rct_Water019 )
        call RegionAddRect( Rects, gg_rct_Water020 )
        call RegionAddRect( Rects, gg_rct_Water021 )
        call RegionAddRect( Rects, gg_rct_Water022 )
        call RegionAddRect( Rects, gg_rct_Water023 )
        call RegionAddRect( Rects, gg_rct_Water024 )
        call RegionAddRect( Rects, gg_rct_Water025 )
        call RegionAddRect( Rects, gg_rct_Water026 )
        call RegionAddRect( Rects, gg_rct_Water027 )
        call RegionAddRect( Rects, gg_rct_Water028 )
        call RegionAddRect( Rects, gg_rct_Water029 )
        call RegionAddRect( Rects, gg_rct_Water030 )
        call RegionAddRect( Rects, gg_rct_Water031 )
        call RegionAddRect( Rects, gg_rct_Water032 )
        call RegionAddRect( Rects, gg_rct_Water033 )
        call RegionAddRect( Rects, gg_rct_Water034 )
        call RegionAddRect( Rects, gg_rct_Water035 )
        call RegionAddRect( Rects, gg_rct_Water036 )
        call RegionAddRect( Rects, gg_rct_Water037 )
        call RegionAddRect( Rects, gg_rct_Water038 )
        call RegionAddRect( Rects, gg_rct_Water039 )
        call RegionAddRect( Rects, gg_rct_Water040 )
        call RegionAddRect( Rects, gg_rct_Water041 )
        call RegionAddRect( Rects, gg_rct_Water042 )
        call RegionAddRect( Rects, gg_rct_Water043 )
        call RegionAddRect( Rects, gg_rct_Water044 )
        call RegionAddRect( Rects, gg_rct_Water045 )
        call RegionAddRect( Rects, gg_rct_Water046 )
        call RegionAddRect( Rects, gg_rct_Water047 )
        call RegionAddRect( Rects, gg_rct_Water048 )
        call RegionAddRect( Rects, gg_rct_Water049 )
        call RegionAddRect( Rects, gg_rct_Water050 )
        call RegionAddRect( Rects, gg_rct_Water051 )
        call RegionAddRect( Rects, gg_rct_Water052 )
        call RegionAddRect( Rects, gg_rct_Water053 )
        call RegionAddRect( Rects, gg_rct_Water054 )
        call RegionAddRect( Rects, gg_rct_Water055 )
        call RegionAddRect( Rects, gg_rct_Water056 )
        call RegionAddRect( Rects, gg_rct_Water057 )
        call RegionAddRect( Rects, gg_rct_Water058 )
        call RegionAddRect( Rects, gg_rct_Water059 )
        call RegionAddRect( Rects, gg_rct_Water060 )
        call RegionAddRect( Rects, gg_rct_Water061 )
        call RegionAddRect( Rects, gg_rct_Water062 )
        call RegionAddRect( Rects, gg_rct_Water063 )
        call RegionAddRect( Rects, gg_rct_Water064 )
        call RegionAddRect( Rects, gg_rct_Water065 )
        
        call TriggerRegisterEnterRegion(t, Rects, null)
        call TriggerAddAction( t, function WaterIn )
        
        set t = CreateTrigger(  )
        call TriggerRegisterLeaveRegion(t, Rects, null)
        call TriggerAddAction( t, function WaterOut )
        
        set Trigger = CreateTrigger(  )
        call TriggerAddAction( Trigger, function WaterEffectAllCheck )
        
        set t = null
    endfunction
endlibrary