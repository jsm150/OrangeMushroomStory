library Key initializer Init
    globals
        private constant integer WHITE_BLOCK_ID = 'D00D'
        private constant integer YELLOW_BLOCK_ID = 'D00C'
        private constant integer RED_BLOCK_ID = 'D00E'
        private constant integer BLUE_BLOCK_ID = 'D00B'

        private constant integer YELLOW_DARK_BLOCK_ID = 'D01C'

        public constant integer WHITE_KEY_ID = 'YOsa'
        public constant integer YELLOW_KEY_ID = 'LOtr'
        public constant integer RED_KEY_ID = 'IOic'
        public constant integer BLUE_KEY_ID = 'OOal'

        integer LeftRailTerrain
        integer RightRailTerrain
        integer OneStageTerrain
        integer TwoStageTerrain
        integer PinkStageTerrain
        integer StationStageTerrain
        integer ValentineStageTerrain
        integer BeachStageTerrain
        integer CokeStageTerrain
        integer CrashTerrain
        integer RefreStageTerrain
        integer UnTerrain
    endglobals

    public struct UseHistroy
        static integer World = 0
        static integer Stage = 0
        static boolean Red = false
        static boolean Yellow = false
        static boolean Blue = false
        static boolean White = false

        public static method Record takes integer keyType returns nothing
            if keyType == RED_KEY_ID then
                call JNWriteLog("RED EAT")
                set Red = true
            endif
            if keyType == YELLOW_KEY_ID then
                call JNWriteLog("YELLOW EAT")
                set Yellow = true
            endif
            if keyType == BLUE_KEY_ID then
                call JNWriteLog("BLUE EAT")
                set Blue = true
            endif
            if keyType == WHITE_KEY_ID then
                call JNWriteLog("WHITE EAT")
                set White = true
            endif
        endmethod

        public static method Clear takes integer world, integer stage returns nothing
            set World = world
            set Stage = stage
            set Red = false
            set Yellow = false
            set Blue = false
            set White = false
        endmethod
    endstruct

    private function SetBlock takes nothing returns nothing
        set LeftRailTerrain = GetTerrainType(-8069,-32233)
        set RightRailTerrain = GetTerrainType(-7960,-32233)
        set OneStageTerrain = GetTerrainType(-7816,-32233)
        set TwoStageTerrain = GetTerrainType(-7681,-32233)
        set PinkStageTerrain = GetTerrainType(-7566,-32233)
        set StationStageTerrain = GetTerrainType(-7426,-32233)
        set ValentineStageTerrain = GetTerrainType(-7292,-32233)
        set BeachStageTerrain = GetTerrainType(-7173,-32233)
        set CokeStageTerrain = GetTerrainType(-7036,-32233)
        set CrashTerrain = GetTerrainType(-6906,-32233)
        set RefreStageTerrain = GetTerrainType(-6786,-32233)
        set UnTerrain = GetTerrainType(-6786 + 128,-32233)
    endfunction
    
    private function TypeCondition takes nothing returns boolean
        local integer kind = GetUnitTypeId(GetTriggerUnit())
        return MushroomType(kind) or kind == 'opeo' or kind == 'ogru' or kind == 'otau' or kind == 'ocat' or kind == 'ohun' or kind == 'o000' or kind == 'o001' or kind == 'h00S' or kind == 'h00T'
    endfunction

    private struct blockLocation
        public real x
        public real y

        static method create takes integer x, integer y returns thistype
            local thistype this = thistype.allocate()
            set this.x = x
            set this.y = y
            return this
        endmethod
    endstruct

    //! runtextmacro Make_LinkedList("blockLocation", "0")

    private interface blockSkin
        public method Setting takes real x, real y returns nothing
    endinterface

    private struct skinForDecoration extends blockSkin
        private integer decorationType
        private string animation

        static method create takes integer decorationType, string animation returns thistype
            local thistype this = thistype.allocate()
            set this.decorationType = decorationType
            set this.animation = animation
            return this
        endmethod

        public method Setting takes real x, real y returns nothing
            call SetDoodadAnimation(x, y, 64, this.decorationType, false, animation, false)
        endmethod
    endstruct

    private struct skinForTile extends blockSkin
        private integer terrainType

        static method create takes integer terrainType returns thistype
            local thistype this = thistype.allocate()
            set this.terrainType = terrainType
            return this
        endmethod

        public method Setting takes real x, real y returns nothing
            call SetTerrainType(x, y, terrainType, -1, 1, 0)
        endmethod
    endstruct

    private struct collision
        public blockLocationLinkedList posList
        public blockSkin skinManager

        static method create takes blockLocationLinkedList posList, blockSkin skinManager returns thistype
            local thistype this = thistype.allocate()
            set this.posList = posList
            set this.skinManager = skinManager
            return this
        endmethod

        public method Execute takes nothing returns nothing
            local real x
            local real y
            local blockLocationNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "this.posList")
                set x = node.Item.x
                set y = node.Item.y
                call this.SetCollision(x, y)
                call this.skinManager.Setting(x, y)
            //! runtextmacro LinkedList_Foreach_Bottom()
        endmethod

        stub method SetCollision takes real x, real y returns nothing
        endmethod
    endstruct

    private struct createCollision extends collision
        static method create takes blockLocationLinkedList posList, blockSkin skinManager returns thistype
            return thistype.allocate(posList, skinManager)
        endmethod

        public method SetCollision takes real x, real y returns nothing
            local rect r = Rect(x-64, y-64, x+32, y+32)
            call RegionAddRect(Rect_NoEntry, r)
            call RemoveRect(r)
            set r = null
        endmethod
    endstruct

    private struct removeCollision extends collision
        static method create takes blockLocationLinkedList posList, blockSkin skinManager returns thistype
            return thistype.allocate(posList, skinManager)
        endmethod

        public method SetCollision takes real x, real y returns nothing
            local rect r = Rect(x-64, y-64, x+32, y+32)
            call RegionClearRect(Rect_NoEntry, r)
            call RemoveRect(r)

            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", x, y ))
            set r = null
        endmethod
    endstruct

    //! runtextmacro Make_LinkedList("collision", "0")

    private struct keyEvent
        private rect keyRect
        private integer keyType
        private collisionLinkedList actionList
        private collisionLinkedList resetList
        private boolean isExecuted

        private method Execute takes nothing returns nothing
            if this.isExecuted == false and TypeCondition() == true then
                call this.Action()
            endif
        endmethod

        public method Action takes nothing returns nothing
            local collisionNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "this.actionList")
                call node.Item.Execute()
            //! runtextmacro LinkedList_Foreach_Bottom()
            set this.isExecuted = true
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", GetRectCenterX(this.keyRect), GetRectCenterY(this.keyRect)))
            call SetDoodadAnimationRect(keyRect, keyType, "Death", false)
            call UseHistroy.Record(keyType)
        endmethod

        public method TryExecute takes integer keyType returns nothing
            if this.isExecuted == false and this.keyType == keyType then
                call this.Action()
            endif
        endmethod

        public method Reset takes nothing returns nothing
            local collisionNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "this.resetList")
                call node.Item.Execute()
            //! runtextmacro LinkedList_Foreach_Bottom()
            set this.isExecuted = false
            call SetDoodadAnimationRect(keyRect, keyType, "Stand", false)
        endmethod

        static method create takes rect r, integer keyType, collisionLinkedList actionList, collisionLinkedList resetList returns thistype
            local thistype this = thistype.allocate()
            local trigger t = CreateTrigger()
            set this.keyRect = r
            set this.keyType = keyType
            set this.actionList = actionList
            set this.resetList = resetList
            call TriggerRegisterEnterRectSimple(t, r)
            call EventMethod.AddByEvaluate(t, this, this.Execute)
            set t = null
            return this
        endmethod
    endstruct
    
    //! runtextmacro Make_LinkedList("keyEvent", "0")

    public struct keyMap
        private static hashtable H = InitHashtable()

        public static method Add takes integer world, integer stage, keyEventLinkedList list returns nothing
            call SaveInteger(H, world, stage, list)
        endmethod

        public static method ResetBlocks takes integer world, integer stage returns nothing
            local keyEventLinkedList eventList = LoadInteger(H, world, stage)
            local keyEventNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "eventList")
                call node.Item.Reset()
            //! runtextmacro LinkedList_Foreach_Bottom()
            call UseHistroy.Clear(world, stage)
        endmethod

        public static method Execute takes integer world, integer stage, integer keyType returns nothing
            local keyEventLinkedList eventList = LoadInteger(H, world, stage)
            local keyEventNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "eventList")
                call node.Item.TryExecute(keyType)
            //! runtextmacro LinkedList_Foreach_Bottom()
        endmethod
    endstruct

    globals
        private blockSkin redInvisibleToDeco
        private blockSkin redVisibleToDeco
        private blockSkin yellowInvisibleToDeco
        private blockSkin yellowVisibleToDeco
        private blockSkin darkyellowVisibleToDeco 
        private blockSkin darkyellowInvisibleToDeco 
        private blockSkin blueInvisibleToDeco
        private blockSkin blueVisibleToDeco
        private blockSkin whiteInvisibleToDeco
        private blockSkin whiteVisibleToDeco 
    endglobals

    private function Init_blockSkin takes nothing returns nothing
        set redInvisibleToDeco = skinForDecoration.create(RED_BLOCK_ID, "death")
        set redVisibleToDeco = skinForDecoration.create(RED_BLOCK_ID, "stand")
        set yellowInvisibleToDeco = skinForDecoration.create(YELLOW_BLOCK_ID, "death")
        set yellowVisibleToDeco = skinForDecoration.create(YELLOW_BLOCK_ID, "stand")
        set darkyellowInvisibleToDeco = skinForDecoration.create(YELLOW_DARK_BLOCK_ID, "death")
        set darkyellowVisibleToDeco = skinForDecoration.create(YELLOW_DARK_BLOCK_ID, "stand")
        set blueInvisibleToDeco = skinForDecoration.create(BLUE_BLOCK_ID, "death")
        set blueVisibleToDeco = skinForDecoration.create(BLUE_BLOCK_ID, "stand")
        set whiteInvisibleToDeco = skinForDecoration.create(WHITE_BLOCK_ID, "death")
        set whiteVisibleToDeco = skinForDecoration.create(WHITE_BLOCK_ID, "stand")
    endfunction

    private struct keyMapManager
        private static keyEventLinkedList eventList
        private static collisionLinkedList actionList
        private static collisionLinkedList resetList
        private static integer world
        private static integer stage
        private static integer keyType
        private static rect keyRect
        

        public static method SaveEvent takes nothing returns nothing
            call eventList.AddFirst(keyEvent.create(keyRect, keyType, actionList, resetList))
        endmethod

        public static method AddAction takes blockLocationLinkedList posList, string ActionType returns nothing
            if ActionType == "Create" then
                if keyType == RED_KEY_ID then
                    call actionList.AddFirst(createCollision.create(posList, redVisibleToDeco))
                    call resetList.AddFirst(removeCollision.create(posList, redInvisibleToDeco))
                elseif keyType == YELLOW_KEY_ID then
                    call actionList.AddFirst(createCollision.create(posList, yellowVisibleToDeco))
                    call resetList.AddFirst(removeCollision.create(posList, yellowInvisibleToDeco))
                    call actionList.AddFirst(createCollision.create(posList, darkyellowVisibleToDeco))
                    call resetList.AddFirst(removeCollision.create(posList, darkyellowInvisibleToDeco))
                elseif keyType == BLUE_KEY_ID then
                    call actionList.AddFirst(createCollision.create(posList, blueVisibleToDeco))
                    call resetList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))
                elseif keyType == WHITE_KEY_ID then
                    call actionList.AddFirst(createCollision.create(posList, whiteVisibleToDeco))
                    call resetList.AddFirst(removeCollision.create(posList, whiteInvisibleToDeco))
                endif
            elseif ActionType == "Remove" then
                if keyType == RED_KEY_ID then
                    call actionList.AddFirst(removeCollision.create(posList, redInvisibleToDeco))
                    call resetList.AddFirst(createCollision.create(posList, redVisibleToDeco))
                elseif keyType == YELLOW_KEY_ID then
                    call actionList.AddFirst(removeCollision.create(posList, yellowInvisibleToDeco))
                    call resetList.AddFirst(createCollision.create(posList, yellowVisibleToDeco))
                elseif keyType == BLUE_KEY_ID then
                    call actionList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))
                    call resetList.AddFirst(createCollision.create(posList, blueVisibleToDeco))
                elseif keyType == WHITE_KEY_ID then
                    call actionList.AddFirst(removeCollision.create(posList, whiteInvisibleToDeco))
                    call resetList.AddFirst(createCollision.create(posList, whiteVisibleToDeco))
                endif
            endif
        endmethod

        public static method CreateEvent takes integer keyType, rect keyRect returns nothing
            set thistype.keyType = keyType
            set thistype.keyRect = keyRect
            set actionList = collisionLinkedList.create()
            set resetList = collisionLinkedList.create()
        endmethod

        public static method Setting takes integer world, integer stage returns nothing
            set eventList = keyEventLinkedList.create()
            set thistype.world = world
            set thistype.stage = stage
        endmethod

        public static method Register takes nothing returns nothing
            call keyMap.Add(world, stage, eventList)
        endmethod
    endstruct

    private function Init2 takes nothing returns nothing
        local integer j = 0
        local blockLocationLinkedList posList
        local blockLocationLinkedList posList2
        local blockLocationLinkedList posList3
        local keyEventLinkedList eventList
        local collisionLinkedList actionList
        local collisionLinkedList resetList

        call DestroyTrigger(GetTriggeringTrigger())

        //---------------------------------------------------------------
        // 10 - 6
        set eventList = keyEventLinkedList.create()
        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()

        set j = 0
        loop
            exitwhen j > 15 
            call posList.AddFirst(blockLocation.create(20736+(128*j), -10240))
            set j = j + 1
        endloop

        call actionList.AddFirst(removeCollision.create(posList, skinForTile.create(BACKGROUND_TILE)))
        call resetList.AddFirst(removeCollision.create(posList, skinForTile.create(RightRailTerrain)))

        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17021, -11268))

        call actionList.AddFirst(removeCollision.create(posList, redInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, redVisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_6_001, RED_KEY_ID, actionList, resetList))

        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(20608, -9600))

        call actionList.AddFirst(removeCollision.create(posList, yellowInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, yellowVisibleToDeco))
        
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22784, -10112))
        set j = 0
        loop
            exitwhen j > 15
            call posList.AddFirst(blockLocation.create(20736+(128*j), -10240))
            set j = j + 1
        endloop   

        call actionList.AddFirst(createCollision.create(posList, yellowVisibleToDeco))
        call resetList.AddFirst(removeCollision.create(posList, yellowInvisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_6_002, YELLOW_KEY_ID, actionList, resetList))

        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(20608, -10112))
        call posList.AddFirst(blockLocation.create(20608, -10112+128))

        call actionList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, blueVisibleToDeco))

        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 15
            if j != 3 and j != 7 and j != 11 then
                call posList.AddFirst(blockLocation.create(20736+(128*j), -9856))
            endif
            set j = j + 1
        endloop 

        call actionList.AddFirst(createCollision.create(posList, blueVisibleToDeco))
        call resetList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_6_003, BLUE_KEY_ID, actionList, resetList))

        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17280, -11392))
        call posList.AddFirst(blockLocation.create(22656, -11520))

        call actionList.AddFirst(removeCollision.create(posList, whiteInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, whiteVisibleToDeco))

        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        set posList3 = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 23
            call posList.AddFirst(blockLocation.create(19840+(128*j), -12160))
            if j == 2 or j == 8 or j == 14 then
                call posList2.AddFirst(blockLocation.create(19840+(128*j), -12160+(128*2)))
                call posList.AddFirst(blockLocation.create(19840+(128*j), -12160+128))
            elseif j == 5 or j == 11 or j == 17 then
                call posList3.AddFirst(blockLocation.create(19840+(128*j), -12160+(128*2)))
                call posList.AddFirst(blockLocation.create(19840+(128*j), -12160+128))
            endif
            set j = j + 1
        endloop

        call actionList.AddFirst(createCollision.create(posList, whiteVisibleToDeco))
        call resetList.AddFirst(removeCollision.create(posList, whiteInvisibleToDeco))

        call actionList.AddFirst(removeCollision.create(posList2, skinForTile.create(LeftRailTerrain)))
        call resetList.AddFirst(removeCollision.create(posList2, skinForTile.create(BACKGROUND_TILE)))

        call actionList.AddFirst(removeCollision.create(posList3, skinForTile.create(RightRailTerrain)))
        call resetList.AddFirst(removeCollision.create(posList3, skinForTile.create(BACKGROUND_TILE)))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_6_004, WHITE_KEY_ID, actionList, resetList))

        call keyMap.Add(10, 6, eventList)

        //---------------------------------------------------------------
        call keyMapManager.Setting(10, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key10_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22528, -13312))
        call posList.AddFirst(blockLocation.create(23424, -14208))
        call posList.AddFirst(blockLocation.create(23424, -14208-128))
        call posList.AddFirst(blockLocation.create(23424, -14208+128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key10_7_002)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(21760, -13696))
        set j = 0
        loop
            exitwhen j > 4
            call posList2.AddFirst(blockLocation.create(23296, -14336+(128*j)))
            call posList2.AddFirst(blockLocation.create(22272, -14208+(128*j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key10_7_003)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25344, -14080))
        call posList.AddFirst(blockLocation.create(25344, -14080+128))
        call posList2.AddFirst(blockLocation.create(22016, -14592))
        call posList2.AddFirst(blockLocation.create(22016+128, -14592-128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        // 10 - 8
        
        set eventList = keyEventLinkedList.create()
        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22784, -5760))
        call posList.AddFirst(blockLocation.create(23808, -6272))
        call posList.AddFirst(blockLocation.create(23680, -6528))
        call posList.AddFirst(blockLocation.create(23680 + 128, -6528))
        call posList.AddFirst(blockLocation.create(23680 + 256, -6528))
        call posList.AddFirst(blockLocation.create(23808, -6912))
        call posList.AddFirst(blockLocation.create(23808 + 128, -6912))
        call posList.AddFirst(blockLocation.create(26752, -8832))
        call posList.AddFirst(blockLocation.create(26752, -8832 + 128))
        call posList.AddFirst(blockLocation.create(26752, -8832 + 256))

        call actionList.AddFirst(removeCollision.create(posList, redInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, redVisibleToDeco))

        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 5
            call posList.AddFirst(blockLocation.create(24832+(128*j), -8320))
            if j < 3 then
                call posList.AddFirst(blockLocation.create(25728+(128*j), -8320))
            endif
            if j < 4 then
                call posList.AddFirst(blockLocation.create(26240+(128*j), -8320))
            endif
            set j = j + 1
        endloop

        call actionList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))

        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(23680, -8448))
        call posList.AddFirst(blockLocation.create(23680+128, -8448))

        call actionList.AddFirst(createCollision.create(posList, redVisibleToDeco))
        call resetList.AddFirst(removeCollision.create(posList, redInvisibleToDeco))

        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(26752, -8192))
        call posList.AddFirst(blockLocation.create(26752, -8192+128))

        call actionList.AddFirst(createCollision.create(posList, blueVisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_8_001, RED_KEY_ID, actionList, resetList))

        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 6
            call posList.AddFirst(blockLocation.create(22912, -8576+(128*j)))
            set j = j + 1
        endloop

        call actionList.AddFirst(removeCollision.create(posList, yellowInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, yellowVisibleToDeco))

        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(23040+(128*j), -7552))
            call posList.AddFirst(blockLocation.create(24064+(128*j), -7808))
            set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(23296, -6272))
        call posList.AddFirst(blockLocation.create(23936, -6016))
        call posList.AddFirst(blockLocation.create(24448, -6400))
        call posList.AddFirst(blockLocation.create(24192, -6144))
        call posList.AddFirst(blockLocation.create(24192 + 128, -6144))

        call actionList.AddFirst(createCollision.create(posList, yellowVisibleToDeco))
        call resetList.AddFirst(removeCollision.create(posList, yellowInvisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_8_002, YELLOW_KEY_ID, actionList, resetList))

        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(24704, -8192))
        call posList.AddFirst(blockLocation.create(26752, -8192))
        call posList.AddFirst(blockLocation.create(26752, -8192+128))

        call actionList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, blueVisibleToDeco))

        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 5
            call posList.AddFirst(blockLocation.create(24832+(128*j), -8320))
            if j < 3 then
                call posList.AddFirst(blockLocation.create(25728+(128*j), -8320))
            endif
            if j < 4 then
                call posList.AddFirst(blockLocation.create(26240+(128*j), -8320))
            endif
            set j = j + 1
        endloop

        call actionList.AddFirst(createCollision.create(posList, blueVisibleToDeco))
        call resetList.AddFirst(removeCollision.create(posList, blueInvisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_8_003, BLUE_KEY_ID, actionList, resetList))

        set actionList = collisionLinkedList.create()
        set resetList = collisionLinkedList.create()
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(23552, -8832))
        call posList.AddFirst(blockLocation.create(23552, -8576))
        call posList.AddFirst(blockLocation.create(23296, -8704))

        call actionList.AddFirst(removeCollision.create(posList, whiteInvisibleToDeco))
        call resetList.AddFirst(createCollision.create(posList, whiteVisibleToDeco))

        call eventList.AddFirst(keyEvent.create(gg_rct_Key10_8_004, WHITE_KEY_ID, actionList, resetList))

        call keyMap.Add(10, 8, eventList)


        //---------------------------------------------------------------
        call keyMapManager.Setting(11, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key11_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25728, -16256))
        call posList.AddFirst(blockLocation.create(22272, -17664))
        call posList.AddFirst(blockLocation.create(22272+128, -17664))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(11, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key11_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(21760, -18816))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key11_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(27392, -17664))
        call posList.AddFirst(blockLocation.create(27392, -17664 - 128))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key11_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(27008, -18816))
        call posList.AddFirst(blockLocation.create(27008 + 128, -18816))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key11_2_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(27392, -17664))
        call posList.AddFirst(blockLocation.create(27392, -17664 - 128))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(11, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key11_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25856, -19712))
        call posList.AddFirst(blockLocation.create(25856 - 128, -19712))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key11_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(27392, -19584))
        call posList.AddFirst(blockLocation.create(27392, -19584-128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key11_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(27264, -19840))
        call posList.AddFirst(blockLocation.create(27264+128, -19840))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key11_3_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(24064, -25088))
        call posList.AddFirst(blockLocation.create(24064-128, -25088))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(11, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key11_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18176, -21568))
        call posList.AddFirst(blockLocation.create(18176+128, -21568))
        call posList.AddFirst(blockLocation.create(22144, -22016))
        call posList.AddFirst(blockLocation.create(22144+128, -22016))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key11_4_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(21888 + (128 * j), -23040))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key11_4_003)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList2.AddFirst(blockLocation.create(17920, -22144))
        call posList.AddFirst(blockLocation.create(22144, -21888))
        call posList.AddFirst(blockLocation.create(22144+128, -21888))
        call posList.AddFirst(blockLocation.create(17664, -21504))
        call posList.AddFirst(blockLocation.create(17664+128, -21504))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key11_4_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22272, -22656))
        call posList.AddFirst(blockLocation.create(22272, -22656 - 128))
        call posList.AddFirst(blockLocation.create(22272, -22656 - 256))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(11, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key11_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(21888, -24320))
        call posList.AddFirst(blockLocation.create(21888 + 128, -24320))
        call posList.AddFirst(blockLocation.create(22400, -24320))
        call posList.AddFirst(blockLocation.create(22400 + 128, -24320))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key11_5_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 6
            call posList.AddFirst(blockLocation.create(19968, -26240 + (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key11_5_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(21376, -24960))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(21248, 15744))
        call posList.AddFirst(blockLocation.create(21248, 15744 + 128))
        call posList.AddFirst(blockLocation.create(21248, 15744 + 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22272, 16256))
        call posList.AddFirst(blockLocation.create(22272, 16256 + 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(24448, 13824))
        call posList.AddFirst(blockLocation.create(24448 + 128, 13824))
        call posList.AddFirst(blockLocation.create(24832, 13824))
        call posList.AddFirst(blockLocation.create(24832 + 128, 13824))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_2_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(22784, 14080 + (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key12_2_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(22656, 14080 + (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key12_2_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(24064, 11520))
        call posList.AddFirst(blockLocation.create(24064, 11520 + 128))
        call posList.AddFirst(blockLocation.create(25344, 14336))
        call posList.AddFirst(blockLocation.create(25344, 14336 + 128))
        call posList.AddFirst(blockLocation.create(20480, 11648))
        call posList.AddFirst(blockLocation.create(20480, 11648 + 128))
        call posList.AddFirst(blockLocation.create(25216, 11392))
        call posList.AddFirst(blockLocation.create(25216 + 128, 11392))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_3_001)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(15232, 15104))
        call posList.AddFirst(blockLocation.create(18176, 16000))
        call posList.AddFirst(blockLocation.create(17792, 16256))
        call posList.AddFirst(blockLocation.create(17792, 16256 + 128))
        set j = 0
        loop
            exitwhen j > 2
            call posList2.AddFirst(blockLocation.create(16896 + (128 * j), 16000))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_3_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(17280, 15872 - (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key12_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18176, 15232))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(10880, 13440))
        call posList.AddFirst(blockLocation.create(10880, 13440 - 128))
        call posList.AddFirst(blockLocation.create(10880, 13440 - 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_4_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(10752, 14592))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key12_4_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(10752, 14848))
        call posList.AddFirst(blockLocation.create(9088, 13952))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key12_4_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8704, 14848))
        call posList.AddFirst(blockLocation.create(8704 - 128, 14848))
        call posList.AddFirst(blockLocation.create(8704, 14848 - 128))
        call posList.AddFirst(blockLocation.create(8704 + 128, 14848 - 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19200, 16256))
        call posList.AddFirst(blockLocation.create(19200, 16256 - 128))
        call posList.AddFirst(blockLocation.create(19200, 16256 - 256))
        call posList.AddFirst(blockLocation.create(19200, 16256 + 128))
        call posList.AddFirst(blockLocation.create(19200, 16256 + 256))
        call posList.AddFirst(blockLocation.create(19072, 15744))
        call posList.AddFirst(blockLocation.create(20224, 15488))
        call posList.AddFirst(blockLocation.create(20224, 15488 - 128))
        call posList.AddFirst(blockLocation.create(19840, 16384))
        call posList.AddFirst(blockLocation.create(19840, 16384 + 128))
        call posList.AddFirst(blockLocation.create(19456, 9472))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_5_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18816, 9984))
        call posList.AddFirst(blockLocation.create(18816, 9984 + 128))
        call posList.AddFirst(blockLocation.create(19456, 16128))
        call posList.AddFirst(blockLocation.create(19456 + 128, 16128))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_6_001)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(11648, 15360))
        call posList.AddFirst(blockLocation.create(11648 - 128, 15360))
        call posList.AddFirst(blockLocation.create(11648, 15360 + 128))
        call posList.AddFirst(blockLocation.create(11392, 13056))
        call posList2.AddFirst(blockLocation.create(11904, 14976))
        call posList2.AddFirst(blockLocation.create(11904 + 128, 14976))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_6_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14464, 14848))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17408, 12928))
        call posList.AddFirst(blockLocation.create(17408, 12928 - 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key12_7_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19520, 13376))
        call posList.AddFirst(blockLocation.create(19456, 13248))
        call posList.AddFirst(blockLocation.create(19456, 13568))
        set j = 0
        loop
            exitwhen j > 5
            call posList.AddFirst(blockLocation.create(19264, 13440 - (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key12_7_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18816, 11776))
        call posList.AddFirst(blockLocation.create(18816 + 128, 11776))
        call posList.AddFirst(blockLocation.create(18816 + 256, 11776))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key12_7_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14976, 11776))
        call posList.AddFirst(blockLocation.create(14976 + 128, 11776))
        call posList.AddFirst(blockLocation.create(14976 + 128, 11776 - 128))
        call posList.AddFirst(blockLocation.create(17280, 13824))
        call posList.AddFirst(blockLocation.create(17280, 13824 + 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key12_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(15360, 10752))
        call posList.AddFirst(blockLocation.create(15488, 10880))
        call posList.AddFirst(blockLocation.create(17280, 10752))
        call posList.AddFirst(blockLocation.create(17152, 10880))
        call posList.AddFirst(blockLocation.create(17536, 9344))
        call posList.AddFirst(blockLocation.create(17536, 9344 - 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(12, 9)

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key12_9_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(23424, -28928))
        call posList.AddFirst(blockLocation.create(23424, -28928 - 128))
        call posList.AddFirst(blockLocation.create(23424 + 128, -28928))
        call posList.AddFirst(blockLocation.create(23424 + 128, -28928 - 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-5120, 18176))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-6528, 17920))
        call posList.AddFirst(blockLocation.create(-7424, 19968))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3840, 18816))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4096, 18816))
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-3456 + (128 * j), 18176))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()


        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4608, 19840))
        call posList.AddFirst(blockLocation.create(-4608 + 128, 19840))
        call posList.AddFirst(blockLocation.create(-1792, 19712))
        call posList.AddFirst(blockLocation.create(-1536, 18560))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(896, 18304))
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-512 + (128 * j), 19456))
            if j <= 2 then
                call posList.AddFirst(blockLocation.create(512 + (128 * j), 19456))
                call posList.AddFirst(blockLocation.create(1280 + (128 * j), 18816))
            endif
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(256, 19840))
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(384, 19968 - (128 * j)))
            if j <= 2 then
                call posList.AddFirst(blockLocation.create(128 + (128 * j), 19456))
            endif
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(512, 18688))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(2560, 18432))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_4_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(3712, 19584))
        call posList.AddFirst(blockLocation.create(4224, 17920))
        call posList.AddFirst(blockLocation.create(5376, 18048))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_4_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(5248, 19712))
        call posList.AddFirst(blockLocation.create(5248 + 128, 19712))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(6400, 17152))
        call posList.AddFirst(blockLocation.create(8832, 17920))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_5_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(6912, 16896))
        call posList.AddFirst(blockLocation.create(7168, 17024))
        call posList.AddFirst(blockLocation.create(7168, 17024 + 128))
        call posList.AddFirst(blockLocation.create(7168, 17024 + 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_5_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8704, 18304))
        call posList.AddFirst(blockLocation.create(6784, 18304))
        call posList.AddFirst(blockLocation.create(6784 + 128, 18304))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(13312, 18176))
        call posList.AddFirst(blockLocation.create(9984, 18816))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_6_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9472, 19328))
        call posList.AddFirst(blockLocation.create(12544, 18048))
        call posList.AddFirst(blockLocation.create(12544 - 128, 18048))
        call posList.AddFirst(blockLocation.create(12672, 18560))
        //! runtextmacro for("set j = 0", "j < 3")
            call posList.AddFirst(blockLocation.create(12672, 17920 + (128 * j)))
            if j < 2 then
                call posList.AddFirst(blockLocation.create(10624 + (128 * j), 18688))
            endif
        //! runtextmacro for_end("set j = j + 1")
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_6_003)
        set posList = blockLocationLinkedList.create()
        //! runtextmacro for("set j = 0", "j < 3")
            call posList.AddFirst(blockLocation.create(9600, 17920 + (128 * j)))
        //! runtextmacro for_end("set j = j + 1")
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key13_6_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(11776, 17152))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(13, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14464, 18944))
        call posList.AddFirst(blockLocation.create(17792, 18560))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_7_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14848, 18816))
        call posList.AddFirst(blockLocation.create(15232, 18816))
        call posList.AddFirst(blockLocation.create(16000, 18816))
        call posList.AddFirst(blockLocation.create(16000 + 256, 18816))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_7_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14208, 18048))
        call posList.AddFirst(blockLocation.create(14208 + 128, 18048))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key13_7_004)
        set posList = blockLocationLinkedList.create()
        //! runtextmacro for("set j = 0", "j < 5")
            call posList.AddFirst(blockLocation.create(16896 + (128 * j), 19200))
        //! runtextmacro for_end("set j = j + 1")
        call posList.AddFirst(blockLocation.create(16768, 19072))
        call posList.AddFirst(blockLocation.create(16768 + 128, 19072))
        call posList.AddFirst(blockLocation.create(17280, 19328))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //-------------------------------------------------------------------
        call keyMapManager.Setting(13, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19456, 19328))
        call posList.AddFirst(blockLocation.create(22784, 20352))
        call posList.AddFirst(blockLocation.create(22784 + 128, 20352))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_8_002)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22528, 19456))
        call posList.AddFirst(blockLocation.create(22528, 19456 - 128))
        call posList.AddFirst(blockLocation.create(22528, 19456 - 256))
        call posList.AddFirst(blockLocation.create(22528 - 128, 19456 - 384))
        call posList.AddFirst(blockLocation.create(23040, 19840))
        call posList.AddFirst(blockLocation.create(23040, 19840 - 128))
        call posList2.AddFirst(blockLocation.create(22272, 18560))
        call posList2.AddFirst(blockLocation.create(22272 + 128, 18560 + 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()       

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_8_003)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22784, 20224))
        call posList.AddFirst(blockLocation.create(22784 + 128, 20224))
        call posList.AddFirst(blockLocation.create(22272, 19456))
        call posList.AddFirst(blockLocation.create(22272 + 128, 19456))
        call posList2.AddFirst(blockLocation.create(18880, 19456))
        call posList2.AddFirst(blockLocation.create(18880, 19456 - 128))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.AddAction(posList2, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

//---------------------------------------------------------------
        call keyMapManager.Setting(14, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key14_1_001)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()       
        
        set j = 0
        loop
            exitwhen j > 2
                call posList.AddFirst(blockLocation.create(-7040, 27392 - (256 * j)))
            set j = j + 1
        endloop
        call posList2.AddFirst(blockLocation.create(-5248, 26624))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key14_1_002)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 1
                call posList.AddFirst(blockLocation.create(-640 + (128 * j), 25728))
            set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(-832 , 25728))
        call posList2.AddFirst(blockLocation.create(-3008, 25728))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()       

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key14_1_003)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3328, 27264))
        call posList.AddFirst(blockLocation.create(-3328 - 128, 27264 - 128))
        call posList.AddFirst(blockLocation.create(-3200, 26496))
        call posList.AddFirst(blockLocation.create(-3200 + 128, 26496 - 128))

        call posList2.AddFirst(blockLocation.create(-7040 , 26048))
        call posList2.AddFirst(blockLocation.create(-7040 + 128 , 26048))
        call posList2.AddFirst(blockLocation.create(-7040 + 256 , 26048))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key14_1_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-1024 + 128, 25856))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

//---------------------------------------------------------------
        call keyMapManager.Setting(14, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key14_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(4352, 26112))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key14_2_002)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(6016, 26496))
        call posList.AddFirst(blockLocation.create(6016 - 128, 26496 - 128))
        call posList2.AddFirst(blockLocation.create(768, 27264))
        call posList2.AddFirst(blockLocation.create(768 + 128, 27264))
        call posList2.AddFirst(blockLocation.create(768 + 128 * 4, 27264))
        call posList2.AddFirst(blockLocation.create(1920, 27264))
        call posList2.AddFirst(blockLocation.create(1920 + 128, 27264))
        call posList2.AddFirst(blockLocation.create(1920 + 128 * 4, 27264))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()       

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key14_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(768 + 128 * 7, 26240 - 128))
        call posList.AddFirst(blockLocation.create(768 + 128 * 0, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 1, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 2, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 3, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 4, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 5, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 6, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 8, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 9, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 10, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 11, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 12, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 13, 26240))
        call posList.AddFirst(blockLocation.create(768 + 128 * 14, 26240))

        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key14_2_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 0))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 1))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 2))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 3))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 4))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 5))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 6))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 7))
        call posList.AddFirst(blockLocation.create(5376, 26496 - 128 * 8))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 0))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 1))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 2))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 3))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 4))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 5))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 6))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 7))
        call posList.AddFirst(blockLocation.create(5248, 26496 - 128 * 8))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(14, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key14_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(13824, 28416))
        call posList.AddFirst(blockLocation.create(13824 + 128, 28416 - 128))
        call posList.AddFirst(blockLocation.create(14080, 28160))
        call posList.AddFirst(blockLocation.create(10752, 27776))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key14_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(11264, 28800))
        call posList.AddFirst(blockLocation.create(11264, 28800 - 128))
        call posList.AddFirst(blockLocation.create(11264 - 128, 28800 - 256))
        call posList.AddFirst(blockLocation.create(14080 + 128, 28160))
        call posList.AddFirst(blockLocation.create(10752 + 128, 27776))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()       

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key14_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14080 + 256, 28160))
        call posList.AddFirst(blockLocation.create(10752 + 256, 27776))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(14, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key14_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(16000, 27136))
        call posList.AddFirst(blockLocation.create(16000 + 128, 27136))
        call posList.AddFirst(blockLocation.create(16000 + 256, 27136))
        set j = 0
        loop
            exitwhen j > 4
            call posList.AddFirst(blockLocation.create(15872, 26240 - (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key14_4_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(15232, 28032))
        call posList.AddFirst(blockLocation.create(15232, 28032 - 128))
        call posList.AddFirst(blockLocation.create(15232, 28032 - 256))
        call posList.AddFirst(blockLocation.create(15232 - 128, 28032 - 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()       
 
        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key14_4_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(16000, 25856))
        call posList.AddFirst(blockLocation.create(16000 + 512, 25856))
        call posList.AddFirst(blockLocation.create(26624, 25984))
        call posList.AddFirst(blockLocation.create(26624, 25984 - 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()   
        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(14, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key13_Minus1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7296, 23168))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key13_Minus1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4480, 21888))
        call posList.AddFirst(blockLocation.create(-4480 + 384, 21888))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key13_Minus1_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-2944, 22656))
        call posList.AddFirst(blockLocation.create(-2944 + 128, 22656))
        call posList.AddFirst(blockLocation.create(-2944 + 640, 22656))
        call posList.AddFirst(blockLocation.create(-2944 + 768, 22656))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key13_Minus1_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-2560, 22784))
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(15, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key15_1_001)
        set posList = blockLocationLinkedList.create()
        //! runtextmacro for("set j = 0", "j < 6")
            call posList.AddFirst(blockLocation.create(-11648, 25600 + (128 * j)))
        //! runtextmacro for_end("set j = j + 1")
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key15_1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-12800, 27392))
        call posList.AddFirst(blockLocation.create(-12800 + 128, 27392))
        call posList.AddFirst(blockLocation.create(-12800 + 256, 27392 + 128))
        call posList.AddFirst(blockLocation.create(-9216, 26368))
        call posList.AddFirst(blockLocation.create(-9216 - 128, 26368))
        call posList.AddFirst(blockLocation.create(-9216 - 256, 26368 + 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key15_1_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-12928, 26112))
        call posList.AddFirst(blockLocation.create(-12544, 25984))
        call posList.AddFirst(blockLocation.create(-12032, 25856))
        call posList.AddFirst(blockLocation.create(-10880, 25856))
        call posList.AddFirst(blockLocation.create(-10880 + 128, 25856))
        call posList.AddFirst(blockLocation.create(-12416, 26368))
        call posList.AddFirst(blockLocation.create(-11520, 27136))
        call posList.AddFirst(blockLocation.create(-10496, 26624))
        call posList.AddFirst(blockLocation.create(-10368, 27264))
        call posList.AddFirst(blockLocation.create(-12672, 26752))
        call posList.AddFirst(blockLocation.create(-12672, 26752 + 128))
        call posList.AddFirst(blockLocation.create(-12032, 26368))
        call posList.AddFirst(blockLocation.create(-12032, 26368 + 128))
        call posList.AddFirst(blockLocation.create(-12032, 26368 + 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()
    endfunction

    // 연산 초과
    private function Init takes nothing returns nothing
        local integer j = 0
        local blockLocationLinkedList posList
        local blockLocationLinkedList posList2

        local trigger t = CreateTrigger()

        call Init_blockSkin()

        //---------------------------------------------------------------
        call keyMapManager.Setting(1, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key1_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9984, -6528))
        call posList.AddFirst(blockLocation.create(9984, -6656))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(1, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key1_6_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 5
            call posList.AddFirst(blockLocation.create(12800+(128*j), -5504))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key1_6_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 6
            call posList.AddFirst(blockLocation.create(11776+(128*j), -6016))
        set j = j + 1
        endloop
        set j = 0
        set j = 0
        loop
        exitwhen j > 6
            call posList.AddFirst(blockLocation.create(11648+(128*j), -6528))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(1, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key1_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(2176, -6272))
        call posList.AddFirst(blockLocation.create(2176, -6400))
        call posList.AddFirst(blockLocation.create(2176, -6528))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key1_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(2688, -7424))
        call posList.AddFirst(blockLocation.create(2688, -7552))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(1, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key1_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14336, -6912))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(1, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key1_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-6272, -4480))
        call posList.AddFirst(blockLocation.create(-6272, -4608))
        call posList.AddFirst(blockLocation.create(-6272, -4736))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key1_8_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-5120, -4480))
        call posList.AddFirst(blockLocation.create(-5120, -4608))
        call posList.AddFirst(blockLocation.create(-5120, -4736))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key1_8_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4096, -4480))
        call posList.AddFirst(blockLocation.create(-4096, -4608))
        call posList.AddFirst(blockLocation.create(-4096, -4736))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7424, -512))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4992, -384))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key2_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-2432, -1280))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key2_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-1408, -256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-1280, -3072))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key2_3_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 5 
            if j < 2 or j > 3 then
                call posList.AddFirst(blockLocation.create(896+(128*j), -3328))
            endif
        set j = j + 1
        endloop
        set j = 0
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(2688, -3712-(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key2_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(768, -3840))
        call posList.AddFirst(blockLocation.create(4352, -4352))
        call posList.AddFirst(blockLocation.create(4352, -4480))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-384, -1408))
        call posList.AddFirst(blockLocation.create(-384, -1536))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8448, -1664))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key2_5_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(7552, -2048))
        call posList.AddFirst(blockLocation.create(7680, -2048))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9472, -2944))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key2_6_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(10112, -2944))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key2_6_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(10752, -2944))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key2_6_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(11776, -2816))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(15360, -2816))
        call posList.AddFirst(blockLocation.create(15360, -2944))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(2, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key2_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(5760 + 128, -128))
        call posList.AddFirst(blockLocation.create(5760 + 128, -256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, -1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_Minus1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19200, 24064))
        call posList.AddFirst(blockLocation.create(19200, 24064 - 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key3_Minus1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18432 + 128, 22528))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-5504, 3072))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-2560, 4352))
        call posList.AddFirst(blockLocation.create(-2560, 4480))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key3_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3200, 2944))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(2816, 4224))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4224, 4608))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key3_4_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3328, 7168))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(4480, 5120))
        set j = 0
        loop
        exitwhen j > 7
            call posList.AddFirst(blockLocation.create(2816+(128*j), 6912))
            if j <= 2 then
                call posList.AddFirst(blockLocation.create(1792, 6144-(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key3_6_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 4
            call posList.AddFirst(blockLocation.create(3328+(128*j), 4992))
            call posList.AddFirst(blockLocation.create(1920+(128*j), 6912))
        set j = j + 1
        endloop
        set j = 0
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(3840, 6400-(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key3_6_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(3200, 5632-(128*j)))
            if j != 3 then
                call posList.AddFirst(blockLocation.create(3584, 6272-(128*j)))
            endif
        set j = j + 1
        endloop
        set j = 0
        set j = 0
        loop
        exitwhen j > 4
            call posList.AddFirst(blockLocation.create(3968+(128*j), 6016))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key3_6_004)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 16
            call posList.AddFirst(blockLocation.create(-1280+(128*j), 6400))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(5504, 3840))
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(5376, 3840-(128*j)))
            call posList.AddFirst(blockLocation.create(5632, 3840-(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key3_8_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(6784+(128*j), 5504))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(3, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key3_7_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 14
            call posList.AddFirst(blockLocation.create(9600+(128*j), 6528))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key3_7_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 13
            call posList.AddFirst(blockLocation.create(12416+(128*j), 1664))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, -1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_Minus1_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(16640+(384*j), 21856))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_Minus1_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(16256+(384*j), 22368))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key4_Minus1_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9984, 23680))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7168, -10752))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7552, -12544))
        set j = 0
        loop
        exitwhen j > 4
            call posList.AddFirst(blockLocation.create(-6656+(128*j), -12151))
            if j < 3 then
                call posList.AddFirst(blockLocation.create(-6144, -12032+(128*j)))
            endif
            if j < 2 then
                call posList.AddFirst(blockLocation.create(-5376, -12032+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key4_1_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(-5760+(128*j), -12151))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4096, -12160))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_2_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 4
            call posList.AddFirst(blockLocation.create(-3584+(128*j), -10752))
            if j < 4 then
                call posList.AddFirst(blockLocation.create(-1792, -11008+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_3_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 6
            if j != 1 then
                call posList.AddFirst(blockLocation.create(1280, -10752+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(384, -12416))
        call posList.AddFirst(blockLocation.create(256, -11776))
        call posList.AddFirst(blockLocation.create(384, -11776))
        set j = 0
        loop
        exitwhen j > 11
            call posList.AddFirst(blockLocation.create(1664, -12416+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key4_3_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(3072+(128*j), -11776))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_5_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(11520, -12288+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_5_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(11776, -12288+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key4_5_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(12032, -12288+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key4_5_004)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 5
            call posList.AddFirst(blockLocation.create(8320, -12288+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(15232, -11648))
        call posList.AddFirst(blockLocation.create(14592, -11776))
        call posList.AddFirst(blockLocation.create(15232, -11904))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_6_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(14464, -12544+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key4_6_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(12800, -11392))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(4, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key4_7_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(11008+(128*j), -10752))
            call posList.AddFirst(blockLocation.create(11392, -10752+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key4_7_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(11520+(128*j), -10752))
            call posList.AddFirst(blockLocation.create(11904, -10752+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key4_7_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(12032+(128*j), -10752))
            call posList.AddFirst(blockLocation.create(12416, -10752+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 3)

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key5_3_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(128, -16000+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_3_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(3200, -14720+(128*j)))
            call posList.AddFirst(blockLocation.create(256+(128*j), -14464))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key5_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(3840, -15104))
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(0, -16000+(128*j)))
            call posList.AddFirst(blockLocation.create(2816, -16128+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7424, -14720))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key5_1_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(-4224+(128*j), -14848))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3456, -14464))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key5_2_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(-1408+(128*j), -15744))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_4_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(5248, -15232+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key5_4_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(7168+(128*j), -15616))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key5_4_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(4480+(128*j), -14464))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8832, -14720))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key5_5_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9728, -15488))
        call posList.AddFirst(blockLocation.create(11520, -15872))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(15744, -15744))
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(12032, -15616+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_7_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(-7552+(128*j), -18304))
            call posList.AddFirst(blockLocation.create(-7552+(128*j), -17536))
        set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(-6272, -18048))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key5_7_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-6016, -17408))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(5, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key5_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-5376, -19328))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key5_8_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 6
            call posList.AddFirst(blockLocation.create(-4480+(128*j), -17920))
            call posList.AddFirst(blockLocation.create(-4480+(128*j), -17536))
        set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(-3456, -17536))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_1_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(-6144, -23296+(128*j)))
        set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(-4608, -23424))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-1792, -22272))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key6_2_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(-1920, -23552+(128*j)))
            call posList.AddFirst(blockLocation.create(-1536, -23552+(128*j)))
            call posList.AddFirst(blockLocation.create(-384, -23552+(128*j)))
            call posList.AddFirst(blockLocation.create(640, -23552+(128*j)))
        set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(-3456, -21248))
        call posList.AddFirst(blockLocation.create(-2816, -22912))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key6_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3200, -22272))
        call posList.AddFirst(blockLocation.create(2432, -22528))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key6_2_004)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(-3840+(128*j), -22912))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-1152, -20864))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(4736, -22272))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key6_4_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(8448+(128*j), -22912))
            if j != 2 then
                call posList.AddFirst(blockLocation.create(8192, -23552+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9984, -23424))
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(11136, -23552+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(14592, -21760))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key6_6_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(13824, -22016+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_7_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(8192, -19328+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key6_7_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(8704, -20736+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key6_7_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(7040, -18688+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(6, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key6_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(11520, -19200))
        call posList.AddFirst(blockLocation.create(10624, -20352))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key6_8_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(10496, -19200))
        call posList.AddFirst(blockLocation.create(11520, -20096))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key6_8_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(11776, -20096))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key6_8_004)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(11904+(128*j), -20224))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7424, -25088))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4992, -26752))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_1_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7424, -27008))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4480, -27776))
        call posList.AddFirst(blockLocation.create(-2944, -27392))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3712, -27008))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-4224, -25472))
        call posList.AddFirst(blockLocation.create(-4224, -25728))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-512, -27776))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_3_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-512, -26752+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-256, -26112))
        call posList.AddFirst(blockLocation.create(-384, -26112))
        call posList.AddFirst(blockLocation.create(-256, -25728))
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(-1792+(128*j), -26368))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(640, -26496))
        call posList.AddFirst(blockLocation.create(896, -25856))
        call posList.AddFirst(blockLocation.create(1536, -25856))
        call posList.AddFirst(blockLocation.create(2176, -26880))
        call posList.AddFirst(blockLocation.create(2176, -27008))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(3968, -25472))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_5_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(4608, -25984))
        call posList.AddFirst(blockLocation.create(4736, -25984))
        call posList.AddFirst(blockLocation.create(4608, -25344))
        call posList.AddFirst(blockLocation.create(4736, -25344))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_5_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(5248, -26624))
        call posList.AddFirst(blockLocation.create(5376, -27392))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key7_5_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(7808, -25600))
        call posList.AddFirst(blockLocation.create(7936, -25600))
        call posList.AddFirst(blockLocation.create(7808, -26624))
        call posList.AddFirst(blockLocation.create(7936, -26624))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_6_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(7808+(128*j), -27264))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_6_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            if j <= 1 then
                call posList.AddFirst(blockLocation.create(10496+(128*j), -25344))
            endif
            call posList.AddFirst(blockLocation.create(9856, -25856+(128*j)))
        set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(10496, -25856))
        call posList.AddFirst(blockLocation.create(9216, -26368))
        call posList.AddFirst(blockLocation.create(7680, -27520))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_6_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(9344, -25344))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-6272, -30592))
        call posList.AddFirst(blockLocation.create(-6144, -30592))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_8_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-5888, -29568))
        call posList.AddFirst(blockLocation.create(-5888, -29440))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_8_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7552, -30464))
        set j = 0
        loop
        exitwhen j > 6
            call posList.AddFirst(blockLocation.create(-7424+(128*j), -29952))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key7_8_004)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 6
            call posList.AddFirst(blockLocation.create(-7424+(128*j), -30336))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(7, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key7_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-2176, -30080))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key7_7_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(-2688+(128*j), -28800))
            if j <= 1 then
                call posList.AddFirst(blockLocation.create(-2176, -28672+(128*j)))
                call posList.AddFirst(blockLocation.create(-2432, -28672+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key7_7_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 5
            call posList.AddFirst(blockLocation.create(-2304+(128*j), -28800))
            if j <= 1 then
                call posList.AddFirst(blockLocation.create(-1664, -28672+(128*j)))
                call posList.AddFirst(blockLocation.create(-1408, -28672+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-5504, 9344))
        call posList.AddFirst(blockLocation.create(-4864, 9344))
        call posList.AddFirst(blockLocation.create(-4480, 9344))
        call posList.AddFirst(blockLocation.create(-3840, 9344))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key8_1_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-5632+(512*j), 9344))
        set j = j + 1
        endloop 
        call posList.AddFirst(blockLocation.create(-3584, 10112))
        call posList.AddFirst(blockLocation.create(-4480, 10624))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key8_1_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-5632+(512*j), 9216))
            call posList.AddFirst(blockLocation.create(-5632+(512*j), 9472))
            call posList.AddFirst(blockLocation.create(-5632+(512*j), 9600))
            call posList.AddFirst(blockLocation.create(-5632+(512*j), 9728))
            call posList.AddFirst(blockLocation.create(-5632+(512*j), 9984))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-896, 9728))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key8_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(384, 9344))
        call posList.AddFirst(blockLocation.create(384, 9216))
        call posList.AddFirst(blockLocation.create(2688, 9984))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key8_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(512, 10624))
        call posList.AddFirst(blockLocation.create(512, 10496))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key8_2_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(2688, 10496))
        call posList.AddFirst(blockLocation.create(2688, 10624))
        call posList.AddFirst(blockLocation.create(2688, 10752))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(6144, 9472))
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(6528, 9600+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key8_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(7296, 9472))
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(7680, 9600+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key8_3_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8192, 9472))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_4_001)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(11648+(128*j), 10240))
            call posList.AddFirst(blockLocation.create(12032, 10240+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key8_4_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(12160+(128*j), 10240))
            call posList.AddFirst(blockLocation.create(12928+(128*j), 10112))
            call posList.AddFirst(blockLocation.create(12928+(128*j), 11008))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-7296, 12928))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-3840, 14848))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key8_6_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-1920, 15872+(128*j)))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key8_6_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-1024, 15360+(128*j)))
            if j <= 1 then
                call posList.AddFirst(blockLocation.create(-896, 15872+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key8_6_004)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 3
            call posList.AddFirst(blockLocation.create(-640, 15360+(128*j)))
            if j <= 1 then
                call posList.AddFirst(blockLocation.create(-384, 15872+(128*j)))
            endif
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(8, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key8_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(1408, 13952))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key8_7_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 1
            call posList.AddFirst(blockLocation.create(4096, 13824+(128*j)))
        set j = j + 1
        endloop
        call posList.AddFirst(blockLocation.create(2688, 14592))
        call posList.AddFirst(blockLocation.create(2432, 14336))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key8_7_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
        exitwhen j > 2
            call posList.AddFirst(blockLocation.create(5760+(128*j), 13952))
        set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------

        call keyMapManager.Setting(9, -1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_Minus1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-640, 21376))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_Minus1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(-896, 21376))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.Register()

        //---------------------------------------------------------------

        call keyMapManager.Setting(9, -2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_Minus2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8832, 23552))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_Minus2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(8832, 23552 - 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()
 
        call keyMapManager.Register()

        //---------------------------------------------------------------

        call keyMapManager.Setting(9, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19072, -3071))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_1_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17153, -2175))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22785, 4483))
        call posList.AddFirst(blockLocation.create(23164, 4483))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_3_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25344, 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_3_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(26880, -256))
        call posList.AddFirst(blockLocation.create(26880, -256 - 128))
        call posList.AddFirst(blockLocation.create(25087, 1279))
        call posList.AddFirst(blockLocation.create(25599, 1920))
        call posList.AddFirst(blockLocation.create(25599, 2044))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key9_3_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 6
                call posList.AddFirst(blockLocation.create(26877+(128*j), 1152))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_4_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17536, 4224))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_4_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17409, 5761))
        call posList.AddFirst(blockLocation.create(20736, 6528))
        call posList.AddFirst(blockLocation.create(20736, 6528 + 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key9_4_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 2
                call posList.AddFirst(blockLocation.create(19200+(128*j), 6784))
                if j < 2 then
                    call posList.AddFirst(blockLocation.create(20864, 6528+(128*j)))
                endif
                set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25984, 8064))
        call posList.AddFirst(blockLocation.create(25600, 6912))
        call posList.AddFirst(blockLocation.create(26368, 5888))
        call posList.AddFirst(blockLocation.create(26752, 3840))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_5_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(26368, 6912))
        call posList.AddFirst(blockLocation.create(26368 + 128, 6912))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key9_5_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(26112, 5506))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 6)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_6_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19968, -5760))
        call posList.AddFirst(blockLocation.create(17408, -7040))
        call posList.AddFirst(blockLocation.create(20864, -4736))
        call posList.AddFirst(blockLocation.create(20480, -4736))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_6_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19200, -8192))
        call posList.AddFirst(blockLocation.create(19200 + 128, -8192))
        call posList.AddFirst(blockLocation.create(19200, -8192+128))
        call posList.AddFirst(blockLocation.create(19200 + 128, -8192 + 128))
        call posList.AddFirst(blockLocation.create(17920, -7168))
        call posList.AddFirst(blockLocation.create(17920 + 128, -7168))
        call posList.AddFirst(blockLocation.create(19713, -6526))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key9_6_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18304, -7808))
        call posList.AddFirst(blockLocation.create(18304 + 128, -7808))
        call posList.AddFirst(blockLocation.create(21120, -5760))
        call posList.AddFirst(blockLocation.create(22144, -5760))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key9_6_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(20480, -8192))
        call posList.AddFirst(blockLocation.create(20480, -8192 + 128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 7)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_7_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18816, 1792))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_7_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17280, 2048))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key9_7_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17280, 256))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(9, 8)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key9_8_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22784, 256))
        call posList.AddFirst(blockLocation.create(22912, 768))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key9_8_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22656, -1024))
        call posList.AddFirst(blockLocation.create(22656, -1024+128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key9_8_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(21632 + (128 * j), 128))
            if j < 3 then
                call posList.AddFirst(blockLocation.create(21632, 128 + (128 * j)))
            endif
            set j = j+1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key9_8_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(22784, 1792))
        call posList.AddFirst(blockLocation.create(22784 + 128, 1792))
        call posList.AddFirst(blockLocation.create(21120, -768))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(10, 1)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key10_1_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18432, -9344))
        call posList.AddFirst(blockLocation.create(17792, -9472))
        call keyMapManager.AddAction(posList, "Remove")
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 4
            call posList.AddFirst(blockLocation.create(18176+(128*j), -11136))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key10_1_002)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 4
            if j < 3 then 
                call posList.AddFirst(blockLocation.create(19200 + (128*j), -9600))
            endif
            call posList.AddFirst(blockLocation.create(19840 + (128*j), -9600))
            call posList2.AddFirst(blockLocation.create(18304 + (128*j), -11008))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(10, 2)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key10_2_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17152, -13312))
        call posList.AddFirst(blockLocation.create(17152, -13312+128))
        call posList.AddFirst(blockLocation.create(17152-128, -13312))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key10_2_002)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17152, -13568))
        call posList.AddFirst(blockLocation.create(17152, -13568 + 128))
        call posList.AddFirst(blockLocation.create(17152-128, -13568))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key10_2_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(19840, -13440))
        call posList.AddFirst(blockLocation.create(19840, -13440+128))
        call posList.AddFirst(blockLocation.create(19840-128, -13440))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(10, 3)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key10_3_001)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25728, -10624))
        set j = 0
        loop
            exitwhen j > 6 
            call posList2.AddFirst(blockLocation.create(25472+(128*j), -9856))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key10_3_002)
        set posList2 = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 6
            call posList2.AddFirst(blockLocation.create(25472+(128*j), -9728))
            if j < 4 then
                call posList2.AddFirst(blockLocation.create(25600+(128*j), -11264))
            endif
            set j = j + 1
        endloop
        call posList2.AddFirst(blockLocation.create(27264, -11136))
        call posList2.AddFirst(blockLocation.create(27264+(128*2), -11136))
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key10_3_003)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(27776, -11520))
        call posList.AddFirst(blockLocation.create(27776+128, -11520))
        call posList.AddFirst(blockLocation.create(27776, -11520+128))
        call posList2.AddFirst(blockLocation.create(25344, -11776))
        call posList2.AddFirst(blockLocation.create(25344, -11776+128))
        call posList2.AddFirst(blockLocation.create(27776, -11136))
        call posList2.AddFirst(blockLocation.create(27776+128, -11136))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key10_3_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(26112, -12160))
        call posList.AddFirst(blockLocation.create(26624, -9216))
        call posList.AddFirst(blockLocation.create(26624, -9216+128))
        call posList.AddFirst(blockLocation.create(26624-128, -9216))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(10, 4)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key10_4_001)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(18176, -15744 + 128))
        set j = 0
        loop
            exitwhen j > 3
            call posList2.AddFirst(blockLocation.create(19328 + (128 * j), -17280))
            call posList.AddFirst(blockLocation.create(18176 + (128 * j), -15744))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key10_4_002)
        set posList2 = blockLocationLinkedList.create()
        call posList2.AddFirst(blockLocation.create(19328, -17152))
        call posList2.AddFirst(blockLocation.create(19328 + 128, -17152))
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key10_4_003)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 3
            call posList.AddFirst(blockLocation.create(20096, -16768 + (128 * j)))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key10_4_004)
        set posList = blockLocationLinkedList.create()
        set posList2 = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(17280, -16384))
        call posList2.AddFirst(blockLocation.create(19328, -17024))
        set j = 0
        loop
            exitwhen j > 5
            call posList.AddFirst(blockLocation.create(18944+(128*j), -15872))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.AddAction(posList2, "Create")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        //---------------------------------------------------------------
        call keyMapManager.Setting(10, 5)

        call keyMapManager.CreateEvent(RED_KEY_ID, gg_rct_Key10_5_001)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(24320, -4480))
        call posList.AddFirst(blockLocation.create(24319, -4480-128))
        call posList.AddFirst(blockLocation.create(24319, -4480-(128*2)))
        call posList.AddFirst(blockLocation.create(24576, -4352))
        call posList.AddFirst(blockLocation.create(24704, -4480))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(YELLOW_KEY_ID, gg_rct_Key10_5_002)
        set posList = blockLocationLinkedList.create()
        set j = 0
        loop
            exitwhen j > 6
            call posList.AddFirst(blockLocation.create(22144+(128*j), -3328))
            set j = j + 1
        endloop
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(BLUE_KEY_ID, gg_rct_Key10_5_003)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(21760, -1792))
        call posList.AddFirst(blockLocation.create(24576, -2304))
        call posList.AddFirst(blockLocation.create(24576+128, -2304+128))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.CreateEvent(WHITE_KEY_ID, gg_rct_Key10_5_004)
        set posList = blockLocationLinkedList.create()
        call posList.AddFirst(blockLocation.create(25856, -3584))
        call posList.AddFirst(blockLocation.create(25856+128, -3584))
        call posList.AddFirst(blockLocation.create(25856, -3200))
        call posList.AddFirst(blockLocation.create(24448, -3328))
        call posList.AddFirst(blockLocation.create(24448-128, -3328))
        call posList.AddFirst(blockLocation.create(24448, -3328+128))
        call posList.AddFirst(blockLocation.create(24448, -3328+(128*2)))
        call keyMapManager.AddAction(posList, "Remove")
        call keyMapManager.SaveEvent()

        call keyMapManager.Register()

        call SetBlock()

        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Init2 )

        set t = null
    endfunction
endlibrary