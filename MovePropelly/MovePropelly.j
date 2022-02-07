scope Propelly initializer init
    globals
        private region array Rects
        private rect array CompareRect
        private real array FlyGravity
        private string array Angle
    endglobals
    
    private function SetTerrain takes integer terrainType, real x, real y returns nothing
        call SetTerrainType(x, y, terrainType, -1, 1, 0)
        if terrainType == BACKGROUND_TILE then
            call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\DispelMagic\\DispelMagicTarget.mdl", x, y ))
        endif
    endfunction
    
    private function Main takes nothing returns nothing
        local integer i = 1
        local integer j = 1
        
        if GetUnitTypeId(GetTriggerUnit()) == 'orai' then
            loop
            exitwhen CompareRect[i] == null
                if GetTriggeringRegion() == Rects[i] then
                    loop
                    exitwhen j > Stage_BoxsCount
                        if GetUnitTypeId(OrangeMushroom[PLAYER_MAXINUM+j]) == 'orai' and GetTriggerUnit() == OrangeMushroom[PLAYER_MAXINUM+j] and GetUnitUserData(GetTriggerUnit()) != i then
                            call SetUnitUserData( GetTriggerUnit(), i )
                            if Angle[i] == "Left" then
                                if GravityChanger_State == false then
                                    call SetUnitAnimation( GetTriggerUnit(), "Stand First" )
                                else
                                    call SetUnitAnimation( GetTriggerUnit(), "Stand Second" )
                                endif
                                set LeftArrow[PLAYER_MAXINUM+j] = true
                                set RightArrow[PLAYER_MAXINUM+j] = false
                            elseif Angle[i] == "Right" then
                                if GravityChanger_State == false then
                                    call SetUnitAnimation( GetTriggerUnit(), "Stand Second" )
                                else
                                    call SetUnitAnimation( GetTriggerUnit(), "Stand First" )
                                endif
                                set LeftArrow[PLAYER_MAXINUM+j] = false
                                set RightArrow[PLAYER_MAXINUM+j] = true
                            else
                                set LeftArrow[PLAYER_MAXINUM+j] = false
                                set RightArrow[PLAYER_MAXINUM+j] = false
                            endif
                            set gravity[PLAYER_MAXINUM+j] = FlyGravity[i]
                        endif
                    set j = j + 1
                    endloop
                    return
                endif
            set i = i + 1
            endloop
        endif
    endfunction
    
    private function SetRect takes trigger t, integer i, rect r, real g, string a returns nothing
        set Rects[i] = CreateRegion()
        call RegionAddRect( Rects[i], r )
        set FlyGravity[i] = g
        set CompareRect[i] = r
        set Angle[i] = a
        call TriggerRegisterEnterRegion(t, Rects[i], null)
    endfunction
    
    
    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call SetRect(t, 1, gg_rct_PropellyMove001, 10, "none")
        call SetRect(t, 2, gg_rct_PropellyMove002, -10, "none")
        call SetRect(t, 3, gg_rct_PropellyMove003, 10, "none")
        call SetRect(t, 4, gg_rct_PropellyMove004, -10, "none")
        call SetRect(t, 5, gg_rct_PropellyMove005, 0, "Right")
        call SetRect(t, 6, gg_rct_PropellyMove006, 0, "Left")
        call SetRect(t, 7, gg_rct_PropellyMove007, 0, "Right")
        call SetRect(t, 8, gg_rct_PropellyMove008, 0, "Left")
        call SetRect(t, 9, gg_rct_PropellyMove009, 10, "none")
        call SetRect(t, 10, gg_rct_PropellyMove010, -10, "none")
        call SetRect(t, 11, gg_rct_PropellyMove011, 10, "none")
        call SetRect(t, 12, gg_rct_PropellyMove012, -10, "none")
        call SetRect(t, 13, gg_rct_PropellyMove013, -10, "none")
        call SetRect(t, 14, gg_rct_PropellyMove014, 0, "Left")
        call SetRect(t, 15, gg_rct_PropellyMove015, 10, "none")
        call SetRect(t, 16, gg_rct_PropellyMove016, 0, "Right")
        call SetRect(t, 17, gg_rct_PropellyMove017, 2, "Right")
        call SetRect(t, 18, gg_rct_PropellyMove018, -2, "Left")
        call SetRect(t, 19, gg_rct_PropellyMove019, 0, "Right")
        call SetRect(t, 20, gg_rct_PropellyMove020, 0, "Left")
        call SetRect(t, 21, gg_rct_PropellyMove021, 0, "Right")
        call SetRect(t, 22, gg_rct_PropellyMove022, 0, "Left")
        call SetRect(t, 23, gg_rct_PropellyMove023, 8, "Right")
        call SetRect(t, 24, gg_rct_PropellyMove024, -8, "Left")
        call SetRect(t, 25, gg_rct_PropellyMove025, 0, "Right")
        call SetRect(t, 26, gg_rct_PropellyMove026, 0, "Left")
        call SetRect(t, 27, gg_rct_PropellyMove027, 0, "Right")
        call SetRect(t, 28, gg_rct_PropellyMove028, 0, "Left")
        call SetRect(t, 29, gg_rct_PropellyMove029, 0, "Right")
        call SetRect(t, 30, gg_rct_PropellyMove030, 10, "none")
        call SetRect(t, 31, gg_rct_PropellyMove031, 0, "Left")
        call SetRect(t, 32, gg_rct_PropellyMove032, -10, "none")
        call SetRect(t, 33, gg_rct_PropellyMove033, 0, "Right")
        call SetRect(t, 34, gg_rct_PropellyMove034, 0, "Left")
        call SetRect(t, 35, gg_rct_PropellyMove035, 0, "Right")
        call SetRect(t, 36, gg_rct_PropellyMove036, 0, "Left")
        call SetRect(t, 37, gg_rct_PropellyMove037, 10, "none")
        call SetRect(t, 38, gg_rct_PropellyMove038, -10, "none")
        call SetRect(t, 39, gg_rct_PropellyMove039, 0, "Right")
        call SetRect(t, 40, gg_rct_PropellyMove040, 0, "Left")
        call SetRect(t, 41, gg_rct_PropellyMove041, 0, "Left")
        call SetRect(t, 42, gg_rct_PropellyMove042, 0, "Right")
        call SetRect(t, 43, gg_rct_PropellyMove043, 0, "Left")
        call SetRect(t, 44, gg_rct_PropellyMove044, 0, "Right")
        call SetRect(t, 45, gg_rct_PropellyMove045, 0, "Left")
        call SetRect(t, 46, gg_rct_PropellyMove046, 0, "Right")
        call SetRect(t, 47, gg_rct_PropellyMove047, 0, "Left")
        call SetRect(t, 48, gg_rct_PropellyMove048, 0, "Right")
        call SetRect(t, 49, gg_rct_PropellyMove049, 0, "Left")
        call SetRect(t, 50, gg_rct_PropellyMove050, 0, "Left")
        call SetRect(t, 51, gg_rct_PropellyMove051, 0, "Right")
        call SetRect(t, 52, gg_rct_PropellyMove052, 0, "Right")
        call SetRect(t, 53, gg_rct_PropellyMove053, 0, "Right")
        call SetRect(t, 54, gg_rct_PropellyMove054, 0, "Left")
        call SetRect(t, 55, gg_rct_PropellyMove055, 0, "Left")
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endscope