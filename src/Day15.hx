using buddy.Should;
using util.StringTools;
using StringTools;
using haxe.Int64;

class Day15 extends buddy.SingleSuite {
    function new() {
        describe("Day15", {
            it("part1", {
                calculateJudgeCount(65, 8921).should.be(588);
            });
        });
    }

    function calculateJudgeCount(seedA:Int, seedB:Int):Int {
        inline function toBinary(n:Int64) {
            return n.toInt().toBinary().lpad("0", 16).substr(-16);
        }

        var valueA:Int64 = seedA;
        var valueB:Int64 = seedB;

        var count = 0;
        for (i in 0...40000000) {
            valueA = (valueA * 16807) % 2147483647;
            valueB = (valueB * 48271) % 2147483647;
            
            if (toBinary(valueA) == toBinary(valueB)) {
                count++;
            }
        }
        return count;
    }
}
