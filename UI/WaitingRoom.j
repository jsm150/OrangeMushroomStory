scope WaitingRoom
    globals
        private integer AniScreenCount = 0
        private integer AniScreenMaxCount = 90
    endglobals
    
    private function DzFrameSetTextAlignmentFix takes integer frame, integer vert, integer horz returns nothing
        local integer align = 0
        if vert == JN_TEXT_JUSTIFY_TOP then
            set align = 1
        elseif vert == JN_TEXT_JUSTIFY_MIDDLE then
            set align = 2
        elseif vert == JN_TEXT_JUSTIFY_BOTTOM then
            set align = 4
        endif
        if horz == JN_TEXT_JUSTIFY_LEFT then
            set align = align + 8
        elseif horz == JN_TEXT_JUSTIFY_CENTER then
            set align = align + 16
        elseif horz == JN_TEXT_JUSTIFY_RIGHT then
            set align = align + 32
        endif
        call DzFrameSetTextAlignment(frame, align)
    endfunction
    
    private function DownloadLink takes nothing returns nothing
        call JNOpenBrowser("https://m16tool.xyz/Game/OM150")
    endfunction
    
    private function AnimationScreen takes nothing returns nothing
        local integer buttonBackdrop
        local integer buttonCase
        local integer ControllerLink
        local integer buttonText
        
        if AniScreenCount >= AniScreenMaxCount and DzFrameGetAlpha(DzFrameFindByName("CancelButton", 0)) == 255 then
            set buttonBackdrop = DzCreateFrameByTagName("BACKDROP", "", DzFrameFindByName("MapInfoPane", 0), "StandardMenuButtonBaseBackdrop", 0)
            call DzFrameSetAbsolutePoint(buttonBackdrop, JN_FRAMEPOINT_CENTER, 0.665, 0.21)
            call DzFrameSetSize(buttonBackdrop, 0.24, 0.064)
            
            set buttonCase = DzCreateFrameByTagName("BACKDROP", "", buttonBackdrop, "BattleNetButtonBackdropTemplate", 0)
            call DzFrameSetPoint(buttonCase, JN_FRAMEPOINT_TOPRIGHT, buttonBackdrop, JN_FRAMEPOINT_TOPRIGHT, -0.012, -0.0165)
            call DzFrameSetSize(buttonCase, 0.168, 0.031)
            
            set ControllerLink = DzCreateFrameByTagName("GLUECHECKBOX", "", buttonBackdrop, "", 0)
            call DzFrameSetPoint(ControllerLink, JN_FRAMEPOINT_TOPLEFT, buttonCase, JN_FRAMEPOINT_TOPLEFT, 0, 0)
            call DzFrameSetPoint(ControllerLink, JN_FRAMEPOINT_BOTTOMRIGHT, buttonCase, JN_FRAMEPOINT_BOTTOMRIGHT, 0, 0)
            call DzFrameSetScriptByCode(ControllerLink, JN_FRAMEEVENT_CHECKBOX_CHECKED, function DownloadLink, false)
            call DzFrameSetScriptByCode(ControllerLink, JN_FRAMEEVENT_CHECKBOX_UNCHECKED, function DownloadLink, false)
            
            set buttonText = DzCreateFrameByTagName("TEXT", "", DzFrameFindByName("MapInfoPane", 0), "StandardLabelTextTemplate", 0)
            call DzFrameSetPoint(buttonText, JN_FRAMEPOINT_TOPLEFT, ControllerLink, JN_FRAMEPOINT_TOPLEFT, 0, 0)
            call DzFrameSetPoint(buttonText, JN_FRAMEPOINT_BOTTOMRIGHT, ControllerLink, JN_FRAMEPOINT_BOTTOMRIGHT, 0, 0)
            call DzFrameSetText(buttonText, "|cfffcd211최신버전 다운로드 링크")
            call DzFrameSetTextAlignmentFix(buttonText, JN_TEXT_JUSTIFY_CENTER, JN_TEXT_JUSTIFY_CENTER)
            call DzFrameSetEnable(buttonText, false)
            
            call DzFrameSetUpdateCallback(null)
            return
        endif
        set AniScreenCount = AniScreenCount + 1
    endfunction
    
    //! inject config
        call DzLoadToc("war3mapImported\\SkillToolTip.toc")
        if JNGetConnectionState() == 1413697614 or DzFrameGetAlpha(DzFrameFindByName("CreateGameButton", 0)) == 255 then
            if JNGetConnectionState() == 1413697614 then
                set AniScreenMaxCount = 30
            endif
            call DzFrameSetUpdateCallbackByCode(function AnimationScreen)
        else
            set AniScreenMaxCount = 1
            call DzFrameSetUpdateCallbackByCode(function AnimationScreen)
        endif
        
        //여기부터는 자신의 맵의 config원본을...

        call SetMapName("TRIGSTR_001")
        call SetMapDescription("TRIGSTR_003")
        call SetPlayers(8)
        call SetTeams(8)
        call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)

        call DefineStartLocation(0, - 8128.0, 16832.0)
        call DefineStartLocation(1, - 8128.0, 16832.0)
        call DefineStartLocation(2, - 8128.0, 16832.0)
        call DefineStartLocation(3, - 8128.0, 16832.0)
        call DefineStartLocation(4, - 8128.0, 16832.0)
        call DefineStartLocation(5, - 8128.0, 16832.0)
        call DefineStartLocation(6, - 8128.0, 16832.0)
        call DefineStartLocation(7, - 8128.0, 16832.0)

        // Player setup
        call InitCustomPlayerSlots()
        call InitCustomTeams()
        call InitAllyPriorities()
    //! endinject
endscope