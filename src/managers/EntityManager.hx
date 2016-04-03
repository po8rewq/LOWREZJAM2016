package managers;

import ent.*;

class EntityManager
{

  public static function create( k : Kind, x, y ) : Entity
  {
		return switch( k )
    {
			case RBloc:
				new ColorBloc(k, x, y, Red);
			case YBloc:
				new ColorBloc(k, x, y, Yellow);
      case RSwitch:
        new Switch(k, x, y, Red);
      case YSwitch:
        new Switch(k, x, y, Yellow);
      case Dog:
        new Dog(k, x, y);
      case Water:
        new BasicAnim(k, x, y, true);
			default:
				new Entity(k, x, y);
		};
	}

}
