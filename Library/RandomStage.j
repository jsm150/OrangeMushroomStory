library RandomStage initializer Init
    globals
        public integer array randomWorld
        public integer array randomStage
        public integer state = 1
        public boolean isRandom = false
        public integer ReSelectCount = 2
    endglobals
    
    private struct Map
        public integer World
        public integer Stage
        public integer Weight

        static method create takes integer world, integer stage, integer weight returns thistype
            local thistype this = thistype.allocate()
            set this.World = world
            set this.Stage = stage
            set this.Weight = weight
            return this
        endmethod
    endstruct

    //! runtextmacro Make_LinkedList("Map", "0")

    private struct LevelUnit
        public static constant integer Hidden = 15
        public static constant integer VeryHard = 25
        public static constant integer Hard = 50
        public static constant integer Normal = 75
        public static constant integer Easy = 100
    endstruct

    private struct RandomPickMachine
        private MapLinkedList mapList
        private integer WeightTotal = 0
        
        public method Add takes Map map returns nothing
            set this.WeightTotal = this.WeightTotal + map.Weight
            call mapList.AddLast(map)
        endmethod

        public method PickUp takes nothing returns nothing
            local integer acc
            local integer random
            local integer i
            local MapNode node

            debug call JNWriteLog("  가중치 합 : " + I2S(this.WeightTotal))

            //! runtextmacro for("set i = 1", "i <= 10") // stage 8개 + 재선택 2번
                set random = GetRandomInt(1, this.WeightTotal)
                set acc = 0
                //! runtextmacro LinkedList_Foreach_Top("node", "this.mapList")
                    set acc = acc + node.Item.Weight
                    if random <= acc then
                        set randomWorld[i] = node.Item.World
                        set randomStage[i] = node.Item.Stage
                        set this.WeightTotal = this.WeightTotal - node.Item.Weight
                        call this.mapList.RemoveNode(node)
                        exitwhen true
                    endif
                //! runtextmacro LinkedList_Foreach_Bottom()
            //! runtextmacro for_end("set i = i + 1")
        endmethod

        public static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            set this.mapList = MapLinkedList.create()
            return this
        endmethod

        public method destroy takes nothing returns nothing
            local MapNode node
            //! runtextmacro LinkedList_Foreach_Top("node", "this.mapList")
                call node.Item.destroy()
            //! runtextmacro LinkedList_Foreach_Bottom()

            call this.mapList.destroy()
            call thistype.deallocate(this)
        endmethod
    endstruct

    public function PrintRandomStage takes player p returns nothing
        local integer i = 1
        call DisplayTimedTextToPlayer(p, 0, 0, 60, " ")
        loop
            exitwhen i > 10
            call DisplayTimedTextToPlayer(p, 0, 0, 60, I2S(randomWorld[i]) + " - " + I2S(randomStage[i]))
            if i == 8 then
                call DisplayTimedTextToPlayer(p, 0, 0, 60, "------------------------")
            endif
            set i = i + 1
        endloop
    endfunction

    public function ReSelect takes nothing returns nothing
        local integer i = GetPlayerId(GetTriggerPlayer()) + 1

        if i != HostNumber then
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 방장 권한을 가진 플레이어만 사용 가능한 명령어 입니다.")
            return
        endif
        if isRandom == false then
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 랜덤 월드에서만 사용할 수 있습니다.")
            return
        endif
        if ReSelectCount <= 0 then
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 횟수가 소진되었습니다.")
            return
        endif
        if FinalStage then
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 현재 스테이지에서는 재시작 할 수 없습니다.")
            return
        endif
        if Stage_Loading or GravityChanger_Loading then
            call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 잠시뒤 다시 시도해주세요.")
            return
        endif

        set randomWorld[state] = randomWorld[8 + ReSelectCount]
        set randomStage[state] = randomStage[8 + ReSelectCount]
        set state = state - 1
        call Stage_Clear.execute(1)
        set ReSelectCount = ReSelectCount - 1

        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 스테이지가 변경 되었습니다." )

        if ReSelectCount > 0 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이제 " + I2S(ReSelectCount) + "번 사용할 수 있습니다." )
        else
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이제 더이상 사용할 수 없습니다." )
        endif
    endfunction
    
    private function Init takes nothing returns nothing
        local RandomPickMachine random = RandomPickMachine.create()
        
        call random.Add(Map.create(3, -1, LevelUnit.Hidden))
        call random.Add(Map.create(3, 1, LevelUnit.Easy))
        call random.Add(Map.create(3, 2, LevelUnit.Easy))
        call random.Add(Map.create(3, 3, LevelUnit.Easy))
        call random.Add(Map.create(3, 4, LevelUnit.Easy))
        call random.Add(Map.create(3, 5, LevelUnit.Easy))
        call random.Add(Map.create(3, 6, LevelUnit.Easy))
        call random.Add(Map.create(3, 7, LevelUnit.Easy))
        call random.Add(Map.create(3, 8, LevelUnit.Easy))

        call random.Add(Map.create(4, -1, LevelUnit.Hidden))
        call random.Add(Map.create(4, 1, LevelUnit.Easy))
        call random.Add(Map.create(4, 2, LevelUnit.Easy))
        call random.Add(Map.create(4, 3, LevelUnit.Easy))
        call random.Add(Map.create(4, 4, LevelUnit.Easy))
        call random.Add(Map.create(4, 5, LevelUnit.Easy))
        call random.Add(Map.create(4, 6, LevelUnit.Easy))
        call random.Add(Map.create(4, 7, LevelUnit.Easy))
        call random.Add(Map.create(4, 8, LevelUnit.Easy))

        call random.Add(Map.create(5, 1, LevelUnit.Easy))
        call random.Add(Map.create(5, 2, LevelUnit.Easy))
        call random.Add(Map.create(5, 3, LevelUnit.Easy))
        call random.Add(Map.create(5, 4, LevelUnit.Easy))
        call random.Add(Map.create(5, 5, LevelUnit.Easy))
        call random.Add(Map.create(5, 6, LevelUnit.Easy))
        call random.Add(Map.create(5, 7, LevelUnit.Easy))
        call random.Add(Map.create(5, 8, LevelUnit.Easy))

        call random.Add(Map.create(6, 1, LevelUnit.Easy))
        call random.Add(Map.create(6, 2, LevelUnit.Easy))
        call random.Add(Map.create(6, 3, LevelUnit.Easy))
        call random.Add(Map.create(6, 4, LevelUnit.Easy))
        call random.Add(Map.create(6, 5, LevelUnit.Normal))
        call random.Add(Map.create(6, 6, LevelUnit.Easy))
        call random.Add(Map.create(6, 7, LevelUnit.Normal))
        call random.Add(Map.create(6, 8, LevelUnit.Easy))

        call random.Add(Map.create(7, 1, LevelUnit.Easy))
        call random.Add(Map.create(7, 2, LevelUnit.Easy))
        call random.Add(Map.create(7, 3, LevelUnit.Easy))
        call random.Add(Map.create(7, 4, LevelUnit.Easy))
        call random.Add(Map.create(7, 5, LevelUnit.Easy))
        call random.Add(Map.create(7, 6, LevelUnit.Easy))
        call random.Add(Map.create(7, 7, LevelUnit.Easy))
        call random.Add(Map.create(7, 8, LevelUnit.Easy))

        call random.Add(Map.create(8, 1, LevelUnit.VeryHard))
        call random.Add(Map.create(8, 2, LevelUnit.Normal))
        call random.Add(Map.create(8, 3, LevelUnit.Normal))
        call random.Add(Map.create(8, 4, LevelUnit.Hard))
        call random.Add(Map.create(8, 5, LevelUnit.Hard))
        call random.Add(Map.create(8, 6, LevelUnit.Hard))
        call random.Add(Map.create(8, 7, LevelUnit.VeryHard))

        call random.Add(Map.create(9, -1, LevelUnit.Hidden))
        call random.Add(Map.create(9, -2, LevelUnit.Hidden))
        call random.Add(Map.create(9, 1, LevelUnit.Normal))
        call random.Add(Map.create(9, 2, LevelUnit.Normal))
        call random.Add(Map.create(9, 3, LevelUnit.Normal))
        call random.Add(Map.create(9, 4, LevelUnit.Normal))
        call random.Add(Map.create(9, 5, LevelUnit.Hard))
        call random.Add(Map.create(9, 6, LevelUnit.VeryHard))
        call random.Add(Map.create(9, 7, LevelUnit.VeryHard))
        call random.Add(Map.create(9, 8, LevelUnit.Hard))

        call random.Add(Map.create(10, 1, LevelUnit.Hard))
        call random.Add(Map.create(10, 2, LevelUnit.Normal))
        call random.Add(Map.create(10, 3, LevelUnit.Normal))
        call random.Add(Map.create(10, 4, LevelUnit.Normal))
        call random.Add(Map.create(10, 5, LevelUnit.Hard))
        call random.Add(Map.create(10, 6, LevelUnit.VeryHard))
        call random.Add(Map.create(10, 7, LevelUnit.VeryHard))
        call random.Add(Map.create(10, 8, LevelUnit.VeryHard))

        call random.Add(Map.create(11, 1, LevelUnit.Normal))
        call random.Add(Map.create(11, 2, LevelUnit.Hard))
        call random.Add(Map.create(11, 3, LevelUnit.Hard))
        call random.Add(Map.create(11, 4, LevelUnit.VeryHard))
        call random.Add(Map.create(11, 5, LevelUnit.VeryHard))
        
        call random.Add(Map.create(12, 1, LevelUnit.Normal))
        call random.Add(Map.create(12, 2, LevelUnit.Hard))
        call random.Add(Map.create(12, 3, LevelUnit.Hard))
        call random.Add(Map.create(12, 4, LevelUnit.VeryHard))
        call random.Add(Map.create(12, 5, LevelUnit.VeryHard))
        call random.Add(Map.create(12, 6, LevelUnit.VeryHard))
        call random.Add(Map.create(12, 7, LevelUnit.VeryHard))
        call random.Add(Map.create(12, 8, LevelUnit.VeryHard))

        call random.Add(Map.create(13, 1, LevelUnit.Normal))
        call random.Add(Map.create(13, 2, LevelUnit.Normal))
        call random.Add(Map.create(13, 3, LevelUnit.Normal))
        call random.Add(Map.create(13, 4, LevelUnit.Hard))
        call random.Add(Map.create(13, 5, LevelUnit.Hard))
        call random.Add(Map.create(13, 6, LevelUnit.VeryHard))
        call random.Add(Map.create(13, 7, LevelUnit.VeryHard))
        call random.Add(Map.create(13, 8, LevelUnit.VeryHard))

        call random.Add(Map.create(14, 1, LevelUnit.VeryHard))
        call random.Add(Map.create(14, 2, LevelUnit.VeryHard))
        call random.Add(Map.create(14, 3, LevelUnit.VeryHard))
        call random.Add(Map.create(14, 4, LevelUnit.VeryHard))
        call random.Add(Map.create(14, 5, LevelUnit.VeryHard))

        call random.PickUp()
        call random.destroy()
    endfunction
endlibrary