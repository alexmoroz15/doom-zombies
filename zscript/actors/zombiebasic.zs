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
	
	override void Die(Actor source, Actor inflictor, int dmgflags, Name MeansOfDeath) {
		Super.Die(source, inflictor, dmgflags, MeansOfDeath);
	}
	
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle) {
		return Super.DamageMobj(inflictor, source, damage, mod, flags, angle);
	}
}