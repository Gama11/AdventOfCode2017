using buddy.Should;

class Day1 extends buddy.SingleSuite {
    function new() {
        describe("Day1", {
            it("part1", {
                sum("1122").should.be(3);
                sum("1111").should.be(4);
                sum("1234").should.be(0);
                sum("91212129").should.be(9);
            });

            it("part2", {
                sum("1212").should.be(6);
                sum("1221").should.be(0);
                sum("123425").should.be(4);
                sum("123123").should.be(12);
                sum("12131415").should.be(4);
            });
        });
    }

    function sum(input:String):Int {
        var sum = 0;
        var prev = input.charAt(0);
        var indices = [for (i in 1...input.length) i].concat([0]);
        for (i in indices) {
            var c = input.charAt(i);
            if (prev == c) {
                sum += Std.parseInt(c);
            }
            prev = c;
        }
        return sum;
    }

    function sum2(input:String):Int {
        return 0;
    }
}
