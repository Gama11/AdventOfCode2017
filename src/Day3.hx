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
        });
    }

    function steps(square:Int):Int {
        return getPosition(square).distanceTo(new Point(0, 0));
    }

    function getPosition(square:Int):Point {
        var opCounter = 0;
        var step = 0;
        var ops = [
            new Point(1, 0),  // right
            new Point(0, -1), // up
            new Point(-1, 0), // left
            new Point(0, 1)   // down
        ];

        var x = 0;
        var y = 0;
        for (i in 1...square) {
            var op = ops[opCounter % ops.length];
            x += op.x;
            y += op.y;
            step++;

            var stepsPerOp = Std.int(opCounter / 2) + 1;
            if (step >= stepsPerOp) {
                opCounter++;
                step = 0;
            }
        }
        return new Point(x, y);
    }
}

class Point {
    public final x:Int;
    public final y:Int;

    public function new(x, y) {
        this.x = x;
        this.y = y;
    }

    public function distanceTo(point:Point):Int {
        return Std.int(Math.abs(x - point.x)) + Std.int(Math.abs(y - point.y));
    }
}
