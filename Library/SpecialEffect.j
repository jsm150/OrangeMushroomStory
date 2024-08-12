
// v0.1
library SpecialEffect requires MemoryLib

    //! runtextmacro MemoryLib_DefineMemoryBlock("private", "MemoryBlock", "SpecialEffect__MemoryBlock", "0x4")

    private function GetObjectSprite takes integer pObject returns integer
        // Units and Effects return CSpriteUber | items and destructables returns CSpriteMini
        if pObject != 0 then
            return IntPtr[pObject + 0x28]
        endif

        return 0
    endfunction

    private function jEffectToCEffect takes effect whichEffect returns integer
        local integer addr = pGameDll + 0x021F4A0
        local integer h    = GetHandleId(whichEffect)

        if h == 0 then
            return 0
        endif
        
        call SaveStr(JNProc_ht, JNProc_key, 0, "(I)I")
        call SaveInteger(JNProc_ht, JNProc_key, 1, h)
        if (JNProcCall(JNProc__thiscall, addr, JNProc_ht)) then
            return LoadInteger(JNProc_ht, JNProc_key, 0)
        endif

        return 0
    endfunction

    function SetSpecialEffectColorEx takes effect whichEffect, integer red, integer green, integer blue, integer alpha returns nothing
        local integer addr
        local integer pSprite = GetObjectSprite(jEffectToCEffect(whichEffect))

        if pSprite > 0 then

            set addr = PtrPtr[PtrPtr[pSprite] + 0x30]
            set PtrPtr[MemoryBlock.pHead] = DzGetColor(alpha, red, green, blue)
            call SaveStr(JNProc_ht, JNProc_key, 0, "(II)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call SaveInteger(JNProc_ht, JNProc_key, 2, MemoryBlock.pHead)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)

            if alpha >= 0x00 and alpha <= 0xFF then
                set addr = PtrPtr[PtrPtr[pSprite] + 0x34]
                call SaveStr(JNProc_ht, JNProc_key, 0, "(II)V")
                call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
                call SaveInteger(JNProc_ht, JNProc_key, 2, alpha)
                call JNProcCall(JNProc__thiscall, addr, JNProc_ht)
            endif

            set addr = PtrPtr[PtrPtr[pSprite] + 0x14]
            call SaveStr(JNProc_ht, JNProc_key, 0, "(I)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)

        endif
    endfunction

    function SetSpecialEffectColor takes effect whichEffect, integer red, integer green, integer blue returns nothing
        local integer addr
        local integer pSprite = GetObjectSprite(jEffectToCEffect(whichEffect))

        if pSprite > 0 then

            set addr = PtrPtr[PtrPtr[pSprite] + 0x30]
            set PtrPtr[MemoryBlock.pHead] = DzGetColor(0, red, green, blue)
            call SaveStr(JNProc_ht, JNProc_key, 0, "(II)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call SaveInteger(JNProc_ht, JNProc_key, 2, MemoryBlock.pHead)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)

            set addr = PtrPtr[PtrPtr[pSprite] + 0x14]
            call SaveStr(JNProc_ht, JNProc_key, 0, "(I)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)

        endif
    endfunction

    function SetSpecialEffectAlpha takes effect whichEffect, integer alpha returns nothing
        local integer addr
        local integer pSprite = GetObjectSprite(jEffectToCEffect(whichEffect))
        
        if pSprite != 0 and alpha >= 0x00 and alpha <= 0xFF then

            set addr = PtrPtr[PtrPtr[pSprite] + 0x34]
            call SaveStr(JNProc_ht, JNProc_key, 0, "(II)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call SaveInteger(JNProc_ht, JNProc_key, 2, alpha)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)

            set addr = PtrPtr[PtrPtr[pSprite] + 0x14]
            call SaveStr(JNProc_ht, JNProc_key, 0, "(I)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)
            
        endif
    endfunction

    function SetSpecialEffectColorByPlayer takes effect whichEffect, player whichPlayer returns nothing
        local integer addr    = pGameDll + 0x38AB80
        local integer pSprite = GetObjectSprite(jEffectToCEffect(whichEffect))

        if pSprite != 0 then
            call SaveStr(JNProc_ht, JNProc_key, 0, "(II)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call SaveInteger(JNProc_ht, JNProc_key, 2, GetPlayerId(whichPlayer))
            call JNProcCall(JNProc__fastcall, addr, JNProc_ht)
        endif
    endfunction

    // animtype? _ BlzPlaySpecialEffect?
    function PlaySpecialEffect takes effect whichEffect, integer whichAnim returns nothing
        local integer addr
        local integer pEffect = jEffectToCEffect(whichEffect)

        if pEffect != 0 then
            set addr = PtrPtr[PtrPtr[pEffect] + 0x8C]
            call SaveStr(JNProc_ht, JNProc_key, 0, "(IIII)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pEffect)
            call SaveInteger(JNProc_ht, JNProc_key, 2, whichAnim)
            call SaveInteger(JNProc_ht, JNProc_key, 3, 0)
            call SaveInteger(JNProc_ht, JNProc_key, 4, 1)
            call JNProcCall(JNProc__thiscall, addr, JNProc_ht)
        endif
    endfunction

    // 重_版_有
    function SetSpecialEffectAnimationByIndex takes effect whichEffect, integer whichAnimation returns nothing
        local integer addr    = pGameDll + 0x1D6DD0
        local integer pSprite = GetObjectSprite(jEffectToCEffect(whichEffect))

        if pSprite != 0 then
            call SaveStr(JNProc_ht, JNProc_key, 0, "(III)V")
            call SaveInteger(JNProc_ht, JNProc_key, 1, pSprite)
            call SaveInteger(JNProc_ht, JNProc_key, 2, whichAnimation)
            call SaveInteger(JNProc_ht, JNProc_key, 3, 0) // raritycontrol?
            call JNProcCall(JNProc__fastcall, addr, JNProc_ht)
        endif
    endfunction

endlibrary
