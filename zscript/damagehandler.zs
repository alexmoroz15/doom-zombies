class DamageHandler : EventHandler
{
	protected Le_GlScreen gl_proj;
	protected Le_Viewport viewport;
	protected vector3 base_pos;

	override void OnRegister() {
		gl_proj = new("Le_GlScreen");
	}

	override void WorldThingDamaged(WorldEvent e)
	{
		let damageSource = e.damageSource;
		if (damageSource && damageSource == players[consoleplayer].mo) {
			let dmgnumobj = new("DamageNumObj");
			dmgnumobj.damage = e.damage;
			//dmgnumobj.target = e.thing;
			dmgnumobj.targetPos = e.thing.pos;
			dmgnumobj.lifetime = 35 * 10;
			dmgnumobj.ChangeStatNum(Thinker.STAT_USER);
		}
	}
	
	override void RenderUnderlay(RenderEvent e)
	{
		let ti = ThinkerIterator.Create("DamageNumObj", Thinker.STAT_USER);
		
		let window_aspect = 1.0 * Screen.GetWidth() / Screen.GetHeight();
		let resolution = 480 * (window_aspect, 1);
		let t = e.fractic;
		
		gl_proj.CacheCustomResolution(resolution);
		gl_proj.CacheFov(players[consoleplayer].fov);
		gl_proj.OrientForRenderUnderlay(e);
		gl_proj.BeginProjection();
		
		DamageNumObj current = null;
		while (current = DamageNumObj(ti.Next())) {
			gl_proj.ProjectWorldPos(current.targetPos);
			if (gl_proj.IsInFront()) {
				viewport.FromHud();
				
				let draw_pos = viewport.SceneToCustom(
					gl_proj.ProjectToNormal(),
					resolution);
				
				Screen.DrawText(
					smallfont,
					Font.CR_ICE,
					draw_pos.x,
					draw_pos.y,
					""..current.damage,
					DTA_VIRTUALWIDTHF,	resolution.x,
					DTA_VIRTUALHEIGHTF,	resolution.y,
					DTA_KEEPRATIO,		true);
			}
		}
	}
}