library WorldKey initializer init
    globals
        private string array SaveName
        public string array Code
        public string array Code2
        public string array Code3
        public string array Code4
        public string array Code5
        public string array Code6
        public string array Code7
        public string array Code8
        public string array Code9
        public string array Code10
        public string array Code11
        public string array Code12
    endglobals

    private function Main takes nothing returns nothing
        local integer i = 1
        local integer saveIntName
        local integer array CharCode
	    local string s = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	    local string Message = "혹시 비밀 코드 얻을려고 코드 트리거를 찾다가 이 글을 보고 계신다면... 다른 의미로 노력이 가상하니 가져가세요♥"
        
        loop
        exitwhen i > PLAYER_MAXINUM
            if GetPlayerSlotState(Player(i-1)) == PLAYER_SLOT_STATE_PLAYING then
                set SaveName[i] = StringCase(GetPlayerName(Player(i-1)), false)
                set saveIntName = StringHash(SaveName[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code[i] = Code[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code[i] = Code[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code2[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code2[i] = Code2[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code2[i] = Code2[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code2[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code3[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code3[i] = Code3[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code3[i] = Code3[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code3[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code4[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code4[i] = Code4[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code4[i] = Code4[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(I2S(StringHash(SaveName[i])))
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code5[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code5[i] = Code5[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code5[i] = Code5[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code5[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code6[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code6[i] = Code6[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code6[i] = Code6[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code6[i])
                set saveIntName = StringHash(I2S(saveIntName))
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code7[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code7[i] = Code7[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code7[i] = Code7[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code5[i])
                set saveIntName = StringHash(I2S(saveIntName))
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code8[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code8[i] = Code8[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code8[i] = Code8[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code8[i])
                set saveIntName = StringHash(I2S(saveIntName))
                set saveIntName = StringHash(I2S(saveIntName))
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code9[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code9[i] = Code9[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code9[i] = Code9[i] + SubString(s,CharCode[3],CharCode[3]+1)
                
                set saveIntName = StringHash(Code7[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code10[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code10[i] = Code10[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code10[i] = Code10[i] + SubString(s,CharCode[3],CharCode[3]+1)

                set saveIntName = StringHash(Code10[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code11[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code11[i] = Code11[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code11[i] = Code11[i] + SubString(s,CharCode[3],CharCode[3]+1)

                set saveIntName = StringHash(Code11[i])
                if saveIntName < 0 then
                    set saveIntName = saveIntName * -1
                endif
                if saveIntName < 100000 then
                    set saveIntName = saveIntName + 100000
                endif
                set CharCode[1] = ModuloInteger(S2I(SubString(I2S(saveIntName),0,2)), 26)
                set CharCode[2] = ModuloInteger(S2I(SubString(I2S(saveIntName),2,4)), 26)
                set CharCode[3] = ModuloInteger(S2I(SubString(I2S(saveIntName),4,6)), 26)
                set Code12[i] = SubString(s,CharCode[1],CharCode[1]+1)
                set Code12[i] = Code12[i] + SubString(s,CharCode[2],CharCode[2]+1)
                set Code12[i] = Code12[i] + SubString(s,CharCode[3],CharCode[3]+1)
            endif
        set i = i + 1
        endloop
    endfunction

    private function init takes nothing returns nothing
        local trigger t = CreateTrigger(  )
        
        call TriggerRegisterTimerEvent(t, 0.00, false)
        call TriggerAddAction( t, function Main )
        
        set t = null
    endfunction
endlibrary