#!/usr/bin/perl -w

use strict;
use DBIx::Tree;

use vars qw(@list);

my @opts =
(
$ENV{DBI_DSN} || 'dbi:SQLite:dbname=/tmp/test.sqlite',
$ENV{DBI_USER} || '',
$ENV{DBI_PASS} || '',
);

use DBI;
my $dbh = DBI->connect(@opts, {RaiseError => 0, PrintError => 1, AutoCommit => 1});

if ( !defined $dbh ) {
    die $DBI::errstr;
}

my $tree = new DBIx::Tree( connection => $dbh, 
                          table      => 'food', 
                          method     => sub { disp_tree(@_) },
                          columns    => ['id', 'food', 'parent_id'],
                          start_id   => '001');
$tree->traverse;

$dbh->disconnect;

sub disp_tree {
    my %parms = @_;
    my $item  = $parms{item};
    my $level = $parms{level};
    my $id    = $parms{id};

    $item =~ s/^\s+//;
    $item =~ s/\s+$//;

    print ' ' x ($level * 2), "$item ($id) \n";
}

