-- Ghosts: Force Revive, the master Force healing capstone. It raises the
-- target and the caster's group, refills HAM and wounds, and restores the buffs
-- death removed.
ForceReviveCommand = {
	name = "forcerevive",

	forceCost = 400,
	forceCostMultiplier = 0,
	speed = 4,
	range = 32,
	visMod = 25,

	clientEffect = "clienteffect/pl_force_heal_self.cef",
	animationCRC = hashCode("force_healing_1"),
}

AddCommand(ForceReviveCommand)
