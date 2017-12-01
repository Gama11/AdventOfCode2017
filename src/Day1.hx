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
        var a = (input : CircularAccess);
        for (i in 0...input.length) {
            if (a[i] == a[i + 1]) {
                sum += Std.parseInt(a[i]);
            }
        }
        return sum;
    }

    function sum2(input:String):Int {
        return 0;
    }
}

abstract CircularAccess(String) from String {
    @:arrayAccess function get(i:Int):String {
        i %= this.length;
        return this.charAt(i);
    }
}
