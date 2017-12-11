import util.IntMath;
using buddy.Should;

class Day11 extends buddy.SingleSuite {
    function new() {
        describe("Day11", {
            it("part1", {
                getSteps(walkPath("ne,ne,ne")).should.be(3);
                getSteps(walkPath("ne,ne,sw,sw")).should.be(0);
                getSteps(walkPath("ne,ne,s,s")).should.be(2);
                getSteps(walkPath("se,sw,se,sw,sw")).should.be(3);

                getSteps(walkPath("n,ne")).should.be(2);
                getSteps(walkPath("n,ne,se")).should.be(2);
            });
        });
    }

    function getSteps(position:Point):Int {
        var absX = IntMath.abs(position.x);
        var absY = IntMath.abs(position.y);

        if (position.x > 0 && position.y < 0 || position.x < 0 && position.y > 0) {
            return IntMath.max(absX, absY);
        }
        return absX + absY;
    }

    function walkPath(path:String, ?onStep:Point->Void):Point {
        var x = 0;
        var y = 0;

        for (step in path.split(",")) {
            switch (step) {
                case "ne": x++;
                case "sw": x--;

                case "n": y++;
                case "s": y--;

                case "nw": x--; y++;
                case "se": x++; y--;

                case _:
            }

            if (onStep != null) {
                onStep({x: x, y: y});
            }
        }

        return {x: x, y: y};
    }

    function getFurthestSteps(path:String):Int {
        var maxSteps = 0;
        walkPath(path, point -> {
            maxSteps = IntMath.max(maxSteps, getSteps(point));
        });
        return maxSteps;
    }
}

typedef Point = {
    final x:Int;
    final y:Int;
}
