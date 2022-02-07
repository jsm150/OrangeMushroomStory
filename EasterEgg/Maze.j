scope Maze initializer Init
    globals
        private constant integer SIZE_X = 47
        public constant integer SIZE_Y = 31
    endglobals

    private struct boolArray
        boolean array arr[SIZE_X]

        method operator [] takes integer i returns boolean
            return arr[i]
        endmethod

        method operator []= takes integer i, boolean b returns nothing
            set arr[i] = b
        endmethod
    endstruct

    //! runtextmacro Make_Container("boolArray", "Maze_SIZE_Y")

    globals
        private boolArrayContainer map
        private unit Key
        private rect keyRect
    endglobals

    private struct deepestPos
        static integer depth = 0
        static integer x = 0
        static integer y = 0
    endstruct

    // 미로 생성
    private function Open takes integer x, integer y, integer depth returns nothing
        local integer array dx
        local integer array dy
        local integer nx
        local integer ny
        local integer choice = 4
        local integer randomNum
        local integer temp

        set dx[0] = 1
        set dx[1] = 0
        set dx[2] = -1
        set dx[3] = 0

        set dy[0] = 0
        set dy[1] = -1
        set dy[2] = 0
        set dy[3] = 1

        set map[y][x] = true

        if deepestPos.depth < depth then
            set deepestPos.depth = depth
            set deepestPos.x = x
            set deepestPos.y = y
        endif

        loop
            exitwhen choice <= 0
            set randomNum = GetRandomInt(0, choice - 1)
            set nx = dx[randomNum]
            set ny = dy[randomNum]

            set choice = choice - 1

            set temp = dx[randomNum]
            set dx[randomNum] = dx[choice]
            set dx[choice] = temp

            set temp = dy[randomNum]
            set dy[randomNum] = dy[choice]
            set dy[choice] = temp

            if x + nx < SIZE_X - 1 and x + nx > 0 and y + ny < SIZE_Y - 1 and y + ny > 0 then
                if map[y + ny + ny][x + nx + nx] == false then
                    set map[y + ny][x + nx] = true
                    call Open(x + nx + nx, y + ny + ny, depth + 1)
                endif
            endif
        endloop

    endfunction
    
    private function ObjectVisible takes nothing returns nothing
        call SetDoodadAnimation(22396, -31293, 128.00, 'D00A', false, "stand", false)
        call SetDoodadAnimation(22396, -31548, 128.00, 'YOf3', false, "stand", false)

        call SetDoodadAnimation(16256 + (128 * 23), -27648 - (128 * 15), 128.00, 'VOfl', false, "stand", false)
        call SetDoodadAnimation(16701, -27520, 128.00, 'VOfl', false, "stand", false)

        call SetDoodadAnimation(16383, -27392, 128.00, 'DObw', false, "stand", false)
        call SetDoodadAnimation(16383 + 128, -27392, 128.00, 'YObb', false, "stand", false)
        call SetDoodadAnimation(16383 + 256, -27392, 128.00, 'YOwb', false, "stand", false)
        call SetDoodadAnimation(16383 + 384, -27392, 128.00, 'LOic', false, "stand", false)
        call SetDoodadAnimation(16383 + 512, -27392, 128.00, 'YObw', false, "stand", false)
        call SetDoodadAnimation(16383 + 640, -27392, 128.00, 'IOsm', false, "stand", false)
    endfunction

    private function KeyAction takes nothing returns nothing
        local integer kind = GetUnitTypeId(GetTriggerUnit())
        local integer id = GetPlayerId(GetOwningPlayer(GetTriggerUnit()))
        local rect r1
        local rect r2

        if MushroomType(kind) == false or id >= PLAYER_MAXINUM then
            return
        endif

        set r1 = Rect(22272-64, -31360-64, 22272+32, -31360+32)
        set r2 = Rect(22272-64, -31360-64 + 128, 22272+32, -31360+32 + 128)

        call RemoveUnit(Key)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", GetRectCenterX(keyRect), GetRectCenterY(keyRect)))
        call RegionClearRect( Rect_NoEntry, r1)
        call RegionClearRect( Rect_NoEntry, r2)
        call SetDoodadAnimationRect(r1, 'D00D', "Death", false)
        call SetDoodadAnimationRect(r2, 'D00D', "Death", false)
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetRectCenterX(r1), GetRectCenterY(r1)))
        call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", GetRectCenterX(r2), GetRectCenterY(r2)))

        call RemoveRect(r1)
        call RemoveRect(r2)
        call RemoveRect(keyRect)
        call DestroyTrigger(GetTriggeringTrigger())

        set r1 = null
        set r2 = null
    endfunction

    private function Install takes nothing returns nothing
        local integer startX = 16256
        local integer startY = -27648
        local integer y = 0
        local integer x = 0
        local trigger t = CreateTrigger()
        local rect r1 = Rect(22272-64, -31360-64, 22272+32, -31360+32)
        local rect r2 = Rect(22272-64, -31360-64 + 128, 22272+32, -31360+32 + 128)

        call DestroyTrigger( GetTriggeringTrigger() )

        loop
            exitwhen y >= SIZE_Y
            set x = 0
            loop
                exitwhen x >= SIZE_X
                if map[y][x] == false then
                    call SetTerrainType(startX + (128 * x), startY + (-128 * y), BeachStageTerrain, -1, 1, 0)
                endif
                set x = x + 1
            endloop
            set y = y + 1
        endloop

        set x = 0
        loop
            exitwhen x >= SIZE_X
            call SetTerrainType(startX + (128 * x), startY + (-128 * SIZE_Y), BeachStageTerrain, -1, 1, 0)
            if x < SIZE_Y then
                call SetTerrainType(startX + (128 * SIZE_X), startY + (-128 * x), BeachStageTerrain, -1, 1, 0)
                call SetTerrainType(startX - 128, startY + (-128 * x), BeachStageTerrain, -1, 1, 0)
            endif
            if x >= 7 then
                call SetTerrainType(startX + (128 * x), startY + 128, BeachStageTerrain, -1, 1, 0)
            endif
            set x = x + 1
        endloop

        call SetTerrainType(17151, -27392, BeachStageTerrain, -1, 1, 0)
        call SetTerrainType(17151 + 128, -27392, BeachStageTerrain, -1, 1, 0)
        call SetTerrainType(startX + 128, startY, UnTerrain, -1, 1, 0)

        call SetTerrainType(22143, -31359, UnTerrain, -1, 1, 0)
        call SetTerrainType(22143 + 128, -31359, UnTerrain, -1, 1, 0)
        call SetTerrainType(22143, -31359 + 128, UnTerrain, -1, 1, 0)
        call SetTerrainType(22143 + 128, -31359 + 128, UnTerrain, -1, 1, 0)
        
        call ObjectVisible()

        set Key = CreateUnit(Player(11), 'h00C', startX + (128 * deepestPos.x), startY - (128 * deepestPos.y), 270 )
        set keyRect = Rect((startX + (128 * deepestPos.x)) - 64.0, (startY - (128 * deepestPos.y)) - 64.0, (startX + (128 * deepestPos.x)) + 64.0, (startY - (128 * deepestPos.y)) + 64.0)
        call TriggerRegisterEnterRectSimple(t, keyRect)
        call TriggerAddAction(t, function KeyAction)
        call RegionAddRect( Rect_NoEntry, r1)
        call RegionAddRect( Rect_NoEntry, r2)

        call RemoveRect(r1)
        call RemoveRect(r2)

        set r1 = null
        set r2 = null
        set t = null
    endfunction

    private function Make takes nothing returns nothing
        local trigger t = CreateTrigger()
        local integer p = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        local integer y = 0

        if GetTriggerUnit() != OrangeMushroom[p] then
            return
        endif

        call SetFilter(1.00, 100, 100, 100, 0, 100, 100, 100, 100 )
        call DestroyTrigger( GetTriggeringTrigger() )

        set map = boolArrayContainer.create()
        loop
            exitwhen y >= SIZE_Y
            set map[y] = boolArray.create()
            set y = y + 1
        endloop

        call Open(1, 1, 0)

        call TriggerAddCondition(t, Filter(function Install))
        call TriggerEvaluate(t)
        
        set t = null
    endfunction

    private function Init takes nothing returns nothing
        local trigger t = CreateTrigger()
        call TriggerRegisterEnterRectSimple(t, gg_rct_MazeAction)
        call TriggerAddAction( t, function Make )

        set t = null
    endfunction
endscope