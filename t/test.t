use strict;
use warnings;

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

our $compare;
our $rc;

our $loaded = 0;

BEGIN { $| = 1; print "1..11\n"; }
END {print "not ok 1\n" unless $loaded;}

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

sub disp_tree {
    my(%param) = @_;
	#print STDERR ($param{item} || 'N/A'), "\n";
    my $item = $param{item};
    $item =~ s/^\s+//;
    $item =~ s/\s+$//;
    $compare .= $item;
}

use DBI;

use DBIx::Tree;

use File::Spec;
use File::Temp;

$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

############# create and populate the table we need.

my($dir)  = File::Temp -> newdir;
my($file) = File::Spec -> catfile($dir, 'test.sqlite');
my(@opts) =
(
$ENV{DBI_DSN}  || "dbi:SQLite:dbname=$file",
$ENV{DBI_USER} || '',
$ENV{DBI_PASS} || '',
);

my $dbh = DBI->connect(@opts, {RaiseError => 0, PrintError => 1, AutoCommit => 1});
if ( defined $dbh ) {
        print "ok 2\n";
} else {
        print "not ok 2\n";
        die $DBI::errstr;
}

open (INSTALL, "t/INSTALL.SQL")
  or (print "not ok 2\n" and die "Could not open t/INSTALL.SQL for reading!");
while(<INSTALL>) {
        chomp;

	# strip out NULL for mSQL
	#
	if (/^create/i and $opts[0] =~ /msql/i) {
	    s/null//gi;
	}

        my $sth = $dbh->prepare($_);

		# Skip failure to drop non-existent table.

		next if (! defined $sth);

        my $rc = $sth->execute;

        # ignore drop table.
        #
        if (!$rc) {
          if (/^drop/i) {
            print STDERR "Ignoring failed DROP operation.\n"
          } else {
            print "not ok 2\n";
            die "$DBI::errstr";
          }
        }
}
close (INSTALL);

############# create an instance of the DBIx::Tree
{
my $tree = new DBIx::Tree( connection => $dbh,
			   table      => 'food',
			   method     => sub { disp_tree(@_) },
			   columns    => ['id', 'food', 'parent_id'],
			   start_id   => '001');
if(ref $tree eq 'DBIx::Tree') {
    print "ok 3\n";
} else {
    print "not ok 3\n";
}

############# call do_query
if ($tree->_do_query) {
    print "ok 4\n";
} else {
    print "not ok 4\n";
}

############# call tree

$tree->traverse;
$rc = $compare eq 'FoodBeans and NutsBeansBlack BeansKidney BeansBlack Kidney BeansRed Kidney BeansNutsPecansDairyBeveragesCoffee MilkSkim MilkWhole MilkCheesesCheddarGoudaMuensterStiltonSwiss';
if ($rc == 1) {
    print "ok 5\n";
} else {
    print "not ok 5\n";
}

}
############# create another instance of the DBIx::Tree 
{
my $tree = new DBIx::Tree(connection => $dbh,
                          table      => 'food',
                          method     => sub { disp_tree(@_) },
                          columns    => ['id', 'food', 'parent_id'],
                          start_id   => '001',
                          match_data => 'Dairy');
$compare = "";
$tree->traverse;
$rc = $compare eq 'Dairy';

if ($rc == 1) {
    print "ok 6\n";
} else {
    print "not ok 6: $compare\n";
}

############# test local variables in traverse()

$compare = "";
$tree->traverse(start_id => '011', threshold => 2, match_data => '', limit => 2);
$rc = $compare eq 'Coffee MilkSkim Milk';

if ($rc == 1) {
    print "ok 7\n";
} else {
    print "not ok 7: $compare\n";
}

### OK, now see if the default settings still work:

$compare = "";
$tree->traverse;
$rc = $compare eq 'Dairy';

if ($rc == 1) {
    print "ok 8\n";
} else {
    print "not ok 8: $compare\n";
}
}

############# check out 'sth' constructor
{
my $sth = $dbh->prepare('select id, food, parent_id from food order by food');
my $tree = new DBIx::Tree(connection => $dbh,
                          sth        => $sth,
                          method     => sub { disp_tree(@_) },
                          columns    => ['id', 'food', 'parent_id'],
                          start_id   => '001');
$compare = "";
$tree->traverse;
$rc = $compare eq 'FoodBeans and NutsBeansBlack BeansKidney BeansBlack Kidney BeansRed Kidney BeansNutsPecansDairyBeveragesCoffee MilkSkim MilkWhole MilkCheesesCheddarGoudaMuensterStiltonSwiss';

if ($rc == 1) {
    print "ok 9\n";
} else {
    print "not ok 9: $compare\n";
}
}

############# check out 'sql' constructor
{
my $sql = 'select id, food, parent_id from food order by food';
my $tree = new DBIx::Tree(connection => $dbh,
                          sql        => $sql,
                          method     => sub { disp_tree(@_) },
                          columns    => ['id', 'food', 'parent_id'],
                          start_id   => '001');
$compare = "";
$tree->traverse;
$rc = $compare eq 'FoodBeans and NutsBeansBlack BeansKidney BeansBlack Kidney BeansRed Kidney BeansNutsPecansDairyBeveragesCoffee MilkSkim MilkWhole MilkCheesesCheddarGoudaMuensterStiltonSwiss';

if ($rc == 1) {
    print "ok 10\n";
} else {
    print "not ok 10: $compare\n";
}

############# check out the recursive function: repeat above tests

$compare = "";
$tree->traverse(recursive => 1);
$rc = $compare eq 'FoodBeans and NutsBeansBlack BeansKidney BeansBlack Kidney BeansRed Kidney BeansNutsPecansDairyBeveragesCoffee MilkSkim MilkWhole MilkCheesesCheddarGoudaMuensterStiltonSwiss';

if ($rc == 1) {
    print "ok 11\n";
} else {
    print "not ok 11: $compare\n";
}
}

############# close the dbh
$dbh->do(q{drop table food});
$dbh->disconnect;
