package ;

import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxSprite;
import org.flixel.util.FlxRandom;

/**
 * ...
 * @author Adam Harte (adam@adamharte.com)
 */
class Enemy extends FlxSprite
{
	private var _jumpPower:Int;
	private var _player:Player;
	private var _bullets:FlxGroup;
	private var _jumpTimer:Float;
	
	
	public function new() 
	{
		super();
		
		_jumpTimer = 0;
		
		loadGraphic('assets/bot_walker.png', true, true, 8, 8);
		width = 6;
		height = 7;
		offset.x = 1;
		offset.y = 1;
		
		var walkSpeed:Int = 30;
		drag.x = walkSpeed * 8;
		acceleration.y = 420;
		_jumpPower = 110;
		maxVelocity.x = walkSpeed;
		maxVelocity.y = _jumpPower;
		
		// Setup animations.
		addAnimation('idle', [0, 1], 6);
		addAnimation('walk', [2, 3], 6);
		addAnimation('sleep', [4, 5, 6, 7, 8], 6, false);
		addAnimation('wake', [8, 7, 6, 5, 4], 6, false);
		addAnimation('hit', [9, 10, 11, 12], 6);
		addAnimation('jump', [13, 14], 6, false);
		
	}
	
	public function init(xPos:Float, yPos:Float, bullets:FlxGroup, player:Player):Void 
	{
		_player = player;
		_bullets = bullets;
		
		reset(xPos - width / 2, yPos - height / 2);
		health = 2;
		
		
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		_player = null;
		_bullets = null;
	}
	
	override public function update():Void 
	{
		acceleration.x = 0;
		
		if (!flickering) 
		{
			if (velocity.y == 0) 
			{
				play('walk');
			}
			acceleration.x -= drag.x;
		}
		
		if (velocity.y == 0 && isTouching(FlxObject.LEFT)) 
		{
			_jumpTimer += FlxG.elapsed;
			if (_jumpTimer > 2) 
			{
				velocity.y = -_jumpPower;
				play('jump');
				_jumpTimer = 0;
			}
		}
		else
		{
			_jumpTimer = 0;
		}
		
		if (velocity.x > 0) 
		{
			facing = FlxObject.RIGHT;
		}
		else if (velocity.x < 0)
		{
			facing = FlxObject.LEFT;
		}
		
		
		if (FlxRandom.chanceRoll(2)) 
		{
			var bullet:EnemyBullet = cast(_bullets.recycle(EnemyBullet), EnemyBullet);
			bullet.shoot(getMidpoint(_point), FlxObject.LEFT);
		}
		
		super.update();
	}
	
	override public function hurt(damage:Float):Void 
	{
		play('hit');
		flicker(0.4);
		Reg.score += 10;
		
		super.hurt(damage);
	}
	
	override public function kill():Void 
	{
		if (!alive) 
		{
			return;
		}
		
		super.kill();
		
		flicker(0);
		Reg.score += 100;
	}
	
	
	
}