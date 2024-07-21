function tobool( var )
    if type(var) == "nil" then return nil end
    local conform = {
        [0]=false, [1] = true,
        ["0"]=false, ["1"] = true,
        ["false"] = false, ["true"] = true,
        [true] = true, [false] = false,
    }
    local t = type ( var )
    if t == "number" or t == "string" or t == "boolean" then
        if conform[var] == nil then
            error ( "Invalid string or number given to convert at 'tobool'! [arg:1,"..tostring(var).."]", 2 )
        end
        return conform[var]
    end
    error ( "Invalid value to convert at 'tobool'! [arg:1,"..tostring(var).."]", 2 )
    return nil
end