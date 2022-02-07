
library StructEvent
    globals
        //모델 없고, 경로 없고, 맵에 아무 영향도 안 미치는 파괴 가능 장식물 원시코드
        private constant integer DUMMY_DESTRUCTABLE_TYPE_ID = 'OTis'
        private hashtable H = InitHashtable()
        private hashtable HS = InitHashtable()
        private trigger T = null
    endglobals

    struct eventStruct extends array
        
        static method operator e takes nothing returns integer
            return LoadInteger( HS,0,GetHandleId(GetTriggeringTrigger()) )
        endmethod

        static method register takes integer id, integer ev, code c returns trigger
            local destructable d = LoadDestructableHandle( H,0,ev )
            set T = CreateTrigger()

            if d == null then
                set d = CreateDestructable(DUMMY_DESTRUCTABLE_TYPE_ID,0,0,0,0,0)
                call KillDestructable( d )
                call SaveDestructableHandle( H,0,ev,d )
            endif

            call TriggerRegisterDeathEvent( T, d )
            call SaveInteger( HS,0,GetHandleId(T),id )
            call TriggerAddCondition( T, Filter(c) )
            set d = null

            return T
        endmethod

        static method evaluate takes integer ev returns nothing
            local destructable d = LoadDestructableHandle( H,0,ev )

            if d != null then
                call DestructableRestoreLife(d, GetDestructableMaxLife(d), true)
                call KillDestructable( d )
            endif

            set d = null
        endmethod

    endstruct
endlibrary

// [출처] StructEvent 1.01 (워크래프트3 리포지드 유즈맵 포럼 [W3UMF]) | 작성자 동동주