library Cart initializer Init needs TriggerSleepAction

    private struct Unit
        public integer Id
        public boolean Left
        public boolean Right
        public string Direction

        public static method create takes integer id, boolean left, boolean right, string direction returns thistype
            local thistype this = thistype.allocate()
            set this.Id = id
            set this.Left = left
            set this.Right = right
            set this.Direction = direction
            return this
        endmethod
    endstruct


    globals
        private unit array uList
        private Unit array storage
        private integer count = 0
    endglobals


    private function Find takes unit u returns integer
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < count")
            exitwhen uList[i] == u
        //! runtextmacro for_end("set i = i + 1")

        return i
    endfunction

    public function Add takes unit u returns nothing
        set uList[count] = u
        set count = count + 1
    endfunction

    private function ChangeCartImg takes unit u, integer idx returns nothing
        local unit img = CreateUnit(Player(11), storage[idx].Id, GetUnitX(u), GetUnitY(u), 270 )

        call SetUnitVertexColor(img, 255, 255, 255, 150)
        call SetUnitScale(img, 0.5, 0.5, 1)
        loop
            exitwhen storage[idx] == 0

            call SetUnitX(img, GetUnitX(u))
            call SetUnitY(img, GetUnitY(u))

            call TriggerSleepActionByTimer(0.02)
        endloop

        call RemoveUnit(img)
        set img = null
    endfunction

    public function CanTakeOut takes unit u returns boolean
        local integer idx = Find(u)
        return idx != count and storage[idx] != 0
    endfunction

    public function Bump takes unit u, unit target, integer which returns nothing
        local integer idx = Find(u)
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)

        if idx == count or storage[idx] != 0 then
            return
        endif

        set storage[idx] = Unit.create(GetUnitTypeId(target), LeftArrow[which], RightArrow[which], Direction[which])
        call ChangeCartImg.execute(u, idx)

        call DestroyEffect(AddSpecialEffect("war3mapImported\\Morph.mdl", x, y ))
    endfunction
    
    public function TakeOut takes unit u, integer num returns nothing
        local integer idx = Find(u)
        local real x = GetUnitX(u)
        local real y = GetUnitY(u)
        local string first = "First"
        local string second = "Second"
        call RemoveUnit(u)

        set OrangeMushroom[num] = CreateUnit(Player(11), storage[idx].Id, x, y, 270 )
        set LeftArrow[num] = storage[idx].Left
        set RightArrow[num] = storage[idx].Right
        set Direction[num] = storage[idx].Direction
        call SetUnitBlendTime(OrangeMushroom[num], 0.00)

        debug call JNWriteLog("  " + storage[idx].Direction)

        if GravityChanger_State then
            set first = "Second"
            set second = "First"
        endif

        if gravity[num] < 0 and MushroomMoving_RectCondition(num, x, y, 40, "DownWidth") == false then
            if storage[idx].Direction == "Left" then
                call SetUnitAnimation( OrangeMushroom[num], "Stand " + first )
            else
                call SetUnitAnimation( OrangeMushroom[num], "Stand " + second )
            endif
        else
            if storage[idx].Direction == "Left" then
                call SetUnitAnimation( OrangeMushroom[num], "Spell " + first)
            else
                call SetUnitAnimation( OrangeMushroom[num], "Spell " + second )
            endif
        endif

        set gravity[num] = 0
        set Acceleration[num] = 0

        call storage[idx].destroy()
        set storage[idx] = 0
        call DestroyEffect(AddSpecialEffect("war3mapImported\\Morph.mdl", x, y ))
    endfunction

    public function Reset takes nothing returns nothing
        local integer i = 0

        //! runtextmacro for("set i = 0", "i < count")
            if storage[i] != null then
                call storage[i].destroy()
                set storage[i] = 0
            endif
        //! runtextmacro for_end("set i = i + 1")
        
        set count = 0
    endfunction


    private function Init takes nothing returns nothing
        
    endfunction
endlibrary
