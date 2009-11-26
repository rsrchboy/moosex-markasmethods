#############################################################################
#
# Author:  Chris Weyl (cpan:RSRCHBOY), <cweyl@alumni.drew.edu>
# Company: No company, personal work
# Created: 02/02/2009 11:41:15 PM PST
#
# Copyright (c) 2009 Chris Weyl <cweyl@alumni.drew.edu>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
#############################################################################

=head1 NAME

no_smart_comments.t - make sure we don't still "use Smart::Comments" somewhere

=head1 DESCRIPTION 

This test ensures we don't release any Smart::Comments out there. 

=head1 TESTS

This module defines the following tests.

=cut

use strict;
use warnings;

use English qw{ -no_match_vars };  # Avoids regex performance penalty

use File::Find::Rule;
use FindBin;
use Module::ScanDeps;

use Test::More;

# debugging...
#use Smart::Comments;

my @files = File::Find::Rule
    ->file
    ->name('*.pm')
    ->in("$FindBin::Bin/../../lib")
    ;

plan tests => scalar @files;

for my $file (@files) {

    my $href = scan_deps(files => [ $file ], recurse => 0);

    # ## $href
    is exists $href->{'Smart/Comments.pm'} => q{}, "$file w/o Smart::Comments";
}
    

__END__

=head1 AUTHOR

Chris Weyl  <cweyl@alumni.drew.edu>


=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 Chris Weyl <cweyl@alumni.drew.edu>

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



