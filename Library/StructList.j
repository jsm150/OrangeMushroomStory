
library StructList
    struct sList
        private static hashtable F = InitHashtable(  )
        private static hashtable H = InitHashtable(  )
        private integer S

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate(  )
            set .S = 0
            return this
        endmethod

        method add takes integer dst returns nothing
            local integer pos = LoadInteger( F, 0, this*8192 + dst )
            if pos > 0 and pos <= .S then
                return
            endif
            call SaveInteger( H, 0, this*8192 + .S, dst )
            call SaveInteger( F, 0, this*8192 + dst, .S+1 )
            set .S = .S + 1
        endmethod

        method remove takes integer dst returns nothing
            local integer pos = LoadInteger( F, 0, this*8192 + dst )
            if pos == 0 or pos > .S then
                return
            endif
            set .S = .S - 1
            call SaveInteger( H, 0, this*8192+pos-1, LoadInteger( H, 0, this*8192+.S ) )
            call SaveInteger( F, 0, this*8192 + LoadInteger( H, 0, this*8192+.S ), pos )
            call SaveInteger( F, 0, this*8192 + dst, 0 )
        endmethod

        method operator [] takes integer i returns integer
            if i >= .S then
                return 0
            endif
            return LoadInteger( H, 0, this*8192+i )
        endmethod

        method operator size takes nothing returns integer
            return .S
        endmethod

        method clear takes nothing returns nothing
            set .S = 0
        endmethod

        method destroy takes nothing returns nothing
            call clear()
            call thistype.deallocate( this )
        endmethod
    endstruct
endlibrary
// [출처] StructList 1.00 (워크래프트3 리포지드 유즈맵 포럼 [W3UMF]) | 작성자 동동주