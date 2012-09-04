package IR::Archivos;

use strict;
use warnings;

our $VERSION = '1.0';

use base 'Exporter';

our @EXPORT = qw(file2hash);

=head1 NAME

IR::Archivos - Modulo de implementacion de metodos de archivos para IR en perl

=head1 SYNOPSIS

  use IR::Archivos;
  print file2hash($filename);

=head1 DESCRIPTION

Modulo de API con archivos en perl para manejar las estructuras comunmente usadas
en los scripts de IR

=head2 Functions

The following functions are exported by default

=head3 file2hash

    %nuevo_hash = file2hash($filename);

Retorna el archivo en un hash, donde el indice es una palabra y el contenido es
la cantidad de veces que aparece en <$filename>

=cut

# Definicion de la funcion file2hash().

sub file2hash {
    
    # Recupero el nombre del archivo
    my $file = shift;
    
    # Armar el procesamiento
    
    # Retornar el hash
    
}

=head1 AUTHOR

Tomas Delvechio <tomas@nesys.com.ar>
Modulo escrito gracias a la documentacion de http://en.wikipedia.org/wiki/Perl_module

=cut

# Todo modulo de perl debe terminar en 1 (True)
1;
