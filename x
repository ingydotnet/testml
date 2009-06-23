=head1 TestML

A Software Testing Meta Language

=head1 Status

Working Draft - 21 June, 2009

This document is the TestML Language Specification. Version 1.0
Pre-release.

This is not the final 1.0 release. It is very new, under
review, under revision and undergoing initial implementation and
testing.

=head1 Overview

B<TestML> is a meta language for writing tests that define how a piece
of software should behave, regardless of the programming language the
software is written in.

It is primarily intended for generic libraries or modules that are
relevant in many languages, or that have multiple implementations in the
same language. In these scenarios the different implementations can all
use the exact same tests. However, TestML's clarity and ease of use may
make it desirable for testing all types of software.

TestML documents define a set of data points and a program written in
an abstract transform/assertion language that invokes the application
being tested. The transforms alter given data points into new states.
Then assertions can be made between the altered data points and
expected result data points. Here is a simple, but complete, TestML
document example:

    %TestML: 1.0

    $input.uppercase() == $output;

    === Test mixed case string
    --- input: I Like Pie
    --- output: I LIKE PIE

    === Test lower case string
    --- input: i love lucy
    --- output: I LOVE LUCY

In this case, a programmer of any given language would do the following:

=over

=item * Implement an application that can turn strings to upper case.

=item * Implement a TestML "bridge class" that defines the 'uppercase'
transform to invoke the application's upper casing facility.

=item * Set up their test environment to use TestML to run the test.

=back

=head1 History

The concept of TestML was heavily inspired by Ward Cunningham's B<FIT>
test framework. The primary difference is that FIT's test documents are
table/spreadsheet based, where TestML's are text file based. This reflects
the premise that FIT caters to business application development (where
spreadsheets are heavily used), while TestML caters to open source
library authors (where everything is in text files).

The specifics of TestML (especially the data format), evolved directly
from Ingy döt Net's data-driven Perl testing framework, B<Test::Base>.
Test::Base was written in 2004 and later ported to JavaScript. As Ingy
ported various libraries to other languages, he realized the potential
value of making the test suites reusable.

=head1 Design Goals

TestML has the following Design Goals:

=over

=item Platform Agnosticism

TestML strives to make no assumptions about the programming language,
environment, or testing framework it will be used in. In this way, the
same corpus of test documents can be used against multiple
implementations of equivalent software.

=item Readability

TestML lets you define tests that are easy for both you and others to
write, read and maintain. The format is intended to let the data points
and test conditions stand out, while keeping the implementation specific
details in the I<bridge class>.

=item Extensibility

TestML has been designed with acknowledgement that it will need to
evolve to meet many various testing requirements. For this reason, every
document requires a TestML version number. Also the original grammar has
been made quite strict, leaving a lot of room for future extension.

=item Ease of Implementation

TestML is designed to be fairly easy to implement in various programming
languages.

The TestML project has a set of tests (written in TestML) that a TestML
implementation must pass to be compliant. See L<http://testml.org/tests/>.

=back

=head1 Terminology

TestML uses a number of specific terms. The following glossary lists the 
terms and defines their meanings.

=over

=item Application

The software that is being tested.

=item Assertion

A I<test assertion> is a statement in the I<TestML document> that
compares two I<data expressions> using a I<testing operator>.

=item Block

A I<data block> is an object that contains a set of named I<data
points>. The block usually has a short label phrase. When the
tests are run, the I<runner class> will run each of the I<test
assertions> against each of the I<data blocks> that contain the I<data
points> needed by the assertion.

=item Bridge

Every test setup defines a class that connects named I<data transform>
functions to the software being tested. This is known as a I<bridge
class>, because it bridges the test to the application or library.

=item Document

A I<TestML document> is a file containing some number of I<test
assertions> and I<data blocks>. This specification describes the format
of such a document.

=item Expression

A I<data expression> is a I<data point> name followed by zero or more
calls to named I<data transforms>.

A I<test assertion> compares the result of two data expressions.

=item Meta

A I<TestML document> can define a number of key/value pairs which are
considered I<meta data> and are used to instantiate a I<meta object>
that the test code can later access.

=item Operator

A I<testing operator> is a method that compares the final state of two
data points. The only operator currently defined by TestML is the '=='
operator, which compares two unicode strings for an exact match.

=item Point

A I<data point> is a named piece of data that belongs to a given I<data
block>. All data points are assumed to start out as unicode strings,
although a I<data transform> may turn them into anything else.

=item Runner

The TestML class that is responsible for running all the
appropriate tests.

=item Section

Every I<TestML document> has two sections, a I<head section> and a
I<data section>. The former specifies I<meta information> and the I<test
assertions> that the document is declaring. The latter section defines
the I<data blocks> against which the test assertions are applied.

=item Transform

A I<transform> is a method provided by a I<bridge class> that changes a
I<data point> from one form into another. A transform usually invokes
functionality of the I<application> it is testing. The whole idea of
TestML is that by passing a data point through one or more transforms,
you can make it equivalent to some other data point, causing the
test to pass.

=back

=head1 The Specification

The TestML Specification it is defined by a set of pseudo-BNF grammars.
The grammars include a I<top level document grammar> and a separate
I<TestML data section grammar>. The data section is separate, because it
may be marked up in any of several syntaxes.

NOTE: The grammar is somewhat self-modifying, because certain meta
      settings in the document can change how the rest of the document
      is parsed.

=head2 Document Encoding

All TestML documents are composed of the printable unicode character set
and I<must> be encoded in UTF8. Any character that does not meet these
requirements must raise an exception.

=head2 Grammar Operators and Primitives

This is a list of the special characters used in the grammars. They are
mostly borrowed from the PCRE regexp standard.

=over

=item * ' | ' - Alternation

=item * ' - ' - Exclusion

=item * '* ' - Zero or more

=item * '+ ' - One or more

=item * '? ' - Zero or one

=item * '(...)' - Parentheses indicate grouping

=back

The following primitives are defined in terms of their PCRE regexp
equivalents.

=over

=item * PRINTABLE - '[\x09\x0A\x0D\x20-\x7E\xA0-\x{D7FF}\x{E000}-\x{FFFD}]'

NOTE: Non-PRINTABLE characters are not allowed in a TestML stream. The
      following units do not allow them either, but they have been left
      out of the regexps for simplicity sake.

=item * ANY - '[\s\S]' - Any unicode character

=item * SPACE - '[\ \t]' - A space or tab character

=item * BREAK - '\n' - A newline character

=item * EOL - '\r?\n' - A Unix or DOS line ending

=item * NON-BREAK - '.' - Any character except newline

=item * LOWER - '[a-z]' - Lower case ASCII alphabetic character

=item * UPPER - '[A-Z]' - Upper case ASCII alphabetic character

=item * ALPHANUM - '[A-Za-z0-9]' - ASCII alphanumeric character

=item * WORD - '\w' - ie '[A-Za-z0-9_]' - A "word" character

=item * DIGIT - '[0-9]' - A numeric digit

=item * DOLLAR - '\$' - A dollar sign character

=item * DOT - '\.' - A period character

=item * HASH - '#' - An octothorpe (or hash) character

=item * BACK - '\' - A backslash character

=item * SINGLE - "'" - A single quote character

=item * DOUBLE - '"' - A double quote character

=item * ESCAPE - '[0nt]' - One of the escapable character IDs

=back 

=head2 Top Level Document Grammar

=over

=item document := meta-section test-section data-section?

A TestML Document consists of 3 sections, a meta section followed by a
test section followed by an optional inline data section.

Here is an example document:

    # TestML document includes:

    # Meta statements,
    %TestML: 1.0

    # And test statements.
    $foo.upper() == $bar;
    $foo == $bar.lower();

    # And a data section that defines data blocks.
    === Test vowels
    --- foo: i ie ie
    --- bar: I IE IE

    === Test consonants
    --- foo
    lk p
    --- bar
    LK P

=head3 Meta Section of the Grammar

=item meta-section :=
    ( comment | blank-line )*
    meta-testml-statement
    ( meta-statement | comment | blank-line )*

The meta section is the first section of the document. It must contain a
testml version statement, and that statement must be the first meta
statement declared.

The parsing of the meta section should instantiate a Meta object.

=item comment := HASH line

Comments start with a '#' and go to the end of the line. Comments are
only allowed where specifically permitted by the grammar. Comments are
treated like insignificant whitespace and ignored by the parser.

=item line := NON-BREAK* EOL

A line is a string of zero or more non break characters followed by
a line ending.

=item blank-line := SPACE* EOL

Blank lines are useful to space things out visually.

=item meta-testml-statement :=
    '%TestML:' SPACE+ testml-version ( SPACE+ comment | EOL )

The meta C<testml> statement is required, must be the first meta
statement, and must specify a valid TestML release version number.

=item testml-version := DIGIT DOT DIGIT+

Currently the only valid version number is '1.0'.

=item meta-statement := '%' meta-keyword ':' SPACE+ meta-value (SPACE+ comment | EOL)

Meta statements are key/value pairs separated by a colon and a
SPACE. A given meta setting may affect the document parsing from
that point forward.

=item meta-keyword := core-meta-keyword | user-meta-keyword

Meta settings come in two forms. TestML defined core settings, and user
defined settings.

=item core-meta-keyword :=
    ( 'Title'
    | 'Data'
    | 'Plan'
    | 'BlockMarker'
    | 'PointMarker'
    )

The listed keywords represent the core meta settings supported in TestML
1.0. See L<Valid Meta Keywords> for the definitions of them.

=item user-meta-keyword := LOWER WORD*

A user can make up their own meta settings, as long as they begin with a
lower case letter. These values are then available to the runtime code.

=item meta-value := ( quoted-string | unquoted-string )

A meta value is the value of the meta setting being defined. Some settings
like C<data> are stored as arrays. Multiple statements with they same keyword
add an element to the array.

=item quoted-string := single-quoted-string | double-quoted-string

A quoted string can use either single or double quotes.

=item single-quoted-string :=
    SINGLE ((ANY - (BREAK | BACK | SINGLE)) | BACK SINGLE | BACK BACK)* SINGLE

A single quoted string encodes the characters placed between the pair of
single quotes. A backslash is used to encode a backslash or a single
quote character.

    'Won\'t you scratch\\slash my back?'

=item double-quoted-string :=
    DOUBLE ((ANY - (BREAK | BACK | DOUBLE)) |
    BACK DOUBLE | BACK BACK | BACK ESCAPE )* DOUBLE

A double quoted string encodes the characters placed between the pair of
double quotes. A backslash is used to encode a backslash or a double
quote character, and also a tab, a newline or a null using the
characters 't', 'n' or '0' respectively.

    "\tline 1\n\"line\" 2\n"

=item unquoted-string :=
    (ANY - (SPACE | BREAK | HASH))
    ((ANY - (BREAK | HASH))* (ANY - (SPACE | BREAK | HASH)))?

AN unquoted string is the first to last non-space characters on a line
before an optional comment.

=head3 Test Section of the Grammar

This section of TestML is the mini, generic programming language. In a
nutshell, the language consists of a list of chained expressions, some
of which make assertions. The following statements are valid syntax:

    # Expressions:
    'string';
    function();
    Constant;
    $data_point;
    $data_point.transform();
    $data_point.transform1().transform2();
    $data.trans('string', "string");
    $data1.trans1($data2, 'str').trans2($data3.trans3);

    # Assertions:
    <expression> == 'string';
    <expression> == Constant;
    <expression> == <expression>;
    <expression>.EQ(<expression>);

Lines beginning with '#' are comments. The first eight statements are
test I<expressions>. The last four lines are test assertions which test
the results of two expressions. The last two are equivalent operations
using different syntax. (Note: Replace '<expression>' with any valid
expression. '<foo>' is not valid TestML syntax)

=item test-section := ( ws | test-statement )*

The test section contains a small program written in the TestML
programming language. This language is used to describe data
transforms and the assertions that should hold. In other words, the
testing program.

The parsing of the meta section should instantiate a Test object. The
Test object will contain an abstract syntax tree that the TestML runtime
can execute.

=item ws := SPACE | EOL | comment

The C<ws> token represents characters in the stream that can be
thrown away.

=item test-statement := test-expression assertion-expression? ';'

A test statement is a processing directive for running tests. A
statement can either be a single test expression, which causes code to
run but doesn't execute tests, or it can be an assertion which runs a
test operation by comparing the results of two data expressions.

=item test-expression :=
    sub-expression (!assertion-call call-indicator sub-expression)*

A test expression is a series of one or more sub expressions which are
evaluated in order, passing the result of each to the next one.

=item sub-expression :=
    (transform-call | data-point | quoted-string | constant))

A sub expression can either start with a plain point name or a transform
function call. Then it is proceeded by a chain of any number of
transform calls.

All sub expressions are turned into transform calls after compilation. For
example:

   $foo.bar("baz") == True;

becomes (internally):

   Point('foo').bar(String("baz")).EQ(Global('True'));

=item transform-call := transform-name '(' ws* argument-list ws* ')'

A transform call consists of a transform name followed by parenthesized
arguments.

=item transform-name := user-transform | core-transform

A transform is either a standard core one, or a user defined transform.

=item user-transform := LOWER WORD*

A user data transform name is an identifier that begins with a lower
case letter. These transforms are defined by the implementor in the
bridge class.

=item core-transform := UPPER WORD*

A core data transform is defined in the TestML Standard Library.

=item call-indicator := (DOT ws* | ws* DOT)

A call indicator is a period between two sub expressions. The period
must be adjecent to one of the sub expressions.

=item data-point := DOLLAR LOWER WORD*

A data point is a user defined data name, preceded by a '$' and
beginning with a lower case letter.

A data point is really a short form for a transform call to 'Point' with
the point name. These are the same:

    $foo.bar();
    Point('foo').bar();

except that the dollar sign point names are also used to select the data
blocks that will apply to that expression.

Statements with points in them apply to all matching blocks. For
example, this TestML statement:

    $foo.bar() == $baz;

would behave like this TestMLesque pseudo-code:

    for block in SelectDataBlocks('foo', 'baz') {
        Assert(block.Point('foo').bar() == block.Point('baz'));
    }

NOTE: The above code is B<NOT> valid TestML.

=item constant := UPPER WORD*

A constant is a name beginning with an upper case letter. It refers to a
constant value defined in the standard library. It contains things like
True, False and Null.

=item argument-list := ( argument ( ws* ',' ws* argument )* )?

An argument list is a list of zero or more sub expressions.

=item argument := sub-expression

Any sub-expression can be an argument.

=item assertion-expression := assertion-operation | assertion-call

An assertion expression is a declaration of a testing operation. A typical
assertion looks like:

    $input-point.transform1().transform2(arguments) == $expected-output-point;

An assertion expression can either be an inline operator expression:

    $foo == $bar;

or a function call:

    $foo.EQ($bar);

=item assertion-operation := ws+ assertion-operator ws+ test-expression

An assertion expression is an operator followed by a data expression
that represents the expected value. The operator must have some
whitespace on either side.

=item assertion-operator := '=='

The only defined assertion operator currently is '==', which maps to 'EQ'.

=item assertion-call :=
    call-indicator assertion-name '(' ws* test-expression ws* ')'

A function assertion call is a special function call that takes one
entire expression as its argument.

=item assertion-name := UPPER+

An assertion name is the name of an assertion function defined by the
standard library. For this reason it begins with an upper case letter.

The only defined assertion name currently is 'EQ'.

=head3 Data Section of the Grammar

=item data-section :=
    testml-data-section |
    yaml-data-section |
    json-data-section |
    xml-data-section

The data section defines a sequence/array/list of data blocks, each of
which is mapping/hash/dictionary consisting of an optional short label
phrase and a set of named data points.

TestML defines a default data section syntax, but this section can also
be specified in YAML, JSON or XML.

The parsing of the data section should instantiate a Data object.

=item testml-data-section := block-marker (SPACE | EOL) rest

The I<TestML data section> starts when the data block marker is detected
at the beginning of a line and continues to the end of the file. This
section is parsed into I<data block> objects.

Here is an example data section in TestML:

    === Test one
    --- input: abc
    --- output: 123
    === Test two
    --- input: xyz
    --- output: 321

See L<TestML Data Section Grammar> for the more formal syntax grammar of
this format.

=item yaml-data-section :=  '---' (SPACE | EOL) rest

Here is an example data section in YAML:

    ---
    - -label: Test one
      input: abc
      output: 123
    - -label: Test two
      input: xyz
      output: 321

=item json-data-section :=  '[' rest

Here is an example data section in JSON:

    [
      {
        "-label": "Test one",
        "input": "abc",
        "output": "123"
      },
      {
        "-label": "Test two",
        "input": "xyz",
        "output": "321"
      }
    ]

=item xml-data-section :=  '<' rest

    <testml>
      <block label="Test one">
        <input>abc</input>
        <output>123</output>
      </block>
      <block label="Test two">
        <input>xyz</input>
        <output>321</output>
      </block>
    </testml>

=item rest := ANY+

The I<rest> token is simply the remainder of the text in the file.
The I<data sections> are all parsed by separate parsers/grammars.

=back

=head2 TestML Data Section Grammar

This grammar defines the TestML data section markup.

=over

=item data-section := data-block*

A data section consists of 0-n data blocks.

=item data-block := block-header (blank-line | comment)* block-point*

A data block in TestML syntax looks like:

    === Block Label
    --- point1: phrase data
    --- point2
    line
    data

=item block-header := block-marker (SPACE+ block-label)? SPACE* EOL

A block header marks the start of a new block. The first one also marks
the start of the data section. It contains an optional label.

    === The next big test

=item block-marker := '===' | Meta.BlockMarker

A block marker is usually C<===>, but it is configurable via a meta
statement, like this:

    BlockMarker: ***

=item block-label :=
    (ANY - (SPACE | BREAK))
    (NON-BREAK* (ANY - (SPACE | BREAK)))?

A label is a short description of the block. It can be used to label
tests at runtime.

=item block-point := lines-point | phrase-point

Data block points are the pieces of raw data that TestML transforms and
compares. They come in two flavors, lines and phrases.

=item lines-point := point-marker SPACE+ user-point SPACE* EOL (line - block-header)*

A "lines" data point encodes a string containing zero or more lines. If
it has one or more lines it always ends with a newline.

    --- lines
    line1
    line2 (3 is blank)
    
    line4

=item phrase-point := point-marker SPACE+ user-point ':' (SPACE NON-BREAK*)? EOL blank-line*

A "phrase" data point encodes a string with no newlines.

    --- phrase: This string is one line with no newline at the end.

=item point-marker := '---' | Meta.PointMarker

A point marker is usually C<--->, but it is configurable via a meta
statement, like this:

    %PointMarker: +++

=back

=head1 Valid Meta Keywords

The following meta section keywords are supported by TestML 1.0.

=over

=item TestML - B<required>

The C<TestML> meta statement is required, must be the first meta
statement and must specify a valid TestML release version number.

Once the version number is known by the parser, it controls how the rest
of the document is parsed. If the parser does not support the specified
version number, it must raise an exception.

For example:

    %TestML: 1.0

As a guideline, the TestML specification authors will attempt to be
backwards compatible with version numbers that have the same first
number. So version 1.3 would be backwards compatible with 1.2, 1.1 and
1.0. Version 2.0 would probably break compatability.

=item Title - I<optional>

The I<Title> meta option specifies a short title phrase to describe the
entire TestML document.

    %Title: These are a few of my Favorite Tests!

The TestML implementation is free to use this meta field as it sees fit.

=item Data - I<optional>

The I<Data> meta option can be specified zero, one or multiple times. It
names a relative file path that should be read and parsed as a data
section. The resulting sequences of all the data files are concatenated
together into the Data object.

By default, the inline data section comes first when other data sources are
specified. A special file path name '_' can be used to indicate the inline
data section.

The file extension is used to determine the format of the data section
encoded in the file.

Example:

    %Data: file1.tml
    %Data: file2.xml
    %Data: _
    %Data: file4.yaml

The Data attribute of the Meta object is always stored as an array.

=item Plan - I<optional>

The I<Plan> meta option specifies the expected number of tests that will
be run by the runner. If the actual number differs the implementation
should complain or raise an exception.

    %Plan: 13

=item BlockMarker - I<optional>

If you choose to use the TestML data markup to encode your data section,
you can choose the character sequence to replace the default ('===').
You would wnat to do this primarily if you had '===' at the beginning of
a line in your data.

Setting this option causes the parser to immediately start looking for
the specified pattern to indicate the start of the data section.

    %BlockMarker: *=*

=item PointMarker - I<optional>

This option is the same as the BlockMarker option above, except
it is for the data point marker.

    %PointMarker: +++

=back

=head1 TestML Standard Library

TestML defines a standard library specification. The standard library
must be implemented and available in every TestML implementation. The
library specification has a version number that is kept in sync with
this specification's version number.

The Standard Library Specification is defined in a separate document. The
latest version is available at L<http://testml.org/spec/stdlib/>.

=head1 TestML Runtime Specification

In order to develop a TestML implementation, one must correctly implement the
runtime processing. TestML defines a runtime specification. The runtime
specification has a version number that is kept in sync with this
specification's version number.

The TestML Runtime Specification is defined in a separate document. The
latest version is available at L<http://testml.org/spec/runtime/>.

=head1 Authors

TestML Version 1.0 was created by Ingy döt Net <ingy@ingy.net>

The spec was reviewed and/or contributed to by the following people:

=over

=item * Tony Bowden

=item * Chris Dent

=item * Yuval Kogman

=item * Adam Kennedy

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
