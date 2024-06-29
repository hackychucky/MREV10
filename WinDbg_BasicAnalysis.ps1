
# Instalacion del modulo WinDbg
New-DbgSession -Kernel -Id $kernelProcessId
# Importacion del modulo y configuracion
Import-Module WinDbg
Set-Location (Get-Module WinDbg).ModuleBase
# Obtencion del ID del proceso del sistema que deseas depurar
$kernelProcessId = Get-Process -Name "System" | Select-Object -ExpandProperty Id

# Inicio de nueva sesión de debugging
New-DbgSession -Kernel -Id $kernelProcessId

Write-Host "Conectando con el kernel..."
Write-Host "Conexión establecida con el kernel."
# Conexion establecida con el kernel al kernel. Ya se pueden usar los comandos de debug necesarios
# Analisis estandar de proceso, thread y dump automatico:
Invoke-DbgCommand "!process"
Invoke-DbgCommand "!thread"
Invoke-DbgCommand "!analyze -v"


# Funcion para mostrar el menú de opciones
function Show-Menu {
    Write-Host "Seleccione una opción:"
    Write-Host "1. Mostrar información de procesos y puertos, TCP/UDP"
    Write-Host "2. Mostrar información de conexiones de red"
    Write-Host "3. Modificar estructuras"
    Write-Host "4. Salir"
}

# Bucle para mostrar el menú y procesar la opción seleccionada
while ($true) {
    Show-Menu

    # Leer la opcion seleccionada por el user
    $option = Read-Host "Elija la opcion deseada"

    switch ($option) {
        1 {
           
            # Comandos para mostrar los puertos usados en el sistema
            Invoke-DbgCommand "!process 0 0"
            # Comando para mostrar información detallada de los puertos TCP/IP
            Invoke-DbgCommand "!tcpip 3"

            # Comando para mostrar informacion detallada de los puertos UDP
            Invoke-DbgCommand "!udp 3"
        }
        2 {
           # Comando para monitorizar conexiones de red
            Invoke-DbgCommand "!netscan" 
            
        }
        
        3 {
             # Se solicita  al usuario la direccion de memoria, el nombre del campo y el nuevo valor
             $MemoryAddress = Read-Host "Introduce la direccion de memoria de la estructura"
             $FieldName = Read-Host "Introduce el nombre del campo que desea modificar"
             $NewValue = Read-Host "Introduce el nuevo valor para el campo"
 
             # Se llama a la funcion para modificar la estructura con los valores proporcionados
             Modify-Structure -MemoryAddress $MemoryAddress -FieldName $FieldName -NewValue $NewValue
         
        }
        
        4 {
            Write-Host "Saliendo..."
            break
        }

        default {
            Write-Host "Opción invalida. Por favor, seleccione una opcin valida (1, 2 o 3)."
        }
    }
}

# Finaliza la sesion de depuracion fuera del ciclo
Stop-DbgSession