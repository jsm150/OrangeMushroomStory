library MouseClick
    globals
        private trigger Trigger = null
    endglobals

    public function AddAction takes code c returns nothing
        if Trigger == null then
            set Trigger = CreateTrigger()
            call DzTriggerRegisterMouseEventByCode(Trigger, JN_MOUSE_BUTTON_TYPE_LEFT, 1, true, null)
        endif

        call TriggerAddAction(Trigger, c)
    endfunction
endlibrary
