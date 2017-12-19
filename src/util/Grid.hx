package util;

class Point {
    public final x:Int;
    public final y:Int;

    public inline function new(x, y) {
        this.x = x;
        this.y = y;
    }

    public function hashCode():Int {
        return x + 10000 * y;
    }

    public inline function add(point:Point):Point {
        return new Point(x + point.x, y + point.y);
    }

    public function distanceTo(point:Point):Int {
        return IntMath.abs(x - point.x) + IntMath.abs(y - point.y);
    }

    public inline function equals(point:Point):Bool {
        return x == point.x && y == point.y;
    }

    public function isHorizontal():Bool {
        return Math.abs(x) > 0;
    }

    public function isVertical():Bool {
        return Math.abs(y) > 0;
    }

    function toString() {
        return '($x, $y)';
    }
}

class Movement {
    public static final Left = new Point(-1, 0);
    public static final Up = new Point(0, -1);
    public static final Down = new Point(0, 1);
    public static final Right = new Point(1, 0);
}
