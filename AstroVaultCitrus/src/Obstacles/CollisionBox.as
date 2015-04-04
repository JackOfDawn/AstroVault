package Obstacles 
{
	import citrus.objects.NapePhysicsObject;
	import flash.display.Bitmap;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CollisionBox extends NapePhysicsObject 
	{
		[Embed(source = "../Assets/TestAssets/testCollisionbox.png")] private static const COLLISIONBOX:Class;
		
		public function CollisionBox(name:String, params:Object=null) 
		{
			super(name, params);
			
			/* graphics */
			var texture:Texture = Texture.fromBitmap(new COLLISIONBOX as Bitmap);
			
			/*height = texture.height;
			width = texture.width;*/
			view = texture;
			updateCallEnabled = false;
			visible = false;
		}
		
		override protected function defineBody():void 
		{
			_bodyType = BodyType.STATIC;
		}
		
		override protected function createMaterial():void 
		{
			_material = new Material(.4, 0, 0, 1, 0);
		}
	}

}