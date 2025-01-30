scope MapNotice initializer init

    globals
        integer array NoticeFrame
        integer array NoticeFrameButton
        integer array NoticeText
        integer array NoticeEscFrame
        integer array NoticeFrameEscButton
        
        string array Notice
        boolean MinMaxBol = false
        
        integer FrameBackDropCount = 0
        integer FrameButtonCount = 0
        integer FrameTextCount = 0
    endglobals
    
    private function FrameCounter takes string str returns integer
        if str == "BACKDROP" then
            set FrameBackDropCount = FrameBackDropCount + 1
            return FrameBackDropCount
        elseif str == "GLUETEXTBUTTON" then
            set FrameButtonCount = FrameButtonCount + 1
            return FrameButtonCount
        elseif str == "TEXT" then
            set FrameTextCount = FrameTextCount + 1
            return FrameTextCount
        endif
        return -1
    endfunction
    
    private function GetNoticeTexturePath takes string notice, string path returns string
        if JNStringContains(notice, "공지") then
            return path + "_1.tga"
        endif
        return path + "_2.tga"
    endfunction
    
    private function Rearrangement takes nothing returns nothing
        local string str
        local integer i = 1

        if GetLocalPlayer() == GetLocalPlayer() then
            if Notice[1] == null then
                call JNFrameSetVisible(NoticeFrame[5], false)
            else
                call JNFrameSetVisible(NoticeFrame[5], true)
                if MinMaxBol then
                    call JNFrameSetTexture(NoticeFrame[5], GetNoticeTexturePath(Notice[1], "D"), 0)
                    loop
                    exitwhen i == 4
                        if Notice[i] != null then
                            call JNFrameSetVisible(NoticeFrame[i], true)
                            call JNFrameSetTexture(NoticeFrame[i], GetNoticeTexturePath(Notice[i], "N"), 0)
                            call JNFrameSetText(NoticeText[i], JNStringSplit(Notice[i], "||", 1))
                            call JNFrameSetTexture(NoticeEscFrame[i], GetNoticeTexturePath(Notice[i], "X"), 0)
                        else
                            call JNFrameSetVisible(NoticeFrame[i], false)
                        endif
                        set i = i + 1
                    endloop
                else
                    call JNFrameSetVisible(NoticeFrame[1], false)
                    call JNFrameSetTexture(NoticeFrame[5], GetNoticeTexturePath(Notice[1], "U"), 0)    
                endif
            endif
        endif

    endfunction
    
    private function GetNotice takes string notice returns nothing
        if GetLocalPlayer() == GetLocalPlayer() then
            if notice != "" then
                if Notice[1] == null then
                    set Notice[1] = notice
                elseif Notice[2] == null then
                    set Notice[2] = notice
                else
                    set Notice[3] = notice
                endif
            endif
            call Rearrangement()
        endif
    endfunction

    private function NoticeOpenBrowser takes nothing returns nothing
        local integer frame = JNGetTriggerUIEventFrame()

        if frame == NoticeFrameButton[1] then
            call JNOpenBrowser(JNStringSplit(Notice[1], "||", 2))
            set Notice[1] = null
            if Notice[2] != null then
                set Notice[1] = Notice[2]
                set Notice[2] = null
                if Notice[3] != null then
                    set Notice[2] = Notice[3]
                    set Notice[3] = null
                endif
            else
                set MinMaxBol = false
            endif
        elseif frame == NoticeFrameButton[2] then
            call JNOpenBrowser(JNStringSplit(Notice[2], "||", 2))
            set Notice[2] = null
            if Notice[3] != null then
                set Notice[2] = Notice[3]
                set Notice[3] = null
            endif
        elseif frame == NoticeFrameButton[3] then
            call JNOpenBrowser(JNStringSplit(Notice[3], "||", 2))
            set Notice[3] = null
        endif

        call Rearrangement()
    endfunction
    
    private function NoticeESC takes nothing returns nothing
        local integer frame = JNGetTriggerUIEventFrame()

        if frame == NoticeFrameEscButton[1] then
            set Notice[1] = null
            if Notice[2] != null then
                set Notice[1] = Notice[2]
                set Notice[2] = null
                if Notice[3] != null then
                    set Notice[2] = Notice[3]
                    set Notice[3] = null
                endif
            else
                set MinMaxBol = false
            endif
        elseif frame == NoticeFrameEscButton[2] then
            set Notice[2] = null
            if Notice[3] != null then
                set Notice[2] = Notice[3]
                set Notice[3] = null
            endif
        elseif frame == NoticeFrameEscButton[3] then
            set Notice[3] = null
        endif

        call Rearrangement()
    endfunction
    
    private function MinMaxFrame takes nothing returns nothing
        if MinMaxBol then
            call JNFrameSetTexture(NoticeFrame[5], GetNoticeTexturePath(Notice[1], "U"), 0)
            set MinMaxBol = false
        else
            call JNFrameSetTexture(NoticeFrame[5], GetNoticeTexturePath(Notice[1], "D"), 0)
            set MinMaxBol = true
        endif
        
        call Rearrangement()
    endfunction
    
    private function MakeFrame takes nothing returns nothing
        local integer ui = JNGetGameUI()
        local integer i = 1
        
        // MinMaxButton index 5
        set NoticeFrame[5] = JNCreateFrameByType("BACKDROP", "MINMAXBACKDROP", ui, "", FrameCounter("BACKDROP"))
        call JNFrameSetSize(NoticeFrame[5], 0.02, 0.02)
        call JNFrameSetPoint(NoticeFrame[5], JN_FRAMEPOINT_BOTTOMLEFT, ui,  JN_FRAMEPOINT_BOTTOMLEFT, 0.05, 0.17)
        call JNFrameSetVisible(NoticeFrame[5], false)
        set NoticeFrameButton[5] = JNCreateFrameByType("GLUETEXTBUTTON", "MINMAXBUTTON", NoticeFrame[5], "", FrameCounter("GLUETEXTBUTTON"))
        call JNFrameSetSize(NoticeFrameButton[5], 0.02, 0.02)
        call JNFrameSetPoint(NoticeFrameButton[5], JN_FRAMEPOINT_CENTER, NoticeFrame[5],  JN_FRAMEPOINT_CENTER, 0, 0)
        call JNFrameSetScript(NoticeFrameButton[5], JN_FRAMEEVENT_CONTROL_CLICK, function MinMaxFrame, false)
        
        // Notice Frame Point
        set NoticeFrame[0] = JNCreateFrameByType("BACKDROP", "NOTICEBACKDROP", NoticeFrame[5], "", FrameCounter("BACKDROP"))
        call JNFrameSetTexture(NoticeFrame[0], "B.tga", 0)
        call JNFrameSetSize(NoticeFrame[0], 0.3, 0.001)
        call JNFrameSetPoint(NoticeFrame[0], JN_FRAMEPOINT_TOPLEFT, NoticeFrame[5],  JN_FRAMEPOINT_BOTTOMRIGHT, 0, 0)
        
        // Notice Frame
        loop
        exitwhen i == 4
            set NoticeFrame[i] = JNCreateFrameByType("BACKDROP", "NOTICEBACKDROP", NoticeFrame[i - 1], "", FrameCounter("BACKDROP"))
            call JNFrameSetSize(NoticeFrame[i], 0.3, 0.02)
            call JNFrameSetPoint(NoticeFrame[i], JN_FRAMEPOINT_BOTTOM, NoticeFrame[i - 1],  JN_FRAMEPOINT_TOP, 0, 0)
            call JNFrameSetVisible(NoticeFrame[i], false)
            
            set NoticeText[i] = JNCreateFrameByType("TEXT", "NOTICENAME", NoticeFrame[i], "", FrameCounter("TEXT"))
            call JNFrameSetTextColor(NoticeText[i], 0)
            call JNFrameSetSize(NoticeText[i], 0.25, 0.02)
            call JNFrameSetPoint(NoticeText[i], JN_FRAMEPOINT_LEFT, NoticeFrame[i],  JN_FRAMEPOINT_LEFT, 0.043, -0.004)
            
            set NoticeFrameButton[i] = JNCreateFrameByType("GLUETEXTBUTTON", "NOTICEBUTTON", NoticeFrame[i], "", FrameCounter("GLUETEXTBUTTON"))
            call JNFrameSetSize(NoticeFrameButton[i], 0.3, 0.02)
            call JNFrameSetPoint(NoticeFrameButton[i], JN_FRAMEPOINT_CENTER, NoticeFrame[i],  JN_FRAMEPOINT_CENTER, 0, 0)
            call JNFrameSetScript(NoticeFrameButton[i], JN_FRAMEEVENT_CONTROL_CLICK, function NoticeOpenBrowser, false)
            
            set NoticeEscFrame[i] = JNCreateFrameByType("BACKDROP", "NOTICEBACKDROP", NoticeFrame[i], "", FrameCounter("BACKDROP"))
            call JNFrameSetSize(NoticeEscFrame[i], 0.017, 0.017)
            call JNFrameSetPoint(NoticeEscFrame[i], JN_FRAMEPOINT_RIGHT, NoticeFrame[i],  JN_FRAMEPOINT_RIGHT, -0.002, 0)
            
            set NoticeFrameEscButton[i] = JNCreateFrameByType("GLUETEXTBUTTON", "NOTICEBUTTON", NoticeEscFrame[i], "", FrameCounter("GLUETEXTBUTTON"))
            call JNFrameSetSize(NoticeFrameEscButton[i], 0.017, 0.017)
            call JNFrameSetPoint(NoticeFrameEscButton[i], JN_FRAMEPOINT_CENTER, NoticeEscFrame[i],  JN_FRAMEPOINT_CENTER, 0, 0)
            call JNFrameSetScript(NoticeFrameEscButton[i], JN_FRAMEEVENT_CONTROL_CLICK, function NoticeESC, false)
            
            set i = i + 1
        endloop
    endfunction
    
    // 공지사항||제목||주소, (마지막 쉼표 무조건 붙여야함.)
    private function Action takes nothing returns nothing
        local string s = MapData_Notice
        local integer i = 0
        local integer cnt = JNStringCount(s, ",")

        //! runtextmacro for("set i = 0", "i < cnt")
            call GetNotice(JNStringSplit(s, ",", i))
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()

        call TriggerRegisterTimerEvent(t, 5.0, false)
        call TriggerAddAction(t, function Action)
        call MakeFrame()
        set t = null
    endfunction
    
endscope