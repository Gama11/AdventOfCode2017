using buddy.Should;
using haxe.Int64;

class Day15 extends buddy.SingleSuite {
    function new() {
        describe("Day15", {
            it("part1", {
                calculateJudgeCount1(65, 8921).should.be(588);
            });

            it("part2", {
                calculateJudgeCount2(65, 8921).should.be(309);
            });
        });
    }

    function areEqual(a:Int, b:Int):Bool {
        return a & 0xFFFF == b & 0xFFFF;
    }

    function calculateJudgeCount1(seedA:Int, seedB:Int):Int {
        var count = 0;
        var pairs = 0;
        generatePairs(seedA, seedB, (a, b) -> {
            if (areEqual(a, b)) {
                count++;
            }
            pairs++;
            return pairs < 40000000;
        });
        return count;
    }

    function calculateJudgeCount2(seedA:Int, seedB:Int):Int {
        var count = 0;
        var pairs = 0;
        var valuesA = new List();
        var valuesB = new List();

        generatePairs(seedA, seedB, (a, b) -> {
            if (a % 4 == 0) {
                valuesA.add(a);
            }
            if (b % 8 == 0) {
                valuesB.add(b);
            }

            if (valuesA.length > 0 && valuesB.length > 0) {
                if (areEqual(valuesA.pop(), valuesB.pop())) {
                    count++;
                }
                pairs++;
            }

            return pairs < 5000000;
        });
        return count;
    }

    function generatePairs(seedA:Int, seedB:Int, onGenerate:(a:Int, b:Int)->Bool) {
        var a:Int64 = seedA;
        var b:Int64 = seedB;
        while (true) {
            a = (a * 16807) % 2147483647;
            b = (b * 48271) % 2147483647;
            if (!onGenerate(a.toInt(), b.toInt())) {
                break;
            }
        }
    }
}
