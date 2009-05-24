package StackTestMLBridge;
use base 'TestML::Bridge';

sub testml_new_stack {
    my $self = shift;
    my $entries = $self->value || [];
    return Stack->new($entries);
}

sub testml_pop_stack {
    my $self = shift;
    my $stack = $self->value;
    return $stack->pop;
}

1;
