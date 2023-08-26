library TeleportMoon initializer init needs Water
    globals
        public region Region
        private rect array CompareRect
        private integer array ExitNumber
        private string array Color
    endglobals
    
    public function SelectPlayer takes integer i, integer rectNum returns integer
        local real x
        local real y
        local integer j = 1
        local integer k = 1
        local integer count = 0
        local integer array temp
        local real saveY
        
        loop
        exitwhen j > PLAYER_MAXINUM+Stage_BoxsCount
            set x = GetUnitX(OrangeMushroom[j])
            set y = GetUnitY(OrangeMushroom[j])
            if i != j and RectContainsUnit(CompareRect[ExitNumber[rectNum]], OrangeMushroom[j]) == true then// and gravity[j] <= 0 and MushroomMoving_RectCondition(j, x, y, 40,"DownWidth") == false
                set count = count + 1
                set temp[count] = j
            endif
        set j = j + 1
        endloop
        
        if count != 0 then
            set k = temp[1]
            set j = 1
            loop
            exitwhen j > count
                set y = GetUnitY(OrangeMushroom[temp[j]])
                if j == 1 then
                    set saveY = y
                else
                    if y > saveY then
                        set k = temp[j]
                        set saveY = y
                    endif
                endif
            set j = j + 1
            endloop
            
            return k
        else
            return 0
        endif
    endfunction
    
    public function Main takes integer i returns nothing
        local integer j = 1
        local integer k = 1
        local integer tempy
        local real now_x = GetUnitX(OrangeMushroom[i])
        local real now_y = GetUnitY(OrangeMushroom[i])
        local real x
        local real y
        
        loop
        exitwhen CompareRect[j] == null
            if RectContainsUnit(CompareRect[j], OrangeMushroom[i]) == true then
                    set k = SelectPlayer(i, j)
                    if k != 0 then
                        set x = GetUnitX(OrangeMushroom[k])
                        set y = GetUnitY(OrangeMushroom[k])
                        
                        call DestroyEffect(AddSpecialEffect( "war3mapImported\\Teleport.mdl", now_x, now_y ))
                        call DestroyEffect(AddSpecialEffect( "war3mapImported\\Teleport.mdl", x, y ))
                        if Color[j] == "Red" then
                            if GetLocalPlayer() == Player(i-1) or GetLocalPlayer() == Player(k-1) then
                                call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 0.00, 0.00, 50.00, 100.00, 0, 0, 100.00 )
                            endif
                        elseif Color[j] == "Blue" then
                            if GetLocalPlayer() == Player(i-1) or GetLocalPlayer() == Player(k-1) then
                                call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 0, 0.00, 100.00, 50.00, 0.00, 0, 100, 100.00 )
                            endif
                        elseif Color[j] == "Yellow" then
                            if GetLocalPlayer() == Player(i-1) or GetLocalPlayer() == Player(k-1) then
                                call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 100.00, 0.00, 50.00, 100.00, 100, 0, 100.00 )
                            endif
                        endif
                        call Water_EffectTimer(i)
                        call Water_EffectTimer(k)
                        call SetUnitPosition( OrangeMushroom[i], x, y )
                        call SetUnitPosition( OrangeMushroom[k], now_x, now_y )
                        if i <= PLAYER_MAXINUM then
                            call BackGroundMove(i, now_x, now_y)
                        endif
                        if k <= PLAYER_MAXINUM then
                            call BackGroundMove(k, x, y)
                        endif
                        set SteppedPlayer[i] = 0
                        set SteppedPlayer[k] = 0
                    else
                        call DisplayTimedTextToPlayer(Player(i-1), 0, 0, 5, "※ 출구에 오브젝트가 있어야 이용할 수 있습니다.")
                    endif
                    return
            endif
        set j = j + 1
        endloop
        
    endfunction
    
    private function SetRect takes rect r, integer i, integer exit, string s returns nothing
        call RegionAddRect( Region, r )
        set CompareRect[i] = r
        set ExitNumber[i] = exit
        set Color[i] = s
    endfunction
    
    
    private function init takes nothing returns nothing
        set Region = CreateRegion()
        call SetRect(gg_rct_TeleportMoon001, 1, 2, "Red")
        call SetRect(gg_rct_TeleportMoon002, 2, 1, "Red")
        call SetRect(gg_rct_TeleportMoon003, 3, 4, "Yellow")
        call SetRect(gg_rct_TeleportMoon004, 4, 3, "Yellow")
        call SetRect(gg_rct_TeleportMoon005, 5, 6, "Red")
        call SetRect(gg_rct_TeleportMoon006, 6, 5, "Red")
        call SetRect(gg_rct_TeleportMoon007, 7, 8, "Yellow")
        call SetRect(gg_rct_TeleportMoon008, 8, 7, "Yellow")
        call SetRect(gg_rct_TeleportMoon009, 9, 10, "Blue")
        call SetRect(gg_rct_TeleportMoon010, 10, 9, "Blue")
        call SetRect(gg_rct_TeleportMoon011, 11, 12, "Red")
        call SetRect(gg_rct_TeleportMoon012, 12, 11, "Red")
        call SetRect(gg_rct_TeleportMoon013, 13, 14, "Yellow")
        call SetRect(gg_rct_TeleportMoon014, 14, 13, "Yellow")
        call SetRect(gg_rct_TeleportMoon015, 15, 16, "Red")
        call SetRect(gg_rct_TeleportMoon016, 16, 15, "Red")
        call SetRect(gg_rct_TeleportMoon017, 17, 18, "Red")
        call SetRect(gg_rct_TeleportMoon018, 18, 17, "Red")
        call SetRect(gg_rct_TeleportMoon019, 19, 20, "Yellow")
        call SetRect(gg_rct_TeleportMoon020, 20, 19, "Yellow")
        call SetRect(gg_rct_TeleportMoon021, 21, 22, "Red")
        call SetRect(gg_rct_TeleportMoon022, 22, 21, "Red")
        call SetRect(gg_rct_TeleportMoon023, 23, 24, "Yellow")
        call SetRect(gg_rct_TeleportMoon024, 24, 23, "Yellow")
        call SetRect(gg_rct_TeleportMoon025, 25, 26, "Blue")
        call SetRect(gg_rct_TeleportMoon026, 26, 25, "Blue")
        call SetRect(gg_rct_TeleportMoon027, 27, 28, "Red")
        call SetRect(gg_rct_TeleportMoon028, 28, 27, "Red")
        call SetRect(gg_rct_TeleportMoon029, 29, 30, "Yellow")
        call SetRect(gg_rct_TeleportMoon030, 30, 29, "Yellow")
        call SetRect(gg_rct_TeleportMoon031, 31, 32, "Blue")
        call SetRect(gg_rct_TeleportMoon032, 32, 31, "Blue")
        call SetRect(gg_rct_TeleportMoon033, 33, 34, "Red")
        call SetRect(gg_rct_TeleportMoon034, 34, 33, "Red")
        call SetRect(gg_rct_TeleportMoon035, 35, 36, "Red")
        call SetRect(gg_rct_TeleportMoon036, 36, 35, "Red")
    endfunction
endlibrary