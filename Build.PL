use strict;
use warnings;

use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'DBIx::Tree',
	license        => 'artistic_2',
	dist_abstract  => 'Generate a tree from a self-referential database table',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		'Test::More' => 1.001014,
		'Test::Pod' => 1.48,
	},
	configure_requires =>
	{
		'Module::Build' => 0.4211,
	},
	meta_merge =>
	{
		resources =>
		{
		'repository' => 'https://github.com/ronsavage/DBIx-Tree',
		},
	},
	requires =>
	{
		'Carp' => 1.08,
		'DBD::SQLite' => 1.37,
		'DBI' => 1.622,
		'File::Spec' => 3.31,
		'File::Temp' => 0.22,
		'strict' => 0,
		'vars' => 0,
		'warnings' => 0,
	},
) -> create_build_script();

