* 1. Encuesta Nacional Agropecuaria (ENA)


clear all
set more off

2. Carpeta principal

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

use "01_cap100_1.dta", clear

di _n "Verificando llave única"

isid anio conglomerado nselua ua

di _n "Resultado de la encuesta"
fre resfin

di _n "Distribución de código"

fre codigo

di _n "Distribución de código (ponderado)"

fre codigo [iw=factor]

cd "$data\data_2022"

use "01_cap100_2.dta", clear

d p105_n

isid anio conglomerado nselua ua p105_n

describe

tab codigo [iw=factor], m

di _n "=== Haciendo merge con 01_cap100_1 ==="

merge m:1 anio conglomerado nselua ua using "01_cap100_1.dta" 

tab _merge

drop if _merge == 2
drop _merge

save "cap100_merge.dta", replace

di _n "=== Base cap100_merge.dta guardada ==="
di "Observaciones finales: " _N

cd "$data\data_2022"

use 01_cap100_1.dta, clear

gen factor2=round(factor)

tab codigo

tab nombredd

replace nombredd = "LIMA" if nombredd == "CALLAO"
compress

encode nombredd, gen(dpto)
fre dpto

sort dpto

tabstat p101 [fw=factor2], s(n mean min p25 p50 p75 max) 

table dpto [iw=factor], statistic(count p101) statistic(mean p101) statistic(min p101) statistic(max p101) nformat(%9.2f)

tabstat p101 [fw=factor2], s(n mean min p25 p50 p75 max) by(dpto)

tabstat p104_sup_ha [fw=factor2], s(n mean min p25 p50 p75 max) by(dpto)

codebook p102_*

mrtab p102_1 p102_2 p102_3

fre p102_1
fre p102_2
fre p102_3

fre p102_3 [iw=factor]

gen tipo_prod = 1 if p102_1 == 1 & p102_2 == 0 & p102_3 == 0
replace tipo_prod = 2 if p102_1 == 0 & p102_2 == 1 & p102_3 == 0
replace tipo_prod = 3 if p102_1 == 1 & p102_2 == 1 & p102_3 == 0

label define tipo_prod 1 "Solo agrícola" 2 "Solo pecuaria" 3 "Agropecuaria"
label values tipo_prod tipo_prod

fre tipo_prod

fre tipo_prod [iw=factor]

save caract_generales.dta, replace

preserve
collapse (mean) p101 p104_sup_ha [pw=factor]
export excel using "$output/resultados_nacional.xlsx", replace firstrow(variables) sheet(nacional)
restore

preserve
collapse (mean) p101 p104_sup_ha [pw=factor], by(dpto)
export excel using "$output/resultados_nacional.xlsx", firstrow(variables) sheet(departamento)
restore

svyset [pw = factor], psu(conglome) strata(dpto)

svy: mean p101
estat cv

svy: mean p101, over(dpto)
estat cv

svy: mean p104_sup_ha
estat cv

svy: mean p104_sup_ha, over(dpto)
estat cv

cd "$data\data_2022"
use 18_Cap1100, clear

codebook omicap1100

tab omicap1100

drop if omicap1100=="99"

d p1100
tab p1100

d conglomerado nselua ua p1100

isid anio conglomerado nselua ua p1100

global idua "anio conglomerado nselua ua"

tab resfin

keep if resfin==1 | resfin==2

gen factor2 = round(factor)

tab nombredd

replace nombredd="LIMA" if nombredd=="CALLAO"
encode nombredd, gen(dpto)

br p1104_a p1104_b

rename p1104_a edad

replace edad=0 if edad==.

gen miembros=1

bys $idua: egen nmiembros = sum(miembros)

codebook p1103

gen mujeres = (p1103 == 2)

bys $idua: egen nmujeres = sum(mujeres)

gen hombres = (p1103 == 1)
bys $idua: egen nhombres = sum(hombres)

gen menores = (edad < 18)
bys $idua: egen nmenores = sum(menores)

gen mayores = (edad > 65)
bys $idua: egen nmayores = sum(mayores)

gen trabajadores = (edad >= 14 & edad <= 65)
bys $idua: egen miembros_edadtrab = sum(trabajadores)

gen tasa_depen = (nmayores + nmenores) / miembros_edadtrab * 100

tab p1107

gen trabaja = (p1107 == 1)
bys $idua: egen ntrabajan = sum(trabaja)

drop trabaja

sort $idua p1102

duplicates drop $idua, force

drop miembros mujeres hombres menores mayores trabajadores

svyset [pweight=factor], psu(conglome) strata(dpto)

fre p1102
fre p1100

keep if p1100==1

fre edad

recode edad (15/29=1 "De 15 a 29 años") ///
           (30/44=2 "De 30 a 44 años") ///
           (45/59=3 "De 45 a 59 años") ///
           (60/max=4 "De 60 a más años"), gen(grupo_edad)
		   
fre grupo_edad [iw=factor]

recode p1103 (1=1 "Hombre") (2=0 "Mujer"), gen(hombre)

fre hombre [iw=factor]

svy: prop hombre
estat cv

svy: mean hombre       
estat cv

svy: mean edad
estat cv

svy: mean edad, over(dpto)
estat cv

tab grupo_edad hombre [iw=factor], col nofre

tab region hombre [iw=factor], col nofre

tab region hombre [iw=factor], row nofre

mrtab p1108_*

mrtab p1108_*

fre p1108_1 [iw=factor]
fre p1108_2 [iw=factor]
fre p1108_3 [iw=factor]
fre p1108_4 [iw=factor]
fre p1108_5 [iw=factor]
fre p1108_6 [iw=factor]

gen alguna_discap = (p1108_1==1 | p1108_2==1 | p1108_3==1 | ///
                     p1108_4==1 | p1108_5==1 | p1108_6==1) if p1108_1 != .

fre alguna_discap [iw=factor]

tab p1105

recode p1105 (1/2=1 "Sin nivel") (3/4=2 "Primaria") ///
            (5/6=3 "Secundaria") (7/8=4 "Superior no universitaria") ///
            (9/10=5 "Superior universitaria"), gen(nivedu)

tab nivedu [iw=factor]


save caract_hogar, replace
