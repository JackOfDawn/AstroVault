package Assets 
{
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class EmbeddedAssets3x 
	{
		[Embed(source="Sounds/explosion.mp3")]
		public static const explosion:Class;
		
		[Embed(source = "Sounds/meteorhit.mp3")]
		public static const meteorhit:Class;
		
		[Embed(source = "Sounds/polebend.mp3")]
		public static const polebend:Class;
		
		[Embed(source = "Sounds/step1.mp3")]
		public static const step1:Class;
		
		[Embed(source = "Sounds/step2.mp3")]
		public static const step2:Class;
		
		[Embed(source = "Sounds/stepfast1.mp3")]
		public static const stepfast1:Class;
		
		[Embed(source = "Sounds/stepfast2.mp3")]
		public static const stepfast2:Class;
		
		[Embed(source="Music/AV001.mp3")]
		public static const TitleScreen:Class;
		
		[Embed(source="Music/AV003a.mp3")]
		public static const SpaceTunes:Class;
		
	}

}