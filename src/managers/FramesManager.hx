package managers;

class FramesManager
{
  public static var frames : Map < String, Map < String, Array<h2d.Tile> > > ;

  /**
   * @params
   *      t
   *      data
   *      offsetX 
   *      nl : true if each kind are on a different line, false otherwise
   */
  public static function initFrames(t : h2d.Tile, data: Array<FData>, ?offsetX: Int = 0, ?nl: Bool = false)
  {
    if(frames == null) frames = new Map();

    var x = offsetX;
		var y = 0;

    for( inf in data )
    {
			var anims = new Map();
			var w = inf.w * 8;
			var h = inf.w * 8;
			if( inf.l == null ) inf.l = ["default", 1];
			for( i in 0...inf.l.length >> 1 )
      {
				var name : String = inf.l[i * 2];
				var count : Int = inf.l[i * 2 + 1];
				var tiles = [];
				var dw = w;
				for( n in 0...count ) {
					if( x + dw > 256 ) {
						x = 0;
						y += h;
					}
					tiles.push(t.sub(x, y, dw, h, -(w >> 1), -h));
					x += dw;
				}
				anims.set(name, tiles);
			}
			frames.set(inf.k.toString(), anims);
      if(nl)
      {
        y+=h;
        x = 0;
      }
		}

  }

}

typedef FData = {
  var k : ent.Kind;
  var w : Int;
  var h : Int;
  @:optional var l : Array<Dynamic>; // default ["default": 1]
}
