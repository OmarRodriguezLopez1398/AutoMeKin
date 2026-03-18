#!/bin/bash
# Extrae frecuencias de ORCA (cm-1), una por línea
# Sustituye frecuencias imaginarias menores de 1 por 1 (igual que get_freq_g09.sh)
awk '/VIBRATIONAL FREQUENCIES/{
        getline; getline   # saltar cabecera
        while(1){
            getline
            if(NF==0) break
            # línea típica: "  0:       0.00 cm**-1"
            freq=$2
            # eliminar el signo negativo para comparar magnitud
            val=freq; if(val<0) val=-val
            if(val<1) freq=1
            printf "%5.0f\n", freq
        }
     }' $1