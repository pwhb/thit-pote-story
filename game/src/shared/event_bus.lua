local EventBus = {}

local listeners = {}

function EventBus.on(eventName, func, context)
    if not listeners[eventName] then
        listeners[eventName] = {}
    end

    table.insert(listeners[eventName], {
        func = func,
        context = context
    })
end

function EventBus.off(eventName)

end

function EventBus.emit(eventName, ...)
    local event_listeners = listeners[eventName]
    if not event_listeners then
        return
    end

    for i, listener in ipairs(event_listeners) do
        if listener.context then
            listener.func(listener.context, ...)
        else
            listener.func(...)
        end
    end
end

return EventBus
