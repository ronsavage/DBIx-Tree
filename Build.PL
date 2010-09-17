use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'DBIx::Tree',
	license        => 'artistic',
	dist_abstract  => 'Generate a tree from a self-referential database table',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		Test::More => 0.94,
		Test::Pod  => 1.44,
	},
	requires =>
	{
		Carp => 1.08,
		DBI  => 1.612,
	},
) -> create_build_script();

