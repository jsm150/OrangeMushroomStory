library MethodEvent
    private function interface methodPtr takes integer this returns nothing

    struct EventMethod
        private static hashtable H = InitHashtable()
        private static constant integer methodKey = 0
        private static constant integer objectKey = 1

        private static method Execute takes nothing returns nothing
            local trigger t = GetTriggeringTrigger()
            local integer obj = LoadInteger(H, objectKey, GetHandleId(t))
            call methodPtr(LoadInteger(H, methodKey, GetHandleId(t))).evaluate(obj)
        endmethod

        public static method AddAction takes trigger t, integer object, methodPtr action returns nothing
            call SaveInteger(H, methodKey, GetHandleId(t), action)
            call SaveInteger(H, objectKey, GetHandleId(t), object)
            call TriggerAddCondition(t, Filter(function thistype.Execute))
        endmethod
    endstruct
endlibrary
