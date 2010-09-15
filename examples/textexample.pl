#!/usr/bin/perl -w

use strict;
use DBIx::Tree;

use vars qw(@list);

open (PWD, "../PWD") 
  or die "Could not open PWD for reading!";

my @dbiparms;
while(<PWD>) {
    chomp;
    push @dbiparms, $_;
}
close (PWD);

use DBI;
my $dbh = DBI->connect(@dbiparms);
if ( !defined $dbh ) {
    die $DBI::errstr;
}

my $tree = new DBIx::Tree( connection => $dbh, 
                          table      => 'food', 
                          method     => sub { disp_tree(@_) },
                          columns    => ['food_id', 'food', 'parent_id'],
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

