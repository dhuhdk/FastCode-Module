local ConnectionManager = {}
ConnectionManager.__index = ConnectionManager

function ConnectionManager.new(Name)
    local self = setmetatable({}, ConnectionManager)
    self.Name = Name
    self.Events = {}
    return self
end

function ConnectionManager:Bind(Key, Connection)
    assert(type(Key) == "string", "Arg1 must be a string.")
    assert(typeof(Connection) == "RBXScriptConnection", "Arg2 must be an event (RBXScriptConnection).")
    if self.Events[Key] and self.Events[Key].Connected then self.Events[Key]:Disconnect() end
    self.Events[Key] = Connection
    return Connection
end

function ConnectionManager:Remove(Key)
    assert(type(Key) == "string", "Arg must be a string value.")
    local OldConnection = self.Events[Key]
    if OldConnection then
        self.Events[Key] = nil
        if not OldConnection.Connected then return nil end
    end
    return OldConnection
end

function ConnectionManager:Disconnect(Key)
    assert(type(Key) == "string", "Arg1 must be a string value.")
    local OldConnection = self.Events[Key]
    if OldConnection then
        self.Events[Key] = nil
        if OldConnection.Connected then
            OldConnection:Disconnect()
        else
            return nil
        end
    end
    return OldConnection
end

function ConnectionManager:Clear()
    for K, Conn in pairs(self.Events) do
        if Conn.Connected then Conn:Disconnect() end
    end
    table.clear(self.Events)
end

function ConnectionManager:Get(Key)
    assert(type(Key) == "string", "Arg1 must be a string.")
    if self.Events[Key] then
        if not self.Events[Key].Connected then
            self.Events[Key] = nil
            return nil
        end
        return self.Events[Key]
    end
    return nil
end

return ConnectionManager