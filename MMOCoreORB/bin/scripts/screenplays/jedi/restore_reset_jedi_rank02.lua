-- One-time recovery for non-Grey Jedi reset before the reset command
-- learned to finish at force_title_jedi_rank_02.
RestoreResetJediRank02 = ScreenPlay:new {
	numberOfActs = 1,
}

registerScreenPlay("RestoreResetJediRank02", false)

local TARGETS = {
	["xixx lightning"] = true,
	["darvin dreadus"] = true,
	["hellucard"] = true,
	["talla vex"] = true,
	["toly"] = true,
	["indiana moramme"] = true,
	["helucard"] = true,
	["valmer"] = true,
	["zaleska"] = true,
	["sello ackine"] = true,
	["luke skiwalker"] = true,
	["vaylin"] = true,
	["xix lightning"] = true,
	["revan"] = true,
}

local function normalizedName(creature)
	local first = string.lower(creature:getFirstName() or "")
	local last = string.lower(creature:getLastName() or "")
	local name = first

	if last ~= "" then
		name = name .. " " .. last
	end

	return string.gsub(name, "^%s*(.-)%s*$", "%1")
end

function RestoreResetJediRank02:playerLoggedIn(pPlayer)
	if pPlayer == nil then
		return
	end

	local creature = CreatureObject(pPlayer)
	local name = normalizedName(creature)

	if not TARGETS[name] then
		return
	end

	if readScreenPlayData(pPlayer, "RestoreResetJediRank02", "done") == "1" then
		return
	end

	-- Never downgrade a character who has already advanced past Padawan.
	if creature:hasSkill("force_title_jedi_rank_03") or
			creature:hasSkill("force_title_jedi_rank_04") or
			creature:hasSkill("force_title_jedi_master") then
		writeScreenPlayData(pPlayer, "RestoreResetJediRank02", "done", "1")
		return
	end

	-- Title skills require Jedi state 1; set Padawan state before granting.
	local pGhost = creature:getPlayerObject()

	if pGhost ~= nil then
		PlayerObject(pGhost):setJediState(2)
	end

	if not creature:hasSkill("force_title_jedi_novice") then
		awardSkill(pPlayer, "force_title_jedi_novice")
	end

	if not creature:hasSkill("force_title_jedi_rank_01") then
		awardSkill(pPlayer, "force_title_jedi_rank_01")
	end

	if not creature:hasSkill("force_title_jedi_rank_02") then
		awardSkill(pPlayer, "force_title_jedi_rank_02")
	end

	if creature:hasSkill("force_title_jedi_rank_02") then
		writeScreenPlayData(pPlayer, "RestoreResetJediRank02", "done", "1")
		creature:sendSystemMessage("\\#FFAA00[Jedi Reset]\\#FFFFFF Your Jedi rank has been restored to rank 02.")
		print("RestoreResetJediRank02: restored rank 02 for " .. name)
	else
		print("RestoreResetJediRank02: could not restore rank 02 for " .. name)
	end
end
