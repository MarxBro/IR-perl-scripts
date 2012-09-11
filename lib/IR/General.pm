package IR::General;

#use strict;
use warnings;

our $VERSION = '1.0';

use base 'Exporter';

our @EXPORT = qw(palabras_vacias preparar_linea tokenizar limpiar_token token_valido);

=head1 NAME

IR::General - Metodos generales y utiles para IR

=head1 SYNOPSIS

  use IR::General;
  @stop_words = palabras_vacias();
  $linea = preparar_linea($linea);

=head1 DESCRIPTION

Modulo de funciones generales y utiles para manejo de IR

=head2 Functions

Las siguientes funciones son exportadas por defecto al invocar el modulo.

=head3 palabras_vacias

    @stop_words = palabras_vacias();

Retorna un arreglo con las palabras que se consideran vacias

=head3 preparar_linea

    $linea = preparar_linea($linea)

Se encarga de dejar la linea del archivo lista para ser tokenizada en un paso posterior

=cut

# Tratamiento de palabras vacias
$ignorar_palabras_vacias = 1; # 0: False; 1: True;
@palabras_vacias = palabras_vacias();

# Definicion de la funcion palabras_vacias().
sub palabras_vacias {
    
    open (FH, "lib/IR/stopwords.txt") or die "No se pudo abrir el archivo: $!";
    
    while($termino = <FH>) {
        
        chomp($termino);
        
        push(@palabras_vacias, $termino);
        
    }
    
    close FH or die "No se pudo cerrar el archivo: $!"; 
    
    @otros_simbolos = [qw(x n a d p e k o stm_aix raquo i var if font function size 0 1 2 3 4 5 6 7 8 9 " ' “ ‘ ’ ´ ¨ , ; : = - \) \( / \\ [ ] { } | & ? ¿ ! * < >)];
    
    return (@palabras_vacias,@otros_simbolos);
    
}

# Definicion de la funcion preparar_linea()
# Esta funcion limpia la linea y la deja preparada para tokenizar
sub preparar_linea {
    
    my $linea = shift;
    
    chomp($linea);
    
    # Agregamos separacion de espacios a caracteres que nos interesa ignorar en los tokens
    
    # Eliminamos caracteres que no nos interesa procesar
    $linea =~ tr/"+#%.<>\\\/“” ´'·¨‘’\(\)[]{};,:!¡¿?*\|º°~¦§ª=&/                                              /;
    
    # Normalizamos caracteres
    $linea =~ tr/ñÑóíáéúüÓÍÁÉÚÜàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛäëïöÄËÏÖåÅãÃõÕ/nNoiaeuuOIAEUUaeiouAEIOUaeiouAEIOUaeioAEIOaAaAoO/;
    
    # Pasamos todo a minuscula
    $linea =~ tr/A-Z/a-z/;
    
    return $linea;
    
}

# Definicion de la funcion tokenizar()
# Esta funcion transforma una linea en tokens especificos
sub tokenizar {
    
    my $linea = shift;
    
    # Las palabras se separan por espacios
    @tokens = split(" ", $linea);
    
    return @tokens;
    
}

# Definicion de limpiar_token()
# Funcion que se encarga de borrar todo lo que no se acepta como token. Devolvera el token listo para ser usado en el indice
sub limpiar_token {
    
    my $token = shift;
    
    # Eliminamos todos los espacios
    $token =~ s/\s//g;
    
    # Si termina con punto u otro caracter que tmb lo reemplaze
    $token =~ s/\.+$//g;
    $token =~ s/^\.+//g;
    $token =~ s/\++$//g;
    $token =~ s/^\++//g;
    $token =~ s/\$+$//g;
    $token =~ s/^\$+//g;
    $token =~ s/\%+$//g;
    $token =~ s/^\%+//g;
    
    return $token;
    
}

# Definicion de token_valido()
#   Esta funcion tiene como mision decidir que considera un token y que no
sub token_valido {
    
         
    switch ($val) {
    case 1	{ print "number 1" }
    case "a"	{ print "string a" }
    case [1..10,42]	{ print "number in list" }
    case (\@array)	{ print "number in list" }
    case /\w+/	{ print "pattern" }
    case qr/\w+/	{ print "pattern" }
    case (\%hash)	{ print "entry in hash" }
    case (\&sub)	{ print "arg to subroutine" }
    else { print "previous case not true" }
    }
    
    my $token = shift;
    
    if( ( not $ignorar_palabras_vacias ) and ( not $token eq " " ) ) {
        
        return 1;
        
    } else {
        
        if ( ( not ( $token ~~ @palabras_vacias ) ) and ( not $token eq " " ) ) {
            
            return 1;
            
        } else {
            
            return 0;
            
        }
        
    }
    
}

=head1 AUTHOR

Tomas Delvechio <tomas@nesys.com.ar>
Modulo escrito gracias a la documentacion de http://en.wikipedia.org/wiki/Perl_module

=cut

# Todo modulo de perl debe terminar en 1 (True)
1;
