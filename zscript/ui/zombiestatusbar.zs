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
		
		let hudscale = GetHUDScale();
		int hs = hudscale.x;
		int x, y, w, h;
		[x, y, w, h] = screen.GetViewWindow();
		
		let fnt = bigfont;
		let fontColor = Font.CR_RED;
		let relX = 0.5;
		let relY = 0.5;
		let str = "Hello World!";
		let scale = (2.0, 1.0);
		
		int pw = screen.GetWidth();
		int ph = screen.GetHeight();
		
		int vwidth = pw * pw / w / hs / scale.x;
		int vheight = ph * ph / h / hs / scale.y;
		screen.DrawText(fnt, fontColor, relX * vwidth, relY * vheight, str, DTA_VirtualWidth, vwidth, DTA_VirtualHeight, vheight, DTA_KeepRatio, true);
	}
}