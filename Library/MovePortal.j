library MovePortal initializer Init needs MushroomMoving, Water 

    //! runtextmacro Make_Container("tick", "15")

    globals
        private tickContainer Ticks
    endglobals

    private struct Object
        public region Region
        public rect Rect
        public boolean array CanMove[15]
        public Object Next

        public static method create takes rect r returns thistype
            local thistype this = thistype.allocate()
            local trigger t = CreateTrigger()
            local integer i = 1

            set this.Region = CreateRegion()
            set this.Rect = r

            call RegionAddRect(this.Region, this.Rect)

            call EventMethod.AddByEvaluate(t, this, this.EnterRegion)
            call TriggerRegisterEnterRegion(t, this.Region, null)

            set t = CreateTrigger()
            call EventMethod.AddByEvaluate(t, this, this.LeaveRegion)
            call TriggerRegisterLeaveRegion(t, this.Region, null)

            set t = null

            loop
                exitwhen i >= 15
                set this.CanMove[i] = true
                set i = i + 1
            endloop

            return this
        endmethod

        public static method SetCanMove takes nothing returns nothing
            local tick tk = tick.getExpired()
            local thistype this = tk.data
            local integer id = tk.data2
            
            set this.CanMove[id] = true
        endmethod

        public method LeaveRegion takes nothing returns nothing
            local unit u = GetTriggerUnit()
            local integer id = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
            local integer i = 1

            if id != 12 and this.CanMove[id] == false and OrangeMushroom[id] == u then
                set Ticks[id].data = this
                set Ticks[id].data2 = id
                
                call Ticks[id].start(0.1, false, function thistype.SetCanMove)
            else
                loop
                    exitwhen i > Stage_BoxsCount
                    set id = PLAYER_MAXINUM + i

                    if this.CanMove[id] == false and OrangeMushroom[id] == u then
                        set Ticks[id].data = this
                        set Ticks[id].data2 = id

                        call Ticks[id].start(0.1, false, function thistype.SetCanMove)
                        exitwhen true
                    endif

                    set i = i + 1
                endloop
            endif
            
            set u = null
        endmethod

        public method EnterRegion takes nothing returns nothing
            local unit u = GetTriggerUnit()
            local integer id = GetPlayerId(GetOwningPlayer(u)) + 1
            local integer i = 1

            if Stage_Loading then
                set u = null
                return
            endif

            if id != 12 and this.CanMove[id] and OrangeMushroom[id] == u then
                set this.Next.CanMove[id] = false
                call this.Teleport(id)
            else
                loop
                    exitwhen i > Stage_BoxsCount
                    set id = PLAYER_MAXINUM + i

                    if this.CanMove[id] and OrangeMushroom[id] == u then
                        set this.Next.CanMove[id] = false
                        call this.Teleport(id)
                        exitwhen true
                    endif
                    
                    set i = i + 1                    
                endloop
            endif

            set u = null
        endmethod

        public method Teleport takes integer i returns nothing
            local real now_x = GetUnitX(OrangeMushroom[i])
            local real now_y = GetUnitY(OrangeMushroom[i])
            local real x = GetRectCenterX(this.Next.Rect)
            local real y = GetRectCenterY(this.Next.Rect)
            local rect r

            loop
                set r = Rect(x-64, y-64, x+64, y+64)
                exitwhen CountUnitsInGroup(GetUnitsInRectAll(r)) == 0
                if GravityChanger_State == false then
                    set y = y + 32
                else
                    set y = y - 32
                endif
                call RemoveRect(r)
            endloop
            call RemoveRect(r)
            
            if GetTerrainType(x, y) == BACKGROUND_TILE and ((GravityChanger_State == false and GetTerrainType(x, y+40) == BACKGROUND_TILE) or (GravityChanger_State == true and GetTerrainType(x, y-40) == BACKGROUND_TILE)) then
                call DestroyEffect(AddSpecialEffect( "war3mapImported\\Teleport.mdl", now_x, now_y ))
                call DestroyEffect(AddSpecialEffect( "war3mapImported\\Teleport.mdl", x, y ))
                call Water_EffectTimer(i)
                call SetUnitPosition( OrangeMushroom[i], x, y )
                call BackGroundMove(i, now_x, now_y)
            else
                call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 출구에 빈 공간이 없어 이동할 수 없습니다!")
            endif
            set r = null
        endmethod

    endstruct

    private struct ObjectLoc
        integer World
        integer Stage
        integer Count = 0
        Object array Item[6]

        static method create takes integer world, integer stage returns thistype
            local thistype this = thistype.allocate()
            set this.World = world
            set this.Stage = stage
            return this
        endmethod

        method AddItem takes Object obj returns nothing
            set this.Item[this.Count] = obj
            set this.Count = this.Count + 1
        endmethod

        method SetCanMoveInit takes nothing returns nothing
            local integer i = 0
            local integer j = 0

            loop
                exitwhen i >= 6
                if Item[i] != 0 then
                    loop
                        exitwhen j >= 15
                        set Item[i].CanMove[j] = true
                        set j = j + 1
                    endloop
                endif
                set i = i + 1
            endloop
        endmethod
    endstruct

    //! runtextmacro Make_LinkedList("ObjectLoc", "0")

    globals
        private ObjectLocLinkedList ObjectLocLink
    endglobals

    private function SetTicks takes nothing returns nothing
        local integer i = 1
        set Ticks = tickContainer.create()

        loop
            exitwhen i >= Ticks.Count
            set Ticks[i] = tick.create(0)
            set i = i + 1
        endloop
    endfunction

    private function ObjectCreate takes rect r1, rect r2 returns nothing
        local Object obj1 = Object.create(r1)
        local Object obj2 = Object.create(r2)
        local ObjectLoc objectLoc = ObjectLocLink.First.Item

        set obj1.Next = obj2
        set obj2.Next = obj1

        call objectLoc.AddItem(obj1)
        call objectLoc.AddItem(obj2)
    endfunction

    private function SetLevel takes integer world, integer stage returns nothing
        call ObjectLocLink.AddFirst(ObjectLoc.create(world, stage))
    endfunction

    public function ResetCanMove takes integer world, integer stage returns nothing
        local ObjectLocNode node = ObjectLocLink.First
        local ObjectLoc obj

        loop
            exitwhen node == 0
            set obj = node.Item
            if obj.World == world and obj.Stage == stage then
                call obj.SetCanMoveInit()
                exitwhen true
            endif
            set node = node.Next
        endloop

    endfunction

    private function Init takes nothing returns nothing
        set ObjectLocLink = ObjectLocLinkedList.create()
        call SetTicks()

        call SetLevel(12, 1)
        call ObjectCreate(gg_rct_MovePortal12_1_001, gg_rct_MovePortal12_1_002)
        call SetLevel(12, 2)
        call ObjectCreate(gg_rct_MovePortal12_2_001, gg_rct_MovePortal12_2_002)
        call ObjectCreate(gg_rct_MovePortal12_2_003, gg_rct_MovePortal12_2_004)
        call SetLevel(12, 3)
        call ObjectCreate(gg_rct_MovePortal12_3_001, gg_rct_MovePortal12_3_002)
        call SetLevel(12, 4)
        call ObjectCreate(gg_rct_MovePortal12_4_001, gg_rct_MovePortal12_4_002)
        call ObjectCreate(gg_rct_MovePortal12_4_003, gg_rct_MovePortal12_4_004)
        call SetLevel(12, 5)
        call ObjectCreate(gg_rct_MovePortal12_5_001, gg_rct_MovePortal12_5_002)
        call SetLevel(12, 6)
        call ObjectCreate(gg_rct_MovePortal12_6_001, gg_rct_MovePortal12_6_002)
        call ObjectCreate(gg_rct_MovePortal12_6_003, gg_rct_MovePortal12_6_004)
        call SetLevel(12, 7)
        call ObjectCreate(gg_rct_MovePortal12_7_001, gg_rct_MovePortal12_7_002)
        call ObjectCreate(gg_rct_MovePortal12_7_003, gg_rct_MovePortal12_7_004)
        call SetLevel(12, 8)
        call ObjectCreate(gg_rct_MovePortal12_8_001, gg_rct_MovePortal12_8_002)
        call SetLevel(14, 5)
        call ObjectCreate(gg_rct_MovePortal13_Minus1_001, gg_rct_MovePortal13_Minus1_002)
        call ObjectCreate(gg_rct_MovePortal13_Minus1_003, gg_rct_MovePortal13_Minus1_004)
        call SetLevel(13, 6)
        call ObjectCreate(gg_rct_MovePortal13_6_001, gg_rct_MovePortal13_6_002)
        call SetLevel(13, 8)
        call ObjectCreate(gg_rct_MovePortal13_8_001, gg_rct_MovePortal13_8_002)
        call ObjectCreate(gg_rct_MovePortal13_8_003, gg_rct_MovePortal13_8_004)
        call ObjectCreate(gg_rct_MovePortal13_8_005, gg_rct_MovePortal13_8_006)
        call SetLevel(14, 1)
        call ObjectCreate(gg_rct_MovePortal14_1_001, gg_rct_MovePortal14_1_002)
        call SetLevel(14, 2)
        call ObjectCreate(gg_rct_MovePortal14_2_001, gg_rct_MovePortal14_2_002)
        call SetLevel(14, 3)
        call ObjectCreate(gg_rct_MovePortal14_3_001, gg_rct_MovePortal14_3_002)
    endfunction
endlibrary
