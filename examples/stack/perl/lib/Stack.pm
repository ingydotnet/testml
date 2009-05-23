package Stack;
use 5.008008;
use Moose;

has 'stack' => (
    isa => 'ArrayRef',
);

sub BUILDARGS {
    my $class = shift;
    my @elems = @_;
    return { stack => [@elems] };
}

sub push {
    my $self = shift;
    my $num = @_;
    die "Stack push method requires 1 argument. You passed $num."
        unless $num == 1;
    my $elem = shift;
    push @{$self->stack, $elem}, $elem;
    return $elem;
}

sub pop {
    my $self = shift;
    my $num = @_;
    die "Stack pop method requires 0 arguments. You passed $num."
        unless $num == 0;
    my $size = @{$self->stack};
    die "Stack has no element to pop."
        unless $size > 0;
    my $elem = pop @{$self->stack};
    return $elem;
}

sub head {
    my $self = shift;
    my $num = @_;
    die "Stack head method requires 0 arguments. You passed $num."
        unless $num == 0;
    my $size = @{$self->stack};
    die "Stack has no head."
        unless $size > 0;
    return $self->stack->[-1];
}

1;

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2008. Ingy döt Net.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
