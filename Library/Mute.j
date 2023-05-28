library Mute initializer Init
    globals
        private hashtable list = InitHashtable()
    endglobals

    private struct Mute
        private region r1
        private region r2

        private method Jumping takes region r returns nothing
            local integer i = 1

            //! runtextmacro for("set i = 1", "i <= PLAYER_MAXINUM")
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING and HasUnit(r, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]), i) then
                    call Jumper_Jumping(i, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]))
                endif
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = PLAYER_MAXINUM + 1", "i <= PLAYER_MAXINUM + Stage_BoxsCount")
                if HasUnit(r, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]), i) then
                    call Jumper_Jumping(i, GetUnitX(OrangeMushroom[i]), GetUnitY(OrangeMushroom[i]))
                endif
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Action takes unit user returns nothing
            if IsUnitInRegion(this.r1, user) then
                call this.Jumping(this.r2)
            else
                call this.Jumping(this.r1)
            endif
        endmethod

        public method Check takes unit user returns boolean
            return IsUnitInRegion(this.r1, user) or IsUnitInRegion(this.r2, user)
        endmethod

        public static method create takes rect r1, rect r2 returns thistype
            local thistype this = thistype.allocate()
            set this.r1 = CreateRegion()
            set this.r2 = CreateRegion()
            call RegionAddRect(this.r1, r1)
            call RegionAddRect(this.r2, r2)
            return this
        endmethod
    endstruct

    public function Main takes integer playerId, integer world, integer stage returns nothing
        local integer i = 0
        local aList a = LoadInteger(list, world, stage)

        if a == 0 then
            return
        endif

        //! runtextmacro for("set i = 0", "i < a.size")
            if Mute(a[i]).Check(OrangeMushroom[playerId]) then
                call Mute(a[i]).Action(OrangeMushroom[playerId])
                return
            endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    private function Add takes rect r1, rect r2, integer world, integer stage returns nothing
        local aList a = LoadInteger(list, world, stage)

        if a == 0 then
            set a = aList.create()
        endif

        call a.add(Mute.create(r1, r2))
        call SaveInteger(list, world, stage, a)
    endfunction

    private function Init takes nothing returns nothing 
        

    endfunction
endlibrary