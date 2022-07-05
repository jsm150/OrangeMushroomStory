scope MouseClick initializer Init
    private function DownAsync takes nothing returns nothing
        call SkinFrame_MouseClickDown()
    endfunction

    private function UpAsync takes nothing returns nothing
        call HotKey_ChatWindowChecker()
        call SkinFrame_MouseClickUp()
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterMouseEventByCode(t, JN_MOUSE_BUTTON_TYPE_LEFT, 1, false, function DownAsync)
        set t = CreateTrigger()
        call DzTriggerRegisterMouseEventByCode(t, JN_MOUSE_BUTTON_TYPE_LEFT, 0, false, function UpAsync)

        set t = null
    endfunction
endscope
