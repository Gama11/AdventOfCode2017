import util.Grid;
import util.Grid.Movement.*;
using buddy.Should;

class Day3 extends buddy.SingleSuite {
    function new() {
        describe("Day3", {
            it("getPosition", {
                getPosition(1).x.should.be(0);
                getPosition(1).y.should.be(0);

                getPosition(5).x.should.be(-1);
                getPosition(5).y.should.be(-1);

                getPosition(10).x.should.be(2);
                getPosition(10).y.should.be(1);

                getPosition(23).x.should.be(0);
                getPosition(23).y.should.be(2);
            });

            it("part1", {
                steps(1).should.be(0);
                steps(12).should.be(3);
                steps(23).should.be(2);
                steps(1024).should.be(31);
            });

            it("part2", {
                firstValueLargerThan(5).should.be(10);
                firstValueLargerThan(26).should.be(54);
                firstValueLargerThan(304).should.be(330);
            });
        });
    }

    var straightOperations = [Right, Up, Left, Down];

    var diagonalOperations = [
        new Point(1, 1),
        new Point(1, -1),
        new Point(-1, 1),
        new Point(-1, -1)
    ];

    function steps(square:Int):Int {
        return getPosition(square).distanceTo(new Point(0, 0));
    }

    function getPosition(square:Int):Point {
        var result = null;
        moveInSpiral((index, point) -> {
            result = point;
            return index + 1 < square;
        });
        return result;
    }

    function moveInSpiral(onStep:(index:Int, point:Point)->Bool) {
        var opCounter = 0;
        var step = 0;
        var ops = straightOperations;
        var index = 0;
        var point = new Point(0, 0);

        while (onStep(index, point)) {
            var op = ops[opCounter % ops.length];
            point = point.add(op);
            step++;
            index++;

            var stepsPerOp = Std.int(opCounter / 2) + 1;
            if (step >= stepsPerOp) {
                opCounter++;
                step = 0;
            }
        }
    }

    function firstValueLargerThan(searchValue:Int):Int {
        var points = new haxe.ds.HashMap();
        var ops = [].concat(straightOperations).concat(diagonalOperations);
        var result = 0;
        moveInSpiral((index, point) -> {
            var value = if (index == 0) 1 else 0;
            for (op in ops) {
                var adjacentValue = points.get(point.add(op));
                if (adjacentValue != null) {
                    value += adjacentValue;
                }
            }

            points.set(point, value);
            result = value;
            return value <= searchValue;
        });
        return result;
    }
}
