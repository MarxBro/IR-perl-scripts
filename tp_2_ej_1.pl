#!/usr/bin/perl
system(clear);

#################
### Variables ###  
#################

$directorio_coleccion_gr = './colecciones/T12012-gr';

$archivo_terminos = './salidas/terminos.txt';

$archivo_estadisticas = './salidas/estadisticas.txt';

$archivo_frecuencias = './salidas/frecuencias.txt';

#################
### Principal ###
#################

# Abrimos el directorio
opendir (dir, $directorio_coleccion_gr) or die "No se pudo abrir";

# Recorremos cada archivo
while( $file = readdir( dir ) ) {
    
    # Ignoramos las referencias de unix a si mismo y al padre
    if( $file ne "." and $file ne ".." ) {
        
        # Abre el archivo
        open (IN,"$directorio_coleccion_gr/$file");
        print "Analizando archivo: $file\n";
        
        # Para cada lines del archivo
        while( $linea = <IN> ) {
            
            chomp($linea);
            
            # Aca definimos que consideramos una palabra de nuestro vocabulario
            
            # Agregamos separacion de espacios a caracteres que nos interesa ignorar en los tokens
            $linea =~ s/\(/ \( /g;
            $linea =~ s/\)/ \) /g;
            $linea =~ s/\[/ \[ /g;
            $linea =~ s/\]/ \] /g;
            $linea =~ s/\{/ \{ /g;
            $linea =~ s/\}/ \} /g;
            $linea =~ s/;/ ; /g;
            $linea =~ s/,/ , /g;
            $linea =~ s/:/ : /g;
            $linea =~ s/!/ ! /g;
            $linea =~ s/¡/ ¡ /g;
            $linea =~ s/¿/ ¿ /g;
            $linea =~ s/\?/ \? /g;
            $linea =~ s/\*/ \* /g;
            $linea =~ s/\|/ \| /g;
            
            # Eliminamos caracteres que no nos interesa procesar
            $linea =~ s/"/ /g;
            $linea =~ s/'/ /g;
            $linea =~ s/“/ /g;
            $linea =~ s/‘/ /g;
            $linea =~ s/’/ /g;
            $linea =~ s/´/ /g;
            
            
            # Transformamos acentos a vocales comunes y otros caracteres
            $linea =~ s/á/a/g;
            $linea =~ s/Á/A/g;
            $linea =~ s/é/e/g;
            $linea =~ s/É/E/g;
            $linea =~ s/í/i/g;
            $linea =~ s/Í/I/g;
            $linea =~ s/ó/o/g;
            $linea =~ s/Ó/O/g;
            $linea =~ s/ú/u/g;
            $linea =~ s/Ú/U/g;
            $linea =~ s/ñ/n/g;
            $linea =~ s/Ñ/N/g;
            
            
            # Las palabras se separan por espacios
            @palabras = split(" ", $linea);
            
            foreach $palabra ( @palabras ) {
                
                $frecuencias{$palabra} += 1;
                
            }
            
        }
    
    }

}

# Abrimos el archivo de salida de terminos
open(OUT, ">$archivo_terminos");

# Teniendo procesada toda la coleccion
foreach $key ( sort( keys %frecuencias ) ) {
            
    print OUT "Clave: $key\tFrecuencia: ". $frecuencias{$key} . "\n";
    
    
}
