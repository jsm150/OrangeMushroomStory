
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

        method debugging takes nothing returns nothing
            local integer i = 0

            if DEBUG_MODE then
                call JNWriteLog("-- array element --")
                //! runtextmacro for("set i = 0", "i < this.S")
                    call JNWriteLog("[" + I2S(i) + "]: " + I2S(this[i]))
                //! runtextmacro for_end("set i = i + 1")

                call JNWriteLog("-- index element --")
                //! runtextmacro for("set i = 0", "i < this.S")
                    call JNWriteLog(I2S(this[i]) + ": " + I2S(LoadInteger( F, 0, this*8192 + this[i] ) - 1))
                //! runtextmacro for_end("set i = i + 1")

                call JNWriteLog("")
            endif
        endmethod

        method sort takes boolean ascending returns nothing
            local integer i = 0
            local integer j = 0
            local integer idx = 0
            local integer temp = 0

            //! runtextmacro for("set i = 0", "i < this.S - 1")
                set idx = i
                //! runtextmacro for("set j = i + 1", "j < this.S")
                    if (ascending and this[idx] > this[j]) or (not(ascending) and this[idx] < this[j]) then
                        set idx = j
                    endif
                //! runtextmacro for_end("set j = j + 1")
                
                set temp = this[idx]
                call SaveInteger( H, 0, this*8192 + idx, this[i] )
                call SaveInteger( H, 0, this*8192 + i, temp )
            //! runtextmacro for_end("set i = i + 1")

            //! runtextmacro for("set i = 0", "i < this.S")
                call SaveInteger( F, 0, this*8192 + this[i], i+1 )
            //! runtextmacro for_end("set i = i + 1")
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