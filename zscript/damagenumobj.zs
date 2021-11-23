class DamageNumObj : Thinker
{
	int damage;
	//Actor target;
	vector3 targetPos;
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