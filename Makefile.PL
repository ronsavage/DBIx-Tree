use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
(
	($] ge '5.005') ?
	(
		AUTHOR   => 'B Jepson <bjepston@jepstone.net>',
		ABSTRACT => 'Generate a tree from a self-referential database table',
    ) : (),
	clean =>
	{
		FILES => 'blib/* Makefile MANIFEST DBIx-Tree-*'
	},
	dist =>
	{
		COMPRESS => 'gzip',
		SUFFIX   => 'gz'
	},
	DISTNAME  => 'DBIx-Tree',
	NAME      => 'DBIx::Tree',
	PL_FILES  => {},
	PREREQ_PM =>
	{
		Carp        => 1.08,
		DBD::SQLite => 1.31,
		DBI         => 1.612,
		File::Spec  => 3.31,
		File::Temp  => 0.22,
		Test::More  => 0.94,
		Test::Pod   => 1.44,
	},
	VERSION_FROM => 'lib/DBIx/Tree.pm',
);
