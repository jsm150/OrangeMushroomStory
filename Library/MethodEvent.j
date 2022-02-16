library MethodEvent
    struct EventMethod
        private static hashtable H = InitHashtable()
        private static constant integer methodKey = 0
        private static constant integer objectKey = 1

        private static method Execute takes nothing returns nothing
            local trigger t = GetTriggeringTrigger()
            local integer obj = LoadInteger(H, objectKey, GetHandleId(t))
            local string func = LoadStr(H, methodKey, GetHandleId(t))
            set f__arg_this = obj
            call ExecuteFunc(func)
        endmethod

        public static method AddAction takes trigger t, integer object, string moduleName, string structName, string mathodName returns nothing
            local string func = "sa__"

            if StringLength(moduleName) == 0 then
                set func = func + structName + "_" + mathodName
            else
                set func = func + moduleName + "___" + structName + "_" + mathodName
            endif

            call SaveStr(H, methodKey, GetHandleId(t), func)
            call SaveInteger(H, objectKey, GetHandleId(t), object)
            call TriggerAddCondition(t, Filter(function thistype.Execute))
        endmethod
    endstruct
endlibrary

//! textmacro EventMethodRegister takes methodName
    private method aaaa$methodName$ takes nothing returns nothing
        if false then
            call this.$methodName$()
        endif
    endmethod
//! endtextmacro