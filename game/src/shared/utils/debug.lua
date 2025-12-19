local function dump_table(t, indent, done)
    indent = indent or 0
    done = done or {}
    if done[t] then
        return "⟨circular⟩"
    end
    done[t] = true

    local result = {}
    local spacing = string.rep("  ", indent)

    if type(t) ~= "table" then
        return tostring(t)
    end

    for k, v in pairs(t) do
        local key_str = type(k) == "string" and k or "[" .. tostring(k) .. "]"
        if type(v) == "table" then
            table.insert(result, spacing .. key_str .. " = {")
            table.insert(result, dump_table(v, indent + 1, done))
            table.insert(result, spacing .. "}")
        else
            table.insert(result, spacing .. key_str .. " = " .. tostring(v))
        end
    end

    return table.concat(result, "\n")
end

local function print(t)
    print(dump_table(t))
end

return {
    dump = dump_table,
    print = print
}
