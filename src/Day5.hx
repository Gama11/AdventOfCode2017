using buddy.Should;

class Day5 extends buddy.SingleSuite {
    function new() {
        describe("Day5", {
            it("part1", {
                countJumpsUntilExit1("0 3 0 1 -3").should.be(5);
            });

            it("part2", {
                countJumpsUntilExit2("0 3 0 1 -3").should.be(10);
            });
        });
    }

    function countJumpsUntilExit(input:String, getIncrement:(offset:Int)->Int):Int {
        var maze = ~/[ \t\n]/g.split(input).map(Std.parseInt);
        var i = 0;
        var jumps = 0;
        while (i >= 0 && i < maze.length) {
            var offset = maze[i];
            maze[i] += getIncrement(offset);
            i += offset;
            jumps++;
        }
        return jumps;
    }

    function countJumpsUntilExit1(input:String):Int {
        return countJumpsUntilExit(input, offset -> 1);
    }

    function countJumpsUntilExit2(input:String):Int {
        return countJumpsUntilExit(input, offset -> if (offset >= 3) -1 else 1);
    }
}

