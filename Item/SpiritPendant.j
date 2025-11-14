library SpiritPendant needs Stage
    private struct Unit
        real X
        real Y
        integer Type
        string Move

        public static method create takes real x, real y, integer t_ype, string move returns thistype
            local thistype this = thistype.allocate()
            set this.X = x
            set this.Y = y
            set this.Type = t_ype
            set this.Move = move
            return this
        endmethod
    endstruct

    private struct Airplane extends Unit
        real Gravity

        public static method create takes real x, real y, integer t_ype, string move, real gravity returns thistype
            local thistype this = thistype.allocate(x, y, t_ype, move)
            set this.Gravity = gravity
            return this
        endmethod
    endstruct

    private struct KeyHistory
        boolean Red
        boolean Yellow
        boolean Blue
        boolean White

        public static method create takes boolean red, boolean yellow, boolean blue, boolean white returns thistype
            local thistype this = thistype.allocate()
            set this.Red = red
            set this.Yellow = yellow
            set this.Blue = blue
            set this.White = white
            return this
        endmethod
    endstruct

    public struct TimeSlip
        private static hashtable blockHistory = InitHashtable()
        private integer blockHistoryCount
        private integer world
        private integer stage
        private boolean dragonStoneState
        private boolean array clearList[PLAYER_MAXINUM]
        private Unit array userList[PLAYER_MAXINUM]
        private aList object
        private KeyHistory keyHistory
        private boolean gravityState
        private aList morphUseList
        private aList gravityUseList
        private boolean array inMirrorState[PLAYER_MAXINUM]
        private integer bombBlockCount
        private static hashtable bombBlockHistory = InitHashtable()
        private integer cartStorageCount
        private static hashtable cartStorage = InitHashtable()

        public method Equals takes integer world, integer stage returns boolean
            return this.world == world and this.stage == stage
        endmethod

        public method destroy takes nothing returns nothing
            local integer i = 0
            local integer c = 0
            //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
                if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING and this.clearList[i] == false then
                    call this.userList[i].destroy()
                endif
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < blockHistoryCount")
                call RemoveLocation(LoadLocationHandle(blockHistory, this, i))
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < this.bombBlockCount")
                call RemoveLocation(LoadLocationHandle(bombBlockHistory, this, i * 3))
                call RemoveLocation(LoadLocationHandle(bombBlockHistory, this, i * 3 + 1))
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < this.cartStorageCount")
                call FlushChildHashtable(cartStorage, this * 8192 + i)
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < this.object.size")
                if Unit(this.object[i]).Type == 'orai' then
                    call Airplane(this.object[i]).destroy()
                else
                    call Unit(this.object[i]).destroy()
                endif
            //! runtextmacro for_end("set i = i + 1")
            call this.object.destroy()

            call this.morphUseList.destroy()
            call this.gravityUseList.destroy()
            call this.keyHistory.destroy()
            call thistype.deallocate(this)
        endmethod

        private method RestorePlayerUnit takes nothing returns nothing
            local integer i = 0
            local boolean temp

            // 플레이어 위치 이동 및 타입 변경
            //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
                if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                    if this.clearList[i] == false then
                        call RemoveUnit(OrangeMushroom[i + 1])
                        set OrangeMushroom[i + 1] = CreateUnit(Player(i), this.userList[i].Type, this.userList[i].X, this.userList[i].Y, 270 )
                        call SetUnitBlendTime(OrangeMushroom[i + 1], 0.00)
                        if this.userList[i].Move == "Left" then
                            set LeftArrow[i + 1] = true
                            set Direction[i + 1] = "Left"
                        elseif this.userList[i].Move == "Right" then
                            set RightArrow[i + 1] = true
                            set Direction[i + 1] = "Right"
                        endif
                        if this.userList[i].Type == 'ogru' or this.userList[i].Type == 'otau' or this.userList[i].Type == 'ocat' or this.userList[i].Type == 'ohun' or this.userList[i].Type == 'orai' then
                            set MorphState[i + 1] = true
                        endif
                        if this.gravityState then
                            set temp = LeftArrow[i + 1]
                            set LeftArrow[i + 1] = RightArrow[i + 1]
                            set RightArrow[i + 1] = temp
                        endif
                        if this.inMirrorState[i] then
                            call Mirror_SetInMirrorState(i + 1, true)
                            call Mirror_ChangeBackGround(i + 1, true)
                        endif
                    else
                        call Observer_Start(i + 1)
                    endif
                endif
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        private method RestoreObjectUnit takes nothing returns nothing
            local integer i = 0
            local boolean temp
            
            //! runtextmacro for("set i = 0", "i < this.object.size")
                call RemoveUnit(OrangeMushroom[PLAYER_MAXINUM + i + 1])
                set OrangeMushroom[PLAYER_MAXINUM + i + 1] = CreateUnit(Player(11), Unit(this.object[i]).Type, Unit(this.object[i]).X, Unit(this.object[i]).Y, 270 )
                call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM + i + 1], 0.00)
                if Unit(this.object[i]).Move == "Left" then
                    set LeftArrow[PLAYER_MAXINUM + i + 1] = true
                    set RightArrow[PLAYER_MAXINUM + i + 1] = false
                    set Direction[PLAYER_MAXINUM + i + 1] = "Left"
                elseif Unit(this.object[i]).Move == "Right" then
                    set LeftArrow[PLAYER_MAXINUM + i + 1] = false
                    set RightArrow[PLAYER_MAXINUM + i + 1] = true
                    set Direction[PLAYER_MAXINUM + i + 1] = "Right"
                else
                    set LeftArrow[PLAYER_MAXINUM + i + 1] = false
                    set RightArrow[PLAYER_MAXINUM + i + 1] = false
                endif

                if Unit(this.object[i]).Type == 'orai' then
                    set gravity[PLAYER_MAXINUM + i + 1] = Airplane(this.object[i]).Gravity
                endif

                if this.gravityState then
                    set temp = LeftArrow[PLAYER_MAXINUM + i + 1]
                    set LeftArrow[PLAYER_MAXINUM + i + 1] = RightArrow[PLAYER_MAXINUM + i + 1]
                    set RightArrow[PLAYER_MAXINUM + i + 1] = temp
                endif
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        private method UseKey takes nothing returns nothing
            if this.keyHistory.Red then
                call Key_keyMap.Execute(Status.World, Status.Level, Key_RED_KEY_ID)
            endif
            if this.keyHistory.Yellow then
                call Key_keyMap.Execute(Status.World, Status.Level, Key_YELLOW_KEY_ID)
            endif
            if this.keyHistory.Blue then
                call Key_keyMap.Execute(Status.World, Status.Level, Key_BLUE_KEY_ID)
            endif
            if this.keyHistory.White then
                call Key_keyMap.Execute(Status.World, Status.Level, Key_WHITE_KEY_ID)
            endif
        endmethod

        private method UseConsumableItem takes nothing returns nothing
            local integer i = 0
            //! runtextmacro for("set i = 0", "i < this.morphUseList.size")
                call MorphStone_Use(this.morphUseList[i])
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < this.gravityUseList.size")
                call JNWriteLog("All Count " + I2S(this.gravityUseList.size))
                call GravityChanger_Use(this.gravityUseList[i])
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        private method DragonStoneSetting takes nothing returns nothing
            if this.dragonStoneState then
                call DragonStone_Execute(this.world, this.stage)
            endif
        endmethod

        private method DestroyLaserBlock takes nothing returns nothing
            local integer i = 0
            local real x
            local real y
            //! runtextmacro for("set i = 0", "i < blockHistoryCount")
                set x = GetLocationX(LoadLocationHandle(blockHistory, this, i))
                set y = GetLocationY(LoadLocationHandle(blockHistory, this, i))
                call SetTerrainType(x, y, BACKGROUND_TILE, -1, 1, 0)
                call Frame_LaserBlockHistory.Add(x, y)
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        private method RestoreBombBlocks takes nothing returns nothing
            local integer i = 0
            local location loc
            local real x
            local real y
            local integer blockType
            //! runtextmacro for("set i = 0", "i < this.bombBlockCount")
                set loc = LoadLocationHandle(bombBlockHistory, this, i * 3)
                set x = GetLocationX(loc)
                set y = GetLocationY(loc)
                set loc = LoadLocationHandle(bombBlockHistory, this, i * 3 + 1)
                set blockType = R2I(GetLocationX(loc))
                call Stage_BlockBoom.SetBlock(i, x, y, blockType)
            //! runtextmacro for_end("set i = i + 1")
            call Stage_BlockBoom.SetState(this.bombBlockCount)
            call Stage_BlockBoom.Reset()
        endmethod

        private method RestoreCartStorage takes nothing returns nothing
            local integer i = 0
            local Unit cartUnit
            local integer unitId
            local boolean left
            local boolean right
            local string direction
            //! runtextmacro for("set i = 0", "i < this.cartStorageCount")
                set unitId = LoadInteger(cartStorage, this, i * 4)
                if unitId != 0 then
                    set left = LoadBoolean(cartStorage, this, i * 4 + 1)
                    set right = LoadBoolean(cartStorage, this, i * 4 + 2)
                    set direction = LoadStr(cartStorage, this, i * 4 + 3)
                    set cartUnit = Unit.create(unitId, left, right, direction)
                    call Cart_SetStorage(i, cartUnit)
                else
                    call Cart_SetStorage(i, 0)
                endif
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Play takes nothing returns nothing
            call Stage_SetRestartMode()
            call Stage_ResetStage()

            set GravityChanger_Loading = true

            call this.RestorePlayerUnit()
            call this.RestoreObjectUnit()
            call this.UseConsumableItem()
            call this.DestroyLaserBlock()
            call this.RestoreBombBlocks()
            call this.RestoreCartStorage()
            call this.DragonStoneSetting()
            call this.UseKey()

            if this.gravityState then
                call GravityChanger_ChangeAction()
                set GravityChanger_Loading = true
                call GravityChanger_ChangeTimerAction()
            endif
        endmethod

        public static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            local integer i = 0
            local string move

            //! runtextmacro for("set i = 0", "i < PLAYER_MAXINUM")
                if GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING then
                    if LevelClearState[i + 1] then
                        set this.clearList[i] = true
                    else
                        if LeftArrow[i + 1] then
                            set move = "Left"
                        elseif RightArrow[i + 1] then
                            set move = "Right"
                        else
                            set move = "Stop"
                        endif

                        set this.clearList[i] = false
                        set this.userList[i] = Unit.create( /*
                        */  GetUnitX(OrangeMushroom[i + 1]), /*
                        */  GetUnitY(OrangeMushroom[i + 1]), /*
                        */  GetUnitTypeId(OrangeMushroom[i + 1]), /*
                        */  move /*
                        */)

                        if Mirror_InLevel(Status.World, Status.Level) then
                            set this.inMirrorState[i] = Mirror_GetInMirrorState(i + 1)
                        endif
                    endif

                endif
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < Frame_LaserBlockHistory.Count")
                call SaveLocationHandle(blockHistory, this, i, Location(GetLocationX(LoadLocationHandle(Frame_LaserBlockHistory.List, 0, i)), GetLocationY(LoadLocationHandle(Frame_LaserBlockHistory.List, 0, i))))
            //! runtextmacro for_end("set i = i + 1")
            set blockHistoryCount = Frame_LaserBlockHistory.Count

            set this.keyHistory = KeyHistory.create( /*
            */  Key_UseHistroy.Red, /*
            */  Key_UseHistroy.Yellow, /*
            */  Key_UseHistroy.Blue, /*
            */  Key_UseHistroy.White /*
            */)

            
            set this.object = aList.create()
            //! runtextmacro for("set i = 1", "i <= Stage_BoxsCount")
                if LeftArrow[PLAYER_MAXINUM + i] then
                    set move = "Left"
                elseif RightArrow[PLAYER_MAXINUM + i] then
                    set move = "Right"
                else
                    set move = "Stop"
                endif

                if GetUnitTypeId(OrangeMushroom[PLAYER_MAXINUM + i]) == 'orai' then
                    call this.object.add(Airplane.create( /*
                    */  GetUnitX(OrangeMushroom[PLAYER_MAXINUM + i]), /*
                    */  GetUnitY(OrangeMushroom[PLAYER_MAXINUM + i]), /*
                    */  GetUnitTypeId(OrangeMushroom[PLAYER_MAXINUM + i]), /*
                    */  move, /*
                    */  gravity[PLAYER_MAXINUM + i] /*
                    */))
                else
                    call this.object.add(Unit.create( /*
                    */  GetUnitX(OrangeMushroom[PLAYER_MAXINUM + i]), /*
                    */  GetUnitY(OrangeMushroom[PLAYER_MAXINUM + i]), /*
                    */  GetUnitTypeId(OrangeMushroom[PLAYER_MAXINUM + i]), /*
                    */  move /*
                    */))
                endif
                
            //! runtextmacro for_end("set i = i + 1")

            set this.morphUseList = aList.create()
            //! runtextmacro for("set i = 0", "i < MorphStone_UseCount")
                call this.morphUseList.add(MorphStone_UseList[i])
            //! runtextmacro for_end("set i = i + 1")

            set this.gravityUseList = aList.create()
            call JNWriteLog("gravityUseList " + I2S(this.gravityUseList))
            //! runtextmacro for("set i = 0", "i < GravityChanger_UseCount")
                call this.gravityUseList.add(GravityChanger_UseList[i])
                call JNWriteLog("Load " + I2S(GravityChanger_UseList[i]) + " Count " + I2S(i + 1))
            //! runtextmacro for_end("set i = i + 1")

            // 폭탄으로 파괴된 블록 저장
            set this.bombBlockCount = Stage_BlockBoom.GetCount()
            //! runtextmacro for("set i = 0", "i < this.bombBlockCount")
                call SaveLocationHandle(bombBlockHistory, this, i * 3, Location(Stage_BlockBoom.GetBlockX(i), Stage_BlockBoom.GetBlockY(i)))
                call SaveLocationHandle(bombBlockHistory, this, i * 3 + 1, Location(I2R(Stage_BlockBoom.GetBlockType(i)), 0))
            //! runtextmacro for_end("set i = i + 1")

            // 수레에 담긴 오브젝트 저장
            set this.cartStorageCount = Cart_GetCount()
            //! runtextmacro for("set i = 0", "i < this.cartStorageCount")
                if Cart_GetStorage(i) != 0 then
                    call SaveInteger(cartStorage, this, i * 4, Cart_GetStorage(i).Id)
                    call SaveBoolean(cartStorage, this, i * 4 + 1, Cart_GetStorage(i).Left)
                    call SaveBoolean(cartStorage, this, i * 4 + 2, Cart_GetStorage(i).Right)
                    call SaveStr(cartStorage, this, i * 4 + 3, Cart_GetStorage(i).Direction)
                else
                    call SaveInteger(cartStorage, this, i * 4, 0)
                endif
            //! runtextmacro for_end("set i = i + 1")

            set this.world = Status.World
            set this.stage = Status.Level
            set this.gravityState = GravityChanger_State
            set this.dragonStoneState = DragonStone_IsOn(Status.World, Status.Level)

            return this
        endmethod
    endstruct

    globals
        private integer array PlayerTimeList[PLAYER_MAXINUM]
    endglobals

    public function Remove takes integer i returns nothing
        call TimeSlip(PlayerTimeList[i]).destroy()
        set PlayerTimeList[i] = 0
    endfunction

    public function Ready takes integer i returns boolean
        return PlayerTimeList[i] != 0
    endfunction

    public function Check takes integer i returns boolean
        return TimeSlip(PlayerTimeList[i]).Equals(Status.World, Status.Level)
    endfunction

    public function Record takes integer i returns nothing
        set PlayerTimeList[i] = TimeSlip.create()
    endfunction

    public function Use takes integer i returns nothing
        call TimeSlip(PlayerTimeList[i]).Play()
    endfunction

endlibrary
