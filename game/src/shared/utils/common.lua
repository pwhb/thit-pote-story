local function shallow_merge(destination, source)
    for k, v in pairs(source) do
        destination[k] = v
    end
    return destination
end

return {
    shallow_merge = shallow_merge
}
