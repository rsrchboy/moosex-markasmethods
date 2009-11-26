#!/usr/bin/env perl
#############################################################################
#
# Author:  Chris Weyl (cpan:RSRCHBOY), <cweyl@alumni.drew.edu>
# Company: No company, personal work
# Created: 11/25/2009
#
# Copyright (c) 2009  <cweyl@alumni.drew.edu>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
#############################################################################

=head1 NAME

02-inheritance.t - Test overloads marked as methods in child classes 

=head1 DESCRIPTION 

This test exercises extending a class with overloads.

=head1 TESTS

This module defines the following tests.

=cut

use strict;
use warnings;

use Test::More 0.92; # tests => XX;

use FindBin;
use lib "$FindBin::Bin/lib";

use ok 'SimpleChild';

my $sc = SimpleChild->new;
isa_ok $sc, 'SimpleChild';
ok overload::Overloaded($sc), 'object is overloaded';
is "$sc", 'bob', 'overload/stringify works';

done_testing;

__END__

=head1 AUTHOR

Chris Weyl  <cweyl@alumni.drew.edu>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009  <cweyl@alumni.drew.edu>

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
     Lesser General Public License for more details.

     You should have received a copy of the GNU Lesser General Public
     License along with this library; if not, write to the 

     Free Software Foundation, Inc.
     59 Temple Place, Suite 330
     Boston, MA  02111-1307  USA

     =cut


