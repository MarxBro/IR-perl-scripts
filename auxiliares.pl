#!/usr/bin/perl
system(clear);

# Archivo para calculos auxiliares. No son parte del TP.

################################################################################
#    CONTAR TERMINOS Y TOKENS EN UN ARCHIVO
################################################################################
# La idea es que teniendo un archivo de tokens separados por enter, contar la 
# cantidad de tokens DIFERENTES que aparecen.

# Recibo el archivo a analizar como parametro.
$archivo_analizar = $ARGV[0];

# Abre el archivo
open (IN,$archivo_analizar);
binmode (IN, "utf8");
print "Analizando archivo: $archivo_analizar\n";

# Para cada linea del archivo
while( $linea = <IN> ) {
    
    # Calculo del TF
    $frecuencias{$linea} += 1;
    
    }

$cantidad_terminos = scalar(keys %frecuencias);
print "Cantidad de terminos extraidos: $cantidad_terminos\n";

