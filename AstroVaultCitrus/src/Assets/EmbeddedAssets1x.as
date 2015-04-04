package Assets 
{
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Jack Storm
	 */
	public class EmbeddedAssets1x 
	{
		//atlas 1
		//[Embed(source="Assets1x/004_everythingsofar.png")]//[Embed(source="Assets1x/Assets1xAtlas.png")]
		//public static const ATLAS:Class;
		//[Embed(source="Assets1x/004_everythingsofar.xml", mimeType="application/octet-stream")]//[Embed(source = "Assets1x/Assets1xAtlas.xml", mimeType="application/octet-stream")]
		//public static const ATLAS_XML:Class;
		
		[Embed(source="Assets1x/Player.png")]
		public static const Player:Class;
		
		[Embed(source = "Assets1x/Sprint.png")]
		public static const Sprint:Class;
		
		[Embed(source="Assets1x/GroundAssets.png")]//[Embed(source="Assets1x/Assets1xAtlas.png")]
		public static const GroundAssets:Class;
		
		[Embed(source = "Assets1x/SpaceAssets.png")]
		public static const SpaceAssets:Class;
		
		
		//[Embed(source="Assets1x/Player.xml", mimeType="application/octet-stream")]//[Embed(source = "Assets1x/Assets1xAtlas.xml", mimeType="application/octet-stream")]
		//public static const PlayerXML:Class;
		
		
		//public static function getTexture():Texture
		//{
			//return Texture.fromBitmap(new ATLAS());
		//}
		
		//public static function getXML():XML
		//{
			//return XML(new ATLAS_XML());
		//}
		
		
		//[Embed(source = "Assets1x/001_running2.xml", mimeType="application/octet-stream")]
		//public static const ATLAS2_XML:Class;
		
		//[Embed(source="Assets1x/001_running2.png")]
		//public static const ATLAS2:Class;
		
		
	}

}