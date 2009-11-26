#############################################################################
#
# 
#
# Author:  Chris Weyl (cpan:RSRCHBOY), <cweyl@alumni.drew.edu>
# Company: No company, personal work
# Created: 11/22/2009
#
# Copyright (c) 2009  <cweyl@alumni.drew.edu>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
#############################################################################

package Simple;

use Moose;
use MooseX::MarkAsMethods;
use namespace::autoclean;

use overload q{""} => 'stringify', fallback => 1;

has id => (is => 'rw', isa => 'Str', default => 'bob');

sub stringify { shift->id }

__PACKAGE__->meta->make_immutable;
1;
