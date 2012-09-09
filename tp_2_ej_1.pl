#!/usr/bin/perl
system(clear);

#################
### Variables ###  
#################

$directorio_coleccion_gr = './colecciones/T12012-gr';

$archivo_terminos = './salidas/terminos.txt';

$archivo_estadisticas = './salidas/estadisticas.txt';

$archivo_frecuencias = './salidas/frecuencias.txt';

#####################
### Procesamiento ###
#####################

# Abrimos el directorio
opendir (dir, $directorio_coleccion_gr) or die "No se pudo abrir";

# Recorremos cada archivo
while( $file = readdir( dir ) ) {
    
    # Ignoramos las referencias de unix a si mismo y al padre
    if( $file ne "." and $file ne ".." ) {
        
        # Abre el archivo
        open (IN,"$directorio_coleccion_gr/$file");
        print "Analizando archivo: $file\n";
        
        $estadisticas{"cantidad_documentos_procesados"} += 1;
        
        # Para cada linea del archivo
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
            $linea =~ s/\¿/ \¿ /g;
            $linea =~ s/\?/ \? /g;
            $linea =~ s/\*/ \* /g;
            $linea =~ s/\|/ \| /g;
            $linea =~ s/°/ ° /g;
            $linea =~ s/=/ = /g;
            $linea =~ s/&/ & /g;
            $linea =~ s/\// \/ /g;
            $linea =~ s/\/\// \/\/ /g;
            $linea =~ s/-/ - /g;
            
            # Eliminamos caracteres que no nos interesa procesar
            #            1234567 1234567
            $linea =~ tr/"'“‘’´¨/       /;
            
            # Transformamos acentos a vocales comunes y otros caracteres
            $linea =~ tr/áÁéÉíÍóÓúÚñÑ/aAeEiIoOuUnN/;
            
            # Pasamos todo a minuscula
            $linea =~ tr/A-Z/a-z/;
            
            # Las palabras se separan por espacios
            @palabras = split(" ", $linea);
            
            # Procesamos cada una de las palabras de la linea
            foreach $palabra ( @palabras ) {
                
                # De la palabra eliminamos todos los espacios en blanco adicionales
                $palabra =~ s/\s+/ /g;
                
                # Si termina con punto u otro caracter que tmb lo reemplaze
                $palabra =~ s/\.+$//g;
                $palabra =~ s/^\.+//g;
                $palabra =~ s/\++$//g;
                $palabra =~ s/^\++//g;
                $palabra =~ s/\$+$//g;
                $palabra =~ s/^\$+//g;
                $palabra =~ s/\%+$//g;
                $palabra =~ s/^\%+//g;
                $palabra =~ s/\#+$//g;
                $palabra =~ s/^\#+//g;
                
                # Calculo del TF
                $frecuencias{$palabra}{"TF"} += 1;
                
                # Recogemos estadisticas de cantidad de terminos por documento
                $estadisticas{"cantidad_terminos_documentos"}{$file} += 1;
                
                # Para despues calcular el DF
                $frecuencias{$palabra}{$file} = 1;
                
            }
            
        }
        
        close(IN);
    
    }

}

$estadisticas{"cantidad_terminos_extraidos"} = scalar(keys %frecuencias);

$estadisticas{"promedio_terminos_por_documento"} =  $estadisticas{"cantidad_terminos_extraidos"} / $estadisticas{"cantidad_documentos_procesados"};

# Calculo del DF
foreach $termino (keys %frecuencias) {
    
    $df = 0;
    
	foreach $documento (keys %{$frecuencias{$termino}}) {
        
        $df += 1;
        
	}
    
    # Ignoramos el indice TF que no corresponde
    $df = $df - 1;
    
    $estadisticas{"largo_promedio_terminos"} += length($termino);
    
    $frecuencias{$termino}{"DF"} = $df;
    
    # Calculamos la cantidad de documentos con TF = 1
    
    if ( $frecuencias{$termino}{"TF"} == 1 ) {
        
        $estadisticas{"cantidad_terminos_tf_uno"} += 1;
        
    }
    
}

$estadisticas{"largo_promedio_terminos"} = int($estadisticas{"largo_promedio_terminos"} / $estadisticas{"cantidad_terminos_extraidos"});

# Busco documento mas corto y mas largo
$estadisticas{"terminos_documento_mas_largo"} = 0;
$estadisticas{"terminos_documento_mas_corto"} = $estadisticas{"cantidad_terminos_extraidos"};

foreach $documento (keys %{$estadisticas{"cantidad_terminos_documentos"}}) {
    
    if( $estadisticas{"terminos_documento_mas_largo"} < $estadisticas{"cantidad_terminos_documentos"}{$documento} ) {
        
        $estadisticas{"terminos_documento_mas_largo"} = $estadisticas{"cantidad_terminos_documentos"}{$documento};
        $estadisticas{"nombre_documento_mas_largo"} = $documento;
        
    }
    
    if( $estadisticas{"terminos_documento_mas_corto"} > $estadisticas{"cantidad_terminos_documentos"}{$documento} ) {
        
        $estadisticas{"terminos_documento_mas_corto"} = $estadisticas{"cantidad_terminos_documentos"}{$documento};
        $estadisticas{"nombre_documento_mas_corto"} = $documento;
        
    }
    
}

###############
### SALIDAS ###
###############

### TERMINOS.TXT

# Abrimos el archivo de salida de terminos
open(OUT, ">$archivo_terminos");

# Teniendo procesada toda la coleccion
foreach $termino ( sort( keys %frecuencias ) ) {
            
    #print OUT "Termino: $key\tTF: ". $frecuencias{$key} . "\n";
    printf(OUT "Termino: %-50s TF: %-5s  DF: %s\n", $termino, $frecuencias{$termino}{"TF"}, $frecuencias{$termino}{"DF"});
    
}

close(OUT);

### ESTADISTICAS.TXT

# Abrimos el archivo
#open(OUT, ">$archivo_estadisticas");

#close(OUT);
