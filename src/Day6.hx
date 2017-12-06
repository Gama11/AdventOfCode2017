using buddy.Should;

class Day6 extends buddy.SingleSuite {
    function new() {
        describe("Day6", {
            it("part1", {
                analyzeRedistribution("0 2 7 0").cycles.should.be(5);
            });

            it("part2", {
                analyzeRedistribution("0 2 7 0").loopSize.should.be(4);
            });
        });
    }

    function analyzeRedistribution(input:String) {
        var banks = ~/[ \t]+/g.split(input).map(Std.parseInt);
        var seenPatterns = [];
        var seenIndex = -1;
        var cycles = 0;

        do {
            seenPatterns.push(banks.join(" "));
            redistribute(getLargestBank(banks), banks);
            cycles++;
            seenIndex = seenPatterns.indexOf(banks.join(" "));
        } while (seenIndex == -1);

        return {
            cycles: cycles,
            loopSize: cycles - seenIndex
        };
    }

    function getLargestBank(banks:Array<Int>):Int {
        var largestBank = 0;
        for (i in 0...banks.length) {
            if (banks[i] > banks[largestBank]) {
                largestBank = i;
            }
        }
        return largestBank;
    }

    function redistribute(bank:Int, banks:Array<Int>) {
        var amount = banks[bank];
        banks[bank] = 0;

        var i = bank;
        do {
            i = (i + 1) % banks.length;
            banks[i]++;
            amount--;
        } while (amount > 0);
    }
}
