package Lingua::HE::MacHebrew;

require 5.006001;

use strict;

require Exporter;
require DynaLoader;

our $VERSION = '0.10';
our @ISA = qw(Exporter DynaLoader);
our @EXPORT = qw(decodeMacHebrew encodeMacHebrew);
our @EXPORT_OK = qw(decode encode);

bootstrap Lingua::HE::MacHebrew $VERSION;
1;
__END__

=head1 NAME

Lingua::HE::MacHebrew - transcoding between Mac OS Hebrew encoding and Unicode

=head1 SYNOPSIS

(1) using function names exported by default:

    use Lingua::HE::MacHebrew;
    $wchar = decodeMacHebrew($octet);
    $octet = encodeMacHebrew($wchar);

(2) using function names exported on request:

    use Lingua::HE::MacHebrew qw(decode encode);
    $wchar = decode($octet);
    $octet = encode($wchar);

(3) using function names fully qualified:

    use Lingua::HE::MacHebrew ();
    $wchar = Lingua::HE::MacHebrew::decode($octet);
    $octet = Lingua::HE::MacHebrew::encode($wchar);

   # $wchar : a string in Perl's Unicode format
   # $octet : a string in Mac OS Hebrew encoding

=head1 DESCRIPTION

This module provides decoding from/encoding to Mac OS Hebrew encoding
(denoted MacHebrew hereafter).

=head2 Features

=over 4

=item bidi support

Functions provided here should cope with Unicode accompanied
with some directional formatting codes: i.e.
C<PDF> (or C<U+202C>), C<LRO> (or C<U+202D>), and C<RLO> (or C<U+202E>).

=item expansion/contraction

e.g. C<decode("\xC0")> returns C<"\x{F86A}\x{05DC}\x{05B9}">
and C<encode("\x{F86A}\x{05DC}\x{05B9}")> returns C<"\xC0">.

=back

=head2 Functions

=over 4

=item C<$wchar = decode($octet)>

=item C<$wchar = decodeMacHebrew($octet)>

Converts MacHebrew to Unicode.

C<decodeMacHebrew()> is an alias for C<decode()> exported by default.

=item C<$octet = encode($wchar)>

=item C<$octet = encode($handler, $wchar)>

=item C<$octet = encodeMacHebrew($wchar)>

=item C<$octet = encodeMacHebrew($handler, $wchar)>

Converts Unicode to MacHebrew.

C<encodeMacHebrew()> is an alias for C<encode()> exported by default.

If the C<$handler> is not specified,
any character that is not mapped to MacHebrew is deleted;
if the C<$handler> is a code reference,
a string returned from that coderef is inserted there.
if the C<$handler> is a scalar reference,
a string (a C<PV>) in that reference (the referent) is inserted there.

The 1st argument for the C<$handler> coderef is
the Unicode code point (integer) of the unmapped character.

E.g.

   sub hexNCR { sprintf("&#x%x;", shift) } # hexadecimal NCR
   sub decNCR { sprintf("&#%d;" , shift) } # decimal NCR

   print encodeMacHebrew("ABC\x{100}\x{10000}");
   # "ABC"

   print encodeMacHebrew(\"", "ABC\x{100}\x{10000}");
   # "ABC"

   print encodeMacHebrew(\"?", "ABC\x{100}\x{10000}");
   # "ABC??"

   print encodeMacHebrew(\&hexNCR, "ABC\x{100}\x{10000}");
   # "ABC&#x100;&#x10000;"

   print encodeMacHebrew(\&decNCR, "ABC\x{100}\x{10000}");
   # "ABC&#256;&#65536;"

=back

=head1 CAVEAT

Sorry, the author is not working on a Mac OS.
Please let him know if you find something wrong.

B<Maybe bug?>: The (default) paragraph direction is not resolved.
Does Mac always surround by C<LRO>..C<PDF> or C<RLO>..C<PDF>
the characters with bidirectional type to be overridden?

=head1 AUTHOR

SADAHIRO Tomoyuki <SADAHIRO@cpan.org>

Copyright(C) 2003-2011, SADAHIRO Tomoyuki. Japan. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

=over 4

=item Map (external version) from Mac OS Hebrew character set
to Unicode 2.1 and later (version: c02 2005-Apr-05)

L<http://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/HEBREW.TXT>

=item Registry (external version) of Apple use of Unicode corporate-zone
characters (version: c03 2005-Apr-04)

L<http://www.unicode.org/Public/MAPPINGS/VENDORS/APPLE/CORPCHAR.TXT>

=item The Bidirectional Algorithm

L<http://www.unicode.org/reports/tr9/>

=back

=cut
