scope HotKey initializer Init
    globals
        private boolean array onEnter[PLAYER_MAXINUM]
    endglobals

    private function SetOnEnter takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerSyncPlayer())
        set onEnter[i] = S2I(JNGetTriggerSyncData()) != 0
    endfunction
    
    private function ChatWindowChecker takes nothing returns nothing
        if DzGetTriggerKeyPlayer() == GetLocalPlayer() then
            call DzSyncData("onEnter", I2S(BytePtr[pGameDll + 0xD04FEC]))
        endif
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterSyncData(t, "onEnter", false)
        call TriggerAddAction(t, function SetOnEnter)

        set t = CreateTrigger()
        call DzTriggerRegisterKeyEvent(t, 13, 1, true, null)
        call TriggerAddAction(t, function ChatWindowChecker)

        call MouseClick_AddDownAction(function ChatWindowChecker)

        set t = null
    endfunction

    private struct Event
        static method Execute takes nothing returns nothing
            local thistype this = eventStruct.e
            local integer i = GetPlayerId(DzGetTriggerKeyPlayer())

            if onEnter[i] == false then
                call this.Action(i)
            elseif DzGetTriggerKeyPlayer() == GetLocalPlayer() and BytePtr[pGameDll + 0xD04FEC] == 0 then
                call DzSyncData("onEnter", "0")
            endif
        endmethod
        
        private stub method Action takes integer playerId returns nothing
        endmethod

        static method create takes integer keyId returns thistype
            local thistype this = thistype.allocate()
            local trigger t = eventStruct.register(this, 0, function thistype.Execute)
            call DzTriggerRegisterKeyEvent(t, keyId, 1, true, null)

            set t = null
            return this
        endmethod
    endstruct

    //! runtextmacro HotKey_Event_Top("Count")
        call Command_CountMain(playerId + 1, "-count 3", true)
    //! runtextmacro HotKey_Event_Bottom("'C'")

    //! runtextmacro HotKey_Event_Top("Observer")
        call Command_OBSMain(playerId + 1)
    //! runtextmacro HotKey_Event_Bottom("'V'")

    //! runtextmacro HotKey_Event_Top("Debug")
        debug call JNWriteLog("")
    //! runtextmacro HotKey_Event_Bottom("JN_OSKEY_P")
endscope


//! textmacro HotKey_Event_Top takes structName
    private struct $structName$ extends Event

    method Action takes integer playerId returns nothing
//! endtextmacro

//! textmacro HotKey_Event_Bottom takes Key
    endmethod

    static method create takes integer keyId returns thistype
        return thistype.allocate(keyId)
    endmethod

    private static method onInit takes nothing returns nothing
        call thistype.create($Key$)
    endmethod

    endstruct
//! endtextmacro