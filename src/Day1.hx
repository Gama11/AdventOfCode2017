using buddy.Should;

class Day1 extends buddy.SingleSuite {
    function new() {
        describe("Day1", {
            it("tests", {
                sum("1122").should.be(3);
                sum("1111").should.be(4);
                sum("1234").should.be(0);
                sum("91212129").should.be(9);
            });
        });
    }

    function sum(input:String):Int {
        return 0;
    }
}
