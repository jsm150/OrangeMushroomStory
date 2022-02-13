scope SkinFrame initializer Init

    private struct SkinAnimation
        private static hashtable motionList = InitHashtable()
        private string name
        private integer fileCount = 0
        private integer currentIdx = 0
        private real motionDelay
        private tick timer
        private boolean playing = false
        
        private static method ChangeAnimation takes nothing returns nothing
            local tick t = tick.getExpired()
            local thistype this = t.data
            local integer frame = t.data2

            if this.playing == false then
                return
            endif

            call DzFrameSetTexture(frame, LoadStr(thistype.motionList, this, currentIdx), 0)

            set this.currentIdx = this.currentIdx + 1
            if this.currentIdx >= this.fileCount then
                set this.currentIdx = 0
            endif

            call this.timer.start(this.motionDelay, false, function thistype.ChangeAnimation)
        endmethod

        public method Run takes integer frame returns nothing
            set this.playing = true
            set this.timer.data2 = frame
            call this.timer.start(0, false, function thistype.ChangeAnimation)
        endmethod

        public method Stop takes integer frame returns nothing
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
            set this.timer = tick.create(this)
            return this
        endmethod

        public method destroy takes nothing returns nothing
            call FlushChildHashtable(thistype.motionList, this)
            call this.timer.destroy()
            call thistype.deallocate(this)
        endmethod
    endstruct

    //! runtextmacro Make_LinkedList("SkinAnimation", "0")

    globals
        private SkinAnimationLinkedList SkinAnimationList
    endglobals

    private struct SkinPreviewUI
        private static constant real size = 0.044
        private integer frame
        private real posX = 0
        private real posY = 0
        private boolean isShow = false
        private SkinAnimation skinAnimation
        private integer playerId


        public method Hide takes nothing returns nothing
            set this.isShow = false
            call skinAnimation.Stop(this.frame)
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, this.isShow)
            endif
        endmethod

        public method Show takes nothing returns nothing
            set this.isShow = true
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, this.isShow)
            endif
            call skinAnimation.Run(this.frame)
        endmethod

        public method Move takes real posX, real posY returns nothing
            set this.posX = posX
            set this.posY = posY
            call DzFrameSetAbsolutePoint(this.frame, JN_FRAMEPOINT_BOTTOM, this.posX, this.posY)
        endmethod

        public method Clone takes nothing returns thistype
            return thistype.create(this.skinAnimation.Clone(), this.playerId)
        endmethod

        public method Equals takes string name returns boolean
            return this.skinAnimation.Equals(name)
        endmethod

        public static method create takes SkinAnimation skinAnimation, integer playerId returns thistype
            local thistype this = thistype.allocate()

            set this.frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set this.playerId = playerId
            set this.skinAnimation = skinAnimation

            call DzFrameSetSize(this.frame, this.size, this.size)
            call DzFrameShow(this.frame, this.isShow)

            return this
        endmethod

        public method destroy takes nothing returns nothing
            call this.Hide()
            call this.skinAnimation.destroy()
            call DzDestroyFrame(this.frame)
            call thistype.deallocate(this)
        endmethod
    endstruct

    private struct SkinPreviewUIBuilder
        public static method Build takes string name, integer playerId returns SkinPreviewUI
            local SkinAnimationNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "SkinAnimationList")
                if node.Item.Equals(name) then
                    return SkinPreviewUI.create(node.Item.Clone(), playerId)
                endif
            //! runtextmacro LinkedList_Foreach_Bottom()
            return 0
        endmethod
    endstruct

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

    private struct SkinPreviewBackgroundUI
        private static constant real size = 0.17
        private static constant real posX = 0.20
        private static constant real posY = 0.45
        private static string array motionList[3]
        private static integer frame = 0
        private integer currentFileIdx = 0
        private boolean isShow = false
        private SkinPreviewUI skinUI
        private NameUI nameUI
        private integer playerId

        public method Show takes nothing returns nothing
            local real skinOffsetX = 0
            local real skinOffsetY = -0.033

            set this.isShow = true

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, this.isShow)
            endif

            call this.skinUI.Move(thistype.posX + skinOffsetX, thistype.posY + skinOffsetY)
            call this.skinUI.Show()
            call this.nameUI.Show()
        endmethod

        public method Hide takes nothing returns nothing
            set this.isShow = false
            call this.nameUI.Hide()
            call this.skinUI.Hide()
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, this.isShow)
            endif
        endmethod

        public method ChangeSkin takes SkinPreviewUI skinUI returns nothing
            if this.skinUI != 0 then
                call this.skinUI.destroy()
            endif

            set this.skinUI = skinUI
            
            if this.isShow then
                call this.skinUI.Show()
            endif
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()
            local real nameOffsetX = -0.017
            local real nameOffsetY = -0.036

            if thistype.frame == 0 then
                set thistype.frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                set thistype.motionList[0] = "PreviewBackground001.blp"
                set thistype.motionList[1] = "PreviewBackground002.blp"
                set thistype.motionList[2] = "PreviewBackground003.blp"

                call DzFrameSetSize(thistype.frame, thistype.size, thistype.size)
                call DzFrameSetAbsolutePoint(thistype.frame, JN_FRAMEPOINT_CENTER, thistype.posX, thistype.posY)
                call DzFrameSetTexture(thistype.frame, thistype.motionList[this.currentFileIdx + 2], 0)

                call DzFrameShow(thistype.frame, false)
            endif

            set this.playerId = playerId
            set this.skinUI = SkinPreviewUIBuilder.Build("Mushroom", playerId)
            set this.nameUI = NameUI.create(playerId, thistype.posX + nameOffsetX, thistype.posY + nameOffsetY)

            return this
        endmethod
    endstruct

    private struct SkinOpenButtonUI
        private static integer frame = 0
        private static constant real size = 0.025
        private static constant real posX = 0.77
        private static constant real posY = 0.495
        private static constant string normalTexture = "SkinUIOpenButtonNormal.blp"
        private static constant string pressedTexture = "SkinUIOpenButtonPressed.blp"
        private static constant string mouseOverTexture = "SkinUIOpenButtonMouseOver.blp"
        private SkinPreviewBackgroundUI preview
        private integer playerId
        private boolean isOpen = false
        private boolean isPressed = false

        public method Contains takes real posX, real posY returns boolean
            // 워크 화면상의 절대좌표
            local real minX = 1788
            local real maxX = 1908
            local real minY = 167
            local real maxY = 205
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        public method ClickDown takes real posX, real posY returns nothing
            if this.isOpen == true then
                return
            endif

            if this.Contains(posX, posY) then
                set this.isPressed = true
                if GetLocalPlayer() == Player(this.playerId) then
                    call DzFrameSetTexture(thistype.frame, thistype.pressedTexture, 0)
                endif
            endif
        endmethod

        public method ClickUp takes real posX, real posY returns nothing
            if this.isOpen == true then
                return
            endif

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameSetTexture(thistype.frame, thistype.normalTexture, 0)
            endif
            
            if this.Contains(posX, posY) then
                call this.Open()
            endif

            set this.isPressed = false
        endmethod

        public method MouseOver takes real posX, real posY returns nothing
            if this.isOpen == true then
                return
            endif

            if GetLocalPlayer() == Player(this.playerId) then
                if this.isPressed == false and this.Contains(posX, posY) then
                    call DzFrameSetTexture(thistype.frame, thistype.mouseOverTexture, 0)
                elseif this.isPressed == false then
                    call DzFrameSetTexture(thistype.frame, thistype.normalTexture, 0)
                endif
            endif
        endmethod

        private method Open takes nothing returns nothing
            set this.isOpen = true
            call this.preview.Show()
        endmethod

        public method Close takes nothing returns nothing
            set this.isOpen = false
            call this.preview.Hide()
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()

            if thistype.frame == 0 then
                set thistype.frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                call DzFrameSetTexture(thistype.frame, thistype.normalTexture, 0)
                call DzFrameSetSize(thistype.frame, thistype.size * 2.1, thistype.size)
                call DzFrameSetAbsolutePoint(thistype.frame, JN_FRAMEPOINT_CENTER, thistype.posX, thistype.posY)
                
                call DzFrameShow(thistype.frame, true)
            endif

            set this.playerId = playerId
            set this.preview = SkinPreviewBackgroundUI.create(playerId)
            return this
        endmethod
    endstruct

    globals
        private SkinOpenButtonUI array PlayerSkinUI[PLAYER_MAXINUM]
        private key SkinOpenButtonClickDownKey
        private key SkinOpenButtonClickUpKey
        private key SkinOpenButtonMouseOverKey
    endglobals

    private function SkinOpenButtonClickDown takes nothing returns nothing
        if GetLocalPlayer() == DzGetTriggerKeyPlayer() then
            call DzSyncData(I2S(SkinOpenButtonClickDownKey), R2S(DzGetMouseXRelative())+", "+R2S(DzGetMouseYRelative()))
        endif
    endfunction

    private function SkinOpenButtonClickUp takes nothing returns nothing
        if GetLocalPlayer() == DzGetTriggerKeyPlayer() then
            call DzSyncData(I2S(SkinOpenButtonClickUpKey), R2S(DzGetMouseXRelative())+", "+R2S(DzGetMouseYRelative()))
        endif
    endfunction

    private function SkinOpenButtonClickDownSync takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerKeyPlayer())
        local string s = DzGetTriggerSyncData()
        local real x = S2R(JNStringSplit(s,", ",0))
        local real y = S2R(JNStringSplit(s,", ",1))
        call PlayerSkinUI[i].ClickDown(x, y)
    endfunction

    private function SkinOpenButtonClickUpSync takes nothing returns nothing
        local integer i = GetPlayerId(DzGetTriggerKeyPlayer())
        local string s = DzGetTriggerSyncData()
        local real x = S2R(JNStringSplit(s,", ",0))
        local real y = S2R(JNStringSplit(s,", ",1))
        call PlayerSkinUI[i].ClickUp(x, y)
    endfunction

    // private function SkinOpenButtonMouseOver takes nothing returns nothing
    //     local integer i = GetPlayerId(GetLocalPlayer())
    //     call PlayerSkinUI[i].ClickUp(DzGetMouseXRelative(), DzGetMouseYRelative())
    // endfunction

    private function InitMouseAction takes nothing returns nothing
        local trigger t = CreateTrigger()
        call DzTriggerRegisterSyncData(t, I2S(SkinOpenButtonClickDownKey), false)
        call TriggerAddAction(t, function SkinOpenButtonClickDownSync)

        set t = CreateTrigger()
        call DzTriggerRegisterSyncData(t, I2S(SkinOpenButtonClickUpKey), false)
        call TriggerAddAction(t, function SkinOpenButtonClickUpSync)

        set t = null

        call MouseClick_AddDownAction(function SkinOpenButtonClickDown)
        call MouseClick_AddUpAction(function SkinOpenButtonClickUp)
    endfunction

    private function InitSkinAnimationList takes nothing returns nothing
        local SkinAnimation skin
        
        set SkinAnimationList = SkinAnimationLinkedList.create()

        set skin = SkinAnimation.create(0.250, "Mushroom")
        call skin.AddMotion("Mushroom001.blp")
        call skin.AddMotion("Mushroom002.blp")
        call SkinAnimationList.AddLast(skin)

        set skin = SkinAnimation.create(0.125, "Meso")
        call skin.AddMotion("Meso001.blp")
        call skin.AddMotion("Meso002.blp")
        call skin.AddMotion("Meso004.blp")
        call skin.AddMotion("Meso003.blp")
        call SkinAnimationList.AddLast(skin)
    endfunction

    private function Init takes nothing returns nothing
        local integer i
        call InitSkinAnimationList()
        call InitMouseAction()

        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                set PlayerSkinUI[i] = SkinOpenButtonUI.create(i)
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction
endscope