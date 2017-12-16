import util.IntMath;
import utest.Assert;
using buddy.Should;
using Lambda;

class Day10 extends buddy.SingleSuite {
    function new() {
        describe("Day10", {
            it("part1", {
                var a = [0, 1, 2, 3, 4];
                reversePartition(a, 4, 1);
                Assert.same([0, 4, 2, 3, 1], a);

                Assert.same([3, 4, 2, 1, 0], knot(5, [3, 4, 1, 5], 1));
                multiplyFirstTwoElements([3, 4, 2, 1, 0]).should.be(12);
            });

            it("part2", {
                knotHash("").should.be("a2582a3a0e66e6e86e3812dcb672a272");
                knotHash("AoC 2017").should.be("33efeb34ea91902bb2f59c9920caa6cd");
                knotHash("1,2,3").should.be("3efbe78a8d82f29979031a4aa0b16a9d");
                knotHash("1,2,4").should.be("63960835bcdc130f0b66d7ff4f6a5a8e");
            });
        });
    }

    static function reversePartition(a:Array<Int>, lo:Int, hi:Int) {
        function iterateRange(f:(index:Int)->Void) {
            var length = IntMath.abs(hi - lo + 1);
            if (lo > hi) {
                length = a.length - length;
            }

            for (i in 0...length) {
                f((lo + i) % a.length);
            }
        }

        var partition = [];
        iterateRange(index -> partition.push(a[index]));

        partition.reverse();

        var i = 0;
        iterateRange(index -> a[index] = partition[i++]);
    }

    static function knot(listSize:Int, lengths:Array<Int>, rounds:Int):Array<Int> {
        var position = 0;
        var skipSize = 0;
        var list = [for (i in 0...listSize) i];

        for (i in 0...rounds) {
            for (length in lengths) {
                if (length > 1) {
                    reversePartition(list, position, (position + length - 1) % listSize);
                }
                position = (position + length + skipSize) % listSize;
                skipSize++;
            }
        }

        return list;
    }

    function multiplyFirstTwoElements(a:Array<Int>):Int {
        return a[0] * a[1];
    }

    public static function knotHash(input:String):String {
        var lengths = input.split("")
            .map(char -> char.charCodeAt(0))
            .concat([17, 31, 73, 47, 23]);
        var sparseHash = knot(256, lengths, 64);
        var denseHash = [];
        for (i in 0...16) {
            denseHash[i] = [for (j in 0...16) sparseHash[i * 16 + j]].fold((a, b) -> a ^ b, 0);
        }
        return denseHash.map(StringTools.hex.bind(_, 2)).map(s -> s.toLowerCase()).join("");
    }
}
