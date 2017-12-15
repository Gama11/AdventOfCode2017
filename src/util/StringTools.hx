package util;

class StringTools {
    public static function toBinary(n:Int):String {
        var s = "";
        while (n > 0) {
            s = (if (n % 2 == 0) "0" else "1") + s;
            n = Std.int(n / 2);
        }
        return s;
    }
}