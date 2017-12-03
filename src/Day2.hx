using buddy.Should;

class Day2 extends buddy.SingleSuite {
    function new() {
        describe("Day2", {
            it("part1", {
                checksum1(
"5 1 9 5
7 5 3
2 4 6 8").should.be(18);
            });

            it("part2", {
                checksum2(
"5 9 2 8
9 4 7 3
3 8 6 5").should.be(9);
            });
        });
    }

    function checksum(spreadsheet:String, calculateSum:Array<Int>->Int):Int {
        var sum = 0;
        for (row in spreadsheet.split("\n")) {
            var numbers = ~/[ \t]+/g.split(row).map(Std.parseInt);
            sum += calculateSum(numbers);
        }
        return sum;
    }

    function checksum1(spreadsheet:String):Int {
        return checksum(spreadsheet, numbers -> {
            numbers.sort(Reflect.compare);
            return numbers[numbers.length - 1] - numbers[0];
        });
    }

    function checksum2(spreadsheet:String):Int {
        return checksum(spreadsheet, numbers -> {
            for (n1 in numbers) {
                for (n2 in numbers) {
                    if (n1 == n2) {
                        continue;
                    }

                    var fraction = Math.max(n1, n2) / Math.min(n1, n2);
                    if (fraction == Std.int(fraction)) {
                        return Std.int(fraction);
                    }
                }
            }
            return 0;
        });
    }
}
