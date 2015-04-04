package Units 
{
	import citrus.objects.NapePhysicsObject;
	import nape.phys.Material;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Pole extends NapePhysicsObject 
	{
		private var texture:Texture;
		public function Pole(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = texture = Registry.assetManager.getTextureAtlas("Player").getTexture("Pole");
			height = texture.height;
			width = texture.width;
			
			updateCallEnabled = true;
		}
		
		override protected function createBody():void
		{
			super.createBody();
			_body.allowRotation = false;
		}
		
		override protected function createMaterial():void
		{
			_material = new Material(0, 0, 0, 1, 0);
		}
		
		override public function update(deltaTime:Number):void
		{
			super.update(deltaTime);
		}
		
	}

}