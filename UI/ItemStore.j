library ItemStore initializer Init
    globals
        private key continueAddItemBoughtEvent
    endglobals

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


            call DzFrameShow(thistype.topLeftFrame, true)
            call DzFrameShow(thistype.leftFrame, true)
            call DzFrameShow(thistype.topFrame, true)
            call DzFrameShow(thistype.topRightFrame, true)
            call DzFrameShow(thistype.menuFrame, true)
            call DzFrameShow(thistype.bodyTopFrame, true)
            call DzFrameShow(thistype.bodyFrame, true)


        endmethod
    endstruct


    private struct ContinueAddItem
        public method Apply takes nothing returns nothing
            local integer playerId = Events.GetEvent(continueAddItemBoughtEvent)
            call Status.SetContinues(Status.Continues + 2)
        endmethod

        private static method onInit takes nothing returns nothing
            local thistype this = thistype.create()
            call Events.Add(continueAddItemBoughtEvent, this, this.Apply)
        endmethod
    endstruct

    private function Init takes nothing returns nothing
        
    endfunction
endlibrary
