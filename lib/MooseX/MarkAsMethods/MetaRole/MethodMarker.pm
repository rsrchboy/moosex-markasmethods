package MooseX::MarkAsMethods::MetaRole::MethodMarker;

# ABSTRACT: MarkAsMethod's class metaclass trait (metarole/etc)

use Moose::Role;
use namespace::autoclean;

sub mark_as_method {
    my $self = shift @_;

    $self->_mark_as_method($_) for @_;
    return;
}

sub _mark_as_method {
    my ($self, $method_name) = @_;

    do { warn "$method_name is already a method!"; return }
    if $self->has_method($method_name);

    my $code = $self->get_package_symbol({
            name  => $method_name,
            sigil => '&',
            type  => 'CODE',
        });

    do { warn "$method_name not found as a CODE symbol!"; return }
    unless defined $code;

    $self->add_method($method_name =>
        $self->wrap_method_body(
            associated_metaclass => $self,
            name => $method_name,
            body => $code,
        ),
    );

    return;
}

!!42;
__END__

=head1 DESCRIPTION

The metaclass trait that lets L<MooseX::MarkAsMethod> do its thing.

=cut
