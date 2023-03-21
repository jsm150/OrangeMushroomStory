library ClickEffect initializer Init needs TriggerSleepAction
    globals
        private key eventKey
        private string array effectPath
        private boolean array clickingArray[PLAYER_MAXINUM]
    endglobals

    private function IsClicking takes integer playerId returns boolean
        return clickingArray[playerId]
    endfunction

    private function SetClicking takes integer playerId, boolean isClick returns nothing
        set clickingArray[playerId] = isClick
    endfunction

    public function EffectOff takes integer playerId returns nothing
        call SetClicking(playerId, false)
    endfunction

    public function EffectOn takes integer playerId returns nothing
        call SetClicking(playerId, true)
        loop
            exitwhen IsClicking(playerId) == false
            if GetLocalPlayer() == Player(playerId) then
                call DzSyncData(I2S(eventKey), R2S(DzGetMouseTerrainX())+", "+R2S(DzGetMouseTerrainY()))
            endif
            call TriggerSleepActionByTimer(0.07)
        endloop
    endfunction

    private function Effect takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerSyncPlayer())
        local string s = DzGetTriggerSyncData()
        local real x = S2R(JNStringSplit(s,", ",0))
        local real y = S2R(JNStringSplit(s,", ",1))
        call DestroyEffect(AddSpecialEffect(effectPath[i], x, y ))
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterSyncData(t, I2S(eventKey), false)
        call TriggerAddAction(t, function Effect)

        set effectPath[0] = "war3mapImported\\RedClickMotion.mdx"
        set effectPath[1] = "war3mapImported\\BlueClickMotion.mdx"
        set effectPath[2] = "war3mapImported\\TealClickMotion.mdx"
        set effectPath[3] = "war3mapImported\\PurpleClickMotion.mdx"
        set effectPath[4] = "war3mapImported\\YellowClickMotion.mdx"
        set effectPath[5] = "war3mapImported\\OrangeClickMotion.mdx"
        set effectPath[6] = "war3mapImported\\GreenClickMotion.mdx"
        
        set t = null
    endfunction
endlibrary
