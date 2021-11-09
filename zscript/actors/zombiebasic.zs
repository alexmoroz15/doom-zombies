class ZombieBasic : ZombieMan
{
	States
	{
	Missile:
		Stop;
	Melee:
		POSS E 10 A_FaceTarget;
		POSS F 8 A_SargAttack;
		POSS E 8;
		Goto See;
	}
	
	override void Die(Actor source, Actor inflictor, int dmgflags = 0, Name MeansOfDeath = 'none') {
		ACS_NamedExecuteAlways("On Zombie Death", 0, source.tid, 0, 0);
		Super.Die(source, inflictor, dmgflags, MeansOfDeath);
	}
	
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags = 0, double angle = 0) {
		ACS_NamedExecuteAlways("On Zombie Damaged", 0, source.tid, 0, 0);
		return Super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}
}