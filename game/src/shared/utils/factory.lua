local function encapsulated(initial_state, method_factory)
    local private = initial_state or {}
    local public = (method_factory and method_factory(private)) or {}
    local mt = {
        __index = function(_, key)
            return public[key] ~= nil and public[key] or private[key]
        end,

        __newindex = function(_, key, _)
            error(('Attempt to modify read-only property "%s". Use a method to update state.'):format(tostring(key)), 2)
        end,

        __metatable = "sealed"
    }

    return setmetatable({}, mt)
end

return {
    encapsulated = encapsulated
}
