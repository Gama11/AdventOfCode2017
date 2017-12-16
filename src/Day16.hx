using buddy.Should;

class Day16 extends buddy.SingleSuite {
    function new() {
        describe("Day16", {
            it("part1", {
                dance(parse("s1,x3/4,pe/b"), 5).should.be("baedc");
            });
        });
    }

    function parse(input:String):Array<DanceMove> {
        return input.split(",").map(move -> {
            var regex = ~/([sxp])(\w+)(?:\/(\w+))?/;
            regex.match(move);

            switch (regex.matched(1)) {
                case "s":
                    Spin(Std.parseInt(regex.matched(2)));
                case "x":
                    Exchange(Std.parseInt(regex.matched(2)),
                        Std.parseInt(regex.matched(3)));
                case "p":
                    Partner(regex.matched(2), regex.matched(3));
                case _:
                    null;
            }
        });
    }

    function dance(moves:Array<DanceMove>, programs:Int):String {
        var programs = [for (i in 0...programs) String.fromCharCode(97 + i)];
        for (move in moves) {
            switch (move) {
                case Spin(count):
                    for (i in 0...count) {
                        programs.unshift(programs.pop());
                    }

                case Exchange(a, b):
                    swap(programs, a, b);

                case Partner(a, b):
                    swap(programs, programs.indexOf(a), programs.indexOf(b));
            }
        }
        return programs.join("");
    }

    function swap<T>(a:Array<T>, index1:Int, index2:Int) {
        var temp = a[index1];
        a[index1] = a[index2];
        a[index2] = temp;
    }
}

enum DanceMove {
    Spin(count:Int);
    Exchange(a:Int, b:Int);
    Partner(a:String, b:String);
}
