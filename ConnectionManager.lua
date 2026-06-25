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

function ConnectionManager:Disconnect(Key)
    assert(type(Key) == "string", "Arg1 must be a string value.")
    local OldConnection = self.Events[Key]
    if OldConnection then
        OldConnection:Disconnect()
        self.Events[Key] = nil
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
    if self.Events[Key] then
        if not self.Events[Key].Connected then
            self.Events[Key] = nil
            return nil
        else
            return self.Events[Key]
        end
    end
    return nil
end

return ConnectionManager
