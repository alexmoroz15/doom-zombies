class DamageHandler : EventHandler
{
	override void WorldThingDamaged(WorldEvent e)
	{
		let damageSource = e.damageSource;
		if (damageSource && damageSource == players[consoleplayer].mo) {
			let dmgnumobj = new("DamageNumObj");
			dmgnumobj.damage = e.damage;
			dmgnumobj.target = e.thing;
			dmgnumobj.lifetime = 35 * 10;
			dmgnumobj.ChangeStatNum(Thinker.STAT_USER);
		}
	}
}