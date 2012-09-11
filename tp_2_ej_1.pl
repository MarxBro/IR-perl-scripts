#!/usr/bin/perl
system(clear);

#################
### Variables ###  
#################

$directorio_coleccion_gr = './colecciones/T12012-gr';

$archivo_terminos = './salidas/terminos.txt';

$archivo_estadisticas = './salidas/estadisticas.txt';

$archivo_frecuencias = './salidas/frecuencias.txt';

# Tratamiento de palabras vacias
$ignorar_palabras_vacias = 1; # 0: False; 1: True;
@palabras_vacias = [qw(el la lo los las este esta ese esa en un no x n a d p e k o stm_aix raquo al de del que y i para se su es con por una var if font function size 0 1 2 3 4 5 6 7 8 9 " ' “ ‘ ’ ´ ¨ , ; : = - \) \( / \\ [ ] { } | & ? ¿ ! * < >)];

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
        
        $estadisticas{"Cantidad de documentos procesados"} += 1;
        
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
            $linea =~ s/\-/ \- /g;
            
            # Eliminamos caracteres que no nos interesa procesar
            #            0        1                  2 |0        1         2  
            #            12345678901 2 3 4 5 6 7 8 9 01 123456789012345678901
            #$linea =~ tr/"'“‘’´¨,;:=\-\)\(\/\[\]\{\}\|&/                     /;
            
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
                $palabra =~ s/\"$//g;
                $palabra =~ s/^\"//g;
                $palabra =~ s/\'$//g;
                $palabra =~ s/^\'//g;
                
                if( not $ignorar_palabras_vacias ) {
                    
                    # Calculo del TF
                    $frecuencias{$palabra}{"TF"} += 1;
                    
                    # Recogemos estadisticas de cantidad de terminos por documento
                    $estadisticas{"cantidad_terminos_documentos"}{$file}{$palabra} += 1;
                    
                    # Para despues calcular el DF
                    $frecuencias{$palabra}{$file} = 1;
                    
                } else {
                    
                    if ( not ( $palabra ~~ @palabras_vacias ) ) {
                        
                        # Calculo del TF
                        $frecuencias{$palabra}{"TF"} += 1;
                        
                        # Recogemos estadisticas de cantidad de terminos por documento
                        $estadisticas{"cantidad_terminos_documentos"}{$file}{$palabra} += 1;
                        
                        # Para despues calcular el DF
                        $frecuencias{$palabra}{$file} = 1;
                        
                    }
                    
                }
                
            }
            
        }
        
        close(IN);
    
    }

}

# Armamos un arreglo con las claves ordenadas por la TF en forma descendente, para el punto c) del TP
@terminos_ordenados_por_frecuencias = sort { $frecuencias{$b}{"TF"} <=> $frecuencias{$a}{"TF"} } keys %frecuencias;

$estadisticas{"Cantidad de terminos extraidos"} = scalar(keys %frecuencias);

$estadisticas{"Promedio de terminos por documento"} =  int($estadisticas{"Cantidad de terminos extraidos"} / $estadisticas{"Cantidad de documentos procesados"});

# Calculo del DF
foreach $termino (keys %frecuencias) {
    
    $df = 0;
    
	foreach $documento (keys %{$frecuencias{$termino}}) {
        
        $df += 1;
        
	}
    
    # Ignoramos el indice TF que no corresponde
    $df = $df - 1;
    
    $estadisticas{"Largo promedio de un termino"} += length($termino);
    
    $frecuencias{$termino}{"DF"} = $df;
    
    # Calculamos la cantidad de documentos con TF = 1
    
    if ( $frecuencias{$termino}{"TF"} == 1 ) {
        
        $estadisticas{"Cantidad de terminos con frecuencia 1 en la coleccion"} += 1;
        
    }
    
}

$estadisticas{"Largo promedio de un termino"} = int($estadisticas{"Largo promedio de un termino"} / $estadisticas{"Cantidad de terminos extraidos"});

# Busco documento mas corto y mas largo
$estadisticas{"Cantidad de terminos del documento mas largo"} = 0;
$estadisticas{"Cantidad de terminos del documento mas corto"} = $estadisticas{"Cantidad de terminos extraidos"};

foreach $documento (keys %{$estadisticas{"cantidad_terminos_documentos"}}) {
    
    # Calculamos la cantidad de terminos para el documento actual
    $cantidad_terminos_documento = scalar(keys %{$estadisticas{"cantidad_terminos_documentos"}{$documento}});
    
    if( $estadisticas{"Cantidad de terminos del documento mas largo"} < $cantidad_terminos_documento ) {
        
        $estadisticas{"Cantidad de terminos del documento mas largo"} = $cantidad_terminos_documento;
        $estadisticas{"Nombre del documento mas largo"} = $documento;
        
    }
    
    if( $estadisticas{"Cantidad de terminos del documento mas corto"} > $cantidad_terminos_documento ) {
        
        $estadisticas{"Cantidad de terminos del documento mas corto"} = $cantidad_terminos_documento;
        $estadisticas{"Nombre del documento mas corto"} = $documento;
        
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
open(OUT, ">$archivo_estadisticas");

print OUT "Estadisticas de la coleccion:\n";
print OUT "=============================\n";
print OUT "Cantidad de documentos procesados: $estadisticas{'Cantidad de documentos procesados'}\n";
print OUT "Cantidad de terminos extraidos: $estadisticas{'Cantidad de terminos extraidos'}\n";
print OUT "Promedio de terminos por documento: $estadisticas{'Promedio de terminos por documento'}\n";
print OUT "Largo promedio de un termino: $estadisticas{'Largo promedio de un termino'}\n";
print OUT "Nombre del documento mas largo: $estadisticas{'Nombre del documento mas largo'}\n";
print OUT "Cantidad de terminos del documento mas largo: $estadisticas{'Cantidad de terminos del documento mas largo'}\n";
print OUT "Nombre del documento mas corto: $estadisticas{'Nombre del documento mas corto'}\n";
print OUT "Cantidad de terminos del documento mas corto: $estadisticas{'Cantidad de terminos del documento mas corto'}\n";
print OUT "Cantidad de terminos con frecuencia 1 en la coleccion: $estadisticas{'Cantidad de terminos con frecuencia 1 en la coleccion'}\n";
print OUT "\n";

close(OUT);

### FRECUENCIAS.TXT

# Abrimos el archivo
open(OUT, ">$archivo_frecuencias");

print OUT "Los 10 terminos mas frencuentes de la coleccion:\n";
print OUT "================================================\n";

for ($i=0; $i<=9; $i++)
{   
    $elem = @terminos_ordenados_por_frecuencias[$i];
    print OUT "$elem: $frecuencias{$elem}{'TF'}\n";
}

print OUT "\nLos 10 terminos menos frencuentes de la coleccion:\n";
print OUT "==================================================\n";

$desde = scalar(@terminos_ordenados_por_frecuencia) - 10;
$hasta = scalar(@terminos_ordenados_por_frecuencia) - 1;

for ($i=$desde; $i<=$hasta; $i++)
{   
    $elem = @terminos_ordenados_por_frecuencias[$i];
    print OUT "$elem: $frecuencias{$elem}{'TF'}\n";
}

close(OUT);

