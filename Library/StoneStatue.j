library StoneStatue initializer Init needs Key

    public struct cameraControler
        static timer tk = CreateTimer()
        static boolean array IsShakeOffForPlayer

        static method ShakeOn takes integer i returns nothing
            set IsShakeOffForPlayer[i] = false
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "※ 진동을 켰습니다.")           
        endmethod

        static method ShakeOff takes integer i returns nothing
            set IsShakeOffForPlayer[i] = true
            call DisplayTimedTextToPlayer(Player(i), 0, 0, 5, "※ 진동을 껏습니다.")
        endmethod

        static method CameraShakeOff takes nothing returns nothing
            local integer i = 0
    
            loop
                exitwhen i > PLAYER_MAXINUM
                call CameraClearNoiseForPlayer(Player(i))
                set i = i + 1
            endloop
        endmethod
    
        static method CameraShakeAll takes real time returns nothing
            local integer i = 0
    
            loop
                exitwhen i > PLAYER_MAXINUM
                if IsShakeOffForPlayer[i] == false then
                    call CameraSetTargetNoiseForPlayer(Player(i), 10, 250)
                endif
                set i = i + 1
            endloop
    
            call TimerStart(thistype.tk, time, false, function thistype.CameraShakeOff)
        endmethod
    endstruct

    private struct abstractBlock
        real X
        real Y
        integer Type

        stub method Action takes nothing returns nothing
        endmethod

        stub method Reset takes nothing returns nothing
        endmethod

        method Change takes integer blockType returns nothing
            call SetTerrainType(this.X, this.Y, blockType, -1, 1, 0)
        endmethod

        static method create takes real x, real y, integer Type returns thistype
            local thistype this = thistype.allocate()
            set this.X = x
            set this.Y = y
            set this.Type = Type
            return this
        endmethod
    endstruct


    private struct generatedBlock extends abstractBlock
        static method create takes real x, real y, integer Type returns thistype
            return thistype.allocate(x, y, Type)
        endmethod

        method Action takes nothing returns nothing
            call this.Change(UnTerrain)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", this.X, this.Y ))
        endmethod

        method Reset takes nothing returns nothing
            call this.Change(this.Type)
        endmethod
    endstruct

    private struct removedBlock extends abstractBlock
        static method create takes real x, real y, integer Type returns thistype
            return thistype.allocate(x, y, Type)
        endmethod

        method Action takes nothing returns nothing
            call this.Change(this.Type)
        endmethod
        
        method Reset takes nothing returns nothing
            call this.Change(UnTerrain)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\FrostArmor\\FrostArmorDamage.mdl", this.X, this.Y ))
        endmethod
    endstruct


    //! runtextmacro Make_LinkedList("abstractBlock", "0")


    private struct blocks
        abstractBlockLinkedList BlockList

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.BlockList = abstractBlockLinkedList.create()
            return this
        endmethod

        method Add takes abstractBlock b returns nothing
            call BlockList.AddFirst(b)
        endmethod

        method Action takes nothing returns nothing
            call this.ChangeBlock("Action")
        endmethod

        method Reset takes nothing returns nothing
            call this.ChangeBlock("Reset")
        endmethod

        private method ChangeBlock takes string blockType returns nothing
            local abstractBlockNode node = BlockList.First
            local abstractBlock b

            loop
                exitwhen node == 0
                set b = node.Item
                if blockType == "Action" then
                    call b.Action()
                elseif blockType == "Reset" then
                    call b.Reset()
                endif
                set node = node.Next
            endloop
        endmethod
    endstruct

    private struct stoneStatue // 석상
        region Region
        rect Rect
        boolean IsOn
        blocks Blocks
        integer World
        integer Stage

        private static method TypeCondition takes unit u returns boolean
            local integer kind = GetUnitTypeId(u)
            return MushroomType(kind) or kind == 'opeo' or kind == 'ogru' or kind == 'otau' or kind == 'ocat' or kind == 'ohun' or kind == 'o000' or kind == 'o001'
        endmethod

        method AddBlock takes abstractBlock b returns nothing
            call Blocks.Add(b)
        endmethod

        method Activate takes nothing returns nothing
            call SetDoodadAnimation(GetRectCenterX(this.Rect), GetRectCenterY(this.Rect), 128.00, 'D008', false, "stand ready", false)
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\StaffOfPurification\\PurificationCaster.mdl", GetRectCenterX(this.Rect), GetRectCenterY(this.Rect) ))
            call this.Blocks.Action()
        endmethod

        method Deactivate takes nothing returns nothing
            call SetDoodadAnimation(GetRectCenterX(this.Rect), GetRectCenterY(this.Rect), 128.00, 'D008', false, "stand", false)
            call this.Blocks.Reset()
        endmethod

        method Reset takes nothing returns nothing
            set this.IsOn = false
            call this.Deactivate()
        endmethod

        private method RectInUnit takes nothing returns boolean
            local integer i = 1

            loop
                exitwhen i > PLAYER_MAXINUM + Stage_BoxsCount
                if RectContainsUnit(this.Rect, OrangeMushroom[i]) and GetUnitTypeId(OrangeMushroom[i]) != 'orai' then
                    return true
                endif
                set i = i + 1
            endloop

            return false
        endmethod

        private method InAction takes nothing returns nothing
            local unit u = GetTriggerUnit()

            if this.TypeCondition(u) and this.IsOn == false then
                set this.IsOn = true
                call StartSound(gg_snd_StoneStatueBgm)
                call cameraControler.CameraShakeAll(1.0)
                call this.Activate()
            endif

            set u = null
        endmethod

        private method OutAction takes nothing returns nothing
            local unit u = GetTriggerUnit()

            if this.TypeCondition(u) and this.RectInUnit() == false then
                set this.IsOn = false
                call StartSound(gg_snd_StoneStatueBgm)
                call cameraControler.CameraShakeAll(1.0)
                call this.Deactivate()
            endif

            set u = null
        endmethod

        public static method create takes rect r, integer world, integer stage returns thistype
            local thistype this = thistype.allocate()
            local trigger t = CreateTrigger()

            set this.Region = CreateRegion()
            set this.Rect = r

            call RegionAddRect(this.Region, this.Rect)

            set this.World = world
            set this.Stage = stage
            set this.IsOn = false

            set this.Blocks = blocks.create()

            call EventMethod.AddByEvaluate(t, this, this.InAction)
            call TriggerRegisterEnterRegion(t, this.Region, null)

            set t = CreateTrigger()
            call EventMethod.AddByEvaluate(t, this, this.OutAction)
            call TriggerRegisterLeaveRegion(t, this.Region, null)

            set t = null
            return this
        endmethod
    endstruct


    //! runtextmacro Make_LinkedList("stoneStatue", "0")

    globals
        private stoneStatueLinkedList stoneStatueList
    endglobals

    
    private function InitBlocks takes nothing returns nothing
        local stoneStatueNode node = stoneStatueList.First

        loop
            exitwhen node == 0
            call node.Item.Reset()
            set node = node.Next
        endloop
    endfunction

    public function ResetBlocks takes integer world, integer stage returns nothing
        local stoneStatueNode node = stoneStatueList.First
        local stoneStatue st

        loop
            exitwhen node == 0
            set st = node.Item
            if world == st.World and stage == st.Stage then
                call st.Reset()
                exitwhen true
            endif
            set node = node.Next
        endloop
    endfunction

    private function RegisterStoneStatue takes nothing returns nothing
        local integer i
        local stoneStatue st

        // -------------------------------------------------------
        set st = stoneStatue.create(gg_rct_StoneStatue001, 12, 3)
        set i = 0
        loop
            exitwhen i > 3
            call st.AddBlock(generatedBlock.create(16128, 14975 - (128 * i) + 896, CokeStageTerrain))

            call st.AddBlock(removedBlock.create(16768, 14975 - (128 * i) + 896, CokeStageTerrain))
            set i = i + 1
        endloop
        call st.AddBlock(generatedBlock.create(17664, 15232 + 896, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18176 + 128, 15487 + 896, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18176 + 128, 15487 - 128 + 896, CokeStageTerrain))

        call st.AddBlock(removedBlock.create(15232, 15103 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(15232, 15103 - 128 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(15488, 15103 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(15488, 15103 - 128 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(17920 + 128, 15488 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(17920 + 128, 15488 - 128 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(18559, 15488 + 896, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(18559, 15488 - 128 + 896, CokeStageTerrain))
        call stoneStatueList.AddFirst(st)


        // -------------------------------------------------------
        set st = stoneStatue.create(gg_rct_StoneStatue004, 12, 5)
        set i = 0
        loop
            exitwhen i > 2
            call st.AddBlock(generatedBlock.create(18047 + (128 * i), 9856, CokeStageTerrain))
            call st.AddBlock(generatedBlock.create(19840 + (128 * i), 15232, CokeStageTerrain))

            call st.AddBlock(removedBlock.create(19327 + (128 * i), 16255, CokeStageTerrain))
            call st.AddBlock(removedBlock.create(19327 + (128 * i), 15232, CokeStageTerrain))
            call st.AddBlock(removedBlock.create(19967 + 128 + (128 * i), 15872, CokeStageTerrain))
            set i = i + 1
        endloop
        
        set i = 0
        loop
            exitwhen i > 4
            call st.AddBlock(removedBlock.create(18432, 9984 + (128 * i), CokeStageTerrain))
            set i = i + 1
        endloop

        call st.AddBlock(generatedBlock.create(19712, 16256, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(19712 + 128, 16256, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(20352, 15232, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(19071, 15487, CokeStageTerrain))
        call stoneStatueList.AddFirst(st)


        // -------------------------------------------------------
        set st = stoneStatue.create(gg_rct_StoneStatue003, 12, 7)
        set i = 0
        loop
            exitwhen i > 5

            if i <= 2 then
                call st.AddBlock(generatedBlock.create(16640 + (128 * i), 12800, CokeStageTerrain))
                call st.AddBlock(generatedBlock.create(16768, 14080 - (128 * i), CokeStageTerrain))
                call st.AddBlock(generatedBlock.create(17408 + (128 * i), 12672, CokeStageTerrain))
            elseif i >= 4 then
                call st.AddBlock(removedBlock.create(16640 + (128 * i), 12800, CokeStageTerrain))
            endif
            set i = i + 1
        endloop

        set i = 0
        loop
            exitwhen i > 4
            call st.AddBlock(removedBlock.create(17408 + (128 * i), 11776, CokeStageTerrain))
            set i = i + 1
        endloop

        set i = 0
        loop
            exitwhen i > 6
            call st.AddBlock(removedBlock.create(16255 - 256 - (128 * i), 12800, CokeStageTerrain))
            call st.AddBlock(removedBlock.create(17152 + (128 * i), 13183, CokeStageTerrain))
            set i = i + 1
        endloop

        set i = 0
        loop
            exitwhen i > 5
            call st.AddBlock(removedBlock.create(15232 + 384 + (128 * i), 14080, CokeStageTerrain))
            call st.AddBlock(removedBlock.create(18048 + (128 * i), 12288, CokeStageTerrain))
            if i <= 2 then
                call st.AddBlock(generatedBlock.create(15232 + (128 * i), 14080, CokeStageTerrain))
            endif
            set i = i + 1
        endloop

        set i = 0
        loop
            exitwhen i > 7
            call st.AddBlock(removedBlock.create(18048 + (128 * i), 12672, CokeStageTerrain))
            set i = i + 1
        endloop

        call st.AddBlock(removedBlock.create(16255, 12800, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(16255, 12800 - 128, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(16512, 14208, CokeStageTerrain))
        call st.AddBlock(removedBlock.create(16512 + 128, 14208, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18047 + 128, 11904, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18047 + 128, 11904 - 128, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18047, 11904, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18047, 11904 - 128, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18047, 11904 + 128, CokeStageTerrain))
        call st.AddBlock(generatedBlock.create(18047 + 128, 11904 + 128, CokeStageTerrain))
        call stoneStatueList.AddFirst(st)


        // -------------------------------------------------------
        set st = stoneStatue.create(gg_rct_StoneStatue002, 12, 8)

        set i = 0
        loop
            exitwhen i > 4
            call st.AddBlock(removedBlock.create(16128 + (128 * i), 9727, CokeStageTerrain))
            if i <= 1 then
                call st.AddBlock(generatedBlock.create(16896 + (128 * i), 9343, CokeStageTerrain))
                call st.AddBlock(generatedBlock.create(15743 + (128 * i), 9855, CokeStageTerrain))
                call st.AddBlock(generatedBlock.create(14975 + (128 * i), 10112, CokeStageTerrain))

                call st.AddBlock(removedBlock.create(16512 + (128 * i), 9215, CokeStageTerrain))
                call st.AddBlock(removedBlock.create(17280 + (128 * i), 9471, CokeStageTerrain))
                call st.AddBlock(removedBlock.create(15360 + (128 * i), 9983, CokeStageTerrain))
            endif
            set i = i + 1
        endloop
        call st.AddBlock(generatedBlock.create(16896, 9343 + (128 * 2), CokeStageTerrain))
        call st.AddBlock(removedBlock.create(15488, 10240, CokeStageTerrain))
        call stoneStatueList.AddFirst(st)


    endfunction

    private function Init takes nothing returns nothing
        set stoneStatueList = stoneStatueList.create()

        call RegisterStoneStatue()
        call InitBlocks()
    endfunction
endlibrary
