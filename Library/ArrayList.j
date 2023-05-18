
library ArrayList
    struct aList
        private static hashtable H = InitHashtable(  )
        private integer S

        static method create takes nothing returns thistype
            local thistype this = thistype.allocate(  )
            set .S = 0
            return this
        endmethod

        method add takes integer dst returns nothing
            call SaveInteger( H, 0, this*8192 + .S, dst )
            set .S = .S + 1
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