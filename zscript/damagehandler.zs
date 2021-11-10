class DamageHandler : EventHandler
{
	override void WorldThingDamaged(WorldEvent e)
	{
		let damageSource = e.damageSource;
		let infstr = "nobody";
		if (damageSource)
		{
			infstr = damageSource.GetClassName();
		}
		console.printf("%s damaged by %s!", e.thing.GetClassName(), infstr);
		
		// General outline:
		// So the way that we draw damage numbers to a player's HUD is a bit messy, but it seems that, in general,
		// Each GZDoom client can only access the respective player's Status bar
		// Makes sense, given it's client-side code.
		
		// We check that the damageSource is not null and the same as the player attached to the client's Status bar
		// We then call a method in the status bar that should add the target (Actor) and player (PlayerInfo) as well as a tick counter (0)
		
		// The status bar then reads this info in the UI thread to draw
		// And updates the underlying data structures on game ticks.
	}
}