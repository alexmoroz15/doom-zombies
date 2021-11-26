class DamageHandler : EventHandler
{
	protected Le_GlScreen gl_proj;
	protected Le_Viewport viewport;
	protected Vector3 base_pos;

	const DMG_PlayerThisBarrel = 1;
	const DMG_PlayerOtherBarrel = 2;
	const DMG_ActorThisBarrel = 3;
	const DMG_ActorOtherBarrel = 4;
	const DMG_OtherBarrel = 5;
	const DMG_PlayerThis = 6;
	const DMG_PlayerOther = 7;
	const DMG_ActorOther = 8;
	const DMG_Other = 9;

	const DEBUG = 0;

	override void OnRegister() {
		gl_proj = new("Le_GlScreen");
	}

	override void WorldThingDamaged(WorldEvent e)
	{
		Super.WorldThingDamaged(e);

		let dmgnumobj = new("DamageNumObj");
		dmgnumobj.damage = e.damage;
		dmgnumobj.targetPos = e.thing.pos;
		dmgnumobj.lifetime = 35 * 2;
		dmgnumobj.ChangeStatNum(Thinker.STAT_USER);

		// Give the correct number of points to the correct player
		AwardDamagePoints(e);
	}

	override void WorldThingDied(WorldEvent e) {
		Super.WorldThingDied(e);
		AwardDamagePoints(e, true);
	}
	
	void AwardDamagePoints(WorldEvent e, bool killed = false) {
		let inflictor = e.inflictor;
		let damageSource = e.damageSource;

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

			if (inflictor is "ExplosiveBarrel") {
				if (damageSource is "PlayerPawn") {
					if (damageSource == players[i].mo) {
						// Actor damaged by barrel destroyed by this player
						scoreTokenItem.Amount += DMG_PlayerThisBarrel;
						if (DEBUG) {
							console.printf("%s damaged by a barrel destroyed by %s, this player with %s", 
								e.thing.GetClassName(), 
								players[i].GetUserName(),
								players[i].ReadyWeapon.GetClassName());
						}
					} else {
						// Actor damaged by barrel destroyed by another player
						scoreTokenItem.Amount += DMG_PlayerOtherBarrel;
						if (DEBUG) {
							console.printf("%s damaged by a barrel destroyed by %s, another player with %s", 
								e.thing.GetClassName(), 
								players[i].GetUserName(),
								players[i].ReadyWeapon.GetClassName());
						}
					}
				} else if (damageSource == e.thing) {
					// Actor damaged by barrel destroyed by itself
					scoreTokenItem.Amount += DMG_ActorThisBarrel;
					if (DEBUG) {
						console.printf("%s damaged by a barrel destroyed by itself", e.thing.GetClassName());
					}
				} else if (damageSource is "Actor") {
					// Actor damamged by barrel destroyed by another actor
					scoreTokenItem.Amount += DMG_ActorOtherBarrel;
					if (DEBUG) {
						console.printf("%s damaged by a barrel destroyed by %s", e.thing.GetClassName(), damageSource.GetClassName());
					}
				} else {
					// Actor damaged by barrel destroyed by other means
					scoreTokenItem.Amount += DMG_OtherBarrel;
					if (DEBUG) {
						console.printf("%s damaged by a barrel destroyed by other means", e.thing.GetClassName());
					}
				}
			} else if (damageSource is "PlayerPawn") {
				if (damageSource == players[i].mo) {
					// Actor damaged by this player
					scoreTokenItem.Amount += DMG_PlayerThis;
					if (DEBUG) {
						console.printf("%s damaged by %s, this player with %s", 
							e.thing.GetClassName(),
							players[i].GetUserName(),
							players[i].ReadyWeapon.GetClassName());
					}
				} else {
					// Actor damaged by another player
					scoreTokenItem.Amount += DMG_PlayerOther;
					if (DEBUG) {
						console.printf("%s damaged by %s, another player with %s", 
						e.thing.GetClassName(),
						players[i].GetUserName(),
						players[i].ReadyWeapon.GetClassName());
					}
				}	
			} else if (damageSource is "Actor") {
				// Actor damaged by another actor
				scoreTokenItem.Amount += DMG_ActorOther;
				if (DEBUG) {
					console.printf("%s damaged by %s", e.thing.GetClassName(), damageSource.GetClassName());
				}
			} else {
				// Actor damaged by other means
				scoreTokenItem.Amount += DMG_Other;
				if (DEBUG) {
					console.printf("%s damaged by other means", e.thing.GetClassName());	
				}
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