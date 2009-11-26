package MooseX::MarkAsMethods;

#MooseX::MarkAsMethods;
#MooseX::Tidy
#MooseX::namespace::tidy
#MooseX::LooseEnds

use warnings;
use strict;

use namespace::autoclean;

use B::Hooks::EndOfScope;
use Moose 0.90 ();

# debugging
use Smart::Comments '###', '####';

=head1 NAME

MooseX::MarkAsMethods - Mark certain code symbols as methods

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

    use Moose;
    use MooseX::MarkAsMethods;

    #...


=head1 DESCRIPTION

MooseX::MarkAsMethods allows one to easily mark certain functions as Moose
methods.  This will allow other packages such as namespace::autoclean to
operate without, say, blowing away your overloads.

By default (and all we can do at this point) is check for overloads, and mark
those functions as methods.

=head1 CAVEAT

As currently implemented, we run our "method maker" at the end of the calling
package's compile scope (L<B::Hooks::EndOfScope>).  As L<namespace::autoclean>
does the same thing, it's important that if namespace::autoclean is use that
it be use'd BEFORE MooseX::MarkAsMethods, so that it's end_of_scope block is
run after ours.

=cut

{
    package MooseX::MarkAsMethods::Meta::Method::Overload;
    use namespace::autoclean;

    use base 'Moose::Meta::Method';
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

            ### adding: $overload_name
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

        ### %methods

        unless ($args{no_autoclean}) {

            #require namespace::autoclean;
            #namespace::autoclean->import(
            #    '-cleanee' => $target,
            #    %{$args{autoclean_args}},
            #);

            #require namespace::clean;
            #namespace::clean->clean_subroutines($target, grep { !$methods{$_} } keys %symbols);
        }
    };

    return;
}

=head1 SEE ALSO

L<B::Hooks::EndOfScope>, L<namespace::autoclean>, L<Class::MOP>, L<Moose>.

=head1 AUTHOR

Chris Weyl, C<< <cweyl at alumni.drew.edu> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-markasmethods at rt.cpan.org>, or through
the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-MarkAsMethods>.
I will be notified, and then you'llautomatically be notified of progress
on your bug as I make changes.

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

Copyright (c) 2009, Chris Weyl C<< <cweyl@alumni.drew.edu> >>.

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
