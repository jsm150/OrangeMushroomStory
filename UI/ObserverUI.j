library ObserverUI initializer Init needs BossMain
    globals
        public integer Backdrop
        private integer array ControlButtons
        /*
        public framehandle Backdrop
        private framehandle array ControlButtons
        */
    endglobals

   
    private function OBSChangeLeft takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerUIEventPlayer()) + 1
        call Observer_Change(i, true)
    endfunction

    private function OBSChangeRight takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerUIEventPlayer()) + 1
        call Observer_Change(i, false)
    endfunction

    private function MusicOnOff takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerUIEventPlayer()) + 1
        call Command_SoundSetting.evaluate(i)
    endfunction
   
   
    private function CreateObserverUI takes nothing returns nothing
        local integer i = 0
        local string array names
       
        set Backdrop=DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuEditBoxBackdropTemplate", 0)
        call DzFrameSetAbsolutePoint(Backdrop, JN_FRAMEPOINT_TOPLEFT, 0.63, 0.10)
        call DzFrameSetAbsolutePoint(Backdrop, JN_FRAMEPOINT_BOTTOMRIGHT, 0.8, 0.03)
           
        set names[0] = "<"
        set names[1] = ">"
        set names[2] = "Music"
        
        loop
        exitwhen i > 2
            set ControlButtons[i] = DzCreateFrameByTagName("GLUETEXTBUTTON", "", Backdrop, "ScriptDialogButton", 0)
            call DzFrameSetPoint(ControlButtons[i], JN_FRAMEPOINT_TOPLEFT, Backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01+(i*0.05), -0.01)
            call DzFrameSetText(ControlButtons[i], "|cffffffff" + names[i] + "|r")
            call DzFrameSetSize(ControlButtons[i], 0.05, 0.05)
        set i = i + 1
        endloop

        call DzFrameSetScriptByCode(ControlButtons[0], JN_FRAMEEVENT_CONTROL_CLICK, function OBSChangeLeft, false)
        call DzFrameSetScriptByCode(ControlButtons[1], JN_FRAMEEVENT_CONTROL_CLICK, function OBSChangeRight, false)
        call DzFrameSetScriptByCode(ControlButtons[2], JN_FRAMEEVENT_CONTROL_CLICK, function MusicOnOff, false)
           
        if GetPlayerId(GetLocalPlayer()) < PLAYER_MAXINUM then
            call DzFrameShow(Backdrop, false)
        endif
    endfunction
   
    private function Init takes nothing returns nothing
        call CreateObserverUI()
    endfunction
endlibrary