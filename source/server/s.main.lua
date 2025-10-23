XP = {}
XP.__index = XP
local Cache = {}

local db = dbConnect('sqlite', 'data/database.sqlite')
dbExec(db, [[
CREATE TABLE IF NOT EXISTS xp(
    account TEXT PRIMARY KEY,
    xp INTEGER,
    level INTEGER
)
]])


function XP:constructor(player)
    local acc = getAccountName(getPlayerAccount(player))
    if not acc or acc == 'guest' then 
        outputChatBox('precisa estar logado!', player, 255, 0, 0)
        return nil
    end

    if Cache[player] then
        return Cache[player]
    end

    local result = dbPoll(dbQuery(db, 'SELECT * FROM xp WHERE account=?', acc), -1)
    local data = result[1] or {xp = 0, level = 1}

    self.player = player
    self.account = acc
    self.xp = tonumber(data.xp)
    self.level = tonumber(data.level)
    Cache[player] = self

    return self
end

function XP:add(amount)
    if not amount or amount <= 0 then return end
    self.xp = self.xp + amount

    if self.xp >= self.level * 100 then
        self.xp = 0
        self.level = self.level + 1
        outputChatBox('subiu level > '..self.level..'!', self.player, 255, 255, 0)
    end
    self:save()
    self:data()
end

function XP:show()
    outputChatBox('nivel: ' .. self.level .. ' | XP: ' .. self.xp .. '/' .. (self.level * 100), self.player, 255, 255, 255)
end

function XP:save()
    if not self.account or self.account == 'guest' then return end
    if type(self.xp) ~= 'number' or self.xp < 0 then self.xp = 0 end
    if type(self.level) ~= 'number' or self.level < 1 then self.level = 1 end
    dbExec(db, 'INSERT OR REPLACE INTO xp(account, xp, level) VALUES(?, ?, ?)', self.account, self.xp, self.level)
end

function XP:data()
    if not self.player then return end
    setElementData(self.player, "Atlas.XP", self.xp, true)
    setElementData(self.player, "Atlas.Level", self.level, true)
end


function getPlayerXP(player)
    if Cache[player] then
        return Cache[player]
    else
        local instance = setmetatable({}, XP)
        return XP.constructor(instance, player)
    end
end

addCommandHandler('addxp', function(player, _, amount)
    amount = tonumber(amount)
    if not amount or amount <= 0 then 
        return outputChatBox('uso: /addxp <quantidade>', player, 255, 0, 0) 
    end

    local xp = getPlayerXP(player)
    if xp then xp:add(amount) end
    outputChatBox('adicionado '..amount..' XP!', player, 255, 255, 255)
end)

addCommandHandler('meulevel', function(player)
    local xp = getPlayerXP(player)
    if xp then xp:show() end
end)

addEventHandler('onPlayerQuit', root, function()
    local xp = getPlayerXP(source)
    if xp then
        xp:save()
        Cache[source] = nil
    end
end)

addEventHandler('onPlayerWasted', root, function(totalAmmo, killer, killerWeapon, bodyPart)
    if killer and killer ~= source and getElementType(killer) == 'player' then
        local xp = getPlayerXP(killer)
        if xp then
            xp:add(settings['GainExpForKill'])
            outputChatBox('você ganhou '..settings['GainExpForKill']..' XP por matar '..getPlayerName(source)..'!', killer, 0, 255, 0)
        end
    end
end)
