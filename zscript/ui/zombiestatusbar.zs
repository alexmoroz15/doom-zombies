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
		let cosAngle = cos(viewAngle);
		let sinAngle = sin(viewAngle);
		let cosPitch = cos(viewPitch);
		let sinPitch = sin(viewPitch);
		
		let focalNormVec = (cosAngle * cosPitch, sinAngle * cosPitch, sinPitch);
		let focalVec = focalLen * focalNormVec;
		
		let xNormVec = (sinAngle, -cosAngle, 0);
		let yNormVec = xNormVec cross focalNormVec;
		
		let aspectRatio = screen.GetAspectRatio();
		
		DamageNumObj dmgnumobj;
		while(dmgnumobj = DamageNumObj(ti.Next()))
		{
			let targVec = cplayer.mo.Vec3To(dmgnumobj.target);
			if (focalVec dot targVec == 0) {
				continue;
			}
			let focalVecDotTargVec = focalVec dot targVec;
			let perspVec = (focalLen * focalLen * targVec - focalVecDotTargVec * focalVec) / abs(focalVecDotTargVec);
			let horizOffset = perspVec dot xNormVec;
			let vertOffset = perspVec dot yNormVec;
			if (horizOffset > aspectRatio * 3 / 8) {
				continue;
			}
			
			DrawTextScaled(bigfont, Font.CR_RED, (0.5 + horizOffset, 0.5 + vertOffset), FormatNumber(dmgnumobj.damage), (1.0, 1.0));
			
			cnt++;
		}
		
		let str = FormatNumber(cnt);
		DrawTextScaled(bigfont, Font.CR_RED, (0.5, 0.5), str, (2.0, 1.0));
	}
	
	double abs(double x) {
		return x < 0 ? -x : x;
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