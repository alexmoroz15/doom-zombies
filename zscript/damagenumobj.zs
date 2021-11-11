class DamageNumObj : Thinker
{
	int damage;
	Actor target;
	int lifetime;
	
	override void Tick()
	{
		super.Tick();
		lifetime--;
		if (lifetime <= 0)
		{
			Destroy();
		}
	}
}