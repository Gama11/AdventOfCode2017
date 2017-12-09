using buddy.Should;

class Day9 extends buddy.SingleSuite {
    function new() {
        describe("Day9", {
            it("part1", {
                calculateStreamScore("{}").should.be(1);
                calculateStreamScore("{{{}}}").should.be(6);
                calculateStreamScore("{{},{}}").should.be(5);
                calculateStreamScore("{{{},{},{{}}}}").should.be(16);
                calculateStreamScore("{<a>,<a>,<a>,<a>}").should.be(1);
                calculateStreamScore("{{<ab>},{<ab>},{<ab>},{<ab>}}").should.be(9);
                calculateStreamScore("{{<!!>},{<!!>},{<!!>},{<!!>}}").should.be(9);
                calculateStreamScore("{{<a!>},{<a!>},{<a!>},{<ab>}}").should.be(3);
            });
        });
    }

    function calculateStreamScore(stream:String):Int {
        var level = 0;
        var score = 0;
        var inGarbage = false;
        var i = 0;
        while (i < stream.length) {
            switch (stream.charAt(i)) {
                case "{" if (!inGarbage):
                    level++;
                case "}" if (!inGarbage):
                    score += level;
                    level--;
                case "<":
                    inGarbage = true;
                case ">":
                    inGarbage = false;
                case "!" if (inGarbage):
                    i++;
                case _:
            }
            i++;
        }
        return score;
    }
}
