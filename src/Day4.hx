using buddy.Should;
using StringTools;

class Day4 extends buddy.SingleSuite {
    function new() {
        describe("Day4", {
            it("part1", {
                isPassphraseValid("aa bb cc dd ee").should.be(true);
                isPassphraseValid("aa bb cc dd aa").should.be(false);
                isPassphraseValid("aa bb cc dd aaa").should.be(true);

                getValidPassphraseCount(
"aa bb cc dd ee
aa bb cc dd aa
aa bb cc dd aaa").should.be(2);
            });
        });
    }

    function isPassphraseValid(passphrase:String):Bool {
        passphrase = passphrase.trim();
        var words = new Map<String, Bool>();
        for (word in ~/[ \t]+/g.split(passphrase)) {
            if (words.exists(word)) {
                return false;
            }
            words[word] = true;
        }
        return true;
    }

    function getValidPassphraseCount(passphrases:String):Int {
        return passphrases.split("\n").map(isPassphraseValid).filter(valid -> valid).length;
    }
}
