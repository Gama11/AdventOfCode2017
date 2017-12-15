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
        var count = 0;
        generatePairs(seedA, seedB, 40000000, (a, b) -> {
            if (a == b) {
                count++;
            }
        });
        return count;
    }

    function generatePairs(seedA:Int, seedB:Int, amount:Int, onGenerate:(a:String, b:String)->Void) {
        inline function toBinary(n:Int64) {
            return n.toInt().toBinary().lpad("0", 16).substr(-16);
        }

        var a:Int64 = seedA;
        var b:Int64 = seedB;
        for (i in 0...amount) {
            a = (a * 16807) % 2147483647;
            b = (b * 48271) % 2147483647;
            onGenerate(toBinary(a), toBinary(b));
        }
    }
}
