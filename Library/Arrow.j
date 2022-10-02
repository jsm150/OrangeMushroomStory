library Arrow initializer init needs Calculation
    globals
        private integer Count = 0
        private hashtable Hash = InitHashtable()
        public boolean array State
        public boolean array EffectState
        public trigger Trigger
        private region array Rects
        public region AllRects
        private real array ArrowAngle
        public real array PlayersArrowAngle
    endglobals
    
    public function SecretAction takes integer i returns nothing
        local real x = GetUnitX(OrangeMushroom[i])
        local real y = GetUnitY(OrangeMushroom[i])
        local real polar_x = DistanceX(x, 70, PlayersArrowAngle[i])
        local real polar_y = DistanceY(y, 70, PlayersArrowAngle[i])
        
        set gravity[i] = polar_y - y
        set Acceleration[i] = polar_x - x
        
        if gravity[i] > 50 then
            set gravity[i] = 50
        elseif gravity[i] < -50 then
            set gravity[i] = -50
        endif
        if Acceleration[i] > 40 then
            set Acceleration[i] = 40
        elseif Acceleration[i] < -40 then
            set Acceleration[i] = -40
        endif
    endfunction
    
    private function RectIn takes integer i returns nothing
        local integer j = 1
        local real x
        local real y
        local real polar_x
        local real polar_y
        
        loop
        exitwhen Rects[j] == null
            if GetTriggeringRegion() == Rects[j] then
                set x = GetUnitX(OrangeMushroom[i])
                set y = GetUnitY(OrangeMushroom[i])
                set polar_x = DistanceX(x, 70, ArrowAngle[j])
                set polar_y = DistanceY(y, 70, ArrowAngle[j])
                call CreateUnit(Player(11), 'ewsp', x, y, ArrowAngle[j] )
                set PlayersArrowAngle[i] = ArrowAngle[j]
                set gravity[i] = polar_y - y
                set Acceleration[i] = polar_x - x
                
                if gravity[i] > 50 then
                    set gravity[i] = 50
                elseif gravity[i] < -50 then
                    set gravity[i] = -50
                endif
                if Acceleration[i] > 40 then
                    set Acceleration[i] = 40
                elseif Acceleration[i] < -40 then
                    set Acceleration[i] = -40
                endif
                
                if GetLocalPlayer() == Player(i-1) then 
                    call StartSound( gg_snd_FlashJump )
                    call CinematicFilterGenericBJ( 0.50, BLEND_MODE_BLEND, "ReplaceableTextures\\CameraMasks\\DreamFilter_Mask.blp", 100, 100.00, 0.00, 0.00, 100.00, 100, 0, 100.00 )
                endif
                return
            endif
        set j = j + 1
        endloop
    endfunction
    
    private function Main takes nothing returns nothing
        local integer i = GetPlayerId(GetOwningPlayer(GetTriggerUnit())) + 1
        local integer j = PLAYER_MAXINUM+1
        local integer types = GetUnitTypeId(GetTriggerUnit())
        
        if Stage_Loading == false and GravityChanger_Loading == false and (MushroomType(types) or types == 'opeo' or types == 'ogru' or types == 'otau' or types == 'ocat' or types == 'ohun' or types == 'o000') then
            if i > PLAYER_MAXINUM then 
                loop
                exitwhen OrangeMushroom[j] == GetTriggerUnit() or Stage_BoxsCount < j-PLAYER_MAXINUM
                set j = j + 1
                endloop
                set i = j
            endif
            
            call RectIn(i)
        endif
    endfunction
    
    private function SetInputRect takes trigger t, rect r, real a returns nothing
        set Count = Count + 1
        set Rects[Count] = CreateRegion()
        call RegionAddRect( Rects[Count], r )
        call RegionAddRect( AllRects, r )
        set ArrowAngle[Count] = a
        call TriggerRegisterEnterRegion(t, Rects[Count], null)
    endfunction
        
    
    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        
        set AllRects = CreateRegion()
        call SetInputRect(t, gg_rct_Arrow001, 0)
        call SetInputRect(t, gg_rct_Arrow002, 70)
        call SetInputRect(t, gg_rct_Arrow003, 180)
        call SetInputRect(t, gg_rct_Arrow004, 180)
        call SetInputRect(t, gg_rct_Arrow005, 180)
        call SetInputRect(t, gg_rct_Arrow006, 30)
        call SetInputRect(t, gg_rct_Arrow007, 30)
        call SetInputRect(t, gg_rct_Arrow008, 0)
        call SetInputRect(t, gg_rct_Arrow009, 115)
        call SetInputRect(t, gg_rct_Arrow010, 0)
        call SetInputRect(t, gg_rct_Arrow011, 35)
        call SetInputRect(t, gg_rct_Arrow012, 145)
        call SetInputRect(t, gg_rct_Arrow013, 180)
        call SetInputRect(t, gg_rct_Arrow014, 0)
        call SetInputRect(t, gg_rct_Arrow015, 0)
        call SetInputRect(t, gg_rct_Arrow016, 135)
        call SetInputRect(t, gg_rct_Arrow017, 0)
        call SetInputRect(t, gg_rct_Arrow018, 0)
        call SetInputRect(t, gg_rct_Arrow019, 0)
        call SetInputRect(t, gg_rct_Arrow020, 0)
        call SetInputRect(t, gg_rct_Arrow021, 180)
        call SetInputRect(t, gg_rct_Arrow022, 180)
        call SetInputRect(t, gg_rct_Arrow023, 135)
        call SetInputRect(t, gg_rct_Arrow024, 45)
        call SetInputRect(t, gg_rct_Arrow025, 180)
        call SetInputRect(t, gg_rct_Arrow026, 0)
        call SetInputRect(t, gg_rct_Arrow027, 180)
        call SetInputRect(t, gg_rct_Arrow028, 0)
        call SetInputRect(t, gg_rct_Arrow029, 150)
        call SetInputRect(t, gg_rct_Arrow030, 30)
        call SetInputRect(t, gg_rct_Arrow031, 150)
        call SetInputRect(t, gg_rct_Arrow032, 180)
        call SetInputRect(t, gg_rct_Arrow033, 180)
        call SetInputRect(t, gg_rct_Arrow034, 135)
        call SetInputRect(t, gg_rct_Arrow035, 45)
        call SetInputRect(t, gg_rct_Arrow036, 0)
        call SetInputRect(t, gg_rct_Arrow037, 0)
        call SetInputRect(t, gg_rct_Arrow038, 0)
        call SetInputRect(t, gg_rct_Arrow039, 25)
        call SetInputRect(t, gg_rct_Arrow040, 0)
        call SetInputRect(t, gg_rct_Arrow041, 0)
        call SetInputRect(t, gg_rct_Arrow042, 180)
        call SetInputRect(t, gg_rct_Arrow043, 180)
        call SetInputRect(t, gg_rct_Arrow044, 0)
        call SetInputRect(t, gg_rct_Arrow045, 20)
        call SetInputRect(t, gg_rct_Arrow046, 180)
        call SetInputRect(t, gg_rct_Arrow047, 0)
        call SetInputRect(t, gg_rct_Arrow048, 0)
        call SetInputRect(t, gg_rct_Arrow049, 135)
        call SetInputRect(t, gg_rct_Arrow050, 0)
        call SetInputRect(t, gg_rct_Arrow051, 180)
        call SetInputRect(t, gg_rct_Arrow052, 180)
        call SetInputRect(t, gg_rct_Arrow053, 0)
        call SetInputRect(t, gg_rct_Arrow054, 145)
        call SetInputRect(t, gg_rct_Arrow055, 35)
        call SetInputRect(t, gg_rct_Arrow056, 35)
        call SetInputRect(t, gg_rct_Arrow057, 35)
        call SetInputRect(t, gg_rct_Arrow058, 0)
        call SetInputRect(t, gg_rct_Arrow059, 120)
        call SetInputRect(t, gg_rct_Arrow060, 0)
        call SetInputRect(t, gg_rct_Arrow061, 0)
        call SetInputRect(t, gg_rct_Arrow062, 0)
        call SetInputRect(t, gg_rct_Arrow063, 0)
        call SetInputRect(t, gg_rct_Arrow064, 0)
        call SetInputRect(t, gg_rct_Arrow065, 180)
        call SetInputRect(t, gg_rct_Arrow066, 180)
        call SetInputRect(t, gg_rct_Arrow067, 180)
        call SetInputRect(t, gg_rct_Arrow068, 180)
        call SetInputRect(t, gg_rct_Arrow069, 180)
        call SetInputRect(t, gg_rct_Arrow070, 180)
        call SetInputRect(t, gg_rct_Arrow071, 180)
        call SetInputRect(t, gg_rct_Arrow072, 180)
        call SetInputRect(t, gg_rct_Arrow073, 180)
        call SetInputRect(t, gg_rct_Arrow074, 180)
        call SetInputRect(t, gg_rct_Arrow075, 180)
        call SetInputRect(t, gg_rct_Arrow076, 180)
        call SetInputRect(t, gg_rct_Arrow077, 180)
        call SetInputRect(t, gg_rct_Arrow078, 0)
        call SetInputRect(t, gg_rct_Arrow079, 0)
        call SetInputRect(t, gg_rct_Arrow080, 0)
        call SetInputRect(t, gg_rct_Arrow081, 0)
        call SetInputRect(t, gg_rct_Arrow082, 0)
        call SetInputRect(t, gg_rct_Arrow083, 0)
        call SetInputRect(t, gg_rct_Arrow084, 0)
        call SetInputRect(t, gg_rct_Arrow085, 0)
        call SetInputRect(t, gg_rct_Arrow086, 0)
        call SetInputRect(t, gg_rct_Arrow087, 0)
        call SetInputRect(t, gg_rct_Arrow088, 0)
        call SetInputRect(t, gg_rct_Arrow089, 0)
        call SetInputRect(t, gg_rct_Arrow090, 0)
        call SetInputRect(t, gg_rct_Arrow091, 0)
        call SetInputRect(t, gg_rct_Arrow092, 0)
        call SetInputRect(t, gg_rct_Arrow093, 0)
        call SetInputRect(t, gg_rct_Arrow094, 0)
        call SetInputRect(t, gg_rct_Arrow095, 0)
        call SetInputRect(t, gg_rct_Arrow096, 0)
        call SetInputRect(t, gg_rct_Arrow097, 0)
        call SetInputRect(t, gg_rct_Arrow098, 0)
        call SetInputRect(t, gg_rct_Arrow099, 90)
        call SetInputRect(t, gg_rct_Arrow100, 180)
        call SetInputRect(t, gg_rct_Arrow101, 180)
        call SetInputRect(t, gg_rct_Arrow102, 0)
        call SetInputRect(t, gg_rct_Arrow103, 0)
        call SetInputRect(t, gg_rct_Arrow104, 0)
        call SetInputRect(t, gg_rct_Arrow105, 0)
        call SetInputRect(t, gg_rct_Arrow106, 0)
        call SetInputRect(t, gg_rct_Arrow107, 0)
        call SetInputRect(t, gg_rct_Arrow108, 180)
        call SetInputRect(t, gg_rct_Arrow109, 180)
        call SetInputRect(t, gg_rct_Arrow110, 180)
        call SetInputRect(t, gg_rct_Arrow111, 180)
        call SetInputRect(t, gg_rct_Arrow112, 180)
        call SetInputRect(t, gg_rct_Arrow113, 180)
        call SetInputRect(t, gg_rct_Arrow114, 180)
        call SetInputRect(t, gg_rct_Arrow115, 180)
        call SetInputRect(t, gg_rct_Arrow116, 180)
        call SetInputRect(t, gg_rct_Arrow117, 180)
        call SetInputRect(t, gg_rct_Arrow118, 180)
        call SetInputRect(t, gg_rct_Arrow119, 180)
        call SetInputRect(t, gg_rct_Arrow120, 145)
        call SetInputRect(t, gg_rct_Arrow121, 35)
        call SetInputRect(t, gg_rct_Arrow122, 0)
        call SetInputRect(t, gg_rct_Arrow123, 0)
        call SetInputRect(t, gg_rct_Arrow124, 0)
        call SetInputRect(t, gg_rct_Arrow125, 0)
        call SetInputRect(t, gg_rct_Arrow126, 0)
        call SetInputRect(t, gg_rct_Arrow127, 0)
        call SetInputRect(t, gg_rct_Arrow128, 0)
        call SetInputRect(t, gg_rct_Arrow129, 0)
        call SetInputRect(t, gg_rct_Arrow130, 0)
        call SetInputRect(t, gg_rct_Arrow131, 0)
        call SetInputRect(t, gg_rct_Arrow132, 0)
        call SetInputRect(t, gg_rct_Arrow133, 0)
        call SetInputRect(t, gg_rct_Arrow134, 0)
        call SetInputRect(t, gg_rct_Arrow135, 0)
        call SetInputRect(t, gg_rct_Arrow136, 0)
        call SetInputRect(t, gg_rct_Arrow137, 0)
        call SetInputRect(t, gg_rct_Arrow138, 0)
        call SetInputRect(t, gg_rct_Arrow139, 180)
        call SetInputRect(t, gg_rct_Arrow140, 180)
        call SetInputRect(t, gg_rct_Arrow141, 0)
        call SetInputRect(t, gg_rct_Arrow142, 180)
        call SetInputRect(t, gg_rct_Arrow143, 180)
        call SetInputRect(t, gg_rct_Arrow144, 180)
        call SetInputRect(t, gg_rct_Arrow145, 180)
        call SetInputRect(t, gg_rct_Arrow146, 180)
        call SetInputRect(t, gg_rct_Arrow147, 180)
        call SetInputRect(t, gg_rct_Arrow148, 180)
        call SetInputRect(t, gg_rct_Arrow149, 180)
        call SetInputRect(t, gg_rct_Arrow150, 180)
        call SetInputRect(t, gg_rct_Arrow151, 180)
        call SetInputRect(t, gg_rct_Arrow152, 180)
        call SetInputRect(t, gg_rct_Arrow153, 180)
        call SetInputRect(t, gg_rct_Arrow154, 180)
        call SetInputRect(t, gg_rct_Arrow155, 180)
        call SetInputRect(t, gg_rct_Arrow156, 90)
        call SetInputRect(t, gg_rct_Arrow157, 90)
        call SetInputRect(t, gg_rct_Arrow158, 90)
        call SetInputRect(t, gg_rct_Arrow159, 90)
        call SetInputRect(t, gg_rct_Arrow160, 90)
        call SetInputRect(t, gg_rct_Arrow161, 0)
        call SetInputRect(t, gg_rct_Arrow162, 0)
        call SetInputRect(t, gg_rct_Arrow163, 30)
        call SetInputRect(t, gg_rct_Arrow164, 60)
        call SetInputRect(t, gg_rct_Arrow165, 135)
        call SetInputRect(t, gg_rct_Arrow166, 45)
        call SetInputRect(t, gg_rct_Arrow167, 30)
        call SetInputRect(t, gg_rct_Arrow168, 230)
        call SetInputRect(t, gg_rct_Arrow169, 270)
        call SetInputRect(t, gg_rct_Arrow170, 180)
        call SetInputRect(t, gg_rct_Arrow171, 0)
        call SetInputRect(t, gg_rct_Arrow172, 180)
        call SetInputRect(t, gg_rct_Arrow173, 340)
        call SetInputRect(t, gg_rct_Arrow174, 180)
        call SetInputRect(t, gg_rct_Arrow175, 180)
        call SetInputRect(t, gg_rct_Arrow176, 110)
        call SetInputRect(t, gg_rct_Arrow177, 30)
        call SetInputRect(t, gg_rct_Arrow178, 30)
        call SetInputRect(t, gg_rct_Arrow179, 30)
        call SetInputRect(t, gg_rct_Arrow180, 270)
        call SetInputRect(t, gg_rct_Arrow181, 270)
        call SetInputRect(t, gg_rct_Arrow182, 270)
        call SetInputRect(t, gg_rct_Arrow183, 0)
        call SetInputRect(t, gg_rct_Arrow184, 270)
        call SetInputRect(t, gg_rct_Arrow185, 0)
        call SetInputRect(t, gg_rct_Arrow186, 0)
        call SetInputRect(t, gg_rct_Arrow187, 0)
        call SetInputRect(t, gg_rct_Arrow188, 230)
        call SetInputRect(t, gg_rct_Arrow189, 270)
        call SetInputRect(t, gg_rct_Arrow190, 0)
        call SetInputRect(t, gg_rct_Arrow191, 0)
        call SetInputRect(t, gg_rct_Arrow192, 0)
        call SetInputRect(t, gg_rct_Arrow193, 0)
        call SetInputRect(t, gg_rct_Arrow194, 180)
        call SetInputRect(t, gg_rct_Arrow195, 180)
        call SetInputRect(t, gg_rct_Arrow196, 0)
        call SetInputRect(t, gg_rct_Arrow197, 270)
        call SetInputRect(t, gg_rct_Arrow198, 0)
        call SetInputRect(t, gg_rct_Arrow199, 10)
        call SetInputRect(t, gg_rct_Arrow200, 20)
        call SetInputRect(t, gg_rct_Arrow201, 270)
        call SetInputRect(t, gg_rct_Arrow202, 230)
        call SetInputRect(t, gg_rct_Arrow203, 180)
        call SetInputRect(t, gg_rct_Arrow204, 0)
        call SetInputRect(t, gg_rct_Arrow205, 325)
        call SetInputRect(t, gg_rct_Arrow206, 214)
        call SetInputRect(t, gg_rct_Arrow207, 214)
        call SetInputRect(t, gg_rct_Arrow208, 214)
        call SetInputRect(t, gg_rct_Arrow209, 0)
        call SetInputRect(t, gg_rct_Arrow210, 180)
        call SetInputRect(t, gg_rct_Arrow211, 180)
        call SetInputRect(t, gg_rct_Arrow212, 145)
        call SetInputRect(t, gg_rct_Arrow213, 75)
        call SetInputRect(t, gg_rct_Arrow214, 90)
        call SetInputRect(t, gg_rct_Arrow215, 180)
        call SetInputRect(t, gg_rct_Arrow216, 180)
        call SetInputRect(t, gg_rct_Arrow217, 45)
        call SetInputRect(t, gg_rct_Arrow218, 45)
        call SetInputRect(t, gg_rct_Arrow219, 45)
        call SetInputRect(t, gg_rct_Arrow220, 0)
        call SetInputRect(t, gg_rct_Arrow221, 134)
        call SetInputRect(t, gg_rct_Arrow222, 145)
        call SetInputRect(t, gg_rct_Arrow223, 215)
        call SetInputRect(t, gg_rct_Arrow224, 215)
        call SetInputRect(t, gg_rct_Arrow225, 0)
        call SetInputRect(t, gg_rct_Arrow226, 90)
        call SetInputRect(t, gg_rct_Arrow227, 150)
        call SetInputRect(t, gg_rct_Arrow228, 30)
        call SetInputRect(t, gg_rct_Arrow229, 150)
        call SetInputRect(t, gg_rct_Arrow230, 0)
        call SetInputRect(t, gg_rct_Arrow231, 0)
        call SetInputRect(t, gg_rct_Arrow232, 0)
        call SetInputRect(t, gg_rct_Arrow233, 0)
        call SetInputRect(t, gg_rct_Arrow234, 90)
        call SetInputRect(t, gg_rct_Arrow235, 0)
        call SetInputRect(t, gg_rct_Arrow236, 330)
        call SetInputRect(t, gg_rct_Arrow237, 90)
        call SetInputRect(t, gg_rct_Arrow238, 77)
        call SetInputRect(t, gg_rct_Arrow239, 0)
        call SetInputRect(t, gg_rct_Arrow240, 0)
        call SetInputRect(t, gg_rct_Arrow241, 0)
        call SetInputRect(t, gg_rct_Arrow242, 180)
        call SetInputRect(t, gg_rct_Arrow243, 180)
        call SetInputRect(t, gg_rct_Arrow244, 180)
        call SetInputRect(t, gg_rct_Arrow245, 105)


        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endlibrary