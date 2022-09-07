library Decorate initializer Init
    globals
        public key Aura
        public key Designation
        public key FloorAura
        public key Pet
        public key Soul

        private hashtable posList = InitHashtable()
    endglobals

    private struct Skin
        public real offsetX
        public real offsetY
        private integer skinType
        private unit dummyUnit

        public method operator Type takes nothing returns integer
            return this.skinType
        endmethod

        public method operator Unit takes nothing returns unit
            return this.dummyUnit
        endmethod

        public method operator Id takes nothing returns integer
            return GetUnitTypeId(this.dummyUnit)
        endmethod

        public method SetAngle takes real angle returns nothing
            call SetUnitFacing(this.dummyUnit, angle)
        endmethod

        public method Show takes boolean show returns nothing
            call ShowUnit(this.dummyUnit, show)
        endmethod

        public stub method Move takes real refX, real refY returns nothing
            if GravityChanger_State then
                call SetUnitX(this.dummyUnit, refX - this.offsetX)
                call SetUnitY(this.dummyUnit, refY - this.offsetY)
            else
                call SetUnitX(this.dummyUnit, refX + this.offsetX)
                call SetUnitY(this.dummyUnit, refY + this.offsetY)
            endif
        endmethod

        public static method create takes real offsetX, real offsetY, integer playerId, integer unitId, integer skinType returns thistype
            local thistype this = thistype.allocate()
            set this.offsetX = offsetX
            set this.offsetY = offsetY
            set this.skinType = skinType
            if GravityChanger_State then
                set this.dummyUnit = CreateUnit(Player(playerId), unitId, 0, 0, 90)
            else
                set this.dummyUnit = CreateUnit(Player(playerId), unitId, 0, 0, 270)
            endif
            return this
        endmethod

        public method destroy takes nothing returns nothing
            call RemoveUnit(this.dummyUnit)
            call thistype.deallocate(this)
        endmethod
    endstruct

    public struct PetSkin extends Skin
        public method GoLeft takes nothing returns nothing
            if this.offsetX < 0 then
                set this.offsetX = this.offsetX * -1
            endif
        endmethod

        public method GoRight takes nothing returns nothing
            if this.offsetX > 0 then
                set this.offsetX = this.offsetX * -1
            endif
        endmethod

        public method Move takes real refX, real refY returns nothing
            if GravityChanger_State then
                call SetUnitX(this.Unit, refX + this.offsetX)
                call SetUnitY(this.Unit, refY - this.offsetY)
            else
                call SetUnitX(this.Unit, refX + this.offsetX)
                call SetUnitY(this.Unit, refY + this.offsetY)
            endif
        endmethod
        
        public static method create takes real offsetX, real offsetY, integer playerId, integer unitId, integer skinType returns thistype
            return thistype.allocate(offsetX, offsetY, playerId, unitId, skinType)
        endmethod
    endstruct

    private type DecorateSkinUserList extends sList array[PLAYER_MAXINUM]

    globals
        private DecorateSkinUserList List
    endglobals

    public function SetAbility takes integer playerId, integer abilityId, boolean apply returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < List[playerId].size")
        if apply then
            call UnitAddAbility(Skin(List[playerId][i]).Unit, abilityId)
        else
            call UnitRemoveAbility(Skin(List[playerId][i]).Unit, abilityId)
        endif
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    public function IsTriggeringUnitInDecorate takes integer playerId returns boolean
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < List[playerId].size")
            if Skin(List[playerId][i]).Unit == GetTriggerUnit() then
                return true
            endif
        //! runtextmacro for_end("set i = i + 1")
        return false
    endfunction

    public function AddDecorate takes integer playerId, integer unitId, integer skinType returns nothing
        local real offsetX = GetLocationX(LoadLocationHandle(posList, 0, skinType))
        local real offsetY = GetLocationY(LoadLocationHandle(posList, 0, skinType))
        local integer i = 0
        local Skin temp = 0

        //! runtextmacro for("set i = 0", "i < List[playerId].size")
            if Skin(List[playerId][i]).Id == unitId then
                set temp = List[playerId][i]
                call List[playerId].remove(temp)
                call temp.destroy()
                return
            endif
            if Skin(List[playerId][i]).Type == skinType then
                set temp = List[playerId][i]
                call List[playerId].remove(temp)
                call temp.destroy()
                exitwhen true
            endif
        //! runtextmacro for_end("set i = i + 1")

        if skinType == Pet then
            set temp = PetSkin.create(offsetX, offsetY, playerId, unitId, skinType)
        else
            set temp = Skin.create(offsetX, offsetY, playerId, unitId, skinType)
        endif

        call List[playerId].add(temp)

        if LevelClearState[playerId + 1] == false then
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", /*
                */ GetUnitX(OrangeMushroom[playerId + 1]), GetUnitY(OrangeMushroom[playerId + 1]) ))
        else
            call temp.Show(false)
        endif
    endfunction

    public function RemoveAll takes integer playerId returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < List[playerId].size")
            call Skin(List[playerId][i]).destroy()
        //! runtextmacro for_end("set i = i + 1")  
        call List[playerId].clear()
    endfunction

    public function UnitShow takes integer playerId, boolean show returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < List[playerId].size")
            call Skin(List[playerId][i]).Show(show)
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    public function SetUnitAngle takes integer playerId, real angle returns nothing
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < List[playerId].size")
            call Skin(List[playerId][i]).SetAngle(angle)
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    public function Movement takes nothing returns nothing
        local integer i = 0
        local integer j = 0
        local real x = 0
        local real y = 0

        //! runtextmacro for("set i = 0", "i < List.size")
            set x = GetUnitX(OrangeMushroom[i + 1])
            set y = GetUnitY(OrangeMushroom[i + 1])
            //! runtextmacro for("set j = 0", "j < List[i].size")
                call Skin(List[i][j]).Move(x, y)
            //! runtextmacro for_end("set j = j + 1")
        //! runtextmacro for_end("set i = i + 1")
    endfunction

    public function GetPetSkin takes integer playerId returns PetSkin
        local integer i = 0
        //! runtextmacro for("set i = 0", "i < List[playerId].size")
            if Skin(List[playerId][i]).Type == Pet then
                return List[playerId][i]
            endif
        //! runtextmacro for_end("set i = i + 1")
        return 0
    endfunction

    private function InitPosList takes nothing returns nothing
        call SaveLocationHandle(posList, 0, Aura, Location(0, 0))
        call SaveLocationHandle(posList, 0, Designation, Location(0, -150))
        call SaveLocationHandle(posList, 0, FloorAura, Location(0, 15))
        call SaveLocationHandle(posList, 0, Pet, Location(-110, -39))
        call SaveLocationHandle(posList, 0, Soul, Location(0, 180))
    endfunction

    private function Init takes nothing returns nothing
        local integer i = 0

        set List = DecorateSkinUserList.create()
        //! runtextmacro for("set i = 0", "i < List.size")
            set List[i] = sList.create()
        //! runtextmacro for_end("set i = i + 1")

        call InitPosList()
    endfunction
endlibrary