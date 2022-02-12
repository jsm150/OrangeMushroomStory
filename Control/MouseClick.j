library MouseClick
    globals
        private trigger DownTrigger = null
        private trigger UpTrigger = null
    endglobals

    public function AddDownAction takes code c returns nothing
        if DownTrigger == null then
            set DownTrigger = CreateTrigger()
            call DzTriggerRegisterMouseEventByCode(DownTrigger, JN_MOUSE_BUTTON_TYPE_LEFT, 1, true, null)
        endif

        call TriggerAddAction(DownTrigger, c)
    endfunction

    public function AddUpAction takes code c returns nothing
        if UpTrigger == null then
            set UpTrigger = CreateTrigger()
            call DzTriggerRegisterMouseEventByCode(UpTrigger, JN_MOUSE_BUTTON_TYPE_LEFT, 0, true, null)
        endif

        call TriggerAddAction(UpTrigger, c)
    endfunction
endlibrary
