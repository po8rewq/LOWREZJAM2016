package ent;

import managers.ColorManager;

class Hero extends Entity
{

  var canJump = true;
  public var baseY : Float;

  public var activeColor (default, set): Color;

  public function new(x:Float, y: Float)
  {
    super(Hero, x, y);

    feets = 6;
    height = 6;
  }

  override function getSpeed(anim:String) {
		return switch( anim ) {
  		case "run": 5;
  		default: super.getSpeed(anim);
		}
	}

  override function update(dt:Float)
  {
		super.update(dt);

    var moving = false;

    if( game.key.left )
    {
			spr.scaleX = -1;
			moveX( -0.12 * dt);
			moving = true;
		}
		if( game.key.right )
    {
			spr.scaleX = 1;
			moveX(0.12 * dt);
			moving = true;
		}

    switch( state )
    {
      case Stand:
  			// if( anim == "default" && !moving && randt() < 0.03 ) play("blink", function() play("default")); // megaman style
  			if( moving )
  				play("run");
        else if( anim == "run" )
  				play("default");
      case Jump:
			  if( acc < 0 && !game.key.jump )
				   acc *= Math.pow(0.9, dt);
      default:
    }

    if( state == Stand && game.key.jump && canJump )
    {
			state = Jump;
			canJump = false;
			acc = -0.38;
		}

    if( Math.abs(y - baseY) > 5 ) {
			if( baseY < y ) baseY = y - 5 else baseY = y + 5;
		}

    if( game.level.getCollide(x, y - 0.1) == Die && y - Std.int(y-0.1) > 0.8 )
			destroy();
  }

  override function set_state(s:Entity.State) {
		switch( s )
    {
  		case Stand:
  			accX = 0;
  			baseY = y;
  			if( acc == 0 ) canJump = true;
  		default:
		}
		return super.set_state(s);
	}

  public function set_activeColor(col: Color): Color
  {//trace(col);
    activeColor = col; return col;
  }

  override function hit(by:Entity)
  { // life--
    switch(by)
    {
      default: destroy();
    }
  }

  public function restart() {
		add();
		// life = game.hearts.length;
		acc = 0;
		accX = 0;
		// lock = false;
		gravity = true;
		state = Jump;
		// hitRecovery = 1;
	}

}
