class DamageHandler : EventHandler
{
	protected Le_GlScreen gl_proj;
	protected Le_Viewport viewport;
	protected Vector3 base_pos;

	override void OnRegister() {
		gl_proj = new("Le_GlScreen");
	}

	override void WorldThingDamaged(WorldEvent e)
	{
		let dmgnumobj = new("DamageNumObj");
		dmgnumobj.damage = e.damage;
		dmgnumobj.targetPos = e.thing.pos;
		dmgnumobj.lifetime = 35 * 2;
		dmgnumobj.ChangeStatNum(Thinker.STAT_USER);

		// Give the correct number of points to the correct player
		Super.WorldThingDamaged(e);

		let damageSource = e.damageSource;
		let inflictor = e.inflictor;

		for (int i = 0; i < maxplayers; i++) {
			if (!playeringame[i]) {
				continue;
			}

			let scoreTokenItem = players[i].mo.FindInventory("ScoreToken");
			if (!scoreTokenItem) {
				scoreTokenItem = players[i].mo.GiveInventoryType("ScoreToken");
				if (!scoreTokenItem) {
					continue;
				}
			}

			if (damageSource is "PlayerPawn") {
				if (damageSource == players[i].mo) {
					// Actor damaged by this player
					scoreTokenItem.Amount += 1;
					console.printf("%s damaged by %s, this player with %s", 
						e.thing.GetClassName(),
						players[i].GetUserName(),
						players[i].ReadyWeapon.GetClassName());
				} else {
					// Actor damaged by another player
					scoreTokenItem.Amount += 2;
					console.printf("%s damaged by %s, another player with %s", 
						e.thing.GetClassName(),
						players[i].GetUserName(),
						players[i].ReadyWeapon.GetClassName());
				}
			} else if (inflictor is "ExplosiveBarrel") {
				if (damageSource.target is "PlayerPawn") {
					if (damageSource.target == players[i].mo) {
						// Actor damaged by barrel destroyed by this player
						scoreTokenItem.Amount += 4;
						console.printf("%s damaged by a barrel destroyed by %s, this player with %s", 
							e.thing.GetClassName(), 
							players[i].GetUserName(),
							players[i].ReadyWeapon.GetClassName());
					} else {
						// Actor damaged by barrel destroyed by another player
						scoreTokenItem.Amount += 8;
						console.printf("%s damaged by a barrel destroyed by %s, another player with %s", 
							e.thing.GetClassName(), 
							players[i].GetUserName(),
							players[i].ReadyWeapon.GetClassName());
					}
				} else if (damageSource == e.thing) {
					// Actor damaged by barrel destroyed by itself
					scoreTokenItem.Amount += 16;
					console.printf("%s damaged by a barrel destroyed by itself", e.thing.GetClassName());
				} else if (damageSource is "Actor") {
					// Actor damamged by barrel destroyed by another actor
					scoreTokenItem.Amount += 32;
					console.printf("%s damaged by a barrel destroyed by %s", e.thing.GetClassName(), damageSource.GetClassName());
				} else {
					// Actor damaged by barrel destroyed by other means
					scoreTokenItem.Amount += 64;
					console.printf("%s damaged by a barrel destroyed by other means", e.thing.GetClassName());
				}
			} else if (damageSource is "Actor") {
				// Actor damaged by another actor
				scoreTokenItem.Amount += 128;
				console.printf("%s damaged by %s", e.thing.GetClassName(), damageSource.GetClassName());
			} else {
				// Actor damaged by other means
				scoreTokenItem.Amount += 256;
				console.printf("%s damaged by other means", e.thing.GetClassName());
			}
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