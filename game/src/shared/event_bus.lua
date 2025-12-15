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

function EventBus.off(eventName, func, context)
    local event_listeners = listeners[eventName]
    if not event_listeners then
        return
    end

    for i = #event_listeners, 1, -1 do
        local listener = event_listeners[i]
        if listener.func == func and listener.context == context then
            table.remove(event_listeners, i)
        end
    end

    if #event_listeners == 0 then
        listeners[eventName] = nil
    end
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
