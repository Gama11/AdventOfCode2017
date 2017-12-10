using buddy.Should;

class Day10 extends buddy.SingleSuite {
    function new() {
        describe("Day10", {
            it("part1", {
                function assertEquals(a:Array<Int>, b:Array<Int>) {
                    for (i in 0...a.length) {
                        a[i].should.be(b[i]);
                    }
                }
                
                var a = [0, 1, 2, 3, 4];
                reversePartition(a, 4, 1);
                assertEquals(a, [0, 4, 2, 3, 1]);

                assertEquals(knotHash(5, "3,4,1,5"), [3, 4, 2, 1, 0]);
                multiplyFirstTwoElements([3, 4, 2, 1, 0]).should.be(12);
            });
        });
    }

    function reversePartition(a:Array<Int>, lo:Int, hi:Int) {
        function iterateRange(f:(index:Int)->Void) {
            var length = Std.int(Math.abs(hi - lo + 1));
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

    function knotHash(listSize:Int, lengths:String):Array<Int> {
        var position = 0;
        var skipSize = 0;
        var list = [for (i in 0...listSize) i];

        for (length in lengths.split(",").map(Std.parseInt)) {
            if (length > 1) {
                reversePartition(list, position, (position + length - 1) % listSize);
            }
            position = (position + length + skipSize) % listSize;
            skipSize++;
        }

        return list;
    }

    function multiplyFirstTwoElements(a:Array<Int>):Int {
        return a[0] * a[1];
    }
}
