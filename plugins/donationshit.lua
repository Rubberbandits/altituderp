PLUGIN.name = "Character Limit Per Rank"
PLUGIN.desc = "Set the character limit depending on the player's rank."
PLUGIN.author = "Robert Bearson"

local overrideCharLimit = {
  ["owner"] = 10,
  ["superadmin"] = 7,
  ["admin"] = 5,
  ["user"] = 3
}

hook.Add("GetMaxPlayerCharacter", "returnRankCharLimit", function(ply)
	local rank = ply:GetUserGroup() //ply:GetNWString("usergroup", nil)
	local defchars = nut.config.get("maxChars", 3)

	if not rank then return defchars end
/*
  for group,slots in pairs(overrideCharLimit) do
    if rank == group then
      return slots
    end
  end
*/
  if overrideCharLimit[rank] then
    return overrideCharLimit[rank]
  end

  return defchars
end)