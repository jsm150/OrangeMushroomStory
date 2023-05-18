library Stage initializer init
    globals
        constant integer SENTINEL_TERRAIN = 'Xblm'
        
        hashtable StartRectList = InitHashtable()
        sound BackgroundMusic
        public trigger Restart = CreateTrigger()
        public trigger SentinelTrigger = CreateTrigger()
        public boolean Loading = false
        public boolean WorldSkip = false
        public integer BoxsCount = 0
        public integer array HiddenPortalCount
        private timer TimeLimit = CreateTimer()
        public timer SentinelTimer = CreateTimer()
        public timer SentinelTimer2 = CreateTimer()
        private timerdialog TimeLimitDialog
        private tick tk
        public group SentinelGroup = CreateGroup()
    endglobals
    
    public function SetRestartMode takes nothing returns nothing
        set tk = tick.create(0)
    endfunction

    private function HiddenPortalState takes nothing returns integer
        local integer i = 1
        local integer j = 1
        local integer sum = 0
        local integer worldCount = 13
        
        loop
            exitwhen i > worldCount

            if i != j and HiddenPortalCount[i] > HiddenPortalCount[j] then
                set j = i
            endif

            set sum = sum + HiddenPortalCount[i]
            set i = i + 1
        endloop

        if Status.Portal - sum >= HiddenPortalCount[j] then
            return 0
        endif

        set i = 1
        loop
            exitwhen i > worldCount

            if (i != j and HiddenPortalCount[i] == HiddenPortalCount[j]) or HiddenPortalCount[j] == 0 then
                return 0
            endif

            set i = i + 1
        endloop
        
        return j
    endfunction
    
    private function RemoveBox takes nothing returns nothing
        local integer i = 1
        
        if BoxsCount != 0 then
            loop
            exitwhen i > BoxsCount
                call RemoveUnit(OrangeMushroom[PLAYER_MAXINUM+i])
            set i = i + 1
            endloop
        endif
        set BoxsCount = 0
    endfunction
    
    private function CreateObject takes integer i, rect r, string angle returns nothing
        local unit u
        local real x = GetRectCenterX(r)
        local real y = GetRectCenterY(r)
        
        if SubString(angle, 0, 8) != "Sentinel" then
            set gravity[PLAYER_MAXINUM+i] = 0
            set LeftArrow[PLAYER_MAXINUM+i] = false
            set RightArrow[PLAYER_MAXINUM+i] = false
            set Water_State[PLAYER_MAXINUM+i] = false
            set SteppedPlayer[PLAYER_MAXINUM+i] = 0
            set Acceleration[PLAYER_MAXINUM+i] = 0
        endif
        if angle == "Left" then
            set LeftArrow[PLAYER_MAXINUM+i] = true
            set RightArrow[PLAYER_MAXINUM+i] = false
            set Direction[PLAYER_MAXINUM+i] = "Left"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'ogru', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk First" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell First" )
            endif
        elseif angle == "Right" then
            set LeftArrow[PLAYER_MAXINUM+i] = false
            set RightArrow[PLAYER_MAXINUM+i] = true
            set Direction[PLAYER_MAXINUM+i] = "Right"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'ogru', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if (gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false) then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk Second" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell Second" )
            endif
        elseif angle == "FlyLeft" then
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'orai', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Stand First" )
        elseif angle == "FlyRight" then
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'orai', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Stand Second" )
        elseif angle == "AutoLeft" then
            set LeftArrow[PLAYER_MAXINUM+i] = true
            set RightArrow[PLAYER_MAXINUM+i] = false
            set Direction[PLAYER_MAXINUM+i] = "Left"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'otau', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk First" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell First" )
            endif
        elseif angle == "AutoRight" then
            set LeftArrow[PLAYER_MAXINUM+i] = false
            set RightArrow[PLAYER_MAXINUM+i] = true
            set Direction[PLAYER_MAXINUM+i] = "Right"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'otau', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if (gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false) then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk Second" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell Second" )
            endif
        elseif angle == "CokeMushroomLeft" then
            set LeftArrow[PLAYER_MAXINUM+i] = true
            set RightArrow[PLAYER_MAXINUM+i] = false
            set Direction[PLAYER_MAXINUM+i] = "Left"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'ocat', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk First" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell First" )
            endif
        elseif angle == "CokeMushroomRight" then
            set LeftArrow[PLAYER_MAXINUM+i] = false
            set RightArrow[PLAYER_MAXINUM+i] = true
            set Direction[PLAYER_MAXINUM+i] = "Right"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'ocat', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if (gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false) then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk Second" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell Second" )
            endif
        elseif angle == "BlinLeft" then
            set LeftArrow[PLAYER_MAXINUM+i] = true
            set RightArrow[PLAYER_MAXINUM+i] = false
            set Direction[PLAYER_MAXINUM+i] = "Left"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'o000', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk First" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell First" )
            endif
        elseif angle == "BlinRight" then
            set LeftArrow[PLAYER_MAXINUM+i] = false
            set RightArrow[PLAYER_MAXINUM+i] = true
            set Direction[PLAYER_MAXINUM+i] = "Right"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'o000', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if (gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false) then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk Second" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell Second" )
            endif
        elseif angle == "GhostLeft" then
            set LeftArrow[PLAYER_MAXINUM+i] = true
            set RightArrow[PLAYER_MAXINUM+i] = false
            set Direction[PLAYER_MAXINUM+i] = "Left"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'o001', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk First" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell First" )
            endif
        elseif angle == "GhostRight" then
            set LeftArrow[PLAYER_MAXINUM+i] = false
            set RightArrow[PLAYER_MAXINUM+i] = true
            set Direction[PLAYER_MAXINUM+i] = "Right"
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'o001', x, y, 270 )
            call SetUnitBlendTime(OrangeMushroom[PLAYER_MAXINUM+i], 0.00)
            if (gravity[PLAYER_MAXINUM+i] < 0 and MushroomMoving_RectCondition(PLAYER_MAXINUM+i, x, y, 40, "DownWidth") == false) then
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Walk Second" )
            else
                call SetUnitAnimation( OrangeMushroom[PLAYER_MAXINUM+i], "Spell Second" )
            endif
        elseif angle == "SentinelLeft" then
            call RegionAddRect( Rect_NoEntry, r )
            call RegionAddRect( Rect_MissileZone, r )
            set u = CreateUnit(Player(11), 'ohun', x, y, 270 )
            call SetUnitBlendTime(u, 0.00)
            call SetUnitAnimation(u, "Stand First")
            call GroupAddUnit(SentinelGroup, u)
            call SetUnitUserData( u, 0 )
        elseif angle == "SentinelRight" then
            call RegionAddRect( Rect_NoEntry, r )
            call RegionAddRect( Rect_MissileZone, r )
            set u = CreateUnit(Player(11), 'ohun', x, y, 270 )
            call SetUnitBlendTime(u, 0.00)
            call SetUnitAnimation(u, "Stand Second")
            call GroupAddUnit(SentinelGroup, u)
            call SetUnitUserData( u, 1 )
        elseif angle == "SentinelUp" then
            call RegionAddRect( Rect_NoEntry, r )
            call RegionAddRect( Rect_MissileZone, r )
            set u = CreateUnit(Player(11), 'ohun', x, y, 180 )
            call SetUnitBlendTime(u, 0.00)
            call SetUnitAnimation(u, "Stand First")
            call GroupAddUnit(SentinelGroup, u)
            call SetUnitUserData( u, 2 )
        elseif angle == "SentinelDown" then
            call RegionAddRect( Rect_NoEntry, r )
            call RegionAddRect( Rect_MissileZone, r )
            set u = CreateUnit(Player(11), 'ohun', x, y, 180 )
            call SetUnitBlendTime(u, 0.00)
            call SetUnitAnimation(u, "Stand Second")
            call GroupAddUnit(SentinelGroup, u)
            call SetUnitUserData( u, 3 )
        else
            set OrangeMushroom[PLAYER_MAXINUM+i] = CreateUnit(Player(11), 'opeo', x, y, 270 )
        endif
        call SetUnitPosition(OrangeMushroom[PLAYER_MAXINUM+i], x, y)
        
        set u = null
    endfunction

    private function SentinelChangeTerrain takes integer i returns nothing
        local integer j = 0
        if i == 1 then
            call SetTerrainType(5888, -12288, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(5248, -12288, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(4992, -12288, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(6784, -10880, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(7552, -10880, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(6144, -9984, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 2 then
            loop
            exitwhen j > 12
                if j == 1 or j == 2 or j == 4 or j == 5 or j == 7 or j == 8 or j == 11 then
                    call SetTerrainType(9600+(128*j), -11648, SENTINEL_TERRAIN, -1, 1, 0)
                endif
                if j == 3 or j == 5 or j == 6 or j == 7 or j == 9 or j == 11 then
                    call SetTerrainType(9600+(128*j), -11776, SENTINEL_TERRAIN, -1, 1, 0)
                endif
                if j == 0 or j == 1 or j == 7 or j == 8 or j == 11 or j == 12 then
                    call SetTerrainType(9600+(128*j), -11904, SENTINEL_TERRAIN, -1, 1, 0)
                endif
                if j == 0 or j == 1 or j == 2 or j == 4 or j == 11 or j == 12 then
                    call SetTerrainType(9600+(128*j), -12032, SENTINEL_TERRAIN, -1, 1, 0)
                endif
                if j != 0 and j != 4 and j != 5 and j != 6 then
                    call SetTerrainType(9600+(128*j), -12160, SENTINEL_TERRAIN, -1, 1, 0)
                endif
                if j != 7 then
                    call SetTerrainType(9600+(128*j), -12288, SENTINEL_TERRAIN, -1, 1, 0)
                endif
            set j = j + 1
            endloop
        elseif i == 3 then
            call SetTerrainType(14848, -11648, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(15104, -11776, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(14976, -11904, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 4 then
            loop
            exitwhen j > 3
                call SetTerrainType(8320+(256*j), -9728, SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
            call SetTerrainType(10752, -9728, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 5 then
            loop
            exitwhen j > 3
                call SetTerrainType(-6784+(256*j), -9856, SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
        elseif i == 6 then
            loop
            exitwhen j > 2
                call SetTerrainType(15104-(128*j), -15616+(128*j), SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
            call SetTerrainType(14848, -15616, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 7 then
            loop
            exitwhen j > 2
                call SetTerrainType(13568-(128*j), -22016+(128*j), SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
        elseif i == 8 then
            loop
            exitwhen j > 1
                call SetTerrainType(10880+(128*j), -20352, SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
        elseif i == 9 then
            loop
            exitwhen j > 6
                call SetTerrainType(-6272, -30464+(128*j), SENTINEL_TERRAIN, -1, 1, 0)
                call SetTerrainType(-6144, -30464+(128*j), SENTINEL_TERRAIN, -1, 1, 0)
                if j <= 2 then
                    call SetTerrainType(-4480, -29952+(128*j), SENTINEL_TERRAIN, -1, 1, 0)
                endif
            set j = j + 1
            endloop
            call SetTerrainType(-6272, -31232, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(-7552, -30208, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(-6144, -29184, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 10 then
            loop
            exitwhen j > 1
                call SetTerrainType(-2816+(128*j), -30848, SENTINEL_TERRAIN, -1, 1, 0)
                call SetTerrainType(-4096+(128*j), -30080, SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
            call SetTerrainType(-2304, -28672, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(-1536, -28672, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 11 then
            call SetTerrainType(9856, 9472, SENTINEL_TERRAIN, -1, 1, 0)
            loop
            exitwhen j > 6
                call SetTerrainType(9984+(128*j), 9216, SENTINEL_TERRAIN, -1, 1, 0)
                call SetTerrainType(9984+(128*j), 9472, SENTINEL_TERRAIN, -1, 1, 0)
                call SetTerrainType(9984+(128*j), 10496, SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
        elseif i == 12 then
            loop
            exitwhen j > 1
                call SetTerrainType(4096+(128*j), 14976, SENTINEL_TERRAIN, -1, 1, 0)
                call SetTerrainType(4608+(128*j), 14976, SENTINEL_TERRAIN, -1, 1, 0)
            set j = j + 1
            endloop
            call SetTerrainType(4352, 15232, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(4864, 15252, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 13 then
            call SetTerrainType(23552+128, -14208, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(23552+128+128, -14208, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(23552, -14208, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 14 then
            call SetTerrainType(11008, 28416, SENTINEL_TERRAIN, -1, 1, 0)
        elseif i == 15 then
            call SetTerrainType(18304, 26880, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(18560, 28032, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(18560 + 128, 28032, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(16640, 25856, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(16640, 25856 - 128, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(20352, 28288, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(20352, 28288 - 128, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(20352, 28288 - 256, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(20352, 28288 - 384, SENTINEL_TERRAIN, -1, 1, 0)
            call SetTerrainType(24704, 25344, SENTINEL_TERRAIN, -1, 1, 0)
        endif
    endfunction
    
    private function SetObject takes nothing returns nothing
        if Status.World == 1 then
            if Status.Level == 2 then
                call CreateObject(1, gg_rct_Box1_2_001, "null")
                call CreateObject(2, gg_rct_Box1_2_002, "null")
                set BoxsCount = 2
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Box1_4_001, "null")
                call CreateObject(2, gg_rct_Box1_4_002, "null")
                call CreateObject(3, gg_rct_Box1_4_003, "null")
                call CreateObject(4, gg_rct_Box1_4_004, "null")
                set BoxsCount = 4
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Box1_5_001, "null")
                call CreateObject(2, gg_rct_Box1_5_002, "null")
                call CreateObject(3, gg_rct_Box1_5_003, "null")
                set BoxsCount = 3
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_Box1_6_001, "null")
                call CreateObject(2, gg_rct_Box1_6_002, "null")
                set BoxsCount = 2
            elseif Status.Level == 7 then
                call CreateObject(1, gg_rct_Box1_7_001, "null")
                set BoxsCount = 1
            elseif Status.Level == 8 then
                call CreateObject(1, gg_rct_Box1_8_001, "null")
                set BoxsCount = 1
            endif
        elseif Status.World == 2 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Bloctopus2_1_001, "Right")
                set BoxsCount = 1
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Bloctopus2_2_001, "Right")
                call CreateObject(2, gg_rct_Box2_2_001, "null")
                call CreateObject(3, gg_rct_Box2_2_002, "null")
                set BoxsCount = 3
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Bloctopus2_3_001, "Right")
                set BoxsCount = 1
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Box2_4_001, "null")
                call CreateObject(2, gg_rct_Propelly2_4_001, "FlyRight")
                call CreateObject(3, gg_rct_Propelly2_4_002, "FlyLeft")
                set BoxsCount = 3
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Box2_5_001, "null")
                call CreateObject(2, gg_rct_Propelly2_5_001, "FlyRight")
                call CreateObject(3, gg_rct_Propelly2_5_002, "FlyLeft")
                call CreateObject(4, gg_rct_Bloctopus2_5_001, "Left")
                set BoxsCount = 4
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_Bloctopus2_6_001, "Right")
                call CreateObject(2, gg_rct_Bloctopus2_6_002, "Right")
                call CreateObject(3, gg_rct_Bloctopus2_6_003, "Right")
                call CreateObject(4, gg_rct_Propelly2_6_001, "FlyLeft")
                call CreateObject(5, gg_rct_Box2_6_001, "null")
                set BoxsCount = 5
            elseif Status.Level == 7 then
                call CreateObject(1, gg_rct_Propelly2_7_001, "FlyRight")
                call CreateObject(2, gg_rct_Propelly2_7_002, "FlyRight")
                call CreateObject(3, gg_rct_Box2_7_001, "null")
                call CreateObject(4, gg_rct_Box2_7_002, "null")
                set BoxsCount = 4
            elseif Status.Level == 8 then
                call CreateObject(1, gg_rct_Propelly2_8_001, "FlyLeft")
                call CreateObject(2, gg_rct_Propelly2_8_002, "FlyLeft")
                call CreateObject(3, gg_rct_Propelly2_8_003, "FlyLeft")
                set BoxsCount = 3
            endif
        elseif Status.World == 3 then
            if Status.Level == -1 then
                call CreateObject(1, gg_rct_Box3_Minus1_001, "null")
                call CreateObject(2, gg_rct_Box3_Minus1_002, "null")
                call CreateObject(3, gg_rct_KingBloctopus3_Minus1_001, "AutoRight")
                set BoxsCount = 3
            elseif Status.Level == 1 then
                call CreateObject(1, gg_rct_Box3_1_001, "null")
                set BoxsCount = 1
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Bloctopus3_1_001, "Right")
                call CreateObject(2, gg_rct_Box3_2_001, "null")
                call CreateObject(3, gg_rct_Box3_2_002, "null")
                call CreateObject(4, gg_rct_Box3_2_003, "null")
                set BoxsCount = 4
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box3_3_001, "null")
                call CreateObject(2, gg_rct_Box3_3_002, "null")
                call CreateObject(3, gg_rct_Propelly3_3_001, "FlyRight")
                set BoxsCount = 3
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Bloctopus3_4_001, "Left")
                call CreateObject(2, gg_rct_Bloctopus3_4_002, "Left")
                call CreateObject(3, gg_rct_Box3_4_001, "null")
                call CreateObject(4, gg_rct_Propelly3_4_001, "FlyRight")
                set BoxsCount = 4
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Box3_5_001, "null")
                set BoxsCount = 1
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_Bloctopus3_6_001, "Left")
                set BoxsCount = 1
            elseif Status.Level == 8 then
                call CreateObject(1, gg_rct_Box3_8_001, "null")
                call CreateObject(2, gg_rct_Box3_8_002, "null")
                call CreateObject(3, gg_rct_Box3_8_003, "null")
                call CreateObject(4, gg_rct_Box3_8_004, "null")
                call CreateObject(5, gg_rct_Propelly3_8_001, "FlyRight")
                set BoxsCount = 5
            endif
        elseif Status.World == 4 then
            if Status.Level == -1 then
                call CreateObject(1, gg_rct_Bloctopus4_Minus1_001, "Left")
                call CreateObject(2, gg_rct_Bloctopus4_Minus1_002, "Left")
                call CreateObject(3, gg_rct_Bloctopus4_Minus1_003, "Left")
                call CreateObject(4, gg_rct_Bloctopus4_Minus1_004, "Left")
                call CreateObject(5, gg_rct_Bloctopus4_Minus1_005, "Left")
                call CreateObject(6, gg_rct_Bloctopus4_Minus1_006, "Left")
                call CreateObject(7, gg_rct_Bloctopus4_Minus1_007, "Left")
                set BoxsCount = 7
            elseif Status.Level == 1 then
                call CreateObject(1, gg_rct_KingBloctopus4_1_001, "AutoRight")
                set BoxsCount = 1
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_KingBloctopus4_2_001, "AutoRight")
                set BoxsCount = 1
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_KingBloctopus4_3_001, "AutoRight")
                set BoxsCount = 1
            elseif Status.Level == 4 then
                call SentinelChangeTerrain(1)
                call CreateObject(0, gg_rct_Sentinel4_4_001, "SentinelLeft")
                call CreateObject(0, gg_rct_Sentinel4_4_002, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_4_003, "SentinelRight")
                call CreateObject(1, gg_rct_Box4_4_001, "null")
                call CreateObject(2, gg_rct_KingBloctopus4_4_001, "AutoLeft")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call SentinelChangeTerrain(2)
                call CreateObject(0, gg_rct_Sentinel4_5_001, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_5_002, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_5_003, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_5_004, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_5_005, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_5_006, "SentinelRight")
                call CreateObject(1, gg_rct_Box4_5_001, "null")
                call CreateObject(2, gg_rct_Bloctopus4_5_001, "Right")
                set BoxsCount = 2
            elseif Status.Level == 6 then
                call SentinelChangeTerrain(3)
                call CreateObject(0, gg_rct_Sentinel4_6_001, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel4_6_002, "SentinelLeft")
                call CreateObject(0, gg_rct_Sentinel4_6_003, "SentinelLeft")
                call CreateObject(1, gg_rct_Box4_6_001, "null")
                call CreateObject(2, gg_rct_Bloctopus4_6_001, "Right")
                call CreateObject(3, gg_rct_KingBloctopus4_6_001, "AutoRight")
                set BoxsCount = 3
            elseif Status.Level == 7 then
                call SentinelChangeTerrain(4)
                call CreateObject(0, gg_rct_Sentinel4_7_001, "SentinelRight")
                call CreateObject(1, gg_rct_Box4_7_001, "null")
                call CreateObject(2, gg_rct_Propelly4_7_001, "FlyRight")
                call CreateObject(3, gg_rct_KingBloctopus4_7_001, "AutoRight")
                set BoxsCount = 3
            elseif Status.Level == 8 then
                call SentinelChangeTerrain(5)
                call CreateObject(0, gg_rct_Sentinel4_8_001, "SentinelLeft")
            endif
        elseif Status.World == 5 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box5_1_001, "null")
                call CreateObject(2, gg_rct_Box5_1_002, "null")
                set BoxsCount = 2
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_KingBloctopus5_2_001, "AutoRight")
                call CreateObject(2, gg_rct_Box5_2_001, "null")
                set BoxsCount = 2
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box5_3_001, "null")
                call CreateObject(2, gg_rct_Box5_3_002, "null")
                call CreateObject(3, gg_rct_Box5_3_003, "null")
                set BoxsCount = 3
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Box5_4_001, "null")
                call CreateObject(2, gg_rct_Box5_4_002, "null")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Bloctopus5_5_001, "Right")
                call CreateObject(2, gg_rct_Box5_5_001, "null")
                call CreateObject(3, gg_rct_Box5_5_002, "null")
                set BoxsCount = 3
            elseif Status.Level == 6 then
                call SentinelChangeTerrain(6)
                call CreateObject(0, gg_rct_Sentinel5_6_001, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel5_6_002, "SentinelRight")
                call CreateObject(0, gg_rct_Sentinel5_6_003, "SentinelRight")
                call CreateObject(1, gg_rct_Propelly5_6_001, "FlyRight")
                call CreateObject(2, gg_rct_Box5_6_001, "null")
                set BoxsCount = 2
            elseif Status.Level == 7 then
                call CreateObject(1, gg_rct_Box5_7_001, "null")
                call CreateObject(2, gg_rct_Bloctopus5_7_001, "Left")
                set BoxsCount = 2
            elseif Status.Level == 8 then
                call CreateObject(1, gg_rct_KingBloctopus5_8_001, "AutoRight")
                call CreateObject(2, gg_rct_Box5_8_001, "null")
                set BoxsCount = 2
            endif
        elseif Status.World == 6 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box6_1_001, "null")
                call CreateObject(2, gg_rct_KingBloctopus6_1_001, "AutoLeft")
                set BoxsCount = 2
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Bloctopus6_2_001, "Right")
                call CreateObject(2, gg_rct_Box6_2_001, "null")
                call CreateObject(3, gg_rct_Box6_2_002, "null")
                call CreateObject(4, gg_rct_Box6_2_003, "null")
                set BoxsCount = 4
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Bloctopus6_3_001, "Right")
                set BoxsCount = 1
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Bloctopus6_4_001, "Right")
                call CreateObject(2, gg_rct_Bloctopus6_4_002, "Right")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_KingBloctopus6_5_001, "AutoRight")
                call CreateObject(2, gg_rct_Box6_5_001, "null")
                set BoxsCount = 2
            elseif Status.Level == 6 then
                call SentinelChangeTerrain(7)
                call CreateObject(0, gg_rct_Sentinel6_6_001, "SentinelLeft")
                call CreateObject(0, gg_rct_Sentinel6_6_002, "SentinelLeft")
                call CreateObject(0, gg_rct_Sentinel6_6_003, "SentinelLeft")
                call CreateObject(1, gg_rct_Bloctopus6_6_001, "Left")
                call CreateObject(2, gg_rct_Bloctopus6_6_002, "Left")
                set BoxsCount = 2
            elseif Status.Level == 7 then
                call CreateObject(1, gg_rct_Propelly6_7_001, "FlyRight")
                call CreateObject(2, gg_rct_Propelly6_7_002, "FlyRight")
                set BoxsCount = 2
            elseif Status.Level == 8 then
                call SentinelChangeTerrain(8)
                call CreateObject(0, gg_rct_Sentinel6_8_001, "SentinelRight")
                call CreateObject(1, gg_rct_Box6_8_001, "null")
                call CreateObject(2, gg_rct_Box6_8_002, "null")
                call CreateObject(3, gg_rct_Bloctopus6_8_001, "Left")
                set BoxsCount = 3
            endif
        elseif Status.World == 7 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_CokeMushroom7_1_001, "CokeMushroomRight")
                call CreateObject(2, gg_rct_CokeMushroom7_1_002, "CokeMushroomLeft")
                call CreateObject(3, gg_rct_CokeMushroom7_1_003, "CokeMushroomRight")
                call CreateObject(4, gg_rct_Box7_1_001, "null")
                set BoxsCount = 4
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_CokeMushroom7_2_001, "CokeMushroomRight")
                call CreateObject(2, gg_rct_CokeMushroom7_2_002, "CokeMushroomRight")
                call CreateObject(3, gg_rct_CokeMushroom7_2_003, "CokeMushroomRight")
                call CreateObject(4, gg_rct_CokeMushroom7_2_004, "CokeMushroomRight")
                call CreateObject(5, gg_rct_KingBloctopus7_2_001, "AutoLeft")
                set BoxsCount = 5
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box7_3_001, "null")
                call CreateObject(2, gg_rct_CokeMushroom7_3_001, "CokeMushroomLeft")
                call CreateObject(3, gg_rct_CokeMushroom7_3_002, "CokeMushroomLeft")
                set BoxsCount = 3
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Box7_4_001, "null")
                call CreateObject(2, gg_rct_Box7_4_002, "null")
                call CreateObject(3, gg_rct_Box7_4_003, "null")
                call CreateObject(4, gg_rct_Box7_4_004, "null")
                set BoxsCount = 4
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_CokeMushroom7_5_001, "CokeMushroomRight")
                call CreateObject(2, gg_rct_Propelly7_5_001, "FlyRight")
                call CreateObject(3, gg_rct_Propelly7_5_002, "FlyRight")
                call CreateObject(4, gg_rct_Box7_5_001, "null")
                set BoxsCount = 4
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_CokeMushroom7_6_001, "CokeMushroomLeft")
                call CreateObject(2, gg_rct_CokeMushroom7_6_002, "CokeMushroomRight")
                set BoxsCount = 2
            elseif Status.Level == 7 then
                call SentinelChangeTerrain(10)
                call CreateObject(1, gg_rct_Bloctopus7_7_001, "Left")
                call CreateObject(2, gg_rct_CokeMushroom7_7_001, "CokeMushroomLeft")
                set BoxsCount = 2
            elseif Status.Level == 8 then
                call SentinelChangeTerrain(9)
                call CreateObject(0, gg_rct_Sentinel7_8_001, "SentinelUp")
                call CreateObject(0, gg_rct_Sentinel7_8_002, "SentinelUp")
                call CreateObject(1, gg_rct_Propelly7_8_001, "FlyRight")
                call CreateObject(2, gg_rct_Box7_8_001, "null")
                call CreateObject(3, gg_rct_Bloctopus7_8_001, "Right")
                call CreateObject(4, gg_rct_Bloctopus7_8_002, "Left")
                call CreateObject(5, gg_rct_CokeMushroom7_8_001, "CokeMushroomRight")
                set BoxsCount = 5
            endif
        elseif Status.World == 8 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box8_1_001, "null")
                set BoxsCount = 1
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Bloctopus8_2_001, "Right")
                call CreateObject(2, gg_rct_Bloctopus8_2_002, "Left")
                call CreateObject(3, gg_rct_Propelly8_2_001, "FlyRight")
                call CreateObject(4, gg_rct_Propelly8_2_002, "FlyLeft")
                call CreateObject(5, gg_rct_Propelly8_2_003, "FlyLeft")
                set BoxsCount = 5
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box8_3_001, "null")
                call CreateObject(2, gg_rct_Box8_3_002, "null")
                call CreateObject(3, gg_rct_Box8_3_003, "null")
                set BoxsCount = 3
            elseif Status.Level == 4 then
                call SentinelChangeTerrain(11)
                call CreateObject(0, gg_rct_Sentinel8_4_001, "SentinelLeft")
                call CreateObject(0, gg_rct_Sentinel8_4_002, "SentinelLeft")
                call CreateObject(0, gg_rct_Sentinel8_4_003, "SentinelRight")
                call CreateObject(1, gg_rct_KingBloctopus8_4_001, "AutoRight")
                call CreateObject(2, gg_rct_KingBloctopus8_4_002, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Box8_5_001, "null")
                call CreateObject(2, gg_rct_Box8_5_002, "null")
                call CreateObject(3, gg_rct_Propelly8_5_001, "FlyRight")
                set BoxsCount = 3
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_Box8_6_001, "null")
                call CreateObject(2, gg_rct_KingBloctopus8_6_001, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 7 then
                call SentinelChangeTerrain(12)
                call CreateObject(1, gg_rct_CokeMushroom8_7_001, "CokeMushroomRight")
                call CreateObject(2, gg_rct_CokeMushroom8_7_002, "CokeMushroomRight")
                set BoxsCount = 2
            endif
        elseif Status.World == 9 then
            if Status.Level == -1 then
                call CreateObject(1, gg_rct_KingBloctopus9_Minus1_001, "AutoRight")
                call CreateObject(2, gg_rct_KingBloctopus9_Minus1_002, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == -2 then
                call CreateObject(1, gg_rct_KingBloctopus9_Minus2_001, "AutoRight")
                call CreateObject(2, gg_rct_KingBloctopus9_Minus2_002, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 1 then
                call CreateObject(1, gg_rct_Bloctopus9_1_001, "Right")
                call CreateObject(2, gg_rct_Box9_1_001, "null")
                set BoxsCount = 2
            elseif Status.Level == 2 then    
                call CreateObject(1, gg_rct_KingBloctopus9_2_001, "AutoRight")
                set BoxsCount = 1
            elseif Status.Level == 3 then    
                call CreateObject(1, gg_rct_Bloctopus9_3_001, "Right")
                call CreateObject(2, gg_rct_Bloctopus9_3_002, "Right")
                set BoxsCount = 2
            elseif Status.Level == 4 then    
                call CreateObject(1, gg_rct_KingBloctopus9_4_001, "AutoRight")
                call CreateObject(2, gg_rct_KingBloctopus9_4_002, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 5 then    
                call CreateObject(1, gg_rct_KingBloctopus9_5_001, "AutoRight")
                call CreateObject(2, gg_rct_Bloctopus9_5_001, "Left")
                call CreateObject(3, gg_rct_Box9_5_001, "null")
                set BoxsCount = 3
            elseif Status.Level == 6 then    
                call CreateObject(1, gg_rct_KingBloctopus9_6_001, "AutoRight")
                call CreateObject(2, gg_rct_Bloctopus9_6_001, "Left")
                call CreateObject(3, gg_rct_Propelly9_6_001, "FlyRight")
                set BoxsCount = 3
            elseif Status.Level == 7 then 
                call CreateObject(1, gg_rct_Bloctopus9_7_001, "Right")
                set BoxsCount = 1
            elseif Status.Level == 8 then 
                call CreateObject(1, gg_rct_Bloctopus9_8_001, "Left")
                call CreateObject(2, gg_rct_Bloctopus9_8_002, "Left")
                call CreateObject(3, gg_rct_Bloctopus9_8_003, "Right")
                set BoxsCount = 3  
            endif
        elseif Status.World == 10 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box10_1_001, "null")
                call CreateObject(2, gg_rct_CokeMushroom10_1_001, "CokeMushroomLeft")
                set BoxsCount = 2
            elseif Status.Level == 2 then   
                call CreateObject(1, gg_rct_Box10_2_001, "null")
                call CreateObject(2, gg_rct_CokeMushroom10_2_001, "CokeMushroomRight")
                call CreateObject(3, gg_rct_CokeMushroom10_2_002, "CokeMushroomRight")
                call CreateObject(4, gg_rct_KingBloctopus10_2_001, "AutoRight")
                set BoxsCount = 4
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box10_3_001, "null")
                call CreateObject(2, gg_rct_Bloctopus10_3_001, "Left")
                call CreateObject(3, gg_rct_CokeMushroom10_3_001, "CokeMushroomLeft")
                call CreateObject(4, gg_rct_CokeMushroom10_3_002, "CokeMushroomRight")
                set BoxsCount = 4
            elseif Status.Level == 4 then 
                call CreateObject(1, gg_rct_Box10_4_001, "null")
                call CreateObject(2, gg_rct_Box10_4_002, "null")
                call CreateObject(3, gg_rct_Bloctopus10_4_001, "Right")
                set BoxsCount = 3
            elseif Status.Level == 5 then 
                call CreateObject(1, gg_rct_Bloctopus10_5_001, "Right")
                call CreateObject(2, gg_rct_CokeMushroom10_5_001, "CokeMushroomRight")
                call CreateObject(3, gg_rct_CokeMushroom10_5_002, "CokeMushroomLeft")
                call CreateObject(4, gg_rct_Box10_5_001, "null")
                call CreateObject(5, gg_rct_Box10_5_002, "null")
                call CreateObject(6, gg_rct_Box10_5_003, "null")
                set BoxsCount = 6
            elseif Status.Level == 6 then 
                call CreateObject(1, gg_rct_CokeMushroom10_6_001, "CokeMushroomRight")
                call CreateObject(2, gg_rct_CokeMushroom10_6_002, "CokeMushroomRight")
                call CreateObject(3, gg_rct_Box10_6_001, "null")
                call CreateObject(4, gg_rct_Box10_6_002, "null")
                call CreateObject(5, gg_rct_KingBloctopus10_6_001, "AutoRight")
                set BoxsCount = 5
            elseif Status.Level == 7 then
                call SentinelChangeTerrain(13)
                call CreateObject(1, gg_rct_Box10_7_001, "null")
                call CreateObject(2, gg_rct_Box10_7_002, "null")
                call CreateObject(3, gg_rct_CokeMushroom10_7_001, "CokeMushroomLeft")
                set BoxsCount = 3
            elseif Status.Level == 8 then 
                call CreateObject(1, gg_rct_Bloctopus10_8_001, "Left")
                call CreateObject(2, gg_rct_Bloctopus10_8_002, "Left")
                call CreateObject(3, gg_rct_CokeMushroom10_8_001, "CokeMushroomLeft")
                call CreateObject(4, gg_rct_Propelly10_8_001, "FlyRight")
                call CreateObject(5, gg_rct_Box10_8_001, "null")
                call CreateObject(6, gg_rct_Bloctopus10_8_003, "Left")
                set BoxsCount = 6               
            endif
        elseif Status.World == 11 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box11_1_001, "null")
                set BoxsCount = 1
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Bloctopus11_2_001, "Right")
                call CreateObject(2, gg_rct_Box11_2_001, "null")
                set BoxsCount = 2
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box11_3_001, "null")
                set BoxsCount = 1
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_KingBloctopus11_4_001, "AutoRight")
                call CreateObject(2, gg_rct_Propelly11_4_001, "FlyRight")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_KingBloctopus11_5_001, "AutoRight")
                call CreateObject(2, gg_rct_Box11_5_001, "null")
                call CreateObject(3, gg_rct_CokeMushroom11_5_001, "CokeMushroomRight")
                call CreateObject(4, gg_rct_Bloctopus11_5_001, "Right")
                set BoxsCount = 4
            endif
        elseif Status.World == 12 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box12_1_001, "null")
                call CreateObject(2, gg_rct_Box12_1_002, "null")
                call CreateObject(3, gg_rct_CokeMushroom12_1_001, "CokeMushroomLeft")
                set BoxsCount = 3
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_KingBloctopus12_3_001, "AutoRight")
                set BoxsCount = 1
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_CokeMushroom12_4_001, "CokeMushroomLeft")
                call CreateObject(2, gg_rct_CokeMushroom12_4_002, "CokeMushroomLeft")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Bloctopus12_5_001, "Left")
                call CreateObject(2, gg_rct_KingBloctopus12_5_001, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_Propelly12_6_001, "FlyRight")
                call CreateObject(2, gg_rct_Propelly12_6_002, "FlyRight")
                call CreateObject(3, gg_rct_KingBloctopus12_6_001, "AutoRight")
                call CreateObject(4, gg_rct_Bloctopus12_6_001, "Right")
                set BoxsCount = 4
            elseif Status.Level == 7 then
                call CreateObject(1, gg_rct_Bloctopus12_7_001, "Right")
                call CreateObject(2, gg_rct_Bloctopus12_7_002, "Left")
                set BoxsCount = 2
            elseif Status.Level == 8 then
                call CreateObject(1, gg_rct_Box12_8_001, "null")
                call CreateObject(2, gg_rct_Box12_8_002, "null")
                set BoxsCount = 2
            endif
        elseif Status.World == 13 then
            if Status.Level == 1 then
                call CreateObject(1, gg_rct_Box13_1_001, "null")
                call CreateObject(2, gg_rct_KingBloctopus13_1_001, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Box13_2_001, "null")
                call CreateObject(2, gg_rct_KingBloctopus13_2_001, "AutoRight")
                set BoxsCount = 2
            elseif Status.Level == 3 then
                call CreateObject(1, gg_rct_Box13_3_001, "null")
                call CreateObject(2, gg_rct_Bloctopus13_3_001, "Right")
                call CreateObject(3, gg_rct_Bloctopus13_3_002, "Left")
                set BoxsCount = 3
            elseif Status.Level == 4 then
                call CreateObject(1, gg_rct_Blin13_4_001, "BlinRight")
                call CreateObject(2, gg_rct_Blin13_4_002, "BlinLeft")
                set BoxsCount = 2
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Blin13_5_001, "BlinRight")
                call CreateObject(2, gg_rct_Blin13_5_002, "BlinLeft")
                call CreateObject(3, gg_rct_Blin13_5_003, "BlinLeft")
                set BoxsCount = 3
            elseif Status.Level == 6 then
                call CreateObject(1, gg_rct_Blin13_6_001, "BlinRight")
                call CreateObject(2, gg_rct_Blin13_6_002, "BlinLeft")
                call CreateObject(3, gg_rct_CokeMushroom13_6_001, "CokeMushroomRight")
                set BoxsCount = 3
            elseif Status.Level == 7 then
                call CreateObject(1, gg_rct_Blin13_7_001, "BlinLeft")
                call CreateObject(2, gg_rct_Bloctopus13_7_001, "Right")
                call CreateObject(3, gg_rct_Bloctopus13_7_002, "Right")
                call CreateObject(4, gg_rct_Bloctopus13_7_003, "Left")
                set BoxsCount = 4
            elseif Status.Level == 8 then
                call CreateObject(1, gg_rct_Blin13_8_001, "BlinRight")
                call CreateObject(2, gg_rct_Box13_8_001, "null")
                call CreateObject(3, gg_rct_Propelly13_8_001, "FlyRight")
                set BoxsCount = 3
            endif
        elseif Status.World == 14 then
            if Status.Level == 1  then
                call CreateObject(1, gg_rct_Box14_1_001, "null")
                call CreateObject(2, gg_rct_Box14_1_002, "null")
                call CreateObject(3, gg_rct_Box14_1_003, "null")
                call CreateObject(4, gg_rct_CokeMushroom14_1_001, "CokeMushroomRight")
                set BoxsCount = 4
            elseif Status.Level == 2 then
                call CreateObject(1, gg_rct_Box14_2_001, "null")
                call CreateObject(2, gg_rct_Bloctopus14_2_001, "Right")
                call CreateObject(3, gg_rct_CokeMushroom14_2_001, "CokeMushroomRight")
                set BoxsCount = 3
            elseif Status.Level == 3 then
                call SentinelChangeTerrain(14)
                call CreateObject(1, gg_rct_Box14_3_001, "null")
                call CreateObject(2, gg_rct_CokeMushroom14_3_001, "CokeMushroomRight")
                call CreateObject(3, gg_rct_CokeMushroom14_3_002, "CokeMushroomRight")
                call CreateObject(4, gg_rct_CokeMushroom14_3_003, "CokeMushroomRight")
                call CreateObject(5, gg_rct_Bloctopus14_3_001, "Left")
                set BoxsCount = 5
            elseif Status.Level == 4 then
                call SentinelChangeTerrain(15)
                call CreateObject(0, gg_rct_Sentinel14_4_001, "SentinelRight")
                call CreateObject(1, gg_rct_Bloctopus14_4_001, "Left")
                call CreateObject(2, gg_rct_KingBloctopus14_4_001, "AutoRight")
                call CreateObject(3, gg_rct_Bloctopus14_4_002, "Left")
                call CreateObject(4, gg_rct_CokeMushroom14_4_001, "CokeMushroomLeft")
                set BoxsCount = 4
            elseif Status.Level == 5 then
                call CreateObject(1, gg_rct_Blin13_Minus1_001, "BlinRight")
                call CreateObject(2, gg_rct_Blin13_Minus1_002, "BlinLeft")
                call CreateObject(3, gg_rct_Blin13_Minus1_003, "BlinLeft")
                call CreateObject(4, gg_rct_Propelly13_Minus1_001, "FlyLeft")
                call CreateObject(5, gg_rct_Propelly13_Minus1_002, "FlyLeft")
                set BoxsCount = 5
            endif
        endif
    endfunction
    
    private function SentinelAttackGroup2 takes nothing returns nothing
        local real x = GetUnitX(GetEnumUnit())
        local real y = GetUnitY(GetEnumUnit())
        local unit u
        
        if GetUnitUserData(GetEnumUnit()) <= 1 then
            set u = CreateUnit(Player(11), 'hmtt', x, y, 270 )
        else
            set u = CreateUnit(Player(11), 'hmtt', x, y, 180 )
        endif
         call GroupAddUnit(Frame_SentinelMissile, u)
        call SetUnitUserData( u, GetUnitUserData(GetEnumUnit()) )
        
        set u = null
    endfunction
    
    private function SentinelAttackGroup takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetEnumUnit()))+1
        if i <= PLAYER_MAXINUM then
            if Direction[i] == "Left" then
                call SetUnitUserData( GetEnumUnit(), 0 )
            else
                call SetUnitUserData( GetEnumUnit(), 1 )
            endif
        endif
        if GetUnitUserData(GetEnumUnit()) == 0 or GetUnitUserData(GetEnumUnit()) == 2 then
            call SetUnitAnimation( GetEnumUnit(), "Stand Ready First" )
        else
            call SetUnitAnimation( GetEnumUnit(), "Stand Ready Second" )
        endif
    endfunction
    
    public function SentinelAttack2 takes nothing returns nothing
        call ForGroup(SentinelGroup, function SentinelAttackGroup2)
    endfunction
    
    public function SentinelAttack takes nothing returns nothing
        if GravityChanger_SentinelTime2 != 0 then
            call TimerStart(SentinelTimer2, GravityChanger_SentinelTime2, false, function SentinelAttack2)
            set GravityChanger_SentinelTime2 = 0
        endif
        if GravityChanger_SentinelTime != 0 then
            call TimerStart(SentinelTimer, GravityChanger_SentinelTime, false, function SentinelAttack)
            set GravityChanger_SentinelTime = 0
        else
            call ForGroup(SentinelGroup, function SentinelAttackGroup)
            call TimerStart(SentinelTimer, 5.0, false, function SentinelAttack)
            call TimerStart(SentinelTimer2, 1.5, false, function SentinelAttack2)
            set GravityChanger_SentinelTime = 0
            set GravityChanger_SentinelTime2 = 0
        endif
    endfunction
    
    private function RemoveSentinel takes nothing returns nothing
        local real x = GetUnitX(GetEnumUnit())
        local real y = GetUnitY(GetEnumUnit())
        
        call SetTerrainType(x, y, BACKGROUND_TILE, -1, 1, 0)
        call RemoveUnit( GetEnumUnit() )
    endfunction
    
    private function RemoveSentinelMissile takes nothing returns nothing
        call RemoveUnit( GetEnumUnit() )
    endfunction
    
    private function CanCaveOpen takes nothing returns nothing
        local boolean b = HiddenPortalCount[1] == 1 and HiddenPortalCount[2] == 0 and HiddenPortalCount[3] == 1 and HiddenPortalCount[4] == 3
        set b = b and HiddenPortalCount[5] == 0 and HiddenPortalCount[6] == 0 and HiddenPortalCount[7] == 0 and HiddenPortalCount[8] == 0 and HiddenPortalCount[9] == 0 and HiddenPortalCount[11] == 0

        if b then
             call CaveHiddenEvent_CaveOpen()
        endif
    endfunction

    public function ResetStage takes nothing returns nothing
        local integer i = 1
        local integer playerCount = 0
        
        set Loading = false
        if tk.data > 0 then
            if HiddenPortalState() == 1 then
                call Status.SetLevel(3, 9)
            elseif HiddenPortalState() == 2 then
                call Status.SetLevel(4, 9)
            elseif HiddenPortalState() == 3 then
                call Status.SetLevel(5, 9)
            elseif HiddenPortalState() == 4 then
                call Status.SetLevel(6, 9)
            elseif HiddenPortalState() == 5 then
                call Status.SetLevel(7, 9)
            elseif HiddenPortalState() == 6 then
                call Status.SetLevel(8, 9)
            elseif HiddenPortalState() == 7 then
                call Status.SetLevel(9, 9)
            elseif HiddenPortalState() == 8 then
                call Status.SetLevel(10, 9)
            elseif HiddenPortalState() == 9 and PracticeMode == false then
                set RandomStage_isRandom = true
                call Status.SetLevel(RandomStage_randomWorld[RandomStage_state], RandomStage_randomStage[RandomStage_state])
            elseif HiddenPortalState() == 10 then
                call Status.SetLevel(11, 9)
            elseif HiddenPortalState() == 11 then
                call Status.SetLevel(12, 9)
            elseif HiddenPortalState() == 12 then
                call Status.SetLevel(13, 9)
            else
                if Stage_WorldSkip then
                    call Status.SetLevel(2, 8)
                    call BackGroundChange('hkni')
                    call Inventory_ShowSkinInventoryButton.evaluate(true)
                    call CinematicModeBJ( false, GetPlayersAll() )
                    set BackgroundMusic = gg_snd_William_tell_Overture_Remix
                    call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
                    set Stage_WorldSkip = false
                elseif RandomStage_isRandom then
                    set RandomStage_state = RandomStage_state + tk.data
                    call Status.SetLevel(RandomStage_randomWorld[RandomStage_state], RandomStage_randomStage[RandomStage_state])
                else
                    call Status.SetLevel(Status.World, Status.Level+tk.data)
                endif
            endif
        endif
        set HiddenPortalCount[1] = 0
        set HiddenPortalCount[2] = 0
        set HiddenPortalCount[3] = 0
        set HiddenPortalCount[4] = 0
        set HiddenPortalCount[5] = 0
        set HiddenPortalCount[6] = 0
        set HiddenPortalCount[7] = 0
        set HiddenPortalCount[8] = 0
        set HiddenPortalCount[9] = 0
        set HiddenPortalCount[10] = 0
        set HiddenPortalCount[11] = 0
        set HiddenPortalCount[12] = 0
        set GravityChanger_SentinelTime = 0
        set GravityChanger_SentinelTime2 = 0
        call PauseTimer(SentinelTimer)
        call PauseTimer(SentinelTimer2)
        if tk.data > 0 then
            if RandomStage_isRandom == true and RandomStage_state == 1 then
                call Inventory_ShowSkinInventoryButton.evaluate(true)
                call CinematicModeBJ( false, GetPlayersAll() )
            elseif RandomStage_isRandom == false then
                if Status.World >= 8 and Status.Level > 1 then
                    call Status.SetContinues(Status.Continues + 1)
                endif
                if Status.Level == 1 then
                    call Inventory_ShowSkinInventoryButton.evaluate(true)
                    call CinematicModeBJ( false, GetPlayersAll() )
                    if Status.World >= 8 then
                        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 해당 월드는 클리어마다 컨티뉴가 1씩 추가됩니다." )
                    endif
                endif
                if Status.World == 1 and Status.Level == 1 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, TeamColor[HostNumber] + GetPlayerName(Player(HostNumber-1)) + "|r 님이 ESC를 누르면 게임을 재시작 할 수 있습니다. (컨티뉴 소모)" )
                    set BackgroundMusic = gg_snd_Green_Greens
                    call ForForce( bj_FORCE_ALL_PLAYERS, function PlayersPlayMusic )
                    if SubString("|", -1, 0) != "o" then
                        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 워크래프트3 1.28기준으로 만든 맵이기 때문에, 다른 버전으로 이용하면 약간의 버그가 있을 수 있습니다." )
                        call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 리포지드로 플레이할 경우 클래식 그래픽으로 설정하셔야 원할한 플레이가 가능합니다." )
                    endif
                elseif (Status.World == 3 and Status.Level == 3) or (Status.World == 4 and Status.Level == 2) or (Status.World == 7 and Status.Level == 3) then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 텔레포트 스톤에 대해 자세히 알고 싶다면 F9를 참고해주세요." )
                elseif Status.World == 5 and Status.Level == 1 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 텔레포트 스톤에 대해 자세히 알고 싶다면 F9를 참고해주세요." )
                elseif Status.World == 5 and Status.Level == 2 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 포탈은 땅 또는 오브젝트(버섯, 상자, 문어 블럭)위에 올라탄 상태에서만 이용할 수 있습니다." )
                elseif Status.World == 6 and Status.Level == 1 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 물 속에서 방향키(↑)를 누르면 수영할 수 있습니다." )
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 또한 방향키(↓)를 누르고 있으면 빠르게 하강합니다." )
                elseif Status.World == 7 and Status.Level == 7 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 스톤볼로 변신한 상태에서 방향키(↓)를 누르고 있으면 빔을 발사합니다." )
                elseif Status.World == 11 and Status.Level == 1 then
                    call DisplayTimedTextToForce(GetPlayersAll(), 10.00, "※ 이동하면서 아래키를 눌러보세요!" )
                    call DisplayTimedTextToForce(GetPlayersAll(), 10.00, "|cffeeff55※ 해당 월드는 3-5 까지 있습니다.|r")
                elseif Status.World == 12 and Status.Level == 1 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 블랙홀에 대해 자세히 알고 싶다면 F9를 참고해주세요." )
                elseif Status.World == 12 and Status.Level == 3 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 석상에 대해 자세히 알고 싶다면 F9를 참고해주세요." )
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 진동을 끌수 있습니다. 자세한건 F9를 참고해주세요." )
                elseif Status.World == 13 and Status.Level == 1 then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 보름달에 대해 자세히 알고 싶다면 F9를 참고해주세요." )
                endif
            endif
        endif
        if Status.World == 3 and Status.Level == 5 then
            call TimerStart(TimeLimit, 120, false, null)
            set TimeLimitDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이번 스테이지는 제한시간이 주어집니다." )
        elseif Status.World == 4 and Status.Level == 8 then
            if PersonPlayer() == 5 or PersonPlayer() == 6 then
                call TimerStart(TimeLimit, 60, false, null)
            elseif PersonPlayer() == 7 then
                call TimerStart(TimeLimit, 180, false, null)
            else
                call TimerStart(TimeLimit, 30, false, null)
            endif
            set TimeLimitDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이번 스테이지는 제한시간이 주어집니다." )
        elseif Status.World == 9 and Status.Level == 3 then
            call TimerStart(TimeLimit, 90, false, null)
            set TimeLimitDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이번 스테이지는 제한시간이 주어집니다." )
        elseif Status.World == 10 and Status.Level == 7 then
            if PersonPlayer() == 6 then
                call TimerStart(TimeLimit, 300, false, null)
            elseif PersonPlayer() == 7 then
                call TimerStart(TimeLimit, 420, false, null)
            else
                call TimerStart(TimeLimit, 180, false, null)
            endif
            set TimeLimitDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이번 스테이지는 제한시간이 주어집니다." )
        elseif Status.World == 12 and Status.Level == 8 then
            call TimerStart(TimeLimit, 180, false, null)
            set TimeLimitDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이번 스테이지는 제한시간이 주어집니다." )
        elseif Status.World == 13 and Status.Level == 8 then
            call TimerStart(TimeLimit, 240, false, null)
            set TimeLimitDialog = CreateTimerDialogBJ( TimeLimit, "제한 시간" )
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 이번 스테이지는 제한시간이 주어집니다." )
        endif
        call tk.destroy()
        call Status.SetEscapers(0)
        call RemoveBox()
        call ForGroup(SentinelGroup, function RemoveSentinel)
        call ForGroup(Frame_SentinelMissile, function RemoveSentinelMissile)
        call GroupClear( SentinelGroup )
        call GroupClear( Frame_SentinelMissile )
        call SetObject()
        call Key_keyMap.ResetBlocks(Status.World, Status.Level)
        call GravityChanger_Init()
        call MorphStone_Init()
        call MovePortal_ResetCanMove.execute(Status.World, Status.Level)
        call StoneStatue_ResetBlocks.execute(Status.World, Status.Level)
        call Frame_LaserBlockHistory.Clear()
        set StartRect = LoadRectHandle(StartRectList, Status.World, Status.Level)
        if CountUnitsInGroup(SentinelGroup) > 0 then
            call TimerStart(SentinelTimer, 1.5, false, function SentinelAttack)
        endif
        call TriggerExecute( Water_Trigger )
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                set playerCount = playerCount + 1
                set LeftArrow[i] = false
                set RightArrow[i] = false
                set gravity[i] = 0
                set SteppedPlayer[i] = 0
                set Acceleration[i] = 0

                if GetUnitTypeId(OrangeMushroom[i]) != OrangeMushroomType[i] then
                    set MorphState[i] = false
                endif

                if GetUnitTypeId(OrangeMushroom[i]) == 'ohun' then
                    call PauseTimer(PlayerSentinelTimer[i])
                endif
                if GravityChanger_State == true or GetUnitTypeId(OrangeMushroom[i]) != OrangeMushroomType[i] then
                    call RemoveUnit(OrangeMushroom[i])
                    set OrangeMushroom[i] = CreateUnit(Player(i-1), OrangeMushroomType[i], GetRectMinX(StartRect)+(128*(i-1)), GetRectCenterY(StartRect), 270 )
                    call SetUnitBlendTime(OrangeMushroom[i], 0.00)
                    call Decorate_SetUnitAngle(i - 1, 270)
                endif

                if Status.World == 6 and Status.Level == 8 then
                    call SetUnitPosition(OrangeMushroom[i], GetRectCenterX(StartRect), GetRectMinY(StartRect)+(100*(i-1)))
                    call SetUnitPosition( BackGroundUnits[i], GetRectCenterX(StartRect), GetRectMinY(StartRect)+(100*(i-1)))
                elseif Status.World == 13 or (Status.World == 14 and Status.Level == 5) then
                    if ModuloInteger(playerCount, 2) == 1 then
                        call SetUnitPosition(OrangeMushroom[i], GetRectMinX(StartRect)+(128 * ((playerCount - 1) / 2)), GetRectCenterY(StartRect))
                        call SetUnitPosition( BackGroundUnits[i], GetRectMinX(StartRect)+(128 * ((playerCount - 1) / 2)), GetRectCenterY(StartRect))
                    else
                        call SetUnitPosition(OrangeMushroom[i], GetRectMinX(LoadRectHandle(StartRectList, Status.World * -1, Status.Level))+(128 * ((playerCount - 2) / 2)), GetRectCenterY(LoadRectHandle(StartRectList, Status.World * -1, Status.Level)))
                        call SetUnitPosition( BackGroundUnits[i], GetRectMinX(LoadRectHandle(StartRectList, Status.World * -1, Status.Level))+(128 * ((playerCount - 2) / 2)), GetRectCenterY(LoadRectHandle(StartRectList, Status.World * -1, Status.Level)))
                    endif
                else
                    call SetUnitPosition(OrangeMushroom[i], GetRectMinX(StartRect)+(128*(i-1)), GetRectCenterY(StartRect))
                    call SetUnitPosition( BackGroundUnits[i], GetRectMinX(StartRect)+(128*(i-1)), GetRectCenterY(StartRect))
                endif

                call SetUnitFacing( OrangeMushroom[i], 270 )
                call SetUnitVertexColorBJ( BackGroundUnits[i], 0.00, 0.00, 0.00, 100 )
                if Player(i-1) == GetLocalPlayer() then
                    call SetUnitVertexColorBJ( BackGroundUnits[i], 100.00, 100.00, 100.00, 0 )
                endif
                set Observer_State[i] = false
                set LevelClearState[i] = false
                set Observer_ViewNumber[i] = 0
                call UnitRemoveAbility( OrangeMushroom[i], 'Aloc' )
                call Decorate_SetAbility(i - 1, 'Aloc', false)
                call ShowUnitShow(OrangeMushroom[i])
                call Decorate_UnitShow(i - 1, true)
                call UnitAddAbility( OrangeMushroom[i], 'Aloc' )
                call Decorate_SetAbility(i - 1, 'Aloc', true)
                call SetTextTagVisibility(NameTextTag[i], true)
                set Water_State[i] = IsUnitInRegion(Water_Rects, OrangeMushroom[i])
            endif
        set i = i + 1
        endloop
        set i = 1
        loop
            exitwhen i > 4
            call Observer_Watch.evaluate(PLAYER_MAXINUM + i, Observer_ViewNumber[PLAYER_MAXINUM + i])
            set i = i + 1
        endloop
        set GravityChanger_State = false
    endfunction

    private function ClearTimer takes nothing returns nothing
        call ResetStage()
        call CinematicFilterGenericBJ( 1.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 100 )
    endfunction
    
    private function WorldTimer takes nothing returns nothing
        call Status.SetContinues(20)
        if HiddenPortalState() == 6 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 카페" )
        elseif Status.World == 1 and Status.Level+tk.data > 8 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "World 2: 옥스포드" )
        elseif Status.World == 2 and Status.Level+tk.data > 8 then
            if HiddenPortalState() == 1 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Final World(Part 2): 도시" )
            elseif HiddenPortalState() == 2 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Final World(Part 3): 발렌타인 데이" )
            elseif HiddenPortalState() == 3 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Final World(Part 4): 해변" )
            elseif HiddenPortalState() == 4 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Final World(Part 5): 펩시" )
            elseif HiddenPortalState() == 5 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 월드 첼린지" )
            elseif HiddenPortalState() == 7 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Final World(Part 6): 사막" )
            elseif HiddenPortalState() == 8 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 엘린 숲" )
            elseif HiddenPortalState() == 9 then
                if RandomStage_isHard then
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Random World: ??? |cffFF0202(Hard)|r" )
                else
                    call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Random World: ??? |cff1FBF00(Normal)|r" )
                endif
            elseif HiddenPortalState() == 11 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 깊은 산속" )
            elseif HiddenPortalState() == 12 then
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 월드 첼린지 II" )
            else
                call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Final World: 핑크 핑크" )
            endif
        elseif HiddenPortalState() == 10 then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 얼음 동굴" )
        elseif TESTMODE == false then
            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "World 1: 집 앞마당" )
        endif
        
        call CanCaveOpen()

        if TESTMODE == true then
            call tk.start(0, false, function ClearTimer)
        else
            call tk.start(3.0, false, function ClearTimer)
        endif
    endfunction

    public function RemoveTimeLimit takes nothing returns nothing
        if (Status.World == 3 and Status.Level == 5) or (Status.World == 4 and Status.Level == 8) or (Status.World == 9 and Status.Level == 3) or (Status.World == 10 and Status.Level == 7) or (Status.World == 12 and Status.Level == 8) or (Status.World == 13 and Status.Level == 8) then
            call PauseTimer(TimeLimit)
            call DestroyTimerDialog(TimeLimitDialog)
        endif
    endfunction
    
    public function Clear takes integer i returns nothing
        if Stage_Loading == false then
            set Loading = true
            set tk = tick.create(i)
            call RemoveTimeLimit()
            call SetFilter(1.00, 0, 0, 0, 100, 0, 0, 0, 0 )

            if RandomStage_isRandom == false then
                if (Status.Level+i > 8 or (Status.World == 1 and Status.Level == 0)) then
                    call Inventory_ShowSkinInventoryButton.evaluate(false)
                    call CinematicModeBJ( true, GetPlayersAll() )
                    if Status.World == 1 and Status.Level == 0 then
                        call CinematicFilterGenericBJ( 0.00, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 0, 0, 0, 0, 0, 0, 0, 0 )
                        if TESTMODE == true then
                            call Status.SetLevel(13, 8)
                            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "Secret World: 월드 첼린지 2" )
                            call tk.start(3.0, false, function WorldTimer)
                        else
                            call tk.start(1.0, false, function WorldTimer)
                        endif
                    elseif Status.World == 3 or Status.World == 4 or Status.World == 9 or Status.World == 13 then
                        call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                        call TriggerExecute( Ending_Trigger )
                    elseif Status.World == 5 then
                        call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                        call TriggerExecute( TrueEnding_Trigger )
                    elseif Status.World == 6 then
                        call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                        call TriggerExecute( TrueEnding2_Trigger )
                    elseif Status.World == 7 then
                        call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                        call TriggerExecute( TrueEnding3_Trigger )
                    elseif Status.World == 10 then
                        call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                        set TrueEnding3_PyramidEnding = true
                        call TriggerExecute( TrueEnding3_Trigger )
                    elseif Status.World == 12 then
                        call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                        set TrueEnding3_CaveEnding = true
                        call TriggerExecute( TrueEnding3_Trigger )
                    else
                        call StopSound( BackgroundMusic, false, true )
                        if Stage_WorldSkip == true then
                            call DisplayTimedTextToForce( GetPlayersAll(), 10.00, "※ 방장이 월드를 스킵하였습니다." )
                        endif
                        if TESTMODE == true then
                            call tk.start(0, false, function WorldTimer)
                        else
                            call tk.start(2.0, false, function WorldTimer)
                        endif
                    endif
                elseif HiddenPortalState() == 10 and i > 0 then
                    call Inventory_ShowSkinInventoryButton.evaluate(false)
                    call CinematicModeBJ( true, GetPlayersAll() )
                    call StopSound( BackgroundMusic, false, true )
                    call tk.start(2.0, false, function WorldTimer)
                elseif Status.Level+i > 7 and Status.World == 8 and PracticeMode == false then
                    set SecretEnding = true
                    call Inventory_ShowSkinInventoryButton.evaluate(false)
                    call CinematicModeBJ( true, GetPlayersAll() )
                    call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                    call TriggerExecute( TrueEnding3_Trigger )
                elseif Status.World == 11 and Status.Level+i > 5 and PracticeMode == false then
                    set TrueEnding3END_EllinEnding = true
                    call Inventory_ShowSkinInventoryButton.evaluate(false)
                    call CinematicModeBJ( true, GetPlayersAll() )
                    call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                    call TriggerExecute( TrueEnding3_Trigger )
                elseif Status.World == 14 and Status.Level+i > 5 and PracticeMode == false then
                    set SecretEnding2 = true
                    call Inventory_ShowSkinInventoryButton.evaluate(false)
                    call CinematicModeBJ( true, GetPlayersAll() )
                    call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                    call TriggerExecute( TrueEnding3_Trigger )
                else
                    call tk.start(1.5, false, function ClearTimer)
                endif
            elseif RandomStage_state + i > 8 then
                call Inventory_ShowSkinInventoryButton.evaluate(false)
                call CinematicModeBJ( true, GetPlayersAll() )
                call SetFilter(2.00, 0, 0, 0, 100, 100, 100, 100, 0 )
                call TriggerExecute( Ending_Trigger )
            else
                call tk.start(1.5, false, function ClearTimer)
            endif
        endif
    endfunction
    
    private function Gameover takes nothing returns nothing
        local integer i = 1
        local string msg
        
        if tk.data > 70 then
            call SetSoundPitch( BackgroundMusic, tk.data*0.01 )
            set tk.data = tk.data - 1
        else
            call StopSound( BackgroundMusic, false, true )
            call tk.destroy()
            if Status.World == 1 then
                set msg = "협동을 하랬더니 조별 과제 하고 있냐"
            elseif Status.World == 2 then
                if Status.Level < 5 then
                    set msg = "소개팅은 물 건너갔어."
                else
                    set msg = "절반은 갔는데!"
                endif
            elseif Status.World == 3 then
                if Status.Level < 5 then
                    set msg = "이럴 순 없어!"
                else
                    set msg = "안 돼... 소개팅이 코앞인데!"
                endif
            elseif Status.World == 4 then
                if Status.Level < 5 then
                    set msg = "젠장... 괜히 어려운 길로 갔어!"
                else
                    set msg = "으흑... 내 소개팅!"
                endif
            elseif Status.World >= 5 then
                if Status.Level < 5 then
                    set msg = "거 길 한번 험난하네 진짜."
                else
                    set msg = "아... 이번엔 제대로 된 소개팅을 할 수 있었는데!"
                endif
            else
                set msg = "졌어"
            endif
            loop
            exitwhen i > PLAYER_MAXINUM
                if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                    call CustomDefeatBJ( Player(i-1), msg )
                endif
            set i = i + 1
            endloop
        endif
    endfunction
    
    private function RestartMain takes nothing returns nothing
        if Status.Continues > 0 then
            call Status.SetContinues(Status.Continues-1)
            call Clear(0)
        else
            set Loading = true
            set tk = tick.create(100)
            call SetFilter(2.50, 0, 0, 0, 100, 0, 0, 0, 0)
            call tk.start(0.1, true, function Gameover)
        endif
    endfunction
    
    private function init takes nothing returns nothing
        call SaveRectHandle(StartRectList, 1, 1, gg_rct_StartRect001)
        call SaveRectHandle(StartRectList, 1, 2, gg_rct_StartRect002)
        call SaveRectHandle(StartRectList, 1, 3, gg_rct_StartRect003)
        call SaveRectHandle(StartRectList, 1, 4, gg_rct_StartRect004)
        call SaveRectHandle(StartRectList, 1, 5, gg_rct_StartRect005)
        call SaveRectHandle(StartRectList, 1, 6, gg_rct_StartRect006)
        call SaveRectHandle(StartRectList, 1, 7, gg_rct_StartRect007)
        call SaveRectHandle(StartRectList, 1, 8, gg_rct_StartRect008)

        call SaveRectHandle(StartRectList, 2, 1, gg_rct_StartRect009)
        call SaveRectHandle(StartRectList, 2, 2, gg_rct_StartRect010)
        call SaveRectHandle(StartRectList, 2, 3, gg_rct_StartRect011)
        call SaveRectHandle(StartRectList, 2, 4, gg_rct_StartRect012)
        call SaveRectHandle(StartRectList, 2, 5, gg_rct_StartRect013)
        call SaveRectHandle(StartRectList, 2, 6, gg_rct_StartRect014)
        call SaveRectHandle(StartRectList, 2, 7, gg_rct_StartRect015)
        call SaveRectHandle(StartRectList, 2, 8, gg_rct_StartRect016)

        call SaveRectHandle(StartRectList, 3, -1, gg_rct_StartRect3_Minus1)
        call SaveRectHandle(StartRectList, 3, 1, gg_rct_StartRect017)
        call SaveRectHandle(StartRectList, 3, 2, gg_rct_StartRect018)
        call SaveRectHandle(StartRectList, 3, 3, gg_rct_StartRect019)
        call SaveRectHandle(StartRectList, 3, 4, gg_rct_StartRect020)
        call SaveRectHandle(StartRectList, 3, 5, gg_rct_StartRect021)
        call SaveRectHandle(StartRectList, 3, 6, gg_rct_StartRect022)
        call SaveRectHandle(StartRectList, 3, 7, gg_rct_StartRect023)
        call SaveRectHandle(StartRectList, 3, 8, gg_rct_StartRect024)

        call SaveRectHandle(StartRectList, 4, -1, gg_rct_StartRect4_Minus1)
        call SaveRectHandle(StartRectList, 4, 1, gg_rct_StartRect025)
        call SaveRectHandle(StartRectList, 4, 2, gg_rct_StartRect026)
        call SaveRectHandle(StartRectList, 4, 3, gg_rct_StartRect027)
        call SaveRectHandle(StartRectList, 4, 4, gg_rct_StartRect028)
        call SaveRectHandle(StartRectList, 4, 5, gg_rct_StartRect029)
        call SaveRectHandle(StartRectList, 4, 6, gg_rct_StartRect030)
        call SaveRectHandle(StartRectList, 4, 7, gg_rct_StartRect031)
        call SaveRectHandle(StartRectList, 4, 8, gg_rct_StartRect032)

        call SaveRectHandle(StartRectList, 5, 1, gg_rct_StartRect033)
        call SaveRectHandle(StartRectList, 5, 2, gg_rct_StartRect034)
        call SaveRectHandle(StartRectList, 5, 3, gg_rct_StartRect035)
        call SaveRectHandle(StartRectList, 5, 4, gg_rct_StartRect036)
        call SaveRectHandle(StartRectList, 5, 5, gg_rct_StartRect037)
        call SaveRectHandle(StartRectList, 5, 6, gg_rct_StartRect038)
        call SaveRectHandle(StartRectList, 5, 7, gg_rct_StartRect039)
        call SaveRectHandle(StartRectList, 5, 8, gg_rct_StartRect040)

        call SaveRectHandle(StartRectList, 6, 1, gg_rct_StartRect041)
        call SaveRectHandle(StartRectList, 6, 2, gg_rct_StartRect042)
        call SaveRectHandle(StartRectList, 6, 3, gg_rct_StartRect043)
        call SaveRectHandle(StartRectList, 6, 4, gg_rct_StartRect044)
        call SaveRectHandle(StartRectList, 6, 5, gg_rct_StartRect045)
        call SaveRectHandle(StartRectList, 6, 6, gg_rct_StartRect046)
        call SaveRectHandle(StartRectList, 6, 7, gg_rct_StartRect047)
        call SaveRectHandle(StartRectList, 6, 8, gg_rct_StartRect048)

        call SaveRectHandle(StartRectList, 7, 1, gg_rct_StartRect049)
        call SaveRectHandle(StartRectList, 7, 2, gg_rct_StartRect050)
        call SaveRectHandle(StartRectList, 7, 3, gg_rct_StartRect051)
        call SaveRectHandle(StartRectList, 7, 4, gg_rct_StartRect052)
        call SaveRectHandle(StartRectList, 7, 5, gg_rct_StartRect053)
        call SaveRectHandle(StartRectList, 7, 6, gg_rct_StartRect054)
        call SaveRectHandle(StartRectList, 7, 7, gg_rct_StartRect055)
        call SaveRectHandle(StartRectList, 7, 8, gg_rct_StartRect056)

        call SaveRectHandle(StartRectList, 8, 1, gg_rct_StartRect057)
        call SaveRectHandle(StartRectList, 8, 2, gg_rct_StartRect058)
        call SaveRectHandle(StartRectList, 8, 3, gg_rct_StartRect059)
        call SaveRectHandle(StartRectList, 8, 4, gg_rct_StartRect060)
        call SaveRectHandle(StartRectList, 8, 5, gg_rct_StartRect061)
        call SaveRectHandle(StartRectList, 8, 6, gg_rct_StartRect062)
        call SaveRectHandle(StartRectList, 8, 7, gg_rct_StartRect063)

        call SaveRectHandle(StartRectList, 9, -1, gg_rct_StartRect9_Minus1)
        call SaveRectHandle(StartRectList, 9, -2, gg_rct_StartRect9_Minus2)
        call SaveRectHandle(StartRectList, 9, 1, gg_rct_StartRect065)
        call SaveRectHandle(StartRectList, 9, 2, gg_rct_StartRect066)
        call SaveRectHandle(StartRectList, 9, 3, gg_rct_StartRect067)
        call SaveRectHandle(StartRectList, 9, 4, gg_rct_StartRect068)
        call SaveRectHandle(StartRectList, 9, 5, gg_rct_StartRect069)
        call SaveRectHandle(StartRectList, 9, 6, gg_rct_StartRect070)
        call SaveRectHandle(StartRectList, 9, 7, gg_rct_StartRect071)
        call SaveRectHandle(StartRectList, 9, 8, gg_rct_StartRect072)

        call SaveRectHandle(StartRectList, 10, 1, gg_rct_StartRect073)
        call SaveRectHandle(StartRectList, 10, 2, gg_rct_StartRect074)
        call SaveRectHandle(StartRectList, 10, 3, gg_rct_StartRect075)
        call SaveRectHandle(StartRectList, 10, 4, gg_rct_StartRect076)
        call SaveRectHandle(StartRectList, 10, 5, gg_rct_StartRect077)
        call SaveRectHandle(StartRectList, 10, 6, gg_rct_StartRect078)
        call SaveRectHandle(StartRectList, 10, 7, gg_rct_StartRect079)
        call SaveRectHandle(StartRectList, 10, 8, gg_rct_StartRect080)

        call SaveRectHandle(StartRectList, 11, 1, gg_rct_StartRect081)
        call SaveRectHandle(StartRectList, 11, 2, gg_rct_StartRect082)
        call SaveRectHandle(StartRectList, 11, 3, gg_rct_StartRect083)
        call SaveRectHandle(StartRectList, 11, 4, gg_rct_StartRect084)
        call SaveRectHandle(StartRectList, 11, 5, gg_rct_StartRect085)

        call SaveRectHandle(StartRectList, 12, 1, gg_rct_StartRect089)
        call SaveRectHandle(StartRectList, 12, 2, gg_rct_StartRect090)
        call SaveRectHandle(StartRectList, 12, 3, gg_rct_StartRect091)
        call SaveRectHandle(StartRectList, 12, 4, gg_rct_StartRect092)
        call SaveRectHandle(StartRectList, 12, 5, gg_rct_StartRect093)
        call SaveRectHandle(StartRectList, 12, 6, gg_rct_StartRect094)
        call SaveRectHandle(StartRectList, 12, 7, gg_rct_StartRect095)
        call SaveRectHandle(StartRectList, 12, 8, gg_rct_StartRect096)

        call SaveRectHandle(StartRectList, 13, 1, gg_rct_StartRect097)
        call SaveRectHandle(StartRectList, 13, 2, gg_rct_StartRect098)
        call SaveRectHandle(StartRectList, 13, 3, gg_rct_StartRect099)
        call SaveRectHandle(StartRectList, 13, 4, gg_rct_StartRect100)
        call SaveRectHandle(StartRectList, 13, 5, gg_rct_StartRect101)
        call SaveRectHandle(StartRectList, 13, 6, gg_rct_StartRect102)
        call SaveRectHandle(StartRectList, 13, 7, gg_rct_StartRect103)
        call SaveRectHandle(StartRectList, 13, 8, gg_rct_StartRect104)

        call SaveRectHandle(StartRectList, 14, 1, gg_rct_StartRect105)
        call SaveRectHandle(StartRectList, 14, 2, gg_rct_StartRect106)
        call SaveRectHandle(StartRectList, 14, 3, gg_rct_StartRect107)
        call SaveRectHandle(StartRectList, 14, 4, gg_rct_StartRect108)
        call SaveRectHandle(StartRectList, 14, 5, gg_rct_StartRect109)

        call SaveRectHandle(StartRectList, 15, 1, gg_rct_StartRect113)
        
        // 2번째 소환위치
        call SaveRectHandle(StartRectList, -14, 5, gg_rct_StartRectSub109)
        call SaveRectHandle(StartRectList, -13, 1, gg_rct_StartRectSub097)
        call SaveRectHandle(StartRectList, -13, 2, gg_rct_StartRectSub098)
        call SaveRectHandle(StartRectList, -13, 3, gg_rct_StartRectSub099)
        call SaveRectHandle(StartRectList, -13, 4, gg_rct_StartRectSub100)
        call SaveRectHandle(StartRectList, -13, 5, gg_rct_StartRectSub101)
        call SaveRectHandle(StartRectList, -13, 6, gg_rct_StartRectSub102)
        call SaveRectHandle(StartRectList, -13, 7, gg_rct_StartRectSub103)
        call SaveRectHandle(StartRectList, -13, 8, gg_rct_StartRectSub104)


        set StartRect = LoadRectHandle(StartRectList, 1, 1)
        call TriggerRegisterTimerExpireEvent(Restart, TimeLimit)
        call TriggerAddAction( Restart, function RestartMain )
        
        call TriggerAddAction( SentinelTrigger, function SentinelAttack )
    endfunction
endlibrary