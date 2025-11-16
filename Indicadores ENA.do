* Descarga de base de datos de la Encuesta Nacional Agropecuaria (ENA):
* 2022, 2023 y 2024

clear all
set more off

1. Carpeta principal

global project "C:\Users\DANIEL\Downloads\Cursos\Construcción de indicadores\Sesión 9"

global data    "$project\data"
global do      "$project\do"
global output  "$project\output"

cd "$data"

capture mkdir "data_2022"
capture mkdir "data_2023"
capture mkdir "data_2024"

cd "$data\data_2022"

forvalues i = 1737/1760 {  
    di "=== Procesando Módulo `i' (2022) ==="

    capture copy "https://proyectos.inei.gob.pe/iinei/srienaho/descarga/STATA/844-Modulo`i'.zip" 844-Modulo`i'.zip, replace  
    
    if _rc == 0 {
        capture shell powershell -command "Expand-Archive -Path '844-Modulo`i'.zip' -Force"  

        if _rc == 0 {
            capture shell powershell -command "Copy-Item '844-Modulo`i'\844-Modulo`i'\*.dta' -Destination '.' -Force"  

            if _rc == 0 {
                di "Módulo `i' procesado exitosamente"
            }
            else {
                di as error "Error al copiar archivos .dta del Módulo `i'"
            }
        }
        else {
            di as error "Error al descomprimir Módulo `i'"
        }

        capture erase 844-Modulo`i'.zip
        capture shell powershell -command "Remove-Item '844-Modulo`i'' -Recurse -Force"
    }
    else {
        di as error "Módulo `i' no disponible"
    }
}

di _n "=== Cambiando nombres de variables a minúsculas (2022) ==="
local dta_files : dir "." files "*.dta"

foreach file of local dta_files {
    di "Procesando: `file'"
    use "`file'", clear
    ren _all, lower
    save "`file'", replace
}

di _n "=== Proceso 2022 completado ==="
di "Total archivos .dta de 2022: " wordcount("`dta_files'")

cd "$data\data_2023"

forvalues i = 1828/1848 {
    di "=== Procesando Módulo `i' (2023) ==="
    
    capture copy "https://proyectos.inei.gob.pe/iinei/srienaho/descarga/STATA/922-Modulo`i'.zip" 922-Modulo`i'.zip, replace
    
    if _rc == 0 {
        capture shell powershell -command "Expand-Archive -Path '922-Modulo`i'.zip' -Force"
        
        if _rc == 0 {
            capture shell powershell -command "Copy-Item '922-Modulo`i'\922-Modulo`i'\*.dta' -Destination '.' -Force"
            
            if _rc == 0 {
                di "Módulo `i' procesado exitosamente"
            }
            else {
                di as error "Error al copiar archivos .dta del Módulo `i'"
            }
        }
        else {
            di as error "Error al descomprimir Módulo `i'"
        }
        
        capture erase 922-Modulo`i'.zip
        capture shell powershell -command "Remove-Item '922-Modulo`i'' -Recurse -Force"
    }
    else {
        di as error "Módulo `i' no disponible"
    }
}

di _n "=== Cambiando nombres de variables a minúsculas (2023) ==="
local dta_files : dir "." files "*.dta"
foreach file of local dta_files {
    di "Procesando: `file'"
    use "`file'", clear
    ren _all, lower
    save "`file'", replace
}

di _n "=== Proceso 2023 completado ==="
di "Total archivos .dta de 2023: " wordcount("`dta_files'")

cd "$data\data_2024"

forvalues i = 1893/1913 {
    di "=== Procesando Módulo `i' (2024) ==="
    
    capture copy "https://proyectos.inei.gob.pe/iinei/srienaho/descarga/STATA/973-Modulo`i'.zip" 973-Modulo`i'.zip, replace
    
    if _rc == 0 {
        capture shell powershell -command "Expand-Archive -Path '973-Modulo`i'.zip' -Force"
        
        if _rc == 0 {
            capture shell powershell -command "Copy-Item '973-Modulo`i'\973-Modulo`i'\*.dta' -Destination '.' -Force"
            
            if _rc == 0 {
                di "Módulo `i' procesado exitosamente"
            }
            else {
                di as error "Error al copiar archivos .dta del Módulo `i'"
            }
        }
        else {
            di as error "Error al descomprimir Módulo `i'"
        }
        
        capture erase 973-Modulo`i'.zip
        capture shell powershell -command "Remove-Item '973-Modulo`i'' -Recurse -Force"
    }
    else {
        di as error "Módulo `i' no disponible"
    }
}

di _n "=== Cambiando nombres de variables a minúsculas (2024) ==="
local dta_files : dir "." files "*.dta"
foreach file of local dta_files {
    di "Procesando: `file'"
    use "`file'", clear
    ren _all, lower
    save "`file'", replace
}

di _n "=== Proceso 2024 completado ==="
di "Total archivos .dta de 2024: " wordcount("`dta_files'")

cd "$data"

di _n "========================================="
di "=== DESCARGA COMPLETA DE TODOS LOS AÑOS ==="
di "========================================="

cd "$data\data_2022"

