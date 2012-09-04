#!/usr/bin/perl
system(clear);

# Loads the module and imports any functions into our namespace 
# (defaults to "main") exported by the module.  Hello::World exports
# hello() by default.  Exports can usually be controlled by the caller.

# supone la existencia de una carpeta lib/ al mismo nivel que el script
use lib('lib/');
use Hello::World;
 
print hello();             # prints "Hello, world!\n"
print hello("Milky Way");  # prints "Hello, Milky Way!\n"
