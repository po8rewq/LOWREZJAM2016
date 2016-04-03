package ent;

import managers.ColorManager;

class Switch extends Entity
{
  public var isActive : Bool;
  public var color(default, null) : Color;

  public function new(k, x, y, c)
  {
    super(k,x,y);
    color = c;
  }

  override function init()
  {
    gravity = false;
    feets = 5;
    height = 5;
  }

  override function update(dt:Float)
  {
    super.update(dt);

    // cas de la coupure
    if(isActive && game.hero.activeColor != color)
    {
      isActive = false;
      spr.alpha = 1;
    }
    else if( !isActive && (game.hero.checkHit(this) || game.hero.activeColor == color) )
    {
      isActive = true;
      spr.alpha = .3;
      game.hero.activeColor = color;
    }
  }

}
