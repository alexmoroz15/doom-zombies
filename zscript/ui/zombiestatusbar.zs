class ZombieStatusBar : DoomStatusBar
{
	override void Init()
	{
		Super.Init();
		SetSize(32, 320, 200);
		fullscreenOffsets = true;
	}
}