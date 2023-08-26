library DragonStone initializer Init needs Key
    globals
        private hashtable list = InitHashtable()
    endglobals

    private struct Block
        private integer actionBlock
        private real x
        private real y
        
        public method Change takes nothing returns nothing
            call SetTerrainType(this.x, this.y, this.actionBlock, -1, 1, 0)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", this.x, this.y ))
        endmethod

        public method Reset takes nothing returns nothing
            call SetTerrainType(this.x, this.y, UnTerrain, -1, 1, 0)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", this.x, this.y ))
        endmethod

        public static method create takes real x, real y, integer blockType returns thistype
            local thistype this = thistype.allocate()
            set this.x = x
            set this.y = y
            set this.actionBlock = blockType
            return this
        endmethod
    endstruct

    private struct Object
        private rect r
        private aList list
        private boolean isChange = false

        public method Add takes Block b returns nothing
            call this.list.add(b)
        endmethod

        public method Check takes unit u returns boolean
            return RectContainsUnit(this.r, u)
        endmethod

        public method Change takes nothing returns nothing
            local integer i = 0
            set this.isChange = true
            call SetDoodadAnimation(GetRectCenterX(this.r), GetRectCenterY(this.r), 128.00, 'D00R', false, "stand ready", false)
            //! runtextmacro for("set i = 0", "i < this.list.size")
                call Block(list[i]).Change()
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Reset takes nothing returns nothing
            local integer i = 0
            set this.isChange = false
            call SetDoodadAnimation(GetRectCenterX(this.r), GetRectCenterY(this.r), 128.00, 'D00R', false, "stand", false)
            //! runtextmacro for("set i = 0", "i < this.list.size")
                call Block(list[i]).Reset()
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public method Action takes nothing returns nothing
            if this.isChange then
                call this.Reset()
                else 
                call this.Change()
            endif
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(this.r), GetRectCenterY(this.r) ))
        endmethod

        public static method create takes rect r returns thistype
            local thistype this = thistype.allocate()
            set this.r = r
            set this.list = aList.create()
            return this
        endmethod
    endstruct

    public function Restore takes integer world, integer stage returns nothing
        local Object a = LoadInteger(list, world, stage)

        if a > 0 then
            if world == 15 and stage == 1 then
                call a.Change()
            else
                call a.Reset()
            endif
        endif
    endfunction

    public function Main takes integer playerId, integer world, integer stage returns nothing
        local Object a = LoadInteger(list, world, stage)

        if a > 0 and a.Check(OrangeMushroom[playerId]) then
            call a.Action()
        endif
    endfunction

    private function Register takes real x, real y, integer block, rect r, integer world, integer stage returns nothing
        local Object a = LoadInteger(list, world, stage)

        if a == 0 then
            set a = Object.create(r)
        endif


        call a.Add(Block.create(x, y, block))
        call SaveInteger(list, world, stage, a)
    endfunction

    private function Init takes nothing returns nothing
        // 15 - 1
        call Register(-16512, 13440, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-16640, 14080, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-16768, 14464, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-16768, 14464 + 128, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-14336, 14208, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-14208, 13824, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-14848, 13568, RefreStageTerrain, gg_rct_DragonStone15_1_001, 15, 1)
    endfunction
endlibrary