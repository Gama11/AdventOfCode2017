using buddy.Should;

class Day9 extends buddy.SingleSuite {
    function new() {
        describe("Day9", {
            it("part1", {
                analyzeStream("{}").score.should.be(1);
                analyzeStream("{{{}}}").score.should.be(6);
                analyzeStream("{{},{}}").score.should.be(5);
                analyzeStream("{{{},{},{{}}}}").score.should.be(16);
                analyzeStream("{<a>,<a>,<a>,<a>}").score.should.be(1);
                analyzeStream("{{<ab>},{<ab>},{<ab>},{<ab>}}").score.should.be(9);
                analyzeStream("{{<!!>},{<!!>},{<!!>},{<!!>}}").score.should.be(9);
                analyzeStream("{{<a!>},{<a!>},{<a!>},{<ab>}}").score.should.be(3);
            });

            it("part2", {
                analyzeStream("<>").garbageCharacters.should.be(0);
                analyzeStream("<random characters>").garbageCharacters.should.be(17);
                analyzeStream("<<<<>").garbageCharacters.should.be(3);
                analyzeStream("<{!>}>").garbageCharacters.should.be(2);
                analyzeStream("<!!>").garbageCharacters.should.be(0);
                analyzeStream("<!!!>>").garbageCharacters.should.be(0);
                analyzeStream("<{o\"i!a,<{i<a>").garbageCharacters.should.be(10);
            });
        });
    }

    function analyzeStream(stream:String) {
        var score = 0;
        var garbageCharacters = 0;

        var level = 0;
        var inGarbage = false;
        var i = 0;
        while (i < stream.length) {
            switch [stream.charAt(i), inGarbage] {
                case ["{", false]:
                    level++;
                case ["}", false]:
                    score += level;
                    level--;
                case ["<", false]:
                    inGarbage = true;
                case [">", true]:
                    inGarbage = false;
                case ["!", true]:
                    i++;
                case [_, true]:
                    garbageCharacters++;
                case _:
            }
            i++;
        }

        return {
            score: score,
            garbageCharacters: garbageCharacters
        };
    }
}
