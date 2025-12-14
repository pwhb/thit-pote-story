#!/usr/bin/env lua

-- JSON to Lua Table Converter (Pure Lua, LuaJIT-compatible)
-- Usage:
--   lua tools/json_to_lua.lua input.json output.lua
--   lua tools/json_to_lua.lua input_dir output_dir
local json = require("design.generators.dkjson") -- Ensure dkjson.lua is in your path

-- Serialize Lua table to string (with proper escaping)
-- local function serialize(tbl, indent)
--     indent = indent or 0
--     local spaces = string.rep(" ", indent)
--     if type(tbl) == "table" then
--         local parts = {"{"}
--         for k, v in pairs(tbl) do
--             local key_str = type(k) == "string" and string.format("%q", k) or tostring(k)
--             local val_str = serialize(v, indent + 2)
--             table.insert(parts, string.format("%s[%s] = %s,", string.rep(" ", indent + 2), key_str, val_str))
--         end
--         table.insert(parts, spaces .. "}")
--         return table.concat(parts, "\n")
--     else
--         return type(tbl) == "string" and string.format("%q", tbl) or tostring(tbl)
--     end
-- end

local function serialize(value, indent)
    indent = indent or 0
    local spaces = string.rep(" ", indent)

    if type(value) == "table" then
        -- Check if it's a sequential array
        local is_array = true
        local max_i = 0
        for k, _ in pairs(value) do
            if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
                is_array = false
                break
            end
            max_i = math.max(max_i, k)
        end
        if is_array and max_i ~= #value then
            is_array = false
        end

        if is_array then
            local parts = {"{"}
            for i = 1, #value do
                local val_str = serialize(value[i], indent + 2)
                table.insert(parts, string.rep(" ", indent + 2) .. val_str .. ",")
            end
            table.insert(parts, spaces .. "}")
            return table.concat(parts, "\n")
        else
            local parts = {"{"}
            for k, v in pairs(value) do
                local key_str = type(k) == "string" and string.format("%q", k) or tostring(k)
                local val_str = serialize(v, indent + 2)
                table.insert(parts, string.rep(" ", indent + 2) .. "[" .. key_str .. "] = " .. val_str .. ",")
            end
            table.insert(parts, spaces .. "}")
            return table.concat(parts, "\n")
        end
    elseif type(value) == "string" then
        return string.format("%q", value)
    elseif type(value) == "number" or type(value) == "boolean" then
        return tostring(value)
    else
        return "nil" -- Handle nil, functions, etc.
    end
end

-- Scan directory for .json files (Linux/macOS only)
local function scandir(directory)
    local files = {}
    local cmd = string.format('find "%s" -maxdepth 1 -type f -name "*.json" 2>/dev/null', directory)
    local handle = io.popen(cmd)
    if handle then
        for path in handle:lines() do
            -- Extract filename from full path
            local filename = path:match(".*/(.*)")
            if filename then
                table.insert(files, filename)
            end
        end
        handle:close()
    end
    return files
end

-- Convert single file
local function convert_file(json_path, lua_path)
    local json_file = io.open(json_path, "r")
    if not json_file then
        print("❌ Error: Cannot open " .. json_path)
        return
    end
    local json_str = json_file:read("*a")
    json_file:close()

    local ok, data = pcall(json.decode, json_str)
    if not ok then
        print("❌ Error parsing JSON in " .. json_path .. ": " .. data)
        return
    end

    local lua_str = "return " .. serialize(data)
    local lua_file = io.open(lua_path, "w")
    if lua_file then
        lua_file:write(lua_str)
        lua_file:close()
        print("✅ Converted: " .. json_path .. " → " .. lua_path)
    else
        print("❌ Error: Cannot write to " .. lua_path)
    end
end

-- Convert directory
local function convert_dir(json_dir, lua_dir)
    -- Create output directory
    os.execute("mkdir -p " .. string.gsub(lua_dir, "'", "'\\''", 1))

    local files = scandir(json_dir)
    if #files == 0 then
        print("⚠️ No .json files found in " .. json_dir)
        return
    end

    for _, file in ipairs(files) do
        local json_path = json_dir .. "/" .. file
        local lua_path = lua_dir .. "/" .. file:gsub("%.json$", ".lua")
        convert_file(json_path, lua_path)
    end
end

-- Main
if #arg < 2 then
    print("Usage:")
    print("  lua json_to_lua.lua <input.json> <output.lua>")
    print("  lua json_to_lua.lua <input_dir> <output_dir>")
    return
end

local input = arg[1]
local output = arg[2]

-- Check if input is directory
local input_is_dir = false
local test_handle = io.popen("if [ -d '" .. input .. "' ]; then echo dir; fi")
if test_handle then
    local result = test_handle:read("*l")
    test_handle:close()
    input_is_dir = (result == "dir")
end

if input_is_dir then
    convert_dir(input, output)
else
    convert_file(input, output)
end
