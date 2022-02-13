library MouseClick
    globals
        private trigger DownTriggerSync = null
        private trigger DownTriggerAsync = null

        private trigger UpTriggerSync = null
        private trigger UpTriggerAsync = null
    endglobals

    public function AddDownAction takes code c, boolean sync returns nothing
        if sync then
            if DownTriggerSync == null then
                set DownTriggerSync = CreateTrigger()
                call DzTriggerRegisterMouseEventByCode(DownTriggerSync, JN_MOUSE_BUTTON_TYPE_LEFT, 1, true, null)
            endif
    
            call TriggerAddAction(DownTriggerSync, c)
        else
            if DownTriggerAsync == null then
                set DownTriggerAsync = CreateTrigger()
                call DzTriggerRegisterMouseEventByCode(DownTriggerAsync, JN_MOUSE_BUTTON_TYPE_LEFT, 1, false, null)
            endif
    
            call TriggerAddAction(DownTriggerAsync, c)
        endif
    endfunction

    public function AddUpAction takes code c, boolean sync returns nothing
        if sync then
            if UpTriggerSync == null then
                set UpTriggerSync = CreateTrigger()
                call DzTriggerRegisterMouseEventByCode(UpTriggerSync, JN_MOUSE_BUTTON_TYPE_LEFT, 0, true, null)
            endif
    
            call TriggerAddAction(UpTriggerSync, c)
        else
            if UpTriggerAsync == null then
                set UpTriggerAsync = CreateTrigger()
                call DzTriggerRegisterMouseEventByCode(UpTriggerAsync, JN_MOUSE_BUTTON_TYPE_LEFT, 0, false, null)
            endif
    
            call TriggerAddAction(UpTriggerAsync, c)
        endif
    endfunction
endlibrary
