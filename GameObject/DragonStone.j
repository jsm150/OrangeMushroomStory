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

    globals
        private rect rRect
        private integer rWorld
        private integer rStage
    endglobals

    private function RegisterSetting takes rect r, integer world, integer stage returns nothing
        set rRect = r
        set rWorld = world
        set rStage = stage
    endfunction

    private function Register takes real x, real y, integer block returns nothing
        local Object a = LoadInteger(list, rWorld, rStage)

        if a == 0 then
            set a = Object.create(rRect)
        endif


        call a.Add(Block.create(x, y, block))
        call SaveInteger(list, rWorld, rStage, a)
    endfunction

    private function Init takes nothing returns nothing
        local integer i = 0

        //15 - 1
        call RegisterSetting(gg_rct_DragonStone15_1_001, 15, 1)
        call Register(-9216, 26624, RefreStageTerrain)
        call Register(-11136, 25600, RefreStageTerrain)
        call Register(-11136 + 128, 25600, RefreStageTerrain)
        call Register(-10368, 26112, RefreStageTerrain)
        call Register(-10368, 26112 + 128, RefreStageTerrain)
        call Register(-10368, 26112 + 384, RefreStageTerrain)
        call Register(-10368, 26112 + 512, RefreStageTerrain)
        call Register(-10880, 26368, RefreStageTerrain)
        call Register(-10880 + 128, 26368, RefreStageTerrain)
        call Register(-10624, 27264, RefreStageTerrain)
        call Register(-10624 + 128, 27264, RefreStageTerrain)
        //! runtextmacro for("set i = 0", "i < 3")
            call Register(-12160, 26368 + (128 * i), RefreStageTerrain)
            call Register(-9344, 26752 + (128 * i), RefreStageTerrain)
            call Register(-10240, 27008 + (128 * i), RefreStageTerrain)
            call Register(-10624, 27392 + (128 * i), RefreStageTerrain)
            call Register(-12032 + (128 * i), 27008, RefreStageTerrain)
            call Register(-11264 + (128 * i), 27008, RefreStageTerrain)
        //! runtextmacro for_end("set i = i + 1")

    endfunction
endlibrary