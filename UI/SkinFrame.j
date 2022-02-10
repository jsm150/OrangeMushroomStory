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
        private static constant real size = 0.046
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
            call DzFrameSetAbsolutePoint(this.frame, JN_FRAMEPOINT_CENTER, this.posX, this.posY)
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

    private struct SkinPreviewBackgroundUI
        private static constant real size = 0.17
        private static constant real posX = 0.665
        private static constant real posY = 0.3
        private static string array motionList[3]
        private static integer frame
        private integer currentFileIdx = 0
        private boolean isShow = false
        private SkinPreviewUI skinUI = 0
        private integer playerId

        public method Show takes nothing returns nothing
            set this.isShow = true
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.frame, this.isShow)
            endif
            call this.skinUI.Move(thistype.posX, thistype.posY - 0.01)
            call this.skinUI.Show()
        endmethod

        public method Hide takes nothing returns nothing
            set this.isShow = false
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

            set this.playerId = playerId
            set this.skinUI = SkinPreviewUIBuilder.Build("Mushroom", playerId)

            call DzFrameSetSize(this.frame, thistype.size, thistype.size)
            call DzFrameSetAbsolutePoint(this.frame, JN_FRAMEPOINT_CENTER, thistype.posX, thistype.posY)
            call DzFrameSetTexture(this.frame, thistype.motionList[this.currentFileIdx + 1], 0)

            call DzFrameShow(this.frame, this.isShow)

            return this
        endmethod

        public static method onInit takes nothing returns nothing
            set thistype.frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.motionList[0] = "PreviewBackground001.blp"
            set thistype.motionList[1] = "PreviewBackground002.blp"
            set thistype.motionList[2] = "PreviewBackground003.blp"
        endmethod
    endstruct

    private struct SkinUI
        private SkinPreviewBackgroundUI preview
        private integer plyaerId

        public method Open takes nothing returns nothing
            call this.preview.Show()
        endmethod

        public method Close takes nothing returns nothing
            call this.preview.Hide()
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()
            set this.plyaerId = playerId
            set this.preview = SkinPreviewBackgroundUI.create(playerId)
            return this
        endmethod
    endstruct


    globals
        private SkinUI array PlayerSkinUI[PLAYER_MAXINUM]
    endglobals

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

        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            set PlayerSkinUI[i] = SkinUI.create(i)
        //! runtextmacro for_end("set i = i + 1")

        call PlayerSkinUI[0].Open()

    endfunction
endscope