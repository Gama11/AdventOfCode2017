import util.IntMath;
using buddy.Should;
using Lambda;

class Day13 extends buddy.SingleSuite {
    function new() {
        describe("Day13", {
            var input =
"0: 3
1: 2
4: 4
6: 4";

            it("part1", {
                calculateTripSeverity(input).should.be(24);
            });

            it("part2", {
                findMinimumDelay(input).should.be(10);
            });
        });
    }

    function parseInput(input:String):Array<Scanner> {
        var scanners = [];
        var maxDepth = 0;
        for (line in input.split("\n")) {
            var properties = line.split(": ").map(Std.parseInt);
            var depth = properties[0];
            var range = properties[1];
            scanners[depth] = {depth: depth, range: range};

            maxDepth = IntMath.max(maxDepth, depth);
        }
        return scanners;
    }

    function findScannerCollisions(scanners:Array<Scanner>, delay:Int = 0):Array<Scanner> {
        var collisions = [];
        for (depth in 0...scanners.length + 1) {
            var scanner = scanners[depth];
            var time = depth + delay;
            if (scanner != null && calculateScannerPosition(time, scanner.range) == 0) {
                collisions.push(scanner);
            }
        }
        return collisions;
    }

    function calculateScannerPosition(time:Int, range:Int):Int {
        var maxPosition = range - 1;
        var rounds = Std.int(time / maxPosition);
        var steps = time % maxPosition;
        return if (rounds % 2 == 0) steps else maxPosition - steps;
    }

    function calculateTripSeverity(input:String):Int {
        return findScannerCollisions(parseInput(input))
            .map(scanner -> scanner.depth * scanner.range)
            .fold((a, b) -> a + b, 0);
    } 

    function findMinimumDelay(input:String):Int {
        var scanners = parseInput(input);
        var delay = 0;
        while (true) {
            if (findScannerCollisions(scanners, delay).length == 0) {
                return delay;
            }
            delay++;
        } 
    }
}

typedef Scanner = {
    final depth:Int;
    final range:Int;
}
