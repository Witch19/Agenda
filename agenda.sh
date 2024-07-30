#!/bin/bash
agenda_principal="agenda"
agenda_ordenada="agenda_orden"
echo "Creando asgenda: " $agenda_principal
mkdir -p $agenda_principal
mkdir -p $agenda_ordenada
#read -p "Press enter" 
#Aqui va ayudarme a saber en donde se estan guardando el archivo
ruta_carpeta(){
    clear
    echo "-----------------------------------"
    pwd
    echo "Presione Enter para continuar"
    read -r
}

# Esta funcion va agregar un contacto mientras los va ordenando, obtiene la fecha 
# actual,va a crear un directorio por el dia en el que agrege un nuevo contacto, 
# la fecha en el que se creo el nuevo contacto, utiliza los comandos > y >> para
# colocar el directorio y archivos, en awk me va a ayudar a oredenar por el nombre
# el comando xargs se va a ejecutar dependiendo la carga de datos que tenga y los 
# va a ir ordenando.
anadirContacto(){
    clear
    echo "-----------------------------------"
    echo "       AGREGAR NUEVO CONTACTO"
    echo "Ingrese un el nombre: "
    read contacto

    fecha=$(date +%F)
    #mkdir -p $agenda_orden/$fecha
    #echo "Creando agenda oredenda: "$agenda_ordenada/$fecha
    #echo $agenda_principal/$fecha
    mkdir -p $agenda_principal/$fecha
    echo "Nombre: $contacto" > "$agenda_principal/$fecha/$contacto.txt"
    #awk -F":""{printf"Nombre: %-15s Fecha: ""$agenda_principal"}"
    echo "Fecha de creacion: $(date)" >> "$agenda_principal/$fecha/$contacto.txt"
    echo "Contacto añadido en $fecha "
    echo "Presione Enter para continuar"
    read -r

    
    #cd $agenda_principal/$fecha || return
    #read -p "Press enter"
    #ls *.txt | awk -F'[_.]' '{print $1,$3}' | sort | awk '{print $1"."$2}' | xargs -I {} mv {} "$agenda_ordenada/$fecha"
    #cd ../..
    mkdir -p "$agenda_ordenada/$fecha"
    mv "$agenda_principal/$fecha/$contacto.txt" "$agenda_ordenada/$fecha/"
    
    #ruta_carpeta
}


#Esta funcion va a coger la carpeta que ya se ordeno y va a verificar si existen, o
#mostrara los contactos que ha encontrado, le va buscar la carpeta del dia que quiere
#buscar y lo va a filtrar por nombre del contacto que quiere ingresar
mostrarDias(){
    clear
    echo "------------------------------------"
    echo " LISTA DE DIAS QUE TIENEN CONTACTOS"

    echo "agenda orden: " $agenda_ordenada
    dias=($agenda_ordenada/*)
    echo "dias" $dias

    #echo "Dia encontrado disponibles: "
    echo "Valores encontrados: " ${#dias[@]}
    
    if [ ${#dias[@]} -eq 0 ]; then
        echo "No hay días con contactos."
        echo "Presione Enter para continuar."
        read -r
        return
    fi
    
    echo "------------------------------------"
    echo "Días disponibles: "
    for (( index = 0; index < ${#dias[@]}; index++ )); do
        dia=$agenda_ordenada/$fecha
        #dia="${dias[$index]}"
        nContactos=$(find "$dia" -maxdepth 1 -type f -name "*.txt"| wc -l)
        #read -p "Press enter" 
        echo "$((index + 1)). $(basename "$dia") - Contactos: '$nContactos'"
        #read -p "Press enter" 
        #return ((index))
    done
    
    echo "------------------------------------"
    echo -n "Que dia desea ver? "
    read -r nDia
    #echo "Valor: ${#dia[@]}"
    
    if [ "$nDia" -ge 1 ] && [ "$nDia" -le ${#dias[@]} ]; then
        diaSeleccionado="${dias[$((nDia - 1))]}"
        clear
        echo "---------------------------------"
        echo "Contactos del día $(basename "$diaSeleccionado")"
        ls -l "$diaSeleccionado"/*.txt

        echo "Ingrese el nombre de la persona que quiere encontrar: "
        read fNombre

        if [ -z "$fNombre" ]; then
            cat "$diaSeleccionado"/*.txt
        else
            grep -l -i "$fNombre" "$diaSeleccionado"/*.txt | xargs cat
        fi

    else
        echo "No se ha podido encontrar"
    fi

    echo "Presione Enter para continuar"
    read -r
}

while true; do
    clear
    echo "------------------------------------"
    echo "              AGENDA"
    echo "1. AGREGAR NUEVO CONTACTO"
    echo "2. MOSTRAR LOS DIAS"
    echo "3. MOSTRAR LA UBICACION"
    echo "4. SALIR"
    echo "------------------------------------"
    echo -n "SELECCIONE UNA OPCION: "
    read op

    case $op in
        1)
            anadirContacto
            ;;
        2)
            mostrarDias
            ;;
        3)
            ruta_carpeta
            ;;
        4)
            echo "-------------------------------------"
            echo "              HASTA LUEGO"
            echo "             VUELVA PRONTO"
            break
            ;;
        *)
            echo "NO SE HA ENCONTRADO VUELVA A DIJITAR, GRACIAS."
            ;;
    esac
done

        

