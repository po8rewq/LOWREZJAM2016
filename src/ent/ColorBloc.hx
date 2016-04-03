package ent;

import managers.ColorManager;

class ColorBloc extends Entity
{
  public var active : Bool;
  public var color(default, null) : Color;

  public function new(k, x, y, c)
  {
    super(k,x,y);
    color = c;
  }

  override function init()
  {
    active = false;
    gravity = false;
    spr.alpha = 0.3;
  }

  override function update(dt: Float)
  {
    super.update(dt);

    var hc = game.hero.activeColor;
    if( active && hc != color )
    {
      active = false;
      game.level.setCollide(Std.int(x), Std.int(y-0.5), No);
      spr.alpha = 0.3;
    }
    else if( !active && hc == color )
    {
      active = true;
      game.level.setCollide(Std.int(x), Std.int(y-0.5), Full);
      spr.alpha = 1;
    }
  }

  override function remove()
  {
    super.remove();
    if(active)
      game.level.setCollide(Std.int(x), Std.int(y-0.5), No);
  }

}
