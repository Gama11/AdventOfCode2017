import util.IntMath;
using buddy.Should;

class Day13 extends buddy.SingleSuite {
    function new() {
        describe("Day13", {
            it("part1", {
                calculateTripSeverity(
"0: 3
1: 2
4: 4
6: 4"
                ).should.be(24);
            });
        });
    }

    function calculateTripSeverity(input:String):Int {
        var scanners = new Map<Int, Scanner>();
        var maxDepth = 0;
        for (line in input.split("\n")) {
            var properties = line.split(": ").map(Std.parseInt);
            var depth = properties[0];
            var range = properties[1];
            scanners[depth] = {range: range, position: 0, direction: 1};

            maxDepth = IntMath.max(maxDepth, depth);
        }

        var severity = 0;
        for (depth in 0...maxDepth + 1) {
            var scanner = scanners[depth];
            if (scanner != null && scanner.position == 0) {
                severity += depth * scanner.range;
            }

            for (scanner in scanners) {
                scanner.position += scanner.direction;
                if (scanner.position <= 0 || scanner.position >= scanner.range - 1) {
                    scanner.direction *= -1;
                }
            }
            
        }
        return severity;
    }
}

typedef Scanner = {
    final range:Int;
    var position:Int;
    var direction:Int;
}
