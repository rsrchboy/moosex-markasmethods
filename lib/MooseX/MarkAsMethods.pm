package MooseX::MarkAsMethods;

use warnings;
use strict;

use namespace::autoclean;

use B::Hooks::EndOfScope;
use Moose 0.90 ();

# debugging
#use Smart::Comments '###', '####';

=head1 NAME

MooseX::MarkAsMethods - Mark overload code symbols as methods

=cut

our $VERSION = '0.06';

=head1 SYNOPSIS

    package Foo;
    use Moose;

    # mark overloads as methods and wipe other non-methods
    use MooseX::MarkAsMethods autoclean => 1;

    # define overloads, etc as normal

    package Baz;
    use Moose::Role
    use MooseX::MarkAsMethods autoclean => 1;

    # overloads defined in a role will "just work" when the role is
    # composed into a class

    package Bar;
    use Moose;

    # order is important!
    use namespace::autoclean;
    use MooseX::MarkAsMethods;

    # ...

=head1 DESCRIPTION

MooseX::MarkAsMethods allows one to easily mark certain functions as Moose
methods.  This will allow other packages such as namespace::autoclean to
operate without, say, blowing away your overloads.  After using
MooseX::MarkAsMethods your overloads will be recognized by L<Class::MOP> as
being methods, and class extension as well as composition from roles with
overloads will "just work".

By default we check for overloads, and mark those functions as methods.

If 'autoclean => 1' is passed to import on use'ing this module, we will invoke
namespace::autoclean to clear out non-methods.

=head1 CAVEAT

As currently implemented, we run our "method maker" at the end of the calling
package's compile scope (L<B::Hooks::EndOfScope>).  As L<namespace::autoclean>
does the same thing, it's important that if namespace::autoclean is used that
it be use'd BEFORE MooseX::MarkAsMethods, so that its end_of_scope block is
run after ours.

e.g.

    # yes!
    use namespace::autoclean;
    use MooseX::MarkAsMethods;

    # no -- overloads will be removed
    use namespace::autoclean;
    use MooseX::MarkAsMethods;

The easiest way to invoke this module and clean out non-methods without having
to worry about ordering is:

    use MooseX::MarkAsMethods autoclean => 1;

=cut

{
    package MooseX::MarkAsMethods::Meta::Method::Overload;
    use namespace::autoclean;

    use base 'Moose::Meta::Method';

    our $VERSION = '0.06';

    # strictly speaking, we don't need to do this; we could just use
    # Moose::Meta::Method or even Class::MOP::Method...  But it might be
    # useful to easily differentiate these added methods.
}

sub import {
    my ($class, %args) = @_;

    # our invoking package
    my $target = scalar caller;

    on_scope_end {

        my $meta = Class::MOP::Class->initialize($target);

        ### metaclass: ref $meta
        return unless $meta && ref $meta ne 'Class::MOP::Class';

        my %methods   = map { ($_ => 1) } $meta->get_method_list;
        my %symbols   = %{ $meta->get_all_package_symbols('CODE') };
        my @overloads = grep { /^\(/ } keys %symbols;

        ### %methods
        ### %symbols
        ### @overloads

        foreach my $overload_name (@overloads) {

            next if $methods{$overload_name};

            ### marking as method: $overload_name
            my $method = MooseX::MarkAsMethods::Meta::Method::Overload->wrap(
                associated_metaclass => $meta,
                package_name         => $target,
                name                 => $overload_name,
                body                 => $symbols{$overload_name},
            );

            $meta->add_method($overload_name => $method);
            $methods{$overload_name} = 1;
            delete $symbols{$overload_name};
        }

        return;
    };

    namespace::autoclean->import(-cleanee => $target)
        if $args{autoclean};

    return;
}

=head1 SEE ALSO

L<overload>, L<B::Hooks::EndOfScope>, L<namespace::autoclean>, L<Class::MOP>,
L<Moose>.

L<MooseX::Role::WithOverloading> does allow for overload application from
roles, but it does this by copying the overload symbols from the (not
namespace::autoclean'ed role) the symbols handing overloads during class
composition; we work by marking the overloads as methods and letting
CMOP/Moose handle them.

=head1 AUTHOR

Chris Weyl, C<< <cweyl at alumni.drew.edu> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-markasmethods at rt.cpan.org>, or through
the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-MarkAsMethods>.

=head1 TODO

Additional testing is required, particularly where namespace::autoclean is
also being used.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MooseX::MarkAsMethods


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-MarkAsMethods>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-MarkAsMethods>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-MarkAsMethods>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-MarkAsMethods/>

=back


=head1 COPYRIGHT & LICENSE

Copyright (c) 2009, 2010, Chris Weyl C<< <cweyl@alumni.drew.edu> >>.

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option)
any later version.

This library is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
OR A PARTICULAR PURPOSE.

See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this library; if not, write to the

    Free Software Foundation, Inc.,
    59 Temple Place, Suite 330,
    Boston, MA  02111-1307 USA

=cut

1; # End of MooseX::MarkAsMethods
