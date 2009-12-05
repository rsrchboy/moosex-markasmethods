#############################################################################
#
# Some utility routines to make testing a little easier 
#
# Author:  Chris Weyl (cpan:RSRCHBOY), <cweyl@alumni.drew.edu>
# Company: No company, personal work
# Created: 12/04/2009
#
# Copyright (c) 2009  <cweyl@alumni.drew.edu>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
#############################################################################

my @sugar = qw{ has around augment inner before after blessed confess };

sub check_sugar_removed_ok {
    my $t = shift @_;

    # check some (not all) Moose sugar to make sure it has been cleared
    #my @sugar = qw{ has around augment inner before after blessed confess };
    ok !$t->can($_) => "$t cannot $_" for @sugar;

    return;
}

sub check_sugar_ok {
    my $t = shift @_;

    # check some (not all) Moose sugar to make sure it has been cleared
    #my @sugar = qw{ has around augment inner before after blessed confess };
    ok $t->can($_) => "$t can $_" for @sugar;

    return;
}

sub make_and_check {
    #my $class = shift @_;
    my ($class, $roles, $atts) = @_;

    my $t = $class->new;
    isa_ok  $t, $class;

    # do our class checks: meta, roles, attributes
    meta_ok $class;
    does_ok $class => $_ for @$roles;
    has_attribute_ok $class => $_ for @$atts; 

    return $t;
}

1;
