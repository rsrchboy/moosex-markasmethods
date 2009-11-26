#############################################################################
#
# Test class. 
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

package SimpleChild;

use Moose;
use MooseX::MarkAsMethods;
extends 'Simple';

#use namespace::clean -except => 'meta';

our $VERSION = '0.001';

#sub stringify { 'bob2' }

__PACKAGE__->meta->make_immutable;

__END__
