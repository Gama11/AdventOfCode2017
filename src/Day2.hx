using buddy.Should;

class Day2 extends buddy.SingleSuite {
    function new() {
        describe("Day1", {
            it("part1", {
                checksum1(
"5 1 9 5
7 5 3
2 4 6 8").should.be(18);
            });
        });
    }

    function checksum(spreadsheet:String, calculateSum:Array<Int>->Int):Int {
        var sum = 0;
        for (row in spreadsheet.split("\n")) {
            var numbers = ~/\s+/g.split(row).map(Std.parseInt);
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
}