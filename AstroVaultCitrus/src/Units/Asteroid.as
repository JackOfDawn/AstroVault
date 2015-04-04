package Units 
{
	import citrus.core.CitrusObject;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.NapePhysicsObject;
	import nape.phys.Material;
	import starling.textures.Texture;
	import Utils.InputManager;
	
	public class Asteroid extends CitrusSprite 
	{
		private var texture:Texture;
		public var isAlive:Boolean;
		public var trueHeight:Number,
				   trueWidth:Number;
		private var _startVec:MathVector = new MathVector(0, 0);
		private var _player:AstroVaulter = Registry.player;
		public function Asteroid(name:String, params:Object=null) 
		{
			super(name, params);
			
			view = texture = Registry.assetManager.getTextureAtlas("SpaceAssets").getTexture("Meteor1");
			height = texture.height;
			width = texture.width;
			offsetX = width * .5;
			offsetY = height * .5;
			//trueHeight = height * Math.sin(rotation);
			//trueWidth = width * Math.cos(rotation);
			trace(rotation, trueHeight, trueWidth);
			group = 2;
			updateCallEnabled = false;
			
		}
		
		public function spawn(xx:int, yy:int):void
		{
			this.x = xx;
			this.y = yy;
			isAlive = true;
			updateCallEnabled = true;
			
			_velocity.y = 0;
			_startVec = _velocity.copy();
			if (Math.round(Math.random() * 5) == 1)
			{
				//_startVec.x += -100;
				//_startVec.y += -(50 + Math.random() * 50);
			}
			//trace(_startVec);
		}
		
		override public function update(deltaTime:Number):void
		{
			super.update(deltaTime);
			var _distToPlayer:Number = Math.abs(Math.sqrt(Math.pow((this.x - (_player.x + (_player.width * .5))), 2) + Math.pow((this.y - (_player.y + (0 * .5))), 2))),
				_distX:Number = Math.abs(_player.x - this.x),
				_distY:Number = Math.abs(_player.y - this.y),
				_distXCol:Number = _distX - (width * .5) - 22.5,
				_distYCol:Number = _distY - (height * .5) - 70;
			//trace(_player.velocity.y);
			if (!isAlive)
			{
				visible = false;
				updateCallEnabled = false;
			}
			_velocity.y = (_player.launchSpeedOffset / 200) + _startVec.y;
			trace((_player.launchSpeedOffset / 500), _velocity.y.toFixed(0));
			if (_player.mainPhase != 3)
			{
				if (_distToPlayer > 500)
				{
					isAlive = false;
				}
			}
			else
			{
				if (_distXCol < 0 && _distYCol < -20)
				{
					Registry.tutorialNew.startCameraShake(.25, 30, 5);
					//else Registry.beachLevel.startCameraShake(.25, 30, 5);
					
					_player.launchSpeedOffset -= 6000;
					isAlive = false;
					trace("HIT", _velocity.y);
					Registry.soundManager.playSound("meteorhit");
					//offsetY = height;
				}
				else
				{
					//offsetY = 0;
				}
				if (this.y > _player.y + 500)
				{
					isAlive = false;
				}
				
			}
			
			
		}
		
	}

}