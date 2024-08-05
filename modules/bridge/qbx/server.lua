---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId, group, grade)
    return exports.qbx_core:IsPlayerBoss(playerId, group, grade)
end
