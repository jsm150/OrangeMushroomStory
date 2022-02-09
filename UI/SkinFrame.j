scope SkinFrame initializer Init

    private struct SkinAnimation
        private static hashtable motionList = InitHashtable()
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

        public method Copy takes nothing returns thistype
            local thistype copy = thistype.create(this.motionDelay)
            local integer i
            //! runtextmacro for("set i = 0", "i < this.fileCount")
                call SaveStr(thistype.motionList, copy, i, LoadStr(thistype.motionList, this, i))
            //! runtextmacro for_end("set i = i + 1")
            return copy
        endmethod

        public method AddMotion takes string motion returns nothing
            call SaveStr(thistype.motionList, this, this.fileCount, motion)
            set this.fileCount = this.fileCount + 1
        endmethod

        public static method create takes real motionDelay returns thistype
            local thistype this = thistype.allocate()
            set this.motionDelay = motionDelay
            set this.timer = tick.create(this)
            return this
        endmethod

        public method destroy takes nothing returns nothing
            call FlushChildHashtable(thistype.motionList, this)
            call this.timer.destroy()
            call thistype.deallocate(this)
        endmethod
    endstruct

    private struct SkinPreviewUI
        private integer frame
        private real size = 0.05
        private real posX
        private real posY
        private boolean isShow = false
        private SkinAnimation skinAnimation


        public method Hide takes nothing returns nothing
            set this.isShow = false
            call skinAnimation.Stop(this.frame)
            call DzFrameShow(this.frame, this.isShow)
        endmethod

        public method Show takes nothing returns nothing
            set this.isShow = true
            call DzFrameShow(this.frame, this.isShow)
            call skinAnimation.Run(this.frame)
        endmethod

        public method Move takes real posX, real posY returns nothing
            set this.posX = posX
            set this.posY = posY
            call DzFrameSetAbsolutePoint(this.frame, JN_FRAMEPOINT_CENTER, this.posX, this.posY)
        endmethod

        public method Copy takes nothing returns thistype
            return thistype.create(this.skinAnimation.Copy())
        endmethod

        public static method create takes SkinAnimation skinAnimation returns thistype
            local thistype this = thistype.allocate()

            set this.frame = DzCreateFrameByTagName("BACKDROP", "SkinPreviewUI", DzGetGameUI(), "", 0)
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

    private struct SkinPreviewBackgroundUI
        private static integer frame
        private static string array motionList[3]
        private static integer currentFileIdx = 0
        private static real size = 0.17
        private static real posX = 0.665
        private static real posY = 0.3
        private static boolean isShow = false
        private static SkinPreviewUI skinUI = 0

        public static method Show takes nothing returns nothing
            set isShow = true
            call DzFrameShow(frame, isShow)
            call skinUI.Show()
        endmethod

        private static method Hide takes nothing returns nothing
            set isShow = false
            call skinUI.Hide()
            call DzFrameShow(frame, isShow)
        endmethod

        public static method ChangeSkin takes SkinPreviewUI skinUI returns nothing
            if thistype.skinUI != 0 then
                call thistype.skinUI.destroy()
            endif

            set thistype.skinUI = skinUI
            call thistype.skinUI.Move(posX, posY - 0.008)
            
            if isShow then
                call thistype.skinUI.Show()
            endif
        endmethod

        public static method onInit takes nothing returns nothing
            set frame = DzCreateFrameByTagName("BACKDROP", "PreviewBackground", DzGetGameUI(), "", 0)
            
            set motionList[0] = "PreviewBackground001.blp"
            set motionList[1] = "PreviewBackground002.blp"
            set motionList[2] = "PreviewBackground003.blp"

            call DzFrameSetSize(frame, size, size)
            call DzFrameSetAbsolutePoint(frame, JN_FRAMEPOINT_CENTER, posX, posY)
            call DzFrameSetTexture(frame, motionList[currentFileIdx], 0)

            call DzFrameShow(frame, isShow)
        endmethod
    endstruct

    private function Main takes nothing returns nothing
        local SkinAnimation skin = SkinAnimation.create(0.250)
        call skin.AddMotion("Mushroom001.blp")
        call skin.AddMotion("Mushroom002.blp")
        call SkinPreviewBackgroundUI.ChangeSkin(SkinPreviewUI.create(skin))


        call SkinPreviewBackgroundUI.Show()
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        
        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Main )        

        set t = null
    endfunction
endscope