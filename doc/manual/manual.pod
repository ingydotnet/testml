=head1 TestML User Manual

Welcome to TestML. This manual describes what TestML is, why and when
you would use it, and how it works. Enjoy!

=head1 Status

This documentation is in progress and reflects the current thinking for
the eventual release of TestML 1.0.

=head1 Introduction to TestML

TestML is a meta language for writing software tests. When you write a
corpus of TestML documents, you are in effect describing how the
software should behave under various conditions. The conditions are
expressed as human friendly and readable data points. Then you describe
how that data should be manipulated against the application being
developed/tested, and finally what assertions should hold true after all
the transformation has occurred.

The test descriptions in TestML documents do not

=head1 Use Cases

This section descibes specific use cases for TestML.

=head1 Internal Processing

TestML is an abstract language. This section describes in very specific
terms, how the abstract is applied to reality. In other words, when you
run a TestML test, what actually happens.

=head2 Document Processing

Every TestML test run by a particular implementation's test harness
calls a runner method with a specific TestML document and an associated
bridge class. The runner parses the document and then invokes the
runtime process on it.

When a TestML document has been parsed, it is turned into an in-memory
representation of the document and all its referenced parts. The
document object contains 3 main parts, a meta object, a test program AST
object, and a data object.

The meta object is just a simple mapping of TestML settings to their
values. The meta section is used by the parser for information on how to
parse the TestML document and turn it into a document object.

The test program AST object is the compiled form the test code from
the TestML document. It is run by the runtime against the data in the
data object.

The data object contains all the compiled data from both the inline data
section and any referenced external data files.

=head2 Data Object Model

The data object can be thought of as a sequence (or list or array)
of labeled mappings (or hashes or dictionaries). The mappings are called
data blocks. All of the keys of the blocks are ASCII identifier words
and all the values are unicode strings.

Each of the separate data sections (from multiple sources) that are
parsed, produce a sequence of mappings. The sequences are simply
concatenated into one sequence in the data object.

The data object has methods for iterating over its contents.

=head2 The TestML Runtime Sequence

The runtime execution of TestML is somewhat complex despite the
simplicity of its testing syntax. This section describes exactly what is
happening when a given testml command is executed.

Suppose you have the following testml document:

    testml: 1.0
    input.some_process() == output;
    ===
    input: xxx
    output: yyy
    ===
    input: zzz
    nonsense: qwerty
    ===
    input: abc
    output: def

The program test code here is:

    input.some_process() == output;

It looks at all the data blocks that have both input and output data
points, runs each input through the bridge method C<some_process> and
compares it to the corresponding output.

In effect, this is what happens, but the actual steps to make that
happen are much more involved.

=over

=item The Data Block Set

Every test command has a set containing zero or more data blocks. In
this case, the set contains two blocks (the ones with both input and
output points).

When a command is compiled the AST contains a list of all the referenced
data points. The data block set consists of all the defined data blocks
that contain each of the referenced data points.

A command is run once for each data block in the set associated with
that command.

In our case the command can be thought of as:

    block.input.some_process() == block.output;

Where block is the current data block that the test is being run
against. The current block is known as the "topic".

    topic().input.some_process() == topic().output;

=item The Current Value

The topic block is an object which has a current value. The value starts
off undefined and then is set to the return value of each transform.
Transforms names with no parentheses after them, simply set the topic
value to the value of the named data point.

    topic().point_value('input').some_process() ==
    topic().point_value('output');

If point_value returns the value of the named data point, then it would
set the value of the topic by definition.

=item Transform Function Calling Convention

Each transform in an expression sequence, is passed the topic object
followed by all the parenthesized arguments. The topic object can be
used to access all the information in the test environment. If the
function just wants the current topic value, it calls the C<value>
method on the topic object.

Again, whatever value the transform function returns, that value is set
as the topic object current value.

=item Comparison Method

The '==' operator is really just visual sugar for the C<.equals>
comparison method.

    topic().point_value('input').some_process().equals(
        topic().point_value('output')
    );

It is the C<equals> function that actually runs the test. It gets two
different block objects passed to it, which in reality are the topics of
two different expressions. Each topic has a value and those two values
are unicode strings which are compared for equality.

In reality, those values are passed to the Runner object, which runs the
appropriate test code for the particular test environment in which
everything is being run.

=back

=head1 Authors

=over

=item * Ingy döt Net <ingy@ingy.net>

=back

=head1 License

This work is licensed under the Creative Commons Attribution Share Alike
License. To view a copy of this license, visit
L<http://creativecommons.org/licenses/by-sa/3.0/legalcode>;
or, (b) send a letter to Creative Commons, 171 2nd Street, Suite 300,
San Francisco, California, 94105, USA.

=head1 Copyright

Copyright (c) 2009. Ingy döt Net.

=cut
