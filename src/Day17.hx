using buddy.Should;

class Day17 extends buddy.SingleSuite {
    function new() {
        describe("Day17", {
            it("part1", {
                getValueAfter2017(spinlock(3)).should.be(638);
            });
        });
    }

    function spinlock(stride:Int):Array<Int> {
        var buffer = [0];
        var position = 0;
        for (i in 0...2017) {
            position = (position + stride) % buffer.length;
            buffer.insert(position + 1, i + 1);
            position++;
        }
        return buffer;
    }

    function getValueAfter2017(buffer:Array<Int>):Int {
        return buffer[(buffer.indexOf(2017) + 1) % buffer.length];
    }

    function spinlock2(stride:Int):Int {
        var bufferLength = 1;
        var position = 0;
        var valueAfterZero = -1;
        for (i in 0...50000000) {
            position = (position + stride) % bufferLength;
            bufferLength++;
            position++;
            if (position == 1) {
                valueAfterZero = i + 1;
            }
        }
        return valueAfterZero;
    }
}
