using buddy.Should;

class Day2 extends buddy.SingleSuite {
    function new() {
        describe("Day1", {
            it("part1", {
                checksum(
"5 1 9 5
7 5 3
2 4 6 8").should.be(18);
            });
        });
    }

    function checksum(spreadsheet:String) {
        var sum = 0;
        for (row in spreadsheet.split("\n")) {
            var numbers = ~/\s+/g.split(row).map(Std.parseInt);
            numbers.sort(Reflect.compare);
            var smallest = numbers[0];
            var largest = numbers[numbers.length - 1];
            sum += largest - smallest;
        }
        return sum;
    }
}