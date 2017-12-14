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

    function toString() {
        return '($x, $y)';
    }
}
