use ExtUtils::MakeMaker;

require 5.006001;

do "mkheader";

WriteMakefile(
    'NAME'		=> 'Lingua::HE::MacHebrew',
    'VERSION_FROM'	=> 'MacHebrew.pm',
    'ABSTRACT_FROM'	=> 'MacHebrew.pm',
    'AUTHOR'		=> 'SADAHIRO Tomoyuki <SADAHIRO@cpan.org>',
    clean =>  {FILES=> 'fmmache.h tomache.h'},
);

