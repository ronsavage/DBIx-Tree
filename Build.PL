use Module::Build;

my($builder) = Module::Build -> new
(
	module_name    => 'DBIx::Tree',
	license        => 'artistic',
	dist_abstract  => 'Generate a tree from a self-referential database table',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
	},
	requires =>
	{
	},
) -> create_build_script();

