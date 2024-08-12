library MouseTeleportUI initializer Init

    globals
        private integer backdrop
        private integer array objectButtons
        private string array objectButtonNameList
        private integer selectButtonNumber = 0

        private real uiLeft = 0.01
        private real uiRight = 0.21
        private real uiBottom = 0.01
        private real uiTop = 0.16

        private key sync
    endglobals

    private function ObjectName takes integer kind returns string
        if kind == 'ogru' then
            return "문어"
        elseif kind == 'otau' then
            return "분홍 문어"
        elseif kind == 'ocat' then
            return "코크"
        elseif kind == 'o000' or kind == 'o001' then
            return "도깨비"
        elseif kind == 'h00T' or kind == 'h00S' then
            return "래쉬"
        elseif kind == 'o006' then
            return "폭탄"
        elseif kind == 'opeo' then
            return "상자"
        elseif kind == 'orai' then
            return "비행기"
        endif
        return ""
    endfunction

    private function ChangeName takes integer i, boolean select returns nothing
        local string s = ObjectName(GetUnitTypeId(OrangeMushroom[PLAYER_MAXINUM + i])) + "|r"
        if select then
            set objectButtonNameList[i] = "|cff1FBF00" + s
        else
            set objectButtonNameList[i] = "|cffffffff" + s
        endif
        call DzFrameSetText(objectButtons[i], objectButtonNameList[i])
    endfunction

    //! textmacro SelectObjectNum takes Num
        private struct SelectObject$Num$
            public static key Key
    
            public static method Sync takes nothing returns nothing
                call DzSyncData(I2S(Key), "")
            endmethod

            private static method Func takes nothing returns nothing
                local integer i = $Num$
    
                if i == selectButtonNumber then
                    set MouseTeleport_Number = 0
                    set selectButtonNumber = 0
                    call ChangeName(i, false)
                    return
                endif
    
                set MouseTeleport_Number = i
                call ChangeName(i, true)
                if selectButtonNumber != 0 then
                    call ChangeName(selectButtonNumber, false)
                endif
                set selectButtonNumber = i
            endmethod
    
            private static method onInit takes nothing returns nothing
                local trigger t = CreateTrigger()
                call DzTriggerRegisterSyncData(t, I2S(Key), false)
                call TriggerAddAction(t, function thistype.Func)
                set t = null
            endmethod
        endstruct
    //! endtextmacro

    //! runtextmacro SelectObjectNum("1")
    //! runtextmacro SelectObjectNum("2")
    //! runtextmacro SelectObjectNum("3")
    //! runtextmacro SelectObjectNum("4")
    //! runtextmacro SelectObjectNum("5")
    //! runtextmacro SelectObjectNum("6")
    //! runtextmacro SelectObjectNum("7")
    //! runtextmacro SelectObjectNum("8")
    //! runtextmacro SelectObjectNum("9")


    private function CreateUI takes nothing returns nothing
        local integer i = 0
        set backdrop = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "EscMenuEditBoxBackdropTemplate", 0)

        call DzFrameSetAbsolutePoint(backdrop, JN_FRAMEPOINT_TOPLEFT, uiLeft, uiTop)
        call DzFrameSetAbsolutePoint(backdrop, JN_FRAMEPOINT_BOTTOMRIGHT, uiRight, uiBottom)

        //! runtextmacro for("set i = 1", "i <= 9")
            set objectButtons[i] =  DzCreateFrameByTagName("GLUETEXTBUTTON", "", backdrop, "ScriptDialogButton", 0)
            set objectButtonNameList[i] = " "
            call DzFrameSetText(objectButtons[i], objectButtonNameList[i])
            call DzFrameSetSize(objectButtons[i], 0.06, 0.045)
        //! runtextmacro for_end("set i = i + 1")
            
        call DzFrameSetScriptByCode(objectButtons[1], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject1.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[2], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject2.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[3], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject3.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[4], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject4.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[5], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject5.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[6], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject6.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[7], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject7.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[8], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject8.Sync, false)
        call DzFrameSetScriptByCode(objectButtons[9], JN_FRAMEEVENT_CONTROL_CLICK, function SelectObject9.Sync, false)

        call DzFrameSetPoint(objectButtons[1], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01, -0.01)
        call DzFrameSetPoint(objectButtons[2], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01 + 0.06, -0.01)
        call DzFrameSetPoint(objectButtons[3], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01 + 0.12, -0.01)

        call DzFrameSetPoint(objectButtons[4], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01, -0.055)
        call DzFrameSetPoint(objectButtons[5], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01 + 0.06, -0.055)
        call DzFrameSetPoint(objectButtons[6], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01 + 0.12, -0.055)

        call DzFrameSetPoint(objectButtons[7], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01, -0.1)
        call DzFrameSetPoint(objectButtons[8], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01 + 0.06, -0.1)
        call DzFrameSetPoint(objectButtons[9], JN_FRAMEPOINT_TOPLEFT, backdrop, JN_FRAMEPOINT_TOPLEFT, 0.01 + 0.12, -0.1)
        
        call DzFrameShow(backdrop, false)
    endfunction

    public function Setting takes nothing returns nothing
        local integer i = 1
        local integer kind = 0

        //! runtextmacro for("set i = 1", "i <= Stage_BoxsCount")
            if ObjectName(GetUnitTypeId(OrangeMushroom[PLAYER_MAXINUM + i])) == "비행기" then
                call DzFrameShow(objectButtons[i], false)
            else
                call DzFrameShow(objectButtons[i], true)
                call ChangeName(i, false)
            endif
        //! runtextmacro for_end("set i = i + 1")

        //! runtextmacro for("set i = Stage_BoxsCount + 1", "i <= 9")
            call DzFrameShow(objectButtons[i], false)
        //! runtextmacro for_end("set i = i + 1")

        
        set selectButtonNumber = 0
        set MouseTeleport_Number = 0
    endfunction

    public function OnOff takes nothing returns nothing
        local integer i = 0
        call Setting()

        //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
            if MouseTeleport_State[i] and GetLocalPlayer() == Player(i - 1) then
                call DzFrameShow(backdrop, true)
            elseif GetLocalPlayer() == Player(i - 1) then
                call DzFrameShow(backdrop, false)
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction


    public function TopLeft takes nothing returns location
        return Location(uiLeft, uiTop)
    endfunction

    public function BottomRight takes nothing returns location
        return Location(uiRight, uiBottom)
    endfunction

    private function Init takes nothing returns nothing
        call CreateUI()
    endfunction
endlibrary