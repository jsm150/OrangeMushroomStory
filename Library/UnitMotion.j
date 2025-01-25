library UnitMotion

    public interface IMotionAble
        public method LeftJumpMotion takes integer i returns nothing
        public method RightJumpMotion takes integer i returns nothing
        public method LeftStandMotion takes integer i returns nothing
        public method RightStandMotion takes integer i returns nothing
        public method LeftWalkMotion takes integer i returns nothing
        public method RightWalkMotion takes integer i returns nothing
        public method LeftDownMotion takes integer i returns nothing
        public method RightDownMotion takes integer i returns nothing
    endinterface

    globals
        private sList motionList = 0
    endglobals

    function SetUnitMoveAnimation takes unit u, string aniName returns nothing
        local integer tp = GetUnitTypeId(u)
        if aniName == "Walk First" then
            if tp == 'uobs' then
                call SetUnitAnimationByIndex( u, 0 )
            elseif tp == 'ufro' or tp == 'earc' then
                call SetUnitAnimationByIndex( u, 6 )
            elseif tp == 'esen' or tp == 'edry' then
                call SetUnitAnimationByIndex( u, 4 )
            elseif tp == 'ohun' or tp == 'edot' then
                call SetUnitAnimationByIndex( u, 6 )
            elseif tp == 'orai' then
                call SetUnitAnimation( u, "Stand First" )
            else
                call SetUnitAnimationByIndex( u, 1 )
            endif
        elseif aniName == "Walk Second" then
            if tp == 'ogru' or tp == 'uabo' or tp == 'otau' or tp == 'o005' or tp == 'umtw' or tp == 'h00N' or tp == 'h00J' or tp == 'h00O' or tp == 'h00M' or tp == 'h00L' or tp == 'h00K' then
                call SetUnitAnimationByIndex( u, 4 )
            elseif tp == 'uobs' then
                call SetUnitAnimationByIndex( u, 1 )
            elseif tp == 'ufro' or tp == 'earc' then
                call SetUnitAnimationByIndex( u, 7 )
            elseif tp == 'ohun' or tp == 'edot' then
                call SetUnitAnimationByIndex( u, 7 )
            elseif tp == 'orai' then
                call SetUnitAnimation( u, "Stand Second" )
            elseif tp == 'h00S' or tp == 'h00T' then
                call SetUnitAnimationByIndex( u, 4 )
            else
                call SetUnitAnimationByIndex( u, 5 )
            endif
        endif
    endfunction

    function KeyAnimation takes unit u, string s1, string s2 returns nothing
        local string temp
        
        if s2 == "First" then
            set temp = "Second"
        else
            set temp = "First"
        endif
        
        if GravityChanger_Loading == false then
            if s1 == "Walk" then
                if GravityChanger_State == false then
                    call SetUnitMoveAnimation(u, s1 + " " + s2)
                else
                    call SetUnitMoveAnimation(u, s1 + " " + temp)
                endif
            elseif GetUnitTypeId(u) == 'orai' then
                if GravityChanger_State == false then
                    call SetUnitAnimation( u, "Stand " + s2 )
                else
                    call SetUnitAnimation( u, "Stand " + temp )
                endif
            else
                if GravityChanger_State == false then
                    call SetUnitAnimation( u, s1 + " " + s2 )
                else
                    call SetUnitAnimation( u, s1 + " " + temp )
                endif
            endif
        endif
        
        set u = null
    endfunction

    public function AddMotion takes IMotionAble motion returns nothing
        call JNWriteLog("       motionList :" + I2S(motionList))
        if motionList == 0 then
            set motionList = sList.create()
        endif
        call motionList.add(motion)
    endfunction

    private struct Motion extends IMotionAble
        public method LeftStandMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Stand", "First" )
        endmethod

        public method RightStandMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Stand", "Second" )
        endmethod

        public method LeftWalkMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Walk", "First" )
        endmethod

        public method RightWalkMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Walk", "Second" )
        endmethod

        public method LeftDownMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Stand Ready", "First" )
        endmethod

        public method RightDownMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Stand Ready", "Second" )
        endmethod

        public method LeftJumpMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Spell", "First" )
        endmethod

        public method RightJumpMotion takes integer i returns nothing
            call KeyAnimation( OrangeMushroom[i], "Spell", "Second" )
        endmethod

        private static method onInit takes nothing returns nothing
            local thistype this = thistype.allocate()
            call AddMotion(this)
        endmethod
    endstruct



    public function LeftStand takes integer i returns nothing
        local integer j = 0
        
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).LeftStandMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function RightStand takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).RightStandMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function LeftWalk takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).LeftWalkMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function RightWalk takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).RightWalkMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function LeftJump takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).LeftJumpMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function RightJump takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).RightJumpMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function LeftDown takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).LeftDownMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction

    public function RightDown takes integer i returns nothing
        local integer j = 0
        //! runtextmacro for("set j = 0", "j < motionList.size")
            call IMotionAble(motionList[j]).RightDownMotion(i)
        //! runtextmacro for_end("set j = j + 1")
    endfunction
endlibrary