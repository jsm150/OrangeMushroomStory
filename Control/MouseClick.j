scope MouseClick initializer Init
    function GetMouseFrameX takes integer posX returns real
        return posX / (DzGetWindowWidth() / 0.8)
    endfunction

    function GetMouseFrameY takes integer posY returns real
        local integer height = DzGetWindowHeight()
        return (height - posY) / (height / 0.6)
    endfunction

    //! runtextmacro Make_ButtonMouseEvent_Top("ScreenClickDown")
        debug call JNWriteLog("  screen x: " + R2S(x))
        debug call JNWriteLog("  screen y: " + R2S(y))
        call SkinFrame_ClickDownAction(i, x, y)
    //! runtextmacro Make_ButtonMouseEvent_Bottom("ScreenClickDown")

    //! runtextmacro Make_ButtonMouseEvent_Top("ScreenClickUp")
        call SkinFrame_ClickUpAction(i, x, y)
    //! runtextmacro Make_ButtonMouseEvent_Bottom("ScreenClickUp")

    private function DownAsync takes nothing returns nothing
        call ScreenClickDown()
        // call MouseTeleport_MouseClick()
        call ClickEffect_MouseClick()
    endfunction

    private function UpAsync takes nothing returns nothing
        call HotKey_ChatWindowChecker()
        call ScreenClickUp()
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterMouseEventByCode(t, JN_MOUSE_BUTTON_TYPE_LEFT, 1, false, function DownAsync)
        set t = CreateTrigger()
        call DzTriggerRegisterMouseEventByCode(t, JN_MOUSE_BUTTON_TYPE_LEFT, 0, false, function UpAsync)

        set t = null
    endfunction
endscope


//! textmacro Make_ButtonMouseEvent_Top takes funcName
    globals
        private key $funcName$Key
    endglobals

    private function $funcName$ takes nothing returns nothing
        call DzSyncData(I2S($funcName$Key), R2S(GetMouseFrameX(DzGetMouseXRelative()))+", "+R2S(GetMouseFrameY(DzGetMouseYRelative())))
    endfunction

    private function $funcName$Sync takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerSyncPlayer())
        local string s = DzGetTriggerSyncData()
        local real x = S2R(JNStringSplit(s,", ",0))
        local real y = S2R(JNStringSplit(s,", ",1))
//! endtextmacro

//! textmacro Make_ButtonMouseEvent_Bottom takes funcName
    endfunction

    private struct $funcName$Struct
        private static method onInit takes nothing returns nothing
            local trigger t = CreateTrigger()
            call DzTriggerRegisterSyncData(t, I2S($funcName$Key), false)
            call TriggerAddAction(t, function $funcName$Sync)
            set t = null
        endmethod
    endstruct
//! endtextmacro
