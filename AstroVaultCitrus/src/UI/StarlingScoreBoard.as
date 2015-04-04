package UI 
{
	/**
 * StarlingScoreBoard 1.5 by Alex Smith
 *
 * A textfield for your game score that animates the number count :)
 *
 */
import citrus.objects.CitrusSprite;
import starling.display.Sprite;
import starling.text.TextField;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.BitmapFont;	// used for native size
import starling.display.Image;
 
public class StarlingScoreBoard extends Sprite
{
	[Embed(source = "../Assets/Arial.ttf", embedAsCFF = "false", fontFamily = "Arial")]
	public static const ARIAL:Class;
	
	private var _score_TF:TextField;
	private var _title_TF:TextField;
 
	private var _score:int;
	private var _newScore:int;
	private var _increment:int;
	private var _numIncrement:int;
 
	private var _prefix:String = "";
	private var _titleText:String = "score";
 
	private var _direction:Boolean;
 
	public function StarlingScoreBoard() 
	{
		init();
	}
 
	private function init():void 
	{
		_title_TF = new TextField(100, 50, "0","Arial");
		_title_TF.border = false;
		_title_TF.color = 0xFFFFFF;
		_title_TF.hAlign = "left";
		_title_TF.vAlign = "top";
		_title_TF.fontSize = 14;
		_title_TF.x = 0;
		_title_TF.y = 10;
		addChild(_title_TF);
 
		_score_TF = new TextField(100, 50, "0","Arial");
		_score_TF.border = false;
		_score_TF.color = 0xFFFFFF;
		_score_TF.hAlign = "left";
		_score_TF.vAlign = "top";
		_score_TF.fontSize = BitmapFont.NATIVE_SIZE;
		_score_TF.x = 0;
		_score_TF.y = 25;
		addChild(_score_TF);
 
		_title_TF.text = String(_titleText);
	}
 
	public function setText(value:int):void 
	{
		_score_TF.text = String(value);
	}
 
	public function setScore(value:int):void 
	{
		if (value == _score) 
		{
			return; // don't bother if the score being set is already the current score
		}
		_newScore = value;
		var range:int = Math.abs(_newScore - _score);
		_increment = range / _numIncrement;
		if (_increment == 0) 
		{
			_increment = 1;
		}
 
		if (_newScore <= _score) 
		{
			_direction = false;
		} 
		else 
		{
			_direction = true;
		}
		this.addEventListener(Event.ENTER_FRAME, nextFrame);
		
	}
 
	private function nextFrame(e:Event):void 
	{
		if (!_direction) 
		{
			_score -= _increment;
 
			if (_score <= _newScore) 
			{ // decremented score
				this.removeEventListener(Event.ENTER_FRAME, nextFrame);
				_score = _newScore;
			}
		} 
		else 
		{
			_score += _increment;
			setText(_score);
			if (_score >= _newScore) 
			{ // increment score
				this.removeEventListener(Event.ENTER_FRAME, nextFrame);
				_score = _newScore;
			}
		}
 
		if (_score == _newScore) 
		{
			this.removeEventListener(Event.ENTER_FRAME, nextFrame);
		}
		setText(_score);
	}
 
	public function kill():void 
	{
		this.removeEventListener(Event.ENTER_FRAME, nextFrame);
	}
}
}