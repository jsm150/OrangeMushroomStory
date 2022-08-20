library ItemStore initializer Init
    globals
        private key ContinueAddItemBoughtEvent
        private key ItemPurchaseButtonClickedEvent
    endglobals

    private struct ItemPurchaseButtonClickedEventArgs
        integer sender
        integer playerId
        integer quantity
        Money price
        integer purchasedEvent

        public static method create takes integer sender, integer playerId, integer quantity, Money price, integer purchasedEvent returns thistype
            local thistype this = thistype.allocate()
            set this.sender = sender
            set this.playerId = playerId
            set this.quantity = quantity
            set this.price = price
            set this.purchasedEvent = purchasedEvent
            return this
        endmethod
    endstruct

    private struct ItemUI
        private static constant real sizeX = 0.233
        private static constant real sizeY = 0.315
        private static constant real ratio = 0.3
        private integer frame
        private Money price
        private integer priceLetter
        private integer quantity
        private integer purchasedEvent

        public method ClickInPurchaseButton takes integer idx, real posX, real posY returns boolean
            local real minX = 0.174
            local real maxX = 0.241
            local real minY = 0.352
            local real maxY = 0.370
            local real offsetX = 0.081
            local real offsetY = -0.109
            local integer offsetCountX = ModuloInteger(idx, 5)
            local integer offsetCountY = R2I(idx / 5)
            return posX >= minX + offsetX * offsetCountX /*
                */ and posX <= maxX + offsetX * offsetCountX /*
                */ and posY >= minY + offsetY * offsetCountY /*
                */ and posY <= maxY + offsetY * offsetCountY
        endmethod

        public method Purchase takes integer playerId returns nothing
            set this.quantity = this.quantity - 1
            call Events.Raise(ItemPurchaseButtonClickedEvent, ItemPurchaseButtonClickedEventArgs.create(this, playerId, this.quantity + 1, this.price, this.purchasedEvent))
        endmethod

        public method Show takes integer playerId, integer idx, integer refFrame returns nothing
            local real offsetX = 0.015
            local real offsetY = -0.01
            local real offsetIdxX = 0.08
            local real offsetIdxY = -0.11
            local real x = offsetX + offsetIdxX * ModuloInteger(idx, 5)
            local real y = offsetY + offsetIdxY * R2I(idx / 5)
            local string price = this.price.ToString()

            if GetLocalPlayer() == Player(playerId) then
                call DzFrameSetPoint(this.frame, JN_FRAMEPOINT_TOPLEFT, refFrame, JN_FRAMEPOINT_BOTTOMLEFT, x, y)
                call DzFrameSetPoint(this.priceLetter, JN_FRAMEPOINT_BOTTOMLEFT, this.frame, JN_FRAMEPOINT_BOTTOMLEFT, 0.035, 0.005)
                call DzFrameSetText(this.priceLetter, "|cff5a5656" + price + "        ")

                call DzFrameShow(this.frame, true)
                call DzFrameShow(this.priceLetter, true)
            endif
        endmethod

        public method Hide takes integer playerId returns nothing
            if GetLocalPlayer() == Player(playerId) then
                call DzFrameShow(this.frame, false)
                call DzFrameShow(this.priceLetter, false)
            endif
        endmethod

        public method RollBack takes nothing returns nothing
            set this.quantity = this.quantity + 1
        endmethod

        public static method create takes string blp, Money price, integer quantity, integer purchasedEvent returns thistype
            local thistype this = thistype.allocate()
            set this.frame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            call DzFrameSetSize(this.frame, thistype.sizeX * thistype.ratio, thistype.sizeY * thistype.ratio)
            call DzFrameSetTexture(this.frame, blp, 0)
            call DzFrameShow(this.frame, false)

            set this.priceLetter = DzCreateFrameByTagName("TEXT", "", DzGetGameUI(), "", 0)
            call DzFrameSetFont(this.priceLetter, "Fonts\\DFHeiMd.ttf", 0.0112, 0)
            call DzFrameSetEnable(this.priceLetter, false)
            call DzFrameShow(this.priceLetter, false)

            set this.price = price
            set this.quantity = quantity
            set this.purchasedEvent = purchasedEvent
            return this
        endmethod
    endstruct

    private struct ItemUIList
        private sList list

        private method ClickInItemArea takes real posX, real posY returns boolean
            local real minX = 0.159
            local real maxX = 0.577
            local real minY = 0.149
            local real maxY = 0.454
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        public method Click takes integer playerId, real posX, real posY returns nothing
            local integer i = 0
            if ClickInItemArea(posX, posY) == false then
                return
            endif

            //! runtextmacro for("set i = 0", "i < this.list.size")
                if ItemUI(this.list[i]).ClickInPurchaseButton(i, posX, posY) then
                    call ItemUI(this.list[i]).Purchase(playerId)
                    return
                endif
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Show takes integer playerId, integer refFrame returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < this.list.size")
                call ItemUI(this.list[i]).Show(playerId, i, refFrame)
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Hide takes integer playerId returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < this.list.size")
                call ItemUI(this.list[i]).Hide(playerId)
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Add takes ItemUI itemUI returns nothing
            call list.add(itemUI)
        endmethod

        public static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.list = sList.create()
            return this
        endmethod
    endstruct

    private struct ItemStoreUI
        private static constant real posX = 0.07
        private static constant real posY = 0.545
        private static integer topLeftFrame = 0
        private static integer topRightFrame = 0
        private static integer topFrame = 0
        private static integer leftFrame = 0
        private static integer menuFrame = 0
        private static integer bodyTopFrame = 0
        private static integer bodyFrame = 0
        private integer goldLeafLetter
        private integer playerId
        private ItemUIList itemList
        private boolean isOpen = false

        private method ClickInCloseButton takes real posX, real posY returns boolean
            // 워크 화면상의 절대좌표
            local real minX = 0.548
            local real maxX = 0.570
            local real minY = 0.511
            local real maxY = 0.534
            return posX >= minX and posX <= maxX and posY >= minY and posY <= maxY
        endmethod

        public method Show takes nothing returns nothing
            local string money = User_UserList[this.playerId].GoldLeaf.ToString()

            set this.isOpen = true
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(thistype.topLeftFrame, true)
                call DzFrameShow(thistype.leftFrame, true)
                call DzFrameShow(thistype.topFrame, true)
                call DzFrameShow(thistype.topRightFrame, true)
                call DzFrameShow(thistype.menuFrame, true)
                call DzFrameShow(thistype.bodyTopFrame, true)
                call DzFrameShow(thistype.bodyFrame, true)
                call DzFrameSetText(this.goldLeafLetter, "|cffffffff" + money + "        ")
                call DzFrameShow(this.goldLeafLetter, true)
            endif
            call this.itemList.Show(this.playerId, thistype.menuFrame)
        endmethod

        public method Hide takes nothing returns nothing
            set this.isOpen = false
            if GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(thistype.topLeftFrame, false)
                call DzFrameShow(thistype.leftFrame, false)
                call DzFrameShow(thistype.topFrame, false)
                call DzFrameShow(thistype.topRightFrame, false)
                call DzFrameShow(thistype.menuFrame, false)
                call DzFrameShow(thistype.bodyTopFrame, false)
                call DzFrameShow(thistype.bodyFrame, false)
                call DzFrameShow(this.goldLeafLetter, false)
            endif
            call this.itemList.Hide(this.playerId)
        endmethod

        public method ClickDown takes real posX, real posY returns nothing
            if this.isOpen == false then
                return
            endif

            if ClickInCloseButton(posX, posY) then
                call this.Hide()
            endif
            call this.itemList.Click(this.playerId, posX, posY)
        endmethod

        public method Redisplay takes nothing returns nothing
            local string money = User_UserList[this.playerId].GoldLeaf.ToString()

            if this.playerId == Events.GetEventArgs(User_GoldLeafChangedEvent) and GetLocalPlayer() == Player(this.playerId) then
                call DzFrameShow(this.goldLeafLetter, false)
                call DzFrameSetText(this.goldLeafLetter, "|cffffffff" + money + "        ")
                call DzFrameShow(this.goldLeafLetter, true)
            endif
        endmethod

        public static method create takes integer playerId, ItemUIList itemList returns thistype
            local thistype this = thistype.allocate()
            set this.playerId = playerId
            set this.itemList = itemList

            set this.goldLeafLetter = DzCreateFrameByTagName("TEXT", "", DzGetGameUI(), "", 0)
            call DzFrameSetFont(this.goldLeafLetter, "Fonts\\DFHeiMd.ttf", 0.014, 0)
            call DzFrameSetEnable(this.goldLeafLetter, false)
            call DzFrameSetAbsolutePoint(this.goldLeafLetter, JN_FRAMEPOINT_TOPLEFT, 0.4853, 0.528)
            call DzFrameShow(this.goldLeafLetter, false)
            call Events.Add(User_GoldLeafChangedEvent, this, this.Redisplay)
            return this
        endmethod

        private static method onInit takes nothing returns nothing
            local real topLeftFrameSizeX = 0.087
            local real topFrameSizeY = 0.048

            set thistype.topLeftFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.topRightFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.topFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.leftFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.menuFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.bodyTopFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)
            set thistype.bodyFrame = DzCreateFrameByTagName("BACKDROP", "", DzGetGameUI(), "", 0)

            call DzFrameSetSize(thistype.topLeftFrame, topLeftFrameSizeX, topLeftFrameSizeX * 1.13)
            call DzFrameSetSize(thistype.leftFrame, topLeftFrameSizeX, topLeftFrameSizeX * 3.48)
            call DzFrameSetSize(thistype.topFrame, topFrameSizeY * 10.395 * 0.6, topFrameSizeY)
            call DzFrameSetSize(thistype.topRightFrame, topFrameSizeY * 2.59, topFrameSizeY)
            call DzFrameSetSize(thistype.menuFrame, topFrameSizeY * 2.2, topFrameSizeY * 0.9)
            call DzFrameSetSize(thistype.bodyTopFrame, topFrameSizeY * 6.623, topFrameSizeY * 0.9)
            call DzFrameSetSize(thistype.bodyFrame, topFrameSizeY * 8.828, topFrameSizeY * 6.45)

            call DzFrameSetTexture(thistype.topLeftFrame, "ItemStoreTopLeft.blp", 0)
            call DzFrameSetTexture(thistype.leftFrame, "ItemStoreLeft.blp", 0)
            call DzFrameSetTexture(thistype.topFrame, "ItemStoreTop.blp", 0)
            call DzFrameSetTexture(thistype.topRightFrame, "ItemStoreTopRight.blp", 0)
            call DzFrameSetTexture(thistype.menuFrame, "ItemStoreMenu.blp", 0)
            call DzFrameSetTexture(thistype.bodyTopFrame, "ItemStoreBodyTop.blp", 0)
            call DzFrameSetTexture(thistype.bodyFrame, "ItemStoreBody.blp", 0)

            call DzFrameSetAbsolutePoint(thistype.topLeftFrame, JN_FRAMEPOINT_TOPLEFT, thistype.posX, thistype.posY)
            call DzFrameSetPoint(thistype.leftFrame, JN_FRAMEPOINT_TOPLEFT, thistype.topLeftFrame, JN_FRAMEPOINT_BOTTOMLEFT, 0, 0)
            call DzFrameSetPoint(thistype.topFrame, JN_FRAMEPOINT_TOPLEFT, thistype.topLeftFrame, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
            call DzFrameSetPoint(thistype.topRightFrame, JN_FRAMEPOINT_TOPLEFT, thistype.topFrame, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
            call DzFrameSetPoint(thistype.menuFrame, JN_FRAMEPOINT_TOPLEFT, thistype.topFrame, JN_FRAMEPOINT_BOTTOMLEFT, 0, 0)
            call DzFrameSetPoint(thistype.bodyTopFrame, JN_FRAMEPOINT_TOPLEFT, thistype.menuFrame, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
            call DzFrameSetPoint(thistype.bodyFrame, JN_FRAMEPOINT_TOPLEFT, thistype.menuFrame, JN_FRAMEPOINT_BOTTOMLEFT, 0, 0)

            call DzFrameShow(thistype.topLeftFrame, false)
            call DzFrameShow(thistype.leftFrame, false)
            call DzFrameShow(thistype.topFrame, false)
            call DzFrameShow(thistype.topRightFrame, false)
            call DzFrameShow(thistype.menuFrame, false)
            call DzFrameShow(thistype.bodyTopFrame, false)
            call DzFrameShow(thistype.bodyFrame, false)
        endmethod
    endstruct

    private struct ItemPurchase
        public method Purchase takes nothing returns nothing
            local ItemPurchaseButtonClickedEventArgs args = Events.GetEventArgs(ItemPurchaseButtonClickedEvent)
            local integer playerId = args.playerId
            local integer quantity = args.quantity
            local Money price = args.price
            local integer purchasedEvent = args.purchasedEvent
            
            if quantity == 0 then
                debug call JNWriteLog("매진되었습니다.")
                call ItemUI(args.sender).RollBack()
                call args.destroy()
                return
            endif
            if User_UserList[playerId].Balance() < price.ToInt() then
                debug call JNWriteLog("잔액부족 입니다.")
                call ItemUI(args.sender).RollBack()
                call args.destroy()
                return
            endif

            call User_UserList[playerId].Withdraw(playerId, price.ToInt())
            call User_UserList[playerId].GoldLeafUpload(playerId)
            call PrivateLogging.evaluate(playerId, GetPlayerName(Player(playerId)) + "님이 골드리프 " + price.ToString() + "을 사용했습니다. 잔액은 " /*
                */ + User_UserList[playerId].GoldLeaf.ToString() + "입니다.", "GoldLeafUseLog")
            call Events.Raise(purchasedEvent, playerId)

            call args.destroy()
        endmethod
        
        private static method onInit takes nothing returns nothing
            local thistype this = thistype.create()
            call Events.Add(ItemPurchaseButtonClickedEvent, this, this.Purchase)
        endmethod
    endstruct


    private struct ContinueAddItem
        public method Apply takes nothing returns nothing
            local integer playerId = Events.GetEventArgs(ContinueAddItemBoughtEvent)
            call Status.SetContinues(Status.Continues + 2)
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[playerId + 1] + GetPlayerName(Player(playerId)) + "|r 님이 컨티뉴 2개를 구매했습니다." )
        endmethod

        private static method onInit takes nothing returns nothing
            local thistype this = thistype.create()
            call Events.Add(ContinueAddItemBoughtEvent, this, this.Apply)
        endmethod
    endstruct

    globals
        public ItemStoreUI array ItemStoreUIList[PLAYER_MAXINUM]
    endglobals

    public function ClickDownAction takes integer i, real x, real y returns nothing
        call ItemStoreUIList[i].ClickDown(x, y)
    endfunction

    private function CreateItemUIList takes nothing returns ItemUIList
        local ItemUIList uiList = ItemUIList.create()
        call uiList.Add(ItemUI.create("ContinueAddItemSlot.blp", Money.create(300), 1, ContinueAddItemBoughtEvent))
        return uiList
    endfunction

    private function Init takes nothing returns nothing
        local integer i = 0

        //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
            if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                set ItemStoreUIList[i] = ItemStoreUI.create(i, CreateItemUIList())
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction
endlibrary

/*
* 화면에 띄우려는 blp의 크기가 123 * 456 일때,
* DzFrameSetSize의 사이즈를 x: 123, y: 456 으로 입력하면, 크기는 정사각형이 된다.
* blp의 비율을 맞춰서 화면에 띄우려면
* x: 123, y: 456 * (456 / 123) 으로 사이즈를 줘야한다.
*/