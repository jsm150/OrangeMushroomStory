library MorphStone initializer init needs UnitMotion
    globals
        boolean array MorphState
        
        private tick tk
        private boolean array RectState
        private unit array MorphUnit
        
        public region array Rects
        
        private rect array CompareRect
        private integer CountInt = 0

        public integer array UseList
        public integer UseCount
    endglobals

    private struct Unit
        public static integer OrangeMushroom = 'hpea'
        public static integer Bloctopus = 'ogru'
        public static integer KingBloctopus = 'otau'
        public static integer CokeMushroom = 'ocat'
        public static integer Sentinel = 'ohun'
        public static integer Propelly = 'orai'
    endstruct

    private function HistoryRecord takes integer i returns nothing
        set UseList[UseCount] = i
        set UseCount = UseCount + 1
    endfunction

    private function InitHistory takes nothing returns nothing
        set UseCount = 0
    endfunction

    public function Use takes integer i returns nothing
        call SetDoodadAnimationRect(CompareRect[i], 'LOcb', "Death", false)
        call SetDoodadAnimationRect(CompareRect[i], 'LOss', "Death", false)
        set RectState[i] = true
        call SetUnitVertexColor(MorphUnit[i], 255, 255, 255, 0)
        call HistoryRecord(i)
    endfunction
    
    public function Init takes nothing returns nothing
        local integer i = 1
        
        loop
        exitwhen CompareRect[i] == null
            if RectState[i] == true then
                set RectState[i] = false
                call SetUnitVertexColor(MorphUnit[i], 255, 255, 255, 150)
                call SetDoodadAnimationRect(CompareRect[i], 'LOcb', "Stand", false)
                call SetDoodadAnimationRect(CompareRect[i], 'LOss', "Stand", false)
            endif
        set i = i + 1
        endloop

        call InitHistory()
    endfunction
    
    private function Main takes nothing returns nothing
        local integer i = 1
        local integer j = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        local integer uType
        local real x
        local real y
        
        loop
        exitwhen CompareRect[i] == null
            if GetTriggeringRegion() == Rects[i] and RectState[i] == false and j >= 1 and j <= PLAYER_MAXINUM and BackGroundUnits[j] != GetTriggerUnit() and not(Decorate_IsTriggeringUnitInDecorate(j - 1)) and GetUnitTypeId(GetTriggerUnit()) != GetUnitTypeId(MorphUnit[i]) then
                set x = GetUnitX(OrangeMushroom[j])
                set y = GetUnitY(OrangeMushroom[j])
                
                if GetUnitTypeId(MorphUnit[i]) == 'hpea' then
                    if MorphState[j] == true then
                        if GetUnitTypeId(GetTriggerUnit()) == 'ohun' then
                            call PauseTimer(PlayerSentinelTimer[j])
                        endif
                        if GetUnitTypeId(GetTriggerUnit()) == 'ogru' or GetUnitTypeId(GetTriggerUnit()) == 'otau' then
                            set LeftArrow[j] = false
                            set RightArrow[j] = false
                        endif
                        call RemoveUnit(OrangeMushroom[j])
                        set uType =  OrangeMushroomType[j]
                        set MorphState[j] = false
                        if i != 15 and i != 16 and i != 24 and i != 31 and i != 60 and i != 63 then
                            call SetDoodadAnimationRect(CompareRect[i], 'LOcb', "Death", false)
                        endif
                    else
                        return
                    endif
                else
                    if (GetUnitTypeId(GetTriggerUnit()) == 'ogru' or GetUnitTypeId(GetTriggerUnit()) == 'otau') and GetUnitTypeId(MorphUnit[i]) != 'ogru' and GetUnitTypeId(MorphUnit[i]) != 'otau' then
                        set LeftArrow[j] = false
                        set RightArrow[j] = false
                    endif
                    if GetUnitTypeId(GetTriggerUnit()) == 'ohun' then
                        call PauseTimer(PlayerSentinelTimer[j])
                    endif
                    call RemoveUnit(OrangeMushroom[j])
                    set uType =  GetUnitTypeId(MorphUnit[i])
                    set MorphState[j] = true
                    if i != 15 and i != 16 and i != 24 and i != 31 and i != 60 and i != 63 then
                        call SetDoodadAnimationRect(CompareRect[i], 'LOss', "Death", false)
                    endif
                endif
                
                if i != 15 and i != 16 and i != 24 and i != 31 and i != 60 and i != 63 then
                    set RectState[i] = true
                    call SetUnitVertexColor(MorphUnit[i], 255, 255, 255, 0)
                    call HistoryRecord(i)
                endif
                call DestroyEffect(AddSpecialEffect("war3mapImported\\Morph.mdl", x, y ))
                call StopSound(gg_snd_Morph001, false, false)
                call StartSound( gg_snd_Morph001 )
                if uType == 'orai' or uType == 'o001' then
                    set gravity[j] = 0
                endif
                if GravityChanger_State == false then
                    set OrangeMushroom[j] = CreateUnit(Player(j-1), uType, x, y, 270 )
                else
                    set OrangeMushroom[j] = CreateUnit(Player(j-1), uType, x, y, 90 )
                endif
                
                if GetUnitTypeId(MorphUnit[i]) == 'orai' then
                    if Direction[j] == "Left" then
                        call UnitMotion_LeftStand(j)
                    else
                        call UnitMotion_RightStand(j)
                    endif
                elseif GetUnitTypeId(MorphUnit[i]) == 'ogru' or GetUnitTypeId(MorphUnit[i]) == 'otau' then
                    if Direction[j] == "Left" then
                        if GravityChanger_State == false then
                            set LeftArrow[j] = true
                            set RightArrow[j] = false
                        else
                            set LeftArrow[j] = false
                            set RightArrow[j] = true
                        endif
                    else
                        if GravityChanger_State == false then
                            set LeftArrow[j] = false
                            set RightArrow[j] = true
                        else
                            set LeftArrow[j] = true
                            set RightArrow[j] = false
                        endif
                    endif
                endif
                if GravityChanger_State == false then
                    call SetCameraTargetControllerNoZForPlayer( Player(j-1), OrangeMushroom[j], 0, 128, false )
                else
                    call SetCameraTargetControllerNoZForPlayer( Player(j-1), OrangeMushroom[j], 0, -128, false )
                endif
                call SetUnitBlendTime(OrangeMushroom[j], 0.00)
                 set Acceleration[j] = 0
            endif
        set i = i + 1
        endloop
    endfunction
    
    private function SetRect takes trigger t, integer uType, rect r returns nothing
        set CountInt = CountInt + 1
        if uType != 0 then
            set MorphUnit[CountInt] = CreateUnit(Player(11), uType, GetRectCenterX(r), GetRectCenterY(r), 270 )
            call SetUnitVertexColor(MorphUnit[CountInt], 255, 255, 255, 150)
        else
            set MorphUnit[CountInt] = null
        endif
        set Rects[CountInt] = CreateRegion()
        call RegionAddRect( Rects[CountInt], r )
        set CompareRect[CountInt] = r
        call TriggerRegisterEnterRegion(t, Rects[CountInt], null)
    endfunction
    
    private function init takes nothing returns nothing
        local trigger t = CreateTrigger()
        
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone001)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone002)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone003)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone004)
        call SetRect(t, Unit.CokeMushroom, gg_rct_MorphStone005)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone006)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone007)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone008)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone009)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone010)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone011)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone012)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone013)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone014)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone015)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone016)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone017)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone018)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone019)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone020)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone021)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone022)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone023)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone024)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone025)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone026)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone027)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone028)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone029)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone030)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone031)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone032)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone033)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone034)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone035)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone036)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone037)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone038)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone039)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone040)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone041)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone042)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone043)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone044)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone045)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone046)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone047)
        call SetRect(t, Unit.CokeMushroom, gg_rct_MorphStone048)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone049)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone050)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone051)
        call SetRect(t, Unit.CokeMushroom, gg_rct_MorphStone052)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone053)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone054)
        call SetRect(t, Unit.CokeMushroom, gg_rct_MorphStone055)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone056)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone057)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone058)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone059)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone060)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone061)
        call SetRect(t, Unit.CokeMushroom, gg_rct_MorphStone062)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone063)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone064)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone065)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone066)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone067)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone068)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone069)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone070)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone071)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone072)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone073)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone074)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone075)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone076)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone077)
        call SetRect(t, Unit.Sentinel, gg_rct_MorphStone078)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone079)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone080)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone081)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone082)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone083)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone084)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone085)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone086)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone087)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone088)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone089)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone090)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone091)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone092)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone093)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone094)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone095)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone096)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone097)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone098)
        call SetRect(t, Unit.OrangeMushroom, gg_rct_MorphStone099)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone100)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone101)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone102)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone103)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone104)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone105)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone106)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone107)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone108)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone109)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone110)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone111)
        call SetRect(t, Unit.Propelly, gg_rct_MorphStone112)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone113)
        call SetRect(t, Unit.KingBloctopus, gg_rct_MorphStone114)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone115)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone116)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone117)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone118)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone119)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone120)
        call SetRect(t, Unit.Bloctopus, gg_rct_MorphStone121)

        call TriggerAddAction( t, function Main )
        
        set t = null
        /*
            주황버섯 : hpea
            보라문어 : ogru
            분홍문어 : otau
            코크버섯 : ocat
            스톤볼 : ohun
            비행기 : orai
        */
    endfunction
endlibrary