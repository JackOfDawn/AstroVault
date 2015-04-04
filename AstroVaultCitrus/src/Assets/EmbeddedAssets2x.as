package Assets 
{
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class EmbeddedAssets2x 
	{
		
		
		[Embed(source="Assets1x/GroundAssets.xml", mimeType="application/octet-stream")]//[Embed(source = "Assets1x/Assets1xAtlas.xml", mimeType="application/octet-stream")]
		public static const GroundAssets:Class;
		
		[Embed(source="Assets1x/Player.xml", mimeType="application/octet-stream")]//[Embed(source = "Assets1x/Assets1xAtlas.xml", mimeType="application/octet-stream")]
		public static const Player:Class;
		
		[Embed(source = "Assets1x/Sprint.xml",  mimeType="application/octet-stream")]
		public static const Sprint:Class;
	
		[Embed(source = "Assets1x/SpaceAssets.xml", mimeType = "application/octet-stream")]
		public static const SpaceAssets:Class;
		
	}

}