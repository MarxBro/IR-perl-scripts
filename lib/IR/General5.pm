package IR::General5;

#use strict;
use warnings;

use Switch;

use utf8;

our $VERSION = '1.0';

use base 'Exporter';

our @EXPORT = qw(palabras_vacias preparar_linea tokenizar limpiar_token token_valido);

=head1 NAME

IR::General5 - Metodos generales y utiles para IR

=head1 SYNOPSIS

  use IR::General5;
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

### VARIABLES DEL MODULO

# Tratamiento de palabras vacias
$aceptar_palabras_vacias = 0; # 0: False; 1: True;
@palabras_vacias = palabras_vacias();

$tamano_minimo = 1;
$tamano_maximo = 24; # Estudiar un poco mas

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
    
    # Eliminamos caracteres que no nos interesa procesar
    $linea =~ tr/"+#%.<>\\\/“” ´'·¨‘’\(\)[]{};:!¡¿?*\|º°~¦§ª=&_»«/                                                 /;
    
    utf8::decode($linea);
    
    # Normalizamos caracteres
    $linea =~ tr/ñÑóíáéúüÓÍÁÉÚÜàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛäëïöÄËÏÖåÅãÃõÕ/nNoiaeuuOIAEUUaeiouAEIOUaeiouAEIOUaeioAEIOaAaAoO/;
    
    # Pasamos todo a minuscula
    $linea =~ tr/A-Z/a-z/;
    
    # Si hay caracteres no numericos con , y sin espacio, eliminamos la , por un espacio
    $linea =~ s/([a-z]+),/$1 /g;
    $linea =~ s/,([a-z]+)/ $1/g;
    
    # Si encontramos numeros "pegados" a texto, lo separamos, y visceversa
    #~ $linea =~ s/([0-9])([a-z])/$1 $2/g;
    #~ $linea =~ s/([a-z])([0-9])/$1 $2/g;
    # No usar, rompemos url, mails, etc..
    
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
    
    # Si termina o empieza con punto u otro caracter que tmb lo reemplaze
    $token =~ s/\.+$/ /g;
    $token =~ s/^\.+/ /g;
    $token =~ s/\,+$/ /g;
    $token =~ s/^\,+/ /g;
    $token =~ s/\++$/ /g;
    $token =~ s/^\++/ /g;
    $token =~ s/\$+$/ /g;
    $token =~ s/^\$+/ /g;
    $token =~ s/\%+$/ /g;
    $token =~ s/^\%+/ /g;
    $token =~ s/\-+$/ /g;
    $token =~ s/^\-+/ /g;
    
    # Eliminamos todos los espacios
    $token =~ s/\s//g;
    
    return $token;
    
}

# Definicion de token_valido()
#   Esta funcion tiene como mision decidir que considera un token y que no
#   Establecemos en el switch todas las estructuras validas, y al final, algunas
#       condiciones adicionales de verificacion.
sub token_valido {
    
    my $token = shift;
    
    $token_valido = 0;
    
    if ( (not es_palabra_vacia($token)) and tiene_largo_adecuado($token) ) {
    
        switch ($token) {
            
            case m/[0-9]+[\.|\,]*[0-9]*[\.|\,]*[0-9]*/  { 
                
                # Formato de numero
                $token_valido = 1;
                
            }
            
            case m/[a-z]+/ {
                
                # Formato palabras
                $token_valido = 1;
                
            }
        
        }
    
    }
    
    return $token_valido;
    
}

sub es_palabra_vacia {
    
    my $token = shift;
    
    if( $aceptar_palabras_vacias ) {
        
        return 0;
        
    } else {
        
        if ( $token ~~ @palabras_vacias ) {
            
            return 1;
            
        } else {
            
            return 0;
            
        }
        
    }
    
}

sub tiene_largo_adecuado {
    
    my $token = shift;
    
    #~ # Solo se usa a fin de investigar los caracteres largos. Es poco performante asi que comentar en produccion
    #~ if ( length($token) > $tamano_maximo ) {
        #~ 
        #~ open(OUT, ">>salidas/tokens_largos.txt");
        #~ 
        #~ print OUT "$token\n";
        #~ 
        #~ close(OUT);
        #~ 
    #~ }
    
    if ( ( length($token) > $tamano_minimo ) and ( length($token) < $tamano_maximo ) ) {
        
        return 1;
        
    } else {
        
        return 0;
        
    }
        
}

=head1 AUTHOR

Tomas Delvechio <tomas@nesys.com.ar>
Modulo escrito gracias a la documentacion de http://en.wikipedia.org/wiki/Perl_module

=cut

# Todo modulo de perl debe terminar en 1 (True)
1;
