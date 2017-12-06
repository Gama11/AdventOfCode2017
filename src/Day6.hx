using buddy.Should;

class Day6 extends buddy.SingleSuite {
    function new() {
        describe("Day6", {
            it("part1", {
                countRedistributionCycles("0 2 7 0").should.be(5);
            });
        });
    }

    function countRedistributionCycles(input:String):Int {
        var banks = ~/[ \t]+/g.split(input).map(Std.parseInt);
        var seenPatterns = [];
        var cycles = 0;

        do {
            seenPatterns.push(banks.join(" "));
            redistribute(getLargestBank(banks), banks);
            cycles++;
        } while (seenPatterns.indexOf(banks.join(" ")) == -1);

        return cycles;
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
