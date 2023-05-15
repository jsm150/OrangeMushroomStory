library SkinFrame initializer Init needs TeamColor, TriggerSleepAction
    globals
        private key characterSkinChangeKey
        private key decorateSkinChangeKey
    endglobals

    private struct SkinInfo
        private integer id
        private string name
        private real size
        private real motionDelay
        private integer inventoryClickedEventKey
        private static hashtable motionList = InitHashtable()
        private integer fileCount = 0
        private boolean playing = false

        public method operator Id takes nothing returns integer
            return this.id
        endmethod 

        public method operator Name takes nothing returns string
            return this.name
        endmethod 

        public method operator Size takes nothing returns real
            return this.size
        endmethod 

        public method operator Delay takes nothing returns real
            return this.motionDelay
        endmethod 

        public method operator EventKey takes nothing returns integer
            return this.inventoryClickedEventKey
        endmethod 

        private method ChangeAnimation takes integer frame, integer playerId returns nothing
            local integer currentIdx = 0

            if GetLocalPlayer() == Player(playerId) then
                call DzFrameSetSize(frame, this.size, this.size)
                call DzFrameSetTexture(frame, LoadStr(thistype.motionList, this, currentIdx), 0)
            endif

            loop
                if this.motionDelay == 0 or this.playing == false then
                    return
                endif

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
            if this.playing == false then
                set this.playing = true
                call this.ChangeAnimation.execute(frame, playerId)
            endif
        endmethod

        public method Stop takes nothing returns nothing
            set this.playing = false
        endmethod

        public method ChangeSkin takes integer playerId, SkinSelectWindow window returns nothing
            call Events.Raise(inventoryClickedEventKey, InventoryClickedEvent.create(playerId, this, window))
        endmethod

        public method CopyMotion takes thistype target returns nothing
            local integer i
            //! runtextmacro for("set i = 0", "i < this.fileCount")
                call target.AddMotion(LoadStr(thistype.motionList, this, i))
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public stub method Clone takes nothing returns thistype
            local thistype copy = thistype.create(this.motionDelay, this.name, this.id, this.size, this.inventoryClickedEventKey)
            call this.CopyMotion(copy)
            return copy
        endmethod

        public method AddMotion takes string motion returns nothing
            call SaveStr(thistype.motionList, this, this.fileCount, motion)
            set this.fileCount = this.fileCount + 1
        endmethod

        public method Equals takes integer id returns boolean
            return this.id == id
        endmethod

        public static method create takes real motionDelay, string name, integer id, real size, integer inventoryClickedEventKey returns thistype
            local thistype this = thistype.allocate()
            set this.motionDelay = motionDelay
            set this.name = name
            set this.id = id
            set this.size = size
            set this.inventoryClickedEventKey = inventoryClickedEventKey
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

    private function RegisterSkinOfUser takes integer id returns sList
        local sList skinList = sList.create()
        local integer i = 0

        // 주황 버섯
        call skinList.add(SkinInfo(SkinAnimationList[0]).Clone())

        if User_UserList[id].GetClearCountByWorldId(5) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 1", "i <= 7")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif
        if User_UserList[id].GetClearCountByWorldId(6) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 8", "i <= 14")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif
        if User_UserList[id].GetClearCountByWorldId(7) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 15", "i <= 21")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif
        if User_UserList[id].GetClearCountByWorldId(8) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 22", "i <= 29")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif
        if User_UserList[id].GetClearCountByWorldId(10) >= 1 or DEBUG_MODE then
            call skinList.add(SkinInfo(SkinAnimationList[30]).Clone())
        endif
        if User_UserList[id].GetClearCountByWorldId(12) >= 1 or DEBUG_MODE then
            call skinList.add(SkinInfo(SkinAnimationList[31]).Clone())
        endif
        if User_UserList[id].GetClearCountByWorldId(13) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 32", "i <= 34")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif
        if User_UserList[id].PinkBeanDesignation == 1 or DEBUG_MODE then
            call skinList.add(SkinInfo(SkinAnimationList[35]).Clone())
        endif
        if User_UserList[id].GetClearCountByWorldId(11) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 36", "i <= 39")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif
        if User_UserList[id].GetClearCountByWorldId(9) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 40", "i <= 41")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif

        if User_UserList[id].BellaPet == 1 or DEBUG_MODE then
            call skinList.add(SkinInfo(SkinAnimationList[42]).Clone())
        endif

        if User_UserList[id].LucidSoul == 1 or DEBUG_MODE then
            call skinList.add(SkinInfo(SkinAnimationList[43]).Clone())
        endif

        if User_UserList[id].GetClearCountByWorldId(14) >= 1 or DEBUG_MODE then
            //! runtextmacro for("set i = 44", "i <= 49")
                call skinList.add(SkinInfo(SkinAnimationList[i]).Clone())
            //! runtextmacro for_end("set i = i + 1")
        endif

        if User_UserList[id].SpiritPendant == 1 then
            call skinList.add(SkinInfo(SkinAnimationList[50]).Clone())
        endif

        return skinList
    endfunction
    
    private struct DecorateSkin
        private real offsetX
        private real offsetY
        private integer decorateType
        private integer skinFrame
        private integer priority
        private SkinInfo motion

        public method GetType takes nothing returns integer
            return decorateType
        endmethod

        public method operator Id takes nothing returns integer
            return motion.Id
        endmethod

        public method operator Priority takes nothing returns integer
            return this.priority
        endmethod

        public method Equals takes integer unitId returns boolean
            return motion.Equals(unitId)
        endmethod

        public method ReCreate takes nothing returns nothing
            local SkinInfo temp = this.motion
            call DzDestroyFrame(this.skinFrame)
            set this.skinFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set this.motion = temp.Clone()
            call temp.destroy()
        endmethod

        public method RunAnimation takes integer playerId, integer refFrame returns nothing
            if GetLocalPlayer() == Player(playerId) then
                call DzFrameSetPoint(this.skinFrame, JN_FRAMEPOINT_CENTER, refFrame, JN_FRAMEPOINT_CENTER, this.offsetX, this.offsetY)
                call DzFrameShow(this.skinFrame, true)
            endif
            call motion.Run(this.skinFrame, playerId)
        endmethod

        public method Stop takes integer playerId returns nothing
            if GetLocalPlayer() == Player(playerId) then
                call DzFrameShow(this.skinFrame, false)
            endif
            call motion.Stop()
        endmethod

        public method operator == takes thistype dst returns boolean
            return this.priority == dst.priority
        endmethod

        public method operator < takes thistype dst returns boolean
            return this.priority < dst.priority
        endmethod

        public static method create takes real offsetX, real offsetY, integer decorateType, integer priority, SkinInfo motion returns thistype
            local thistype this = thistype.allocate()
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.decorateType = decorateType
            set this.skinFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set this.priority = priority
            set this.motion = motion
            return this
        endmethod

        public method destroy takes nothing returns nothing
            call DzDestroyFrame(this.skinFrame)
            call motion.destroy()
            call thistype.deallocate(this)
        endmethod
    endstruct

    private struct DecorateSkinInfo extends SkinInfo
        private real offsetX
        private real offsetY
        private integer decorateType
        private integer priority

        public method operator Type takes nothing returns integer
            return this.decorateType
        endmethod

        public method Clone takes nothing returns thistype
            local thistype copy = thistype.create(this.Delay, this.Name, this.Id, this.Size, /*
                */ this.offsetX, this.offsetY, this.decorateType, this.priority, this.EventKey)
            call this.CopyMotion(copy)
            return copy
        endmethod

        public method CreateDecorateSkin takes nothing returns DecorateSkin
            return DecorateSkin.create(this.offsetX, this.offsetY, this.decorateType, this.priority, this.Clone())
        endmethod

        public static method create takes real motionDelay, string name, integer id, real size, /*
            */ real offsetX, real offsetY, integer decorateType, integer priority, integer inventoryClickedEventKey returns thistype

            local thistype this = thistype.allocate(motionDelay, name, id, size, inventoryClickedEventKey)
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.decorateType = decorateType
            set this.priority = priority
            return this
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

    private struct Inventory
        private static constant integer size = 20
        private static integer array framePool[thistype.size]
        private static real maxX = 0.385
        private static real minX = 0.340
        private static real minY = 0.388
        private static real maxY = 0.446
        private static real offsetX = 0.051
        private static real offsetY = -0.063
        private integer page = 1
        private integer lastPage
        private boolean hasCoolDown = false
        private integer playerId
        private integer currentPageLetter
        private integer maxPageLetter
        private integer goldLeafLetter
        private sList skinList

        private method MousePosInInventory takes real posX, real posY, integer itemIdx returns boolean
            local real offsetX = thistype.offsetX * ModuloInteger(itemIdx, 5)
            local real offsetY = thistype.offsetY * R2I(itemIdx / 5)
            return posX >= minX + offsetX and posX <= maxX + offsetX /*
                */ and posY >= minY + offsetY and posY <= maxY + offsetY
        endmethod

        private method HasSkinInInventory takes integer itemIdx returns boolean
            return (page - 1) * thistype.size + itemIdx < skinList.size
        endmethod

        private method ChangeSkin takes integer itemIdx, SkinSelectWindow window returns nothing
            local SkinInfo skin = this.skinList[(page - 1) * thistype.size + itemIdx]
            call skin.ChangeSkin(this.playerId, window)
        endmethod

        private method CoolDownTime takes nothing returns nothing
            set this.hasCoolDown = true
            call TriggerSleepActionByTimer(0.1)
            set this.hasCoolDown = false
        endmethod

        public method ClickDown takes real posX, real posY, SkinSelectWindow window returns nothing
            local integer i = 0

            if this.hasCoolDown then
                return
            endif

            //! runtextmacro for("set i = 0", "i < thistype.size")
                if MousePosInInventory(posX, posY, i) and HasSkinInInventory(i) then
                    call this.CoolDownTime.execute()
                    call ChangeSkin(i, window)
                    return
                endif
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Show takes nothing returns nothing
            local integer skinIdx
            local integer frameIdx
            local integer max = thistype.size * this.page
            local string money = User_UserList[this.playerId].GoldLeaf.ToString()

            if max > this.skinList.size then
                set max = this.skinList.size
            endif

            set frameIdx = 0
            //! runtextmacro for("set skinIdx = thistype.size * (this.page - 1)", "skinIdx < max")
                call SkinInfo(this.skinList[skinIdx]).Run(thistype.framePool[frameIdx], playerId)
                if GetLocalPlayer() == Player(this.playerId) then
                    call DzFrameShow(thistype.framePool[frameIdx], true)
                endif
                set frameIdx = frameIdx + 1
            //! runtextmacro for_end("set skinIdx = skinIdx + 1")

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.maxPageLetter, true)
                call DzFrameShow(this.currentPageLetter, true)
                call DzFrameSetText(this.goldLeafLetter, "|cffffffff" + money + "        ")
                call DzFrameShow(this.goldLeafLetter, true)
            endif
        endmethod

        public method Hide takes nothing returns nothing
            local integer skinIdx
            local integer frameIdx
            local integer max = thistype.size * this.page

            if max > this.skinList.size then
                set max = this.skinList.size
            endif

            set frameIdx = 0
            //! runtextmacro for("set skinIdx = thistype.size * (this.page - 1)", "skinIdx < max")
                call SkinInfo(this.skinList[skinIdx]).Stop()
                if GetLocalPlayer() == Player(this.playerId) then
                    call DzFrameShow(thistype.framePool[frameIdx], false)
                endif
                set frameIdx = frameIdx + 1
            //! runtextmacro for_end("set skinIdx = skinIdx + 1")

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.maxPageLetter, false)
                call DzFrameShow(this.currentPageLetter, false)
                call DzFrameShow(this.goldLeafLetter, false)
            endif
        endmethod

        private method CurrentPageLetterSetting takes nothing returns nothing
            if GetLocalPlayer() == Player(playerId) then
                call DzFrameSetText(this.currentPageLetter, I2S(this.page) + "        ")
            endif
        endmethod
        
        public method NextPage takes nothing returns nothing
            if this.page >= this.lastPage then
                return
            endif

            call this.Hide()
            set this.page = this.page + 1
            call this.CurrentPageLetterSetting()
            call this.Show()
        endmethod

        public method PrevPage takes nothing returns nothing
            if this.page <= 1 then
                return
            endif

            call this.Hide()
            set this.page = this.page - 1
            call this.CurrentPageLetterSetting()
            call this.Show()
        endmethod

        private method InventoryInit takes nothing returns nothing
            set this.skinList = RegisterSkinOfUser(this.playerId)
            set this.lastPage = R2I((this.skinList.size - 1) / thistype.size) + 1
            call DzFrameSetText(this.maxPageLetter, I2S(this.lastPage) + "        ")
        endmethod

        private method BringUserSkinData takes nothing returns nothing
            if this.playerId == Events.GetEventArgs(User_ReconnectedEventKey) then
                call this.InventoryInit()
            endif
        endmethod

        private method ItemAdd takes nothing returns nothing
            if this.playerId == StorageItemsBuyEvent(Events.GetEventArgs(StorageItemsBuyEventKey)).PlayerId then
                call this.InventoryInit()
            endif
        endmethod

        public static method create takes sList skinList, integer playerId returns thistype
            local thistype this = thistype.allocate()
            local real offsetY = -0.0045
            local integer i

            if thistype.framePool[0] == 0 then
                //! runtextmacro for("set i = 0", "i < thistype.size")
                    set thistype.framePool[i] = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
                    call DzFrameShow(thistype.framePool[i], false)
                    call DzFrameSetAbsolutePoint(thistype.framePool[i], JN_FRAMEPOINT_CENTER, /*
                        */ (thistype.minX + thistype.maxX) / 2 + thistype.offsetX * ModuloInteger(i, 5), /*
                        */ (thistype.minY + thistype.maxY) / 2 + offsetY + thistype.offsetY * R2I(i / 5) /*
                */  )
                //! runtextmacro for_end("set i = i + 1")
            endif
            
            set this.skinList = skinList
            set this.playerId = playerId
            set this.lastPage = R2I((this.skinList.size - 1) / thistype.size) + 1

            set this.maxPageLetter = DzCreateFrameByTagName("TEXT", "", DzGetGameUI(), "LadderNameTextTemplate", 0)
            
            call DzFrameSetFont(this.maxPageLetter, "Fonts\\DFHeiMd.ttf", 0.014, 0)
            call DzFrameSetEnable(this.maxPageLetter, false)
            call DzFrameSetAbsolutePoint(this.maxPageLetter, JN_FRAMEPOINT_TOPLEFT, 0.365, 0.1497)
            call DzFrameShow(this.maxPageLetter, false)
            
            set this.currentPageLetter = DzCreateFrameByTagName("TEXT", "", DzGetGameUI(), "LadderNameTextTemplate", 0)
            call DzFrameSetFont(this.currentPageLetter, "Fonts\\DFHeiMd.ttf", 0.014, 0)
            call DzFrameSetEnable(this.currentPageLetter, false)
            call DzFrameSetAbsolutePoint(this.currentPageLetter, JN_FRAMEPOINT_TOPLEFT, 0.344, 0.1497)
            call DzFrameShow(this.currentPageLetter, false)

            set this.goldLeafLetter = DzCreateFrameByTagName("TEXT", "", DzGetGameUI(), "", 0)
            call DzFrameSetFont(this.goldLeafLetter, "Fonts\\DFHeiMd.ttf", 0.014, 0)
            call DzFrameSetEnable(this.goldLeafLetter, false)
            call DzFrameSetAbsolutePoint(this.goldLeafLetter, JN_FRAMEPOINT_TOPLEFT, 0.514, 0.5319)
            call DzFrameShow(this.goldLeafLetter, false)

            if GetLocalPlayer() == Player(playerId) then
                call DzFrameSetText(this.maxPageLetter, I2S(this.lastPage) + "        ")
                call DzFrameSetText(this.currentPageLetter, "1        ")
            endif

            call Events.Add(User_ReconnectedEventKey, this, this.BringUserSkinData)
            call Events.Add(StorageItemsBuyEventKey, this, this.ItemAdd)

            return this
        endmethod
    endstruct

    struct SkinSelectWindow
        private static constant real size = 0.27
        private static constant real posX = 0.06
        private static constant real posY = 0.55
        private static constant integer characterPriority = 1
        private static integer topFrame1 = 0
        private static integer topFrame2 = 0
        private static integer topFrame3 = 0
        private static integer previewFrame = 0
        private static integer bannerFrame = 0
        private static integer inventoryTopFrame = 0
        private static integer inventoryBottomFrame = 0
        private integer skinFrame
        private sList decorateSkinFrameList
        private boolean isShow = false
        private SkinInfo skinAnimation
        private Inventory inventory
        private NameUI nameUI
        private integer playerId

        public static method operator CharacterPriority takes nothing returns integer
            return thistype.characterPriority
        endmethod

        private static method CreateSkinFrame takes nothing returns integer
            local real skinOffsetX = 0.145
            local real skinOffsetY = -0.2052
            local integer frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            call DzFrameSetAbsolutePoint(frame, JN_FRAMEPOINT_BOTTOM, thistype.posX + skinOffsetX, thistype.posY + skinOffsetY)
            return frame
        endmethod

        public method MousePosInCloseButton takes real posX, real posY returns boolean
            // 워크 화면상의 절대좌표
            local real minX = 0.570
            local real maxX = 0.592
            local real minY = 0.515
            local real maxY = 0.539
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        private method MousePosInPageDown takes real posX, real posY returns boolean
            local real minX = 0.504
            local real maxX = 0.538
            local real minY = 0.145
            local real maxY = 0.187
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        private method MousePosInPageUp takes real posX, real posY returns boolean
            local real minX = 0.544
            local real maxX = 0.580
            local real minY = 0.145
            local real maxY = 0.187
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        public method ClickDown takes real posX, real posY returns nothing
            call this.inventory.ClickDown(posX, posY, this)
            if this.MousePosInPageDown(posX, posY) then
                call this.inventory.PrevPage()
            elseif this.MousePosInPageUp(posX, posY) then
                call this.inventory.NextPage()
            endif
        endmethod

        private method DecorateSkinRun takes nothing returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < decorateSkinFrameList.size")
                call DecorateSkin(decorateSkinFrameList[i]).RunAnimation(this.playerId, this.skinFrame)
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        private method DecorateSkinStop takes nothing returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < decorateSkinFrameList.size")
                call DecorateSkin(decorateSkinFrameList[i]).Stop(this.playerId)
            //! runtextmacro for_end("set i = i + 1")
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

            call this.skinAnimation.Run(this.skinFrame, this.playerId)
            call this.DecorateSkinRun()
            call this.nameUI.Show()
            call this.inventory.Show()
        endmethod

        public method Hide takes nothing returns nothing
            set this.isShow = false

            call this.inventory.Hide()
            call this.skinAnimation.Stop()
            call this.nameUI.Hide()
            call this.DecorateSkinStop()

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

        public method ChangeSkin takes SkinInfo skinAnimation returns nothing
            call this.skinAnimation.destroy()
            set this.skinAnimation = skinAnimation
            if this.isShow then
                call this.skinAnimation.Run(this.skinFrame, this.playerId)
            endif
        endmethod

        private method FramePrioritySetting takes nothing returns nothing
            local integer i = 0
            local SkinInfo temp = 0

            call this.decorateSkinFrameList.sort(true)

            //! runtextmacro for("set i = 0", "i < decorateSkinFrameList.size")
                if DecorateSkin(decorateSkinFrameList[i]).Priority > thistype.characterPriority then
                    exitwhen true
                endif
                call DecorateSkin(decorateSkinFrameList[i]).Stop(this.playerId)
                call DecorateSkin(decorateSkinFrameList[i]).ReCreate()
            //! runtextmacro for_end("set i = i + 1")

            call this.skinAnimation.Stop()

            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.skinFrame, false)
            endif
            call DzDestroyFrame(this.skinFrame)
            set this.skinFrame = thistype.CreateSkinFrame()
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.skinFrame, true)
            endif

            set temp = this.skinAnimation
            set this.skinAnimation = temp.Clone()
            call temp.destroy()
            call this.skinAnimation.Run(this.skinFrame, this.playerId)

            //! runtextmacro for("", "i < decorateSkinFrameList.size")
                call DecorateSkin(decorateSkinFrameList[i]).Stop(this.playerId)
                call DecorateSkin(decorateSkinFrameList[i]).ReCreate()
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method ChangeDecorateSkin takes DecorateSkin decorateSkin returns nothing
            local integer i = 0
            local DecorateSkin skin

            //! runtextmacro for("set i = 0", "i < decorateSkinFrameList.size")
                if DecorateSkin(decorateSkinFrameList[i]).Equals(decorateSkin.Id) then
                    set skin = decorateSkinFrameList[i]
                    call decorateSkinFrameList.remove(skin)
                    call skin.destroy()
                    call decorateSkin.destroy()
                    call this.DecorateSkinRun()
                    return
                endif
                if DecorateSkin(decorateSkinFrameList[i]).GetType() == decorateSkin.GetType() then
                    set skin = decorateSkinFrameList[i]
                    call decorateSkinFrameList.remove(skin)
                    call skin.destroy()
                    call decorateSkinFrameList.add(decorateSkin)
                    call this.DecorateSkinRun()
                    return
                endif
            //! runtextmacro for_end("set i = i + 1")
            call decorateSkinFrameList.add(decorateSkin)
            call this.FramePrioritySetting()
            call this.DecorateSkinRun()
        endmethod

        public static method create takes integer playerId, sList skinList returns thistype
            local thistype this = thistype.allocate()
            local real nameOffsetX = 0.128
            local real nameOffsetY = -0.2082
            
            set this.skinFrame = thistype.CreateSkinFrame()
            call DzFrameShow(this.skinFrame, false)

            set this.playerId = playerId
            set this.inventory = Inventory.create(skinList, playerId)
            set this.skinAnimation = SkinInfo(SkinAnimationList[0]).Clone()
            set this.nameUI = NameUI.create(playerId, thistype.posX + nameOffsetX, thistype.posY + nameOffsetY)
            set this.decorateSkinFrameList = sList.create()

            return this
        endmethod

        private static method onInit takes nothing returns nothing
            set thistype.topFrame1 = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.topFrame2 = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.topFrame3 = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.previewFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.bannerFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.inventoryTopFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.inventoryBottomFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)

            call DzFrameSetSize(thistype.topFrame1, thistype.size * 0.222, thistype.size * 0.185)
            call DzFrameSetSize(thistype.topFrame2, thistype.size - thistype.size * 0.222, thistype.size * 0.185)
            call DzFrameSetSize(thistype.topFrame3, thistype.size, thistype.size * 0.185)
            call DzFrameSetSize(thistype.previewFrame, thistype.size, thistype.size * 0.8074)
            call DzFrameSetSize(thistype.bannerFrame, thistype.size, thistype.size * 1.4 - thistype.size * 0.8074)
            call DzFrameSetSize(thistype.inventoryTopFrame, thistype.size, thistype.size * 0.67)
            call DzFrameSetSize(thistype.inventoryBottomFrame, thistype.size, thistype.size * 1.4 - thistype.size * 0.67)

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

            call DzFrameShow(thistype.topFrame1, false)
            call DzFrameShow(thistype.topFrame2, false)
            call DzFrameShow(thistype.topFrame3, false)
            call DzFrameShow(thistype.previewFrame, false)
            call DzFrameShow(thistype.bannerFrame, false)
            call DzFrameShow(thistype.inventoryTopFrame, false)
            call DzFrameShow(thistype.inventoryBottomFrame, false)
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

        public method Hide takes nothing returns nothing
            call DzFrameShow(thistype.frame, false)
        endmethod

        public method Show takes nothing returns nothing
            call DzFrameShow(thistype.frame, true)
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
            call this.MouseOver(GetMouseFrameX.evaluate(DzGetMouseXRelative()), GetMouseFrameY.evaluate(DzGetMouseYRelative()))
        endmethod

        public static method create takes integer playerId returns thistype
            local thistype this = thistype.allocate()
            set this.playerId = playerId
            return this
        endmethod

        private static method onInit takes nothing returns nothing
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

        public method IsOpen takes nothing returns boolean
            return this.isOpen
        endmethod

        private method Open takes nothing returns nothing
            set this.isOpen = true
            call this.buttonUI.ChangeOfStatus(this.isOpen)
            call this.skinSelectWindow.Show()
        endmethod

        public method Close takes nothing returns nothing
            if this.isOpen then
                set this.isOpen = false
                call this.buttonUI.ChangeOfStatus(this.isOpen)
                call this.skinSelectWindow.Hide()
            endif
        endmethod

        public method ClickDown takes real posX, real posY returns nothing
            if this.isOpen == false then
                call this.buttonUI.ButtonDown(posX, posY)
                return
            endif
            if this.skinSelectWindow.MousePosInCloseButton(posX, posY) then
                call this.Close()
            endif
            call this.skinSelectWindow.ClickDown(posX, posY)
        endmethod

        public method ClickUp takes real posX, real posY returns nothing
            if this.isOpen == false then
                call this.buttonUI.ButtonUp()
                if this.buttonUI.Contains(posX, posY) then
                    call this.Open()
                endif
            endif
        endmethod

        public method HotKey takes nothing returns nothing
            if this.isOpen == false then
                call this.Open()
            else
                call this.Close()
            endif
        endmethod

        public method ShowButton takes nothing returns nothing
            call this.buttonUI.Show()
        endmethod

        public method HideButton takes nothing returns nothing
            call this.buttonUI.Hide()
        endmethod

        public static method create takes integer playerId, sList skinList returns thistype
            local thistype this = thistype.allocate()
            set this.buttonUI = ButtonUI.create(playerId)
            set this.skinSelectWindow = SkinSelectWindow.create(playerId, skinList)
            return this
        endmethod
    endstruct

    struct InventoryClickedEvent
        private integer id
        private SkinInfo skinInfo
        private SkinSelectWindow skinSelectWindow

        public method operator Id takes nothing returns integer
            return this.id
        endmethod

        public method operator Skin takes nothing returns SkinInfo
            return this.skinInfo
        endmethod

        public method operator Window takes nothing returns SkinSelectWindow
            return this.skinSelectWindow
        endmethod
        
        public static method create takes integer id, SkinInfo skinInfo, SkinSelectWindow skinSelectWindow returns thistype
            local thistype this = thistype.allocate()
            set this.id = id
            set this.skinInfo = skinInfo
            set this.skinSelectWindow = skinSelectWindow
            return this
        endmethod
    endstruct

    private struct DecorateSkinChange
        public method Apply takes nothing returns nothing
            local InventoryClickedEvent ev = Events.GetEventArgs(decorateSkinChangeKey)
            local integer id = ev.Id
            local DecorateSkinInfo skin = ev.Skin
            local SkinSelectWindow window = ev.Window

            call Decorate_AddDecorate(id, skin.Id, skin.Type)
            call window.ChangeDecorateSkin(skin.CreateDecorateSkin())

            call ev.destroy()
        endmethod

        public static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            call Events.Add(decorateSkinChangeKey, this, this.Apply)
            return this
        endmethod

        private static method onInit takes nothing returns nothing
            call thistype.create()
        endmethod
    endstruct

    private struct CharacterSkinChange
        public method Apply takes nothing returns nothing
            local InventoryClickedEvent ev = Events.GetEventArgs(characterSkinChangeKey)
            local integer id = ev.Id + 1
            local SkinInfo skin = ev.Skin
            local SkinSelectWindow window = ev.Window

            local real x = GetUnitX(OrangeMushroom[id])
            local real y = GetUnitY(OrangeMushroom[id])

            if GravityChanger_Loading == false then
                set OrangeMushroomType[id] = skin.Id

                if MorphState[id] == false then
                    call RemoveUnit(OrangeMushroom[id])

                    if GravityChanger_State == false then
                        set OrangeMushroom[id] = CreateUnit(Player(id-1), OrangeMushroomType[id], x, y, 270 )
                    else
                        set OrangeMushroom[id] = CreateUnit(Player(id-1), OrangeMushroomType[id], x, y, 90 )
                    endif

                    call SetUnitBlendTime(OrangeMushroom[id], 0.00)
                    call SetUnitPosition(OrangeMushroom[id], x, y)

                    if LevelClearState[id] == false then
                        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", x, y ))
                    else
                        call ShowUnit(OrangeMushroom[id], false)
                    endif
    
                endif
                
                call window.ChangeSkin(skin.Clone())
            endif

            call ev.destroy()
        endmethod

        public static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            call Events.Add(characterSkinChangeKey, this, this.Apply)
            return this
        endmethod

        private static method onInit takes nothing returns nothing
            call thistype.create()
        endmethod
    endstruct

    globals
        private PlayerSkinSelect array PlayerSkinUI[PLAYER_MAXINUM]
    endglobals

    public function ClickDownAction takes integer i, real x, real y returns nothing
        call PlayerSkinUI[i].ClickDown(x, y)
    endfunction

    public function ClickUpAction takes integer i, real x, real y returns nothing
        call PlayerSkinUI[i].ClickUp(x, y)
    endfunction

    public function InputKey takes integer i returns nothing
        call PlayerSkinUI[i].HotKey()
    endfunction

    public function WindowOff takes integer i returns nothing
        call PlayerSkinUI[i].Close()
    endfunction

    public function IsActivated takes integer i returns boolean
        return PlayerSkinUI[i].IsOpen()
    endfunction

    /* =======================
     * 순서 바꾸면 안됩니다.   /
     * =====================*/
    private function InitSkinAnimationList takes nothing returns nothing
        local SkinInfo skin
        
        set SkinAnimationList = sList.create()

        //====================================================

        set skin = SkinInfo.create(0.250, "Orange Mushroom", 'hpea', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Mushroom001.blp")
        call skin.AddMotion("Mushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Blue Mushroom", 'uaco', 0.044, characterSkinChangeKey)
        call skin.AddMotion("BlueMushroom001.blp")
        call skin.AddMotion("BlueMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Zombie Mushroom", 'ushd', 0.044, characterSkinChangeKey)
        call skin.AddMotion("ZombieMushroom001.blp")
        call skin.AddMotion("ZombieMushroom002.blp")
        call SkinAnimationList.add(skin)
        
        //====================================================

        set skin = SkinInfo.create(0.250, "Mushrooms", 'ugho', 0.044, characterSkinChangeKey)
        call skin.AddMotion("PileMushroom001.blp")
        call skin.AddMotion("PileMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Bloctopus", 'uabo', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Bloctopus001.blp")
        call skin.AddMotion("Bloctopus002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "King Bloctopus", 'umtw', 0.044, characterSkinChangeKey)
        call skin.AddMotion("KingBloctopus001.blp")
        call skin.AddMotion("KingBloctopus002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Pink Mushroom", 'ucry', 0.044, characterSkinChangeKey)
        call skin.AddMotion("PinkMushroom001.blp")
        call skin.AddMotion("PinkMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "Box", 'ugar', 0.044, characterSkinChangeKey)
        call skin.AddMotion("BoxPlayer001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Slime", 'uban', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Slime001.blp")
        call skin.AddMotion("Slime002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Bubbling", 'unec', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Bubbling001.blp")
        call skin.AddMotion("Bubbling002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Propelly", 'uobs', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Propelly001.blp")
        call skin.AddMotion("Propelly006.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.100, "Cube Slime", 'ufro', 0.044, characterSkinChangeKey)
        call skin.AddMotion("CubeSlime001.blp")
        call skin.AddMotion("CubeSlime002.blp")
        call skin.AddMotion("CubeSlime003.blp")
        call skin.AddMotion("CubeSlime004.blp")
        call skin.AddMotion("CubeSlime005.blp")
        call skin.AddMotion("CubeSlime006.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Yeti", 'earc', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Yeti001.blp")
        call skin.AddMotion("Yeti002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "Ribbon Pig", 'esen', 0.044, characterSkinChangeKey)
        call skin.AddMotion("RibbonPig001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "Lupin", 'edry', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Lupin001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Coke Mushroom", 'ehpr', 0.044, characterSkinChangeKey)
        call skin.AddMotion("CokeMushroom001.blp")
        call skin.AddMotion("CokeMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "Sentinel", 'edot', 0.09, characterSkinChangeKey)
        call skin.AddMotion("Sentinel001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Doodle", 'echm', 0.044, characterSkinChangeKey)
        call skin.AddMotion("DoodleMushroom001.blp")
        call skin.AddMotion("DoodleMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Coketump", 'edoc', 0.044, characterSkinChangeKey)
        call skin.AddMotion("CokeTump001.blp")
        call skin.AddMotion("CokeTump002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.125, "Meso", 'emtg', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Meso001.blp")
        call skin.AddMotion("Meso002.blp")
        call skin.AddMotion("Meso004.blp")
        call skin.AddMotion("Meso003.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Catcher", 'efdr', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Catcher001.blp")
        call skin.AddMotion("Catcher002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Horny Mushroom", 'nnsw', 0.044, characterSkinChangeKey)
        call skin.AddMotion("HornyMushroom001.blp")
        call skin.AddMotion("HornyMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Red Mushroom", 'nmyr', 0.044, characterSkinChangeKey)
        call skin.AddMotion("RedOriginalMushroom001.blp")
        call skin.AddMotion("RedOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Blue Mushroom", 'nnrg', 0.044, characterSkinChangeKey)
        call skin.AddMotion("BlueOriginalMushroom001.blp")
        call skin.AddMotion("BlueOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Teal Mushroom", 'nhyc', 0.044, characterSkinChangeKey)
        call skin.AddMotion("TealOriginalMushroom001.blp")
        call skin.AddMotion("TealOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Purple Mushroom", 'nmpe', 0.044, characterSkinChangeKey)
        call skin.AddMotion("PurpleOriginalMushroom001.blp")
        call skin.AddMotion("PurpleOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Yellow Mushroom", 'nanm', 0.044, characterSkinChangeKey)
        call skin.AddMotion("YellowOriginalMushroom001.blp")
        call skin.AddMotion("YellowOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Green Mushroom", 'nanb', 0.044, characterSkinChangeKey)
        call skin.AddMotion("GreenOriginalMushroom001.blp")
        call skin.AddMotion("GreenOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "Original Black Mushroom", 'nanc', 0.044, characterSkinChangeKey)
        call skin.AddMotion("BlackOriginalMushroom001.blp")
        call skin.AddMotion("BlackOriginalMushroom002.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "Mushmom", 'nanw', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Mushmom001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "PinkBean", 'n000', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Pinkbean001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0.07, "IceAura", 'h00E', 0.06, 0, -0.0025, Decorate_FloorAura, /*
            */ SkinSelectWindow.CharacterPriority - 1, decorateSkinChangeKey)
        call skin.AddMotion("IceAura101.blp")
        call skin.AddMotion("IceAura102.blp")
        call skin.AddMotion("IceAura103.blp")
        call skin.AddMotion("IceAura104.blp")
        call skin.AddMotion("IceAura105.blp")
        call skin.AddMotion("IceAura106.blp")
        call skin.AddMotion("IceAura107.blp")
        call skin.AddMotion("IceAura108.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0, "Blue Mushmom", 'n007', 0.044, characterSkinChangeKey)
        call skin.AddMotion("BlueMushmom001.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.1, "Blin", 'o003', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Blin001.blp")
        call skin.AddMotion("Blin002.blp")
        call skin.AddMotion("Blin003.blp")
        call skin.AddMotion("Blin004.blp")
        call skin.AddMotion("Blin005.blp")
        call skin.AddMotion("Blin006.blp")
        call skin.AddMotion("Blin007.blp")
        call skin.AddMotion("Blin008.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.1, "Papulatus", 'n008', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Papulatus001.blp")
        call skin.AddMotion("Papulatus002.blp")
        call skin.AddMotion("Papulatus003.blp")
        call skin.AddMotion("Papulatus004.blp")
        call skin.AddMotion("Papulatus005.blp")
        call skin.AddMotion("Papulatus006.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0, "PinkBean Designation", 'h00B', 0.06, -0.0015, -0.046, Decorate_Designation, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("PinkBeanDesignation.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0, "Yellow Aura", 'h005', 0.044, 0, 0, Decorate_Aura, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("MushmomEye006.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0, "Blue Aura", 'h004', 0.044, 0, 0, Decorate_Aura, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("BlueAura.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0, "Red Aura", 'h009', 0.044, 0, 0, Decorate_Aura, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("RedAura.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0, "Green Aura", 'h008', 0.044, 0, 0, Decorate_Aura, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("GreenAura.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.25, "HologramMushroomRed", 'h00F', 0.044, characterSkinChangeKey)
        call skin.AddMotion("HologramMushroomRed001.blp")
        call skin.AddMotion("HologramMushroomRed003.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.25, "HologramMushroomBlue", 'h00G', 0.044, characterSkinChangeKey)
        call skin.AddMotion("HologramMushroomBlue001.blp")
        call skin.AddMotion("HologramMushroomBlue003.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = DecorateSkinInfo.create(0.18, "Bella Pet", 'h00H', 0.04, -0.035, -0.012, Decorate_Pet, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("BellaPet002.blp")
        call skin.AddMotion("BellaPet003.blp")
        call skin.AddMotion("BellaPet004.blp")
        call skin.AddMotion("BellaPet005.blp")
        call SkinAnimationList.add(skin)

         //====================================================

         set skin = DecorateSkinInfo.create(0.18, "Lucid Soul", 'h00I', 0.044, 0, 0.07, Decorate_Soul, /*
            */ SkinSelectWindow.CharacterPriority + 1, decorateSkinChangeKey)
        call skin.AddMotion("LucidSoul001.blp")
        call skin.AddMotion("LucidSoul002.blp")
        call skin.AddMotion("LucidSoul003.blp")
        call skin.AddMotion("LucidSoul004.blp")
        call skin.AddMotion("LucidSoul005.blp")
        call skin.AddMotion("LucidSoul006.blp")
        call skin.AddMotion("LucidSoul007.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "RedBloctopus", 'h00N', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Redblockpus1.blp")
        call skin.AddMotion("Redblockpus2.blp")
        call SkinAnimationList.add(skin)
        
        //====================================================

        set skin = SkinInfo.create(0.250, "BlueBloctopus", 'h00J', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Blueblockpus1.blp")
        call skin.AddMotion("Blueblockpus2.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "TealBloctopus", 'h00M', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Tealblockpus1.blp")
        call skin.AddMotion("Tealblockpus2.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "YellowBloctopus", 'h00O', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Yellowblockpus1.blp")
        call skin.AddMotion("Yellowblockpus2.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "OrangeBloctopus", 'h00L', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Orangeblockpus1.blp")
        call skin.AddMotion("Orangeblockpus2.blp")
        call SkinAnimationList.add(skin)

        //====================================================

        set skin = SkinInfo.create(0.250, "GreenBloctopus", 'h00K', 0.044, characterSkinChangeKey)
        call skin.AddMotion("Greenblockpus1.blp")
        call skin.AddMotion("Greenblockpus2.blp")
        call SkinAnimationList.add(skin)

        //====================================================
        set skin = SkinInfo.create(0, "SpiritPendant", 'h00K', 0.044, characterSkinChangeKey)
        call skin.AddMotion("SpiritPendant.blp")
        call SkinAnimationList.add(skin)
    endfunction

    public function ShowSkinInventoryButton takes boolean isVisible returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if isVisible then
                call PlayerSkinUI[i].ShowButton()
            else
                call PlayerSkinUI[i].HideButton()
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    private function Main takes nothing returns nothing
        local integer i
        local integer j

        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                set PlayerSkinUI[i] = PlayerSkinSelect.create(i, RegisterSkinOfUser(i))
            endif
        //! runtextmacro for_end("set i = i + 1")
        
        call DestroyTrigger(GetTriggeringTrigger())
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterTimerEvent(t, 3, false)
        call TriggerAddAction(t, function Main)
        set t = null

        call InitSkinAnimationList()
    endfunction
endlibrary
