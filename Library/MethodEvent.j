library MethodEvent needs StructList
    private function interface methodPtr takes integer this returns nothing

    private struct InstanceMethod
        public integer obj
        public methodPtr action

        public static method create takes integer obj, methodPtr action returns thistype
            local thistype this = thistype.allocate()
            set this.obj = obj
            set this.action = action
            return this
        endmethod
    endstruct

    struct EventMethod
        private static hashtable table = InitHashtable()
        private static key executeKey
        private static key evaluateKey

        private static method Action takes sList list returns nothing
            local integer i = 0
            local InstanceMethod action
            loop
                exitwhen i >= list.size
                call methodPtr(InstanceMethod(list[i]).action).evaluate(InstanceMethod(list[i]).obj)
                set i = i + 1
            endloop
        endmethod

        private static method Execute takes nothing returns nothing
            call thistype.Action(LoadInteger(table, executeKey, GetHandleId(GetTriggeringTrigger())))
        endmethod

        private static method Evaluate takes nothing returns boolean
            call thistype.Action(LoadInteger(table, evaluateKey, GetHandleId(GetTriggeringTrigger())))
            return true
        endmethod

        public static method AddByExecute takes trigger t, integer object, methodPtr action returns nothing
            local sList list = LoadInteger(table, executeKey, GetHandleId(t))

            if list == 0 then
                set list = sList.create()
                call SaveInteger(table, executeKey, GetHandleId(t), list)
                call TriggerAddAction(t, function thistype.Execute)
            endif

            call list.add(InstanceMethod.create(object, action))
        endmethod

        public static method AddByEvaluate takes trigger t, integer object, methodPtr action returns nothing
            local sList list = LoadInteger(table, evaluateKey, GetHandleId(t))

            if list == 0 then
                set list = sList.create()
                call SaveInteger(table, evaluateKey, GetHandleId(t), list)
                call TriggerAddCondition(t, Condition(function thistype.Evaluate))
            endif

            call list.add(InstanceMethod.create(object, action))
        endmethod

        public static method Destroy takes trigger t returns nothing
            local integer i = 0
            local sList evaluateList = LoadInteger(table, evaluateKey, GetHandleId(t))
            local sList executeList = LoadInteger(table, executeKey, GetHandleId(t))

            if evaluateList != 0 then
                set i = 0
                loop
                    exitwhen i >= evaluateList.size
                    call InstanceMethod(evaluateList[i]).destroy()
                    set i = i + 1
                endloop
                call evaluateList.destroy()
            endif
            
            if executeList != 0 then
                set i = 0
                loop
                    exitwhen i >= executeList.size
                    call InstanceMethod(executeList[i]).destroy()
                    set i = i + 1
                endloop
                call executeList.destroy()
            endif

            call DestroyTrigger(t)
        endmethod
    endstruct

    struct Events
        private static constant integer DUMMY_DESTRUCTABLE_TYPE_ID = 'OTis'
        private static hashtable H = InitHashtable()
        private static hashtable HS = InitHashtable()
        private static trigger T = null

        public static method GetEventArgs takes integer eventKey returns integer
            return LoadInteger(H, eventKey, 0)
        endmethod

        public static method Raise takes integer eventKey, integer eventObject returns nothing
            local destructable d = LoadDestructableHandle( H,0,eventKey )

            if d != null then
                call SaveInteger(H, eventKey, 0, eventObject)
                call DestructableRestoreLife(d, GetDestructableMaxLife(d), true)
                call KillDestructable( d )
            endif

            set d = null
        endmethod

        public static method Add takes integer eventKey, integer object, methodPtr action returns trigger
            local destructable d = LoadDestructableHandle( H,0,eventKey )
            set T = LoadTriggerHandle(HS, 0, eventKey)

            if d == null then
                set d = CreateDestructable(DUMMY_DESTRUCTABLE_TYPE_ID,0,0,0,0,0)
                call KillDestructable( d )
                call SaveDestructableHandle( H,0,eventKey,d )
                
                set T = CreateTrigger()
                call SaveTriggerHandle(HS, 0, eventKey, T)
                call TriggerRegisterDeathEvent( T, d )
            endif

            call EventMethod.AddByEvaluate(T, object, action)
            set d = null

            return T
        endmethod
    endstruct
endlibrary
