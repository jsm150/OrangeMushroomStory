library Security
    struct Verification
        private string Key = ""
        private string password

        public stub method operator Data takes nothing returns integer
            return 0
        endmethod

        public stub method operator Data= takes integer val returns nothing
        endmethod

        private method Decrypt takes nothing returns string
            return JNStringDecrypt(this.password, this.Key)
        endmethod

        private method Encrypt takes nothing returns string
            return JNStringEncrypt(I2S(this.Data), this.Key)
        endmethod

        public method Check takes nothing returns boolean
            return this.Decrypt() == I2S(this.Data)
        endmethod

        public method Restore takes nothing returns nothing
            if this.Check() == false then
                set this.Data = S2I(this.Decrypt())
            endif
        endmethod

        public method Set takes integer val returns nothing
            set this.Data = val
            set this.password = this.Encrypt()

            debug call JNWriteLog("  Verification money: " + I2S(this.Data))
            debug call JNWriteLog("  Verification decrypt: " + JNStringDecrypt(this.password, this.Key))
        endmethod

        private method CreateKey takes nothing returns nothing
	        local string s = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            local integer i = 0

            set this.Key = ""
            //! runtextmacro for("set i = 0", "i < 10")
                set this.Key = this.Key + JNStringSub(s, GetRandomInt(0, 35), 1)
            //! runtextmacro for_end("set i = i + 1")
            set this.Key = this.Key + "a0ddb80752b13b1e2c80Bs"

            debug call JNWriteLog("  Security key: " + Key)
        endmethod
        
        public static method create takes integer val returns thistype
            local thistype this = thistype.allocate()
            call this.CreateKey()
            set this.password = JNStringEncrypt(I2S(val), this.Key)

            return this
        endmethod
    endstruct
endlibrary
