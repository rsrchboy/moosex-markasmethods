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

sub check_overloads {
    my ($t, %overloads) = @_;

    die "We expect an instance of $t, not a classname"
        unless ref $t;

    my $class = ref $t;
    ok overload::Overloaded($class), "$class is subject to some overloads";

    for my $op (keys %overloads) {

        # check that Moose knows about it, overload knows about it, and that
        # it works the way we expect it to

        if ($t->meta->has_method("($op")) {

            # we have the method and are its originator
            pass "$class still has o/l method ($op";
        }
        else {

            # we have the method via inheriting, etc
            ok $t->meta->find_method_by_name("($op"), "$class inherits o/l method ($op";
        }

        ok overload::Method($t, $op), "overload claims $class has $op overloaded";
        is "$t", $overloads{$op}, "$class o/l returned the expected value";
    }

    return;
}

1;
