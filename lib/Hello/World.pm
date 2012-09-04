# "package" is the namespace where the module's functionality/data resides. 
# It dictates the name of the file if you want it to be "use"d.
# If more than one word, it constrains the location of the module.

package Hello::World;


# By default Perl allows you to use variables without declaring 
# them.  This may be convenient for short scripts and one-liners.
# But in a longer unit of code such as a module it is wise to declare 
# your variables both to catch typos and to constrain their 
# accessibility appropriately from outside the module. The strict pragma
# forces you to declare your variables.

use strict;

# Similarly, Perl does not issue most compiler or run-time warnings by default.
# More complicated scripts, such as most modules, will usually find them very 
# helpful for debugging. The warnings pragma turns on optional warnings.

use warnings;

# A module's version number is stored in $ModuleName::VERSION; certain 
# forms of the "use" built-in depend on this variable being defined.

our $VERSION = '0.1';

# Inherit from the "Exporter" module which handles exporting functions.
# Most procedural modules make use of this.

use base 'Exporter';

# When the module is invoked, export, by default, the function "hello" into 
# the namespace of the using code.

our @EXPORT = qw(hello);

# Lines starting with an equal sign indicate embedded POD 
# documentation.  POD sections end with an =cut directive, and can 
# be intermixed almost freely with normal code.

=head1 NAME

Hello::World - An encapsulation of a common output message

=head1 SYNOPSIS

  use Hello::World;
  print hello();
  print hello("Milky Way");

=head1 DESCRIPTION

This is a procedural module which gives you the famous "Hello, world!"
message, and it’s even customizable!

=head2 Functions

The following functions are exported by default

=head3 hello

    print hello();
    print hello($target);

Returns the famous greeting.  If a C<$target> is given it will be used,
otherwise "world" is the target of your greeting.

=cut

# define the function hello().

sub hello {
    my $target = shift;
    $target = 'world' unless defined $target;

    return "Hello, $target!\n";
}

=head1 AUTHOR

Joe Hacker <joe@joehacker.org>

=cut

# A Perl module must end with a true value or else it is considered not to
# have loaded.  By convention this value is usually 1 though it can be
# any true value.  A module can end with false to indicate failure but
# this is rarely used and it would instead die() (exit with an error).
1;
