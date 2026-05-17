local locks = {}

---@class Lock : string[]
---@field [number] string An acquired lock id.
---This object must be used with to-be-closed variables ensure
---locks are automatically released after use.
local lock = {
    __metatable = "Lock",
}

function lock:__close()
    for i = 1, #self do
        locks[self[i]] = nil
    end
end

---@param obj string[]
---Returns a `Lock` if every requested lock was sucessfully acquired.
---
---The returned `Lock` must always be assigned to a to-be-closed variable.
---@nodiscard
local function GetLocks(obj)
    for i = 1, #obj do
        local id = obj[i]

        if locks[id] then return false end
    end

    for i = 1, #obj do
        locks[obj[i]] = true
    end

    ---@type Lock
    return setmetatable(obj, lock)
end

return GetLocks
