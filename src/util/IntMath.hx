package util;

class IntMath {
    public static inline function abs(v:Int) {
        return if (v < 0) -v else v;
    }

    public static inline function max(a:Int, b:Int) {
        return if (a < b) b else a;
    }
}
