
BEGIN { $| = 1; print "1..40\n"; }
END {print "not ok 1\n" unless $loaded;}

use Lingua::HE::MacHebrew ();
$loaded = 1;
print "ok 1\n";

####

print 1
   && "" eq Lingua::HE::MacHebrew::encode("")
   && "" eq Lingua::HE::MacHebrew::decode("")
   && "Perl" eq Lingua::HE::MacHebrew::encode("Perl")
   && "Perl" eq Lingua::HE::MacHebrew::decode("Perl")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$ampLR = "\x{202D}\x2B\x{202C}";
$ampRL = "\x{202E}\x2B\x{202C}";

print $ampLR eq Lingua::HE::MacHebrew::decode("\x2B")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $ampRL eq Lingua::HE::MacHebrew::decode("\xAB")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x2B" eq Lingua::HE::MacHebrew::encode($ampLR)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xAB" eq Lingua::HE::MacHebrew::encode($ampRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{C4}" eq Lingua::HE::MacHebrew::decode("\x80")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x80" eq Lingua::HE::MacHebrew::encode("\x{C4}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{5EA}" eq Lingua::HE::MacHebrew::decode("\xFA")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xFA" eq Lingua::HE::MacHebrew::encode("\x{5EA}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$longEnc = "\x24\x20\x28\x29";
$longUni = "\x{202D}\x{0024}\x{0020}\x{0028}\x{0029}\x{202C}";

print $longUni eq Lingua::HE::MacHebrew::decode($longEnc)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print $longEnc eq Lingua::HE::MacHebrew::encode($longUni)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\0" eq Lingua::HE::MacHebrew::encode("\0")
   && "\0" eq Lingua::HE::MacHebrew::decode("\0")
   && "\cA" eq Lingua::HE::MacHebrew::encode("\cA")
   && "\cA" eq Lingua::HE::MacHebrew::decode("\cA")
   && "\t" eq Lingua::HE::MacHebrew::encode("\t")
   && "\t" eq Lingua::HE::MacHebrew::decode("\t")
   && "\x7F" eq Lingua::HE::MacHebrew::encode("\x7F")
   && "\x7F" eq Lingua::HE::MacHebrew::decode("\x7F")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\n" eq Lingua::HE::MacHebrew::encode("\n")
   && "\n" eq Lingua::HE::MacHebrew::decode("\n")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "\r" eq Lingua::HE::MacHebrew::encode("\r")
   && "\r" eq Lingua::HE::MacHebrew::decode("\r")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && "0123456789" eq Lingua::HE::MacHebrew::encode("0123456789")
   && "0123456789" eq Lingua::HE::MacHebrew::decode("0123456789")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

#####

$macDigitRL = "\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9"; # RL only
$uniDigit   = "\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39";
$uniDigitRL = "\x{202E}$uniDigit\x{202C}";

print "0123456789" eq Lingua::HE::MacHebrew::encode($uniDigit)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print 1
   && $uniDigitRL eq Lingua::HE::MacHebrew::decode($macDigitRL)
   && $macDigitRL eq Lingua::HE::MacHebrew::encode($uniDigitRL)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# round-trip convetion for single-character strings

$allchar = map chr, 0..255;
print $allchar eq Lingua::HE::MacHebrew::encode(Lingua::HE::MacHebrew::decode($allchar))
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$NG = 0;
for ($char = 0; $char <= 255; $char++) {
    $bchar = chr $char;
    $uchar = Lingua::HE::MacHebrew::encode(Lingua::HE::MacHebrew::decode($bchar));
    $NG++ unless $bchar eq $uchar;
}
print $NG == 0
   ? "ok" : "not ok", " ", ++$loaded, "\n";

# to be downgraded on decoding.
print "\x{C4}" eq Lingua::HE::MacHebrew::decode("\x{80}")
   && "\x{C4}" eq Lingua::HE::MacHebrew::decode(pack 'U', 0x80)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x30" eq Lingua::HE::MacHebrew::encode("\x30")
   && "\x30" eq Lingua::HE::MacHebrew::encode("\x{202D}\x30") # with LRO
   && "\xB0" eq Lingua::HE::MacHebrew::encode("\x{202E}\x30") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x39" eq Lingua::HE::MacHebrew::encode("\x39")
   && "\x39" eq Lingua::HE::MacHebrew::encode("\x{202D}\x39") # with LRO
   && "\xB9" eq Lingua::HE::MacHebrew::encode("\x{202E}\x39") # with RLO
   ? "ok" : "not ok", " ", ++$loaded, "\n";

$hexNCR = sub { sprintf("&#x%x;", shift) };
$decNCR = sub { sprintf("&#%d;" , shift) };

print "a\xC7" eq Lingua::HE::MacHebrew::encode
	(pack 'U*', 0x100ff, 0x61, 0x3042, 0xFB4B)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "a\xC7" eq Lingua::HE::MacHebrew::encode
	(\"", pack 'U*', 0x100ff, 0x61, 0x3042, 0xFB4B)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "?a?\xC7" eq Lingua::HE::MacHebrew::encode
	(\"?", pack 'U*', 0x100ff, 0x61, 0x3042, 0xFB4B)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#x100ff;a&#x3042;\xC7" eq Lingua::HE::MacHebrew::encode
	($hexNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0xFB4B)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "&#65791;a&#12354;\xC7" eq Lingua::HE::MacHebrew::encode
	($decNCR, pack 'U*', 0x100ff, 0x61, 0x3042, 0xFB4B)
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{5F2}\x{5B7}" eq Lingua::HE::MacHebrew::decode("\x81")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x81" eq Lingua::HE::MacHebrew::encode("\x{5F2}\x{5B7}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x81\x81\x81" eq Lingua::HE::MacHebrew::encode
	("\x{5F2}\x{5B7}\x{5F2}\x{5B7}\x{5F2}\x{5B7}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x81" eq Lingua::HE::MacHebrew::encode("\x{FB1F}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{F86A}\x{05DC}\x{05B9}" eq Lingua::HE::MacHebrew::decode("\xC0")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xC0" eq Lingua::HE::MacHebrew::encode("\x{F86A}\x{05DC}\x{05B9}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{05B8}\x{F87F}" eq Lingua::HE::MacHebrew::decode("\xDE")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xDE" eq Lingua::HE::MacHebrew::encode("\x{05B8}\x{F87F}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xDE\xDE\xDE" eq Lingua::HE::MacHebrew::encode
	("\x{05B8}\x{F87F}\x{05B8}\x{F87F}\x{05B8}\x{F87F}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\x{05B8}" eq Lingua::HE::MacHebrew::decode("\xCB")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xCB" eq Lingua::HE::MacHebrew::encode("\x{05B8}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";

print "\xCB\xDE\xCB\xC8" eq Lingua::HE::MacHebrew::encode
	("\x{05B8}\x{05B8}\x{F87F}\x{05B8}\x{FB35}")
   ? "ok" : "not ok", " ", ++$loaded, "\n";


