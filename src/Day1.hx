using buddy.Should;

class Day1 extends buddy.SingleSuite {
    function new() {
        describe("Day1", {
            it("part1", {
                sum1("1122").should.be(3);
                sum1("1111").should.be(4);
                sum1("1234").should.be(0);
                sum1("91212129").should.be(9);
            });

            it("part2", {
                sum2("1212").should.be(6);
                sum2("1221").should.be(0);
                sum2("123425").should.be(4);
                sum2("123123").should.be(12);
                sum2("12131415").should.be(4);
            });
        });
    }

    function sum(input:String, step:Int):Int {
        var sum = 0;
        var a = (input : CircularAccess);
        for (i in 0...input.length) {
            if (a[i] == a[i + step]) {
                sum += Std.parseInt(a[i]);
            }
        }
        return sum;
    }

    function sum1(input:String):Int
        return sum(input, 1);

    function sum2(input:String):Int
        return sum(input, Std.int(input.length / 2));
}

abstract CircularAccess(String) from String {
    @:arrayAccess function get(i:Int):String {
        return this.charAt(i % this.length);
    }
}
