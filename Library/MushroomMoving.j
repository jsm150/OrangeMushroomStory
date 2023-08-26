library MushroomMoving initializer init
    globals
        constant integer BACKGROUND_TILE = 'Xsqd'
        constant integer TRACKS_LEFT_TILE = 'Jrtl'
        constant integer TRACKS_RIGHT_TILE = 'Jblm'
        
        integer array SteppedPlayer
        integer array WhetherCollision
        boolean array Landing
        boolean array LeftArrow
        boolean array RightArrow
        boolean array UpArrow
        boolean array DownArrow
        string array Direction
        real array gravity
    endglobals
    
    public function Collision takes integer i, real x, real y returns integer
        local integer j = 1
        local real otherx
        local real othery

        loop
        exitwhen j > PLAYER_MAXINUM+Stage_BoxsCount
            if (GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING or j > PLAYER_MAXINUM) and i != j and WhetherCollision[j] == 0 and LevelClearState[j] == false then
                set otherx = GetUnitX(OrangeMushroom[j])
                set othery = GetUnitY(OrangeMushroom[j])
                 if ContainsCoords(otherx-64, othery-64, otherx+64, othery+64, x, y) == true then
                    if GetUnitTypeId(OrangeMushroom[i]) != 'orai' and GetUnitTypeId(OrangeMushroom[j]) != 'orai' then
                     if LeftArrow[Frame_MainPlayer] == true and Acceleration[Frame_MainPlayer] <= 0 then
                         set WhetherCollision[j] = -1
                     elseif RightArrow[Frame_MainPlayer] == true and Acceleration[Frame_MainPlayer] >= 0 then
                         set WhetherCollision[j] = 1
                     else
                         set WhetherCollision[j] = 0
                     endif
                     endif
                     return j
                 endif
            endif
        set j = j + 1
        endloop
        return 0
    endfunction
    
    public function CollisionCheck takes integer i, real x, real y returns boolean
        local integer j = 1
        local real otherx
        local real othery

        loop
        exitwhen j > PLAYER_MAXINUM+Stage_BoxsCount
            if (GetPlayerSlotState(Player(j-1)) == PLAYER_SLOT_STATE_PLAYING or j > PLAYER_MAXINUM) and i != j and LevelClearState[j] == false then
                set otherx = GetUnitX(OrangeMushroom[j])
                set othery = GetUnitY(OrangeMushroom[j])
                if ContainsCoords(otherx-64, othery-64, otherx+64, othery+64, x, y) == true then
                     if PropellyCondition == true then
                         if GetUnitTypeId(OrangeMushroom[j]) != 'orai' then
                             set Frame_MainPlayerY = j
                             return false
                         endif
                     else
                         set Frame_MainPlayerY = j
                         return false
                     endif
                endif
            endif
        set j = j + 1
        endloop
        return true
    endfunction
    
    private function BackGroundsCheck takes real x, real y returns boolean
        return GetTerrainType(x, y) == BACKGROUND_TILE and IsPointInRegion(Rect_NoEntry, x, y) == false
    endfunction
    
    public function RectCondition takes integer i, real x, real y, real distance, string s returns boolean
        local real value = 40
        local boolean b
        if s == "DownWidth" then
            if GravityChanger_State == false then
                set value = -40
            endif
            set b = BackGroundsCheck(x, y+value) and BackGroundsCheck(x-distance, y+value) and BackGroundsCheck(x+distance, y+value)
            return b and CollisionCheck(i, x, y+value) and CollisionCheck(i, x-distance, y+value) and CollisionCheck(i, x+distance, y+value)
        elseif s == "DownWidthJump" then
            if GravityChanger_State == false then
                set value = -40
            endif
            return BackGroundsCheck(x, y+value) and BackGroundsCheck(x-distance, y+value) and BackGroundsCheck(x+distance, y+value)
        elseif s == "UpWidth" then
            if GravityChanger_State == true then
                set value = -40
            endif
            return BackGroundsCheck(x, y+value) and BackGroundsCheck(x-distance, y+value) and BackGroundsCheck(x+distance, y+value)
        elseif s == "LeftHeight" then
            return  BackGroundsCheck(x-48, y) and BackGroundsCheck(x-48, y-distance) and BackGroundsCheck(x-48, y+distance)
        elseif s == "RightHeight" then
            return BackGroundsCheck(x+48, y) and BackGroundsCheck(x+48, y-distance) and BackGroundsCheck(x+48, y+distance)
        elseif s == "DownWidthOM" then
            if GravityChanger_State == false then
                set value = -40
            endif
            return CollisionCheck(i, x, y+value) and CollisionCheck(i, x-distance, y+value) and CollisionCheck(i, x+distance, y+value)
        elseif s == "UpWidthOM" then
            if GravityChanger_State == true then
                set value = -40
            endif
            return CollisionCheck(i, x, y+value) and CollisionCheck(i, x-distance, y+value) and CollisionCheck(i, x+distance, y+value)
        elseif s == "LeftHeightOM" then
            return CollisionCheck(i, x-48, y) and CollisionCheck(i, x-48, y-distance) and CollisionCheck(i, x-48, y+distance)
        elseif s == "RightHeightOM" then
            return CollisionCheck(i, x+48, y) and CollisionCheck(i, x+48, y-distance) and CollisionCheck(i, x+48, y+distance)
        elseif s == "LeftHeightOM2" then
            return CollisionCheck(i, x-48, y)// and CollisionCheck(i, x-48, y-distance)
        elseif s == "RightHeightOM2" then
            return CollisionCheck(i, x+48, y)// and CollisionCheck(i, x+48, y-distance)
        endif
        return false
    endfunction
    
    private function init takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen i > PLAYER_MAXINUM
            set gravity[i] = 0.00
            set Direction[i] = "Right"
        set i = i + 1
        endloop

    endfunction
endlibrary