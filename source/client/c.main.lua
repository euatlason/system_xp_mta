-- teste

function draw()
    local xp = getElementData(localPlayer, "Atlas.XP") or 0
    local level = getElementData(localPlayer, "Atlas.Level") or 1

    dxDrawText("Level: "..level.." | XP: "..xp, 50*8, 175*4.2, 0, 0, tocolor(255, 255, 0, 255), 2, "sans")
end
addEventHandler('onClientRender', root, draw)