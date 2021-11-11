class ZombieStatusBar : DoomStatusBar
{
	override void Init()
	{
		Super.Init();
		SetSize(32, 320, 200);
		fullscreenOffsets = true;
	}

	override void Draw (int state, double TicFrac)
	{
		Super.Draw (state, TicFrac);
		let ti = ThinkerIterator.Create("DamageNumObj", Thinker.STAT_USER);
		int cnt = 0;
		
		if (cplayer == null || !cplayer.mo) return;
		let horizFOV = cplayer.fov;
		let viewAngle = cplayer.mo.angle;
		let viewPitch = cplayer.mo.pitch;
		let playerPos = cplayer.mo.pos;
		
		let focalLen = tan(horizFOV / 2) / 2;
		let focalVec = (focalLen * cos(viewAngle), focalLen * sin(viewAngle));
		let focalPerpVec = (focalVec.y, -focalVec.x);
		
		let aspectRatio = screen.GetAspectRatio();
		
		DamageNumObj dmgnumobj;
		while(dmgnumobj = DamageNumObj(ti.Next()))
		{
			let targVec = cplayer.mo.Vec2To(dmgnumobj.target);
			if (focalVec dot targVec == 0) {
				continue;
			}
			let perspVec = focalLen * focalLen / (focalVec dot targVec) * targVec - focalVec;
			let horizOffset = perspVec.Length();
			if (horizOffset > aspectRatio * 3 / 8) {
				continue;
			}
			if (focalPerpVec dot targVec < 0) {
				horizOffset = -horizOffset;
			}
			
			DrawTextScaled(bigfont, Font.CR_RED, (0.5 + horizOffset, 0.5), FormatNumber(dmgnumobj.damage), (1.0, 1.0));
			
			cnt++;
		}
		
		let str = FormatNumber(cnt);
		DrawTextScaled(bigfont, Font.CR_RED, (0.5, 0.5), str, (2.0, 1.0));
	}
	
	void DrawTextScaled (Font fnt, int fontColor, Vector2 relPos, String str, Vector2 scale)
	{
		let hudscale = GetHUDScale();
		int hs = hudscale.x;
		int x, y, w, h;
		[x, y, w, h] = screen.GetViewWindow();
		
		//int pw = screen.GetWidth();
		int ph = screen.GetHeight();
		
		int vheight = ph * ph / h / hs / scale.y;
		int vwidth = ph * ph * 4 / 3 / h / hs / scale.x;
		screen.DrawText(fnt, fontColor, relPos.x * vwidth, relPos.y * vheight, str, DTA_VirtualWidth, vwidth, DTA_VirtualHeight, vheight, DTA_KeepRatio, false);
	}
}