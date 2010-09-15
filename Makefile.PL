use ExtUtils::MakeMaker qw(prompt WriteMakefile);
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
  AUTHOR => 'Brian Jepson (bjepson@jepstone.net)',
  NAME	=> 'DBIx::Tree',
  VERSION_FROM => 'Tree.pm', # finds $VERSION
  PREREQ_PM    => {
      'DBD::mysql'  => '0',
  }
);

$connstr = prompt ("DBI Connection String?", "DBI:mysql:test");
$userid  = prompt ("User ID?", "");
$passwd  = prompt ("Password?", "");

open(PWD, ">PWD") || die "Could not open PWD for writing!";
print PWD $connstr, "\n";
print PWD $userid, "\n";
print PWD $passwd, "\n";
