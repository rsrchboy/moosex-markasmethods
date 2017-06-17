package MooseX::MarkAsMethods;

# ABSTRACT: Mark overload code symbols as methods

use warnings;
use strict;

use namespace::autoclean 0.12;

use aliased 'MooseX::MarkAsMethods::MetaRole::MethodMarker';

use B::Hooks::EndOfScope;
use Moose 0.94 ();
use Moose::Util::MetaRole;
use Moose::Exporter;

my ($import) = Moose::Exporter->build_import_methods(
    install => [ qw{ init_meta unimport } ],
    class_metaroles => {
        class => [ MethodMarker ],
    },
    role_metaroles => {
        role => [ MethodMarker ],
    },
);

sub import {
    my $class = shift @_;

    # if someone is passing in Sub::Exporter-style initial hash, grab it
    my $exporter_opts;
    $exporter_opts = shift @_ if ref $_[0] && ref $_[0] eq 'HASH';
    my %args = @_;

    my $target
        = defined $exporter_opts && defined $exporter_opts->{into}
        ? $exporter_opts->{into}
        : scalar caller
        ;

    return if $target eq 'main';

    my $do_autoclean = delete $args{autoclean};

    on_scope_end {

        ### $target
        my $meta = Class::MOP::Class->initialize($target);

        ### metaclass: ref $meta
        my %methods   = map { ($_ => 1) } $meta->get_method_list;
        my %symbols   = %{ $meta->get_all_package_symbols('CODE') };
        my @overloads = grep { /^\(/ } keys %symbols;

        ### %methods
        ### %symbols
        ### @overloads

        foreach my $overload_name (@overloads) {

            next if $methods{$overload_name};

            ### marking as method: $overload_name
            $meta->mark_as_method($overload_name);
            $methods{$overload_name} = 1;
            delete $symbols{$overload_name};
        }

        return;
    };

    ### $do_autoclean
    namespace::autoclean->import(-cleanee => $target)
        if $do_autoclean;

    @_ = ($class => $exporter_opts ? ($exporter_opts, %args) : (%args));

    ### @_
    goto &$import;
}

1;

__END__

=for Pod::Coverage init_meta

=head1 SYNOPSIS

    package Foo;
    use Moose;

    # mark overloads as methods and wipe other non-methods
    use MooseX::MarkAsMethods autoclean => 1;

    # define overloads, etc as normal
    use overload '""' => sub { shift->stringify };

    package Baz;
    use Moose::Role;
    use MooseX::MarkAsMethods autoclean => 1;

    # overloads defined in a role will "just work" when the role is
    # composed into a class; they MUST use the anon-sub style invocation
    use overload '""' => sub { shift->stringify };

    # additional methods generated outside Class::MOP/Moose can be marked, too
    use constant foo => 'bar';
    __PACKAGE__->meta->mark_as_method('foo');

    package Bar;
    use Moose;

    # order is important!
    use namespace::autoclean;
    use MooseX::MarkAsMethods;

    # ...

=head1 DESCRIPTION

MooseX::MarkAsMethods allows one to easily mark certain functions as Moose
methods.  This will allow other packages such as L<namespace::autoclean> to
operate without blowing away your overloads.  After using
MooseX::MarkAsMethods your overloads will be recognized by L<Class::MOP> as
being methods, and class extension as well as composition from roles with
overloads will "just work".

By default we check for overloads, and mark those functions as methods.

If C<autoclean =&gt; 1> is passed to import on using this module, we will invoke
namespace::autoclean to clear out non-methods.

=head1 TRAITS APPLIED

Using this package causes a trait to be applied to your metaclass (for both
roles and classes), that provides a mark_as_method() method.  You can use this
to mark newly generated methods at runtime (e.g. during class composition)
that some other package has created for you.

mark_as_method() is invoked with one or more names to mark as a method.  We die
on any error (e.g. name not in symbol table, already a method, etc).  e.g.

    __PACKAGE__->meta->mark_as_method('newly_generated');

e.g. say you have some sugar from another package that creates accessors of
some sort; you could mark them as methods via a method modifier:

    # called as __PACKAGE__->foo_generator('name', ...)
    after 'foo_generator' => sub {

        shift->meta->mark_as_method(shift);
    };

=head1 IMPLICATIONS FOR ROLES

Using MooseX::MarkAsMethods in a role will cause Moose to track and treat your
overloads like any other method defined in the role, and things will "just
work".  That's it.

Except...  note that due to the way overloads, roles, and Moose work, you'll
need to use the coderef or anonymous subroutine approach to overload
declaration, or things will not work as you expect.  Remember, we're talking
about _methods_ here, so we need to make it easy for L<overload> to find
the right method.  The easiest (and supported) way to do this is to create an
anonymous sub to wrap the overload method.

That is, this will work:

    # note method resolution, things will "just work"
    use overload '""' => sub { shift->stringify };

...and this will not:

    use overload '""' => 'stringify';

...and will result in an error message like:

    # wah-wah
    Can't resolve method "???" overloading """" in package "overload"

=head1 CAVEATS

=head2 Roles

See the "IMPLICATIONS FOR ROLES" section, above.

=head2 meta->mark_as_method()

B<You almost certainly don't need or want to do this.>  CMOP/Moose are fairly
good about determining what is and what isn't a method, but not perfect.
Before using this method, you should pause and think about why you need to.

=head2 namespace::autoclean

As currently implemented, we run our "method maker" at the end of the calling
package's compile scope (L<B::Hooks::EndOfScope>).  As L<namespace::autoclean>
does the same thing, it's important that if namespace::autoclean is used that
it be used BEFORE MooseX::MarkAsMethods, so that its end_of_scope block is
run after ours.

e.g.

    # yes!
    use namespace::autoclean;
    use MooseX::MarkAsMethods;

    # no -- overloads will be removed
    use MooseX::MarkAsMethods;
    use namespace::autoclean;

The easiest way to invoke this module and clean out non-methods without having
to worry about ordering is:

    use MooseX::MarkAsMethods autoclean => 1;

=head1 SEE ALSO

overload
namespace::autoclean
B::Hooks::EndOfScope
MooseX::Role::WithOverloading

=cut

