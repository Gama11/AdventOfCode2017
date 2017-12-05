using buddy.Should;

class Day5 extends buddy.SingleSuite {
    function new() {
        describe("Day5", {
            it("part1", {
                countJumpsUntilExit("0 3 0 1 -3").should.be(5);
            });
        });
    }

    function countJumpsUntilExit(input:String):Int {
        var maze = ~/[ \t\n]/g.split(input).map(Std.parseInt);
        var i = 0;
        var jumps = 0;
        while (i >= 0 && i < maze.length) {
            var offset = maze[i];
            maze[i]++;
            i += offset;
            jumps++;
        }
        return jumps;
    }
}

