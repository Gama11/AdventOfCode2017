using buddy.Should;

class Day11 extends buddy.SingleSuite {
    function new() {
        describe("Day11", {
            it("part1", {
                getDistanceToOrigin("ne,ne,ne").should.be(3);
                getDistanceToOrigin("ne,ne,sw,sw").should.be(0);
                getDistanceToOrigin("ne,ne,s,s").should.be(2);
                getDistanceToOrigin("se,sw,se,sw,sw").should.be(3);

                getDistanceToOrigin("n,ne").should.be(2);
                getDistanceToOrigin("n,ne,se").should.be(2);
            });
        });
    }

    function getDistanceToOrigin(path:String):Int {
        var position = findHexagonPosition(path);
        var absX = Std.int(Math.abs(position.x));
        var absY = Std.int(Math.abs(position.y));

        if (position.x > 0 && position.y < 0 || position.x < 0 && position.y > 0) {
            return Std.int(Math.max(absX, absY));
        }
        return absX + absY;
    }

    function findHexagonPosition(path:String):Point {
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
        }

        return {x: x, y: y};
    }
}

typedef Point = {
    final x:Int;
    final y:Int;
}
