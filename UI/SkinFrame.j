library SkinFrame initializer Init needs TeamColor, TriggerSleepAction

    private function GetMouseFrameX takes integer posX returns real
        return posX / (DzGetWindowWidth() / 0.8)
    endfunction

    private function GetMouseFrameY takes integer posY returns real
        local integer height = DzGetWindowHeight()
        return (height - posY) / (height / 0.6)
    endfunction

    private struct SkinAnimation
        private static hashtable motionList = InitHashtable()
        private string name
        private integer fileCount = 0
        private real motionDelay
        private boolean playing = false
        

        private method ChangeAnimation takes integer frame, integer playerId returns nothing
            local integer currentIdx = 0

            set this.playing = true
            loop
                exitwhen this.playing == false
                if GetLocalPlayer() == Player(playerId) then
                    call DzFrameSetTexture(frame, LoadStr(thistype.motionList, this, currentIdx), 0)
                endif
                set currentIdx = currentIdx + 1
                if currentIdx >= this.fileCount then
                    set currentIdx = 0
                endif
                
                call TriggerSleepActionByTimer(this.motionDelay)
            endloop
        endmethod

        public method Run takes integer frame, integer playerId returns nothing
            call this.ChangeAnimation.execute(frame, playerId)
        endmethod

        public method Stop takes nothing returns nothing
            set this.playing = false
        endmethod

        public method Clone takes nothing returns thistype
            local thistype copy = thistype.create(this.motionDelay, this.name)
            local integer i
            //! runtextmacro for("set i = 0", "i < this.fileCount")
                call copy.AddMotion(LoadStr(thistype.motionList, this, i))
            //! runtextmacro for_end("set i = i + 1")
            return copy
        endmethod

        public method AddMotion takes string motion returns nothing
            call SaveStr(thistype.motionList, this, this.fileCount, motion)
            set this.fileCount = this.fileCount + 1
        endmethod

        public method Equals takes string name returns boolean
            return this.name == name
        endmethod

        public static method create takes real motionDelay, string name returns thistype
            local thistype this = thistype.allocate()
            set this.motionDelay = motionDelay
            set this.name = name
            return this
        endmethod

        public method destroy takes nothing returns nothing
            call this.Stop()
            call FlushChildHashtable(thistype.motionList, this)
            call thistype.deallocate(this)
        endmethod
    endstruct

    globals
        private sList SkinAnimationList
    endglobals
    

    private struct NameUI
        private static integer frame = 0
        private integer playerId

        public method Show takes nothing returns nothing
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, true)
            endif
        endmethod

        public method Hide takes nothing returns nothing
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, false)
            endif
        endmethod

        public static method create takes integer playerId, real posX, real posY returns thistype
            local thistype this = thistype.allocate()
            local string playerName = GetPlayerName(Player(playerId))
            local real size = 0.014

            set this.playerId = playerId

            if thistype.frame == 0 then
                set thistype.frame = DzCreateFrameByTagName("TEXT", "", DzGetGameUI(), "TeamLabelTextTemplate", 0)
                call DzFrameSetFont(thistype.frame, "Fonts\\DFHeiMd.ttf", size, 0)
                call DzFrameSetEnable(thistype.frame, false)
                call DzFrameSetAbsolutePoint(thistype.frame, JN_FRAMEPOINT_TOPLEFT, posX, posY)
                call DzFrameShow(thistype.frame, false)
            endif

            if GetLocalPlayer() == Player(playerId) then
                call DzFrameSetText(thistype.frame, TeamColor[playerId + 1] + playerName + "        ")
            endif
            
            return this
        endmethod
    endstruct

    private struct SkinSelectWindow
        private static constant real size = 0.27
        private static constant real posX = 0.06
        private static constant real posY = 0.55
        private static integer topFrame1 = 0
        private static integer topFrame2 = 0
        private static integer topFrame3 = 0
        private static integer previewFrame = 0
        private static integer bannerFrame = 0
        private static integer inventoryTopFrame = 0
        private static integer inventoryBottomFrame = 0
        private static integer skinFrame
        private boolean isShow = false
        private SkinAnimation skinAnimation
        private NameUI nameUI
        private integer playerId

        public method CloseButtonContains takes real posX, real posY returns boolean
            // 워크 화면상의 절대좌표
            local real minX = 0.570
            local real maxX = 0.592
            local real minY = 0.515
            local real maxY = 0.539
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        public method Show takes nothing returns nothing
            set this.isShow = true

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.topFrame1, this.isShow)
                call DzFrameShow(this.topFrame2, this.isShow)
                call DzFrameShow(this.topFrame3, this.isShow)
                call DzFrameShow(this.previewFrame, this.isShow)
                call DzFrameShow(this.bannerFrame, this.isShow)
                call DzFrameShow(this.inventoryTopFrame, this.isShow)
                call DzFrameShow(this.inventoryBottomFrame, this.isShow)
                call DzFrameShow(this.skinFrame, this.isShow)
            endif

            call this.skinAnimation.Run(thistype.skinFrame, this.playerId)
            call this.nameUI.Show()
        endmethod

        public method Hide takes nothing returns nothing
            set this.isShow = false

            call this.skinAnimation.Stop()
            call this.nameUI.Hide()
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.topFrame1, this.isShow)
                call DzFrameShow(this.topFrame2, this.isShow)
                call DzFrameShow(this.topFrame3, this.isShow)
                call DzFrameShow(this.previewFrame, this.isShow)
                call DzFrameShow(this.bannerFrame, this.isShow)
                call DzFrameShow(this.inventoryTopFrame, this.isShow)
                call DzFrameShow(this.inventoryBottomFrame, this.isShow)
                call DzFrameShow(this.skinFrame, this.isShow)
            endif
        endmethod

        public method ChangeSkin takes SkinAnimation skinAnimation returns nothing
            call this.skinAnimation.destroy()
            set this.skinAnimation = skinAnimation
            if this.isShow then
                call this.skinAnimation.Run(this.skinFrame, this.playerId)
            endif
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()
            local real nameOffsetX = 0.128
            local real nameOffsetY = -0.2082
            local real skinOffsetX = 0.145
            local real skinOffsetY = -0.2052

            if thistype.topFrame1 == 0 then
                set thistype.topFrame1 = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.topFrame2 = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.topFrame3 = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.previewFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.bannerFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.inventoryTopFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.inventoryBottomFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.skinFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)

                call DzFrameSetSize(thistype.topFrame1, thistype.size * 0.222, thistype.size * 0.185)
                call DzFrameSetSize(thistype.topFrame2, thistype.size - thistype.size * 0.222, thistype.size * 0.185)
                call DzFrameSetSize(thistype.topFrame3, thistype.size, thistype.size * 0.185)
                call DzFrameSetSize(thistype.previewFrame, thistype.size, thistype.size * 0.8074)
                call DzFrameSetSize(thistype.bannerFrame, thistype.size, thistype.size * 1.4 - thistype.size * 0.8074)
                call DzFrameSetSize(thistype.inventoryTopFrame, thistype.size, thistype.size * 0.67)
                call DzFrameSetSize(thistype.inventoryBottomFrame, thistype.size, thistype.size * 1.4 - thistype.size * 0.67)
                call DzFrameSetSize(thistype.skinFrame, 0.044, 0.044)

                call DzFrameSetTexture(thistype.topFrame1, "SkinWindowTop1.blp", 0)
                call DzFrameSetTexture(thistype.topFrame2, "SkinWindowTop2.blp", 0)
                call DzFrameSetTexture(thistype.topFrame3, "SkinWindowTop3.blp", 0)
                call DzFrameSetTexture(thistype.previewFrame, "SkinWindowPreview.blp", 0)
                call DzFrameSetTexture(thistype.bannerFrame, "SkinWindowBanner.blp", 0)
                call DzFrameSetTexture(thistype.inventoryTopFrame, "SkinWindowInventoryTop.blp", 0)
                call DzFrameSetTexture(thistype.inventoryBottomFrame, "SkinWindowInventoryBottom.blp", 0)

                call DzFrameSetAbsolutePoint(thistype.topFrame1, JN_FRAMEPOINT_TOPLEFT, thistype.posX, thistype.posY)
                call DzFrameSetPoint(thistype.topFrame2, JN_FRAMEPOINT_TOPLEFT, thistype.topFrame1, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
                call DzFrameSetPoint(thistype.topFrame3, JN_FRAMEPOINT_TOPLEFT, thistype.topFrame2, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
                call DzFrameSetPoint(thistype.previewFrame, JN_FRAMEPOINT_TOPLEFT, thistype.topFrame1, JN_FRAMEPOINT_BOTTOMLEFT, 0, 0)
                call DzFrameSetPoint(thistype.bannerFrame, JN_FRAMEPOINT_TOPLEFT, thistype.previewFrame, JN_FRAMEPOINT_BOTTOMLEFT, 0, 0)
                call DzFrameSetPoint(thistype.inventoryTopFrame, JN_FRAMEPOINT_TOPLEFT, thistype.previewFrame, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
                call DzFrameSetPoint(thistype.inventoryBottomFrame, JN_FRAMEPOINT_TOPLEFT, thistype.inventoryTopFrame, JN_FRAMEPOINT_BOTTOMLEFT, 0, 0)
                call DzFrameSetAbsolutePoint(thistype.skinFrame, JN_FRAMEPOINT_BOTTOM, thistype.posX + skinOffsetX, thistype.posY + skinOffsetY)

                call DzFrameShow(thistype.topFrame1, false)
                call DzFrameShow(thistype.topFrame2, false)
                call DzFrameShow(thistype.topFrame3, false)
                call DzFrameShow(thistype.previewFrame, false)
                call DzFrameShow(thistype.bannerFrame, false)
                call DzFrameShow(thistype.inventoryTopFrame, false)
                call DzFrameShow(thistype.inventoryBottomFrame, false)
                call DzFrameShow(thistype.skinFrame, false)
            endif

            set this.playerId = playerId
            set this.skinAnimation = SkinAnimation(SkinAnimationList[0]).Clone()
            set this.nameUI = NameUI.create(playerId, thistype.posX + nameOffsetX, thistype.posY + nameOffsetY)

            return this
        endmethod
    endstruct

    private struct ButtonUI
        private static integer frame = 0
        private static integer dummyFrame = 0
        private static constant real size = 0.025
        private static constant real posX = 0.77
        private static constant real posY = 0.495
        private static constant string normalTexture = "SkinUIOpenButtonNormal.blp"
        private static constant string pressedTexture = "SkinUIOpenButtonPressed.blp"
        private static constant string mouseOverTexture = "SkinUIOpenButtonMouseOver.blp"
        private integer playerId
        private boolean isPressed = false
        private boolean isOpen = false

        public method Contains takes real posX, real posY returns boolean
            // 워크 화면상의 절대좌표
            local real minX = 0.745
            local real maxX = 0.795
            local real minY = 0.486
            local real maxY = 0.508
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        public method ButtonDown takes real posX, real posY returns nothing
            if this.Contains(posX, posY) then
                set this.isPressed = true
                if GetLocalPlayer() == Player(this.playerId) then
                    call DzFrameSetTexture(thistype.frame, thistype.pressedTexture, 0)
                endif
            endif
        endmethod

        public method ButtonUp takes nothing returns nothing
            set this.isPressed = false

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameSetTexture(thistype.frame, thistype.normalTexture, 0)
            endif
        endmethod

        public method ChangeOfStatus takes boolean isOpen returns nothing
            set this.isOpen = isOpen
        endmethod

        private method MouseOver takes real posX, real posY returns nothing
            if this.isOpen == true or this.isPressed then
                return
            endif

            if this.Contains(posX, posY) then
                call DzFrameSetTexture(thistype.frame, thistype.mouseOverTexture, 0)
            else
                call DzFrameSetTexture(thistype.frame, thistype.normalTexture, 0)
            endif
        endmethod

        private static method MouseOverEvent takes nothing returns nothing
            local thistype this = GetPlayerId(GetLocalPlayer()) + 1
            call this.MouseOver(GetMouseFrameX(DzGetMouseXRelative()), GetMouseFrameY(DzGetMouseYRelative()))
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()
            set this.playerId = playerId
            return this
        endmethod

        public static method onInit takes nothing returns nothing
            set thistype.frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            call DzFrameSetTexture(thistype.frame, thistype.normalTexture, 0)
            call DzFrameSetSize(thistype.frame, thistype.size * 2.1, thistype.size)
            call DzFrameSetAbsolutePoint(thistype.frame, JN_FRAMEPOINT_CENTER, thistype.posX, thistype.posY)

            set thistype.dummyFrame = DzCreateFrameByTagName("BUTTON", "", DzGetGameUI(), "", 0)
            call DzFrameSetSize(thistype.dummyFrame, thistype.size * 2.1, thistype.size)
            call DzFrameSetAbsolutePoint(thistype.dummyFrame, JN_FRAMEPOINT_CENTER, thistype.posX, thistype.posY)

            call DzFrameSetScriptByCode(thistype.dummyFrame, JN_FRAMEEVENT_MOUSE_ENTER, function thistype.MouseOverEvent, false)
            call DzFrameSetScriptByCode(thistype.dummyFrame, JN_FRAMEEVENT_MOUSE_LEAVE, function thistype.MouseOverEvent, false)

            call DzFrameShow(thistype.dummyFrame, true)
            call DzFrameShow(thistype.frame, true)
        endmethod
    endstruct
    
    private struct PlayerSkinSelect
        private ButtonUI buttonUI
        private SkinSelectWindow skinSelectWindow
        private boolean isOpen = false

        private method Open takes nothing returns nothing
            set this.isOpen = true
            call this.buttonUI.ChangeOfStatus(this.isOpen)
            call this.skinSelectWindow.Show()
        endmethod

        private method Close takes nothing returns nothing
            set this.isOpen = false
            call this.buttonUI.ChangeOfStatus(this.isOpen)
            call this.skinSelectWindow.Hide()
        endmethod

        public method ClickDown takes real posX, real posY returns nothing
            if this.isOpen == false then
                call this.buttonUI.ButtonDown(posX, posY)
            elseif this.skinSelectWindow.CloseButtonContains(posX, posY) then
                call this.Close()
            endif
        endmethod

        public method ClickUp takes real posX, real posY returns nothing
            if this.isOpen == false then
                call this.buttonUI.ButtonUp()
                if this.buttonUI.Contains(posX, posY) then
                    call this.Open()
                endif
            endif
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()
            set this.buttonUI = ButtonUI.create(playerId)
            set this.skinSelectWindow = SkinSelectWindow.create(playerId)
            return this
        endmethod
    endstruct

    globals
        private PlayerSkinSelect array PlayerSkinUI[PLAYER_MAXINUM]
    endglobals
    

    //! runtextmacro Make_ButtonMouseEvent_Top("MouseClickDown")
        call PlayerSkinUI[i].ClickDown(GetMouseFrameX(DzGetMouseXRelative()), GetMouseFrameY(DzGetMouseYRelative()))
    //! runtextmacro Make_ButtonMouseEvent_Bottom("MouseClickDown")

    //! runtextmacro Make_ButtonMouseEvent_Top("MouseClickUp")
        call PlayerSkinUI[i].ClickUp(GetMouseFrameX(DzGetMouseXRelative()), GetMouseFrameY(DzGetMouseYRelative()))
    //! runtextmacro Make_ButtonMouseEvent_Bottom("MouseClickUp")


    private function InitSkinAnimationList takes nothing returns nothing
        local SkinAnimation skin
        
        set SkinAnimationList = sList.create()

        set skin = SkinAnimation.create(0.250, "Mushroom")
        call skin.AddMotion("Mushroom001.blp")
        call skin.AddMotion("Mushroom002.blp")
        call SkinAnimationList.add(skin)

        set skin = SkinAnimation.create(0.125, "Meso")
        call skin.AddMotion("Meso001.blp")
        call skin.AddMotion("Meso002.blp")
        call skin.AddMotion("Meso004.blp")
        call skin.AddMotion("Meso003.blp")
        call SkinAnimationList.add(skin)
    endfunction

    private function Init takes nothing returns nothing
        local integer i
        call InitSkinAnimationList()

        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                set PlayerSkinUI[i] = PlayerSkinSelect.create(i)
            endif
        //! runtextmacro for_end("set i = i + 1")
        
    endfunction
endlibrary

//! textmacro Make_ButtonMouseEvent_Top takes funcName
    globals
        private key $funcName$Key
    endglobals

    public function $funcName$ takes nothing returns nothing
        call DzSyncData(I2S($funcName$Key), R2S(DzGetMouseXRelative())+", "+R2S(DzGetMouseYRelative()))
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
        public static method onInit takes nothing returns nothing
            local trigger t = CreateTrigger()
            call DzTriggerRegisterSyncData(t, I2S($funcName$Key), false)
            call TriggerAddAction(t, function $funcName$Sync)
            set t = null
        endmethod
    endstruct
//! endtextmacro
