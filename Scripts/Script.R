

# Shotcuts ----------------------------------------------------------------

# Ctrl + shift + R                  permite crear secciones en el script
# Ctrl + Shift + M                  pipe operator  |> 
# Alt -                             Asignación de objetos <-

# Instalar y cargar paquetes -------------------------------------------------------

install.packages("dplyr") ## se usa las comillas para señalar que es un nombre; sin comillas se entiende como un objeto
install.packages("tidyverse")
install.packages("openxlsx")
install.packages("magrittr") # paquete que contiene el operador pipe
install.packages("readr") # paquete que contiene la función parse_factor()

library(dplyr)  ## puede ser utilizado una vez instalado  ## los paquetes deben cargarse cada vez que se abre el proyecto
library(tidyverse)
library (openxlsx)
library(stringr)
library(readr)
library(skimr)

## prueba git 1


# Ayuda -------------------------------------------------------------------

?tail  # aparece en Help la documentación oficial, pertenece al paquete utils
?select


# Generalidades -----------------------------------------------------------

# expresiones se imprimen directamente en consola
5+3 ## expresión que se imprime diréctamente en consola
log(6) # función logaritmo con base 10 
        # usamos tab para ver los argumentos de cualquier función
round(x= log(6), digits = 3) # se pueden anidar las funciones
round(log(6),3) # si se colocan los argumentos en el orden correcto no es necesario colocar el nombre del argumento)

plot(c(1,2,3))

# R es case sensitive, por lo que no es lo mismo escribir "data" que "Data"


nombres <- c("Andrea", "Rosa", "Juan") # se crea un objeto


# Funciones útiles --------------------------------------------------------

#secuencias

5:20 # genera una secuencia de números enteros del 5 al 20

?seq
seq(5,20) # secuencia consecutiva (default) de 5 a 20

seq(5,30, by=5)
seq(5, by=5, length.out=6) # genera 6 elementos
seq(5, 5, 30) # está mal colocado el orden de los argumentos

#repeticiones
rep(10,7)
rep(nombres,3)


# Importar datos ----------------------------------------------------------

data_banco <- read.xlsx("Data/Data_Banco.xlsx", sheet="Data")
View(data_banco) # con mayúscula genera un visor como objeto
str(data_banco) # estructura del objeto
#tipo de dato del objeto 

class(data_banco) # clase del objeto

# Estructuras de datos ----------------------------------------------------

# Vectores
c(30,38,49,56) # función concatenar
edades <- c(30,38,49,56) 

#data frame
df1 <- data.frame(Ciudad=c("UIO", "GYE", "Machala"), Ingreso =c(100, 150,80))

# factor 
puntuaciones <- c("Regular","Mala","Muy Mala") # es de tipo caracter
fcp <- factor(c("Regular","Mala","Muy Mala"), levels=c("Muy Mala", "Mala", "Regular", "Buena", "Muy Buena"), ordered = TRUE)
# Existe un paquete llamado FORCATS para el manejo de factores


# Transformar tipos de datos ----------------------------------------------

#Coerción: familia as.*() forma parte de R Base

# Lógica de cohersión
# logical -> int -> num -> char  # sentido de las posibilidades de cohersion


as.character(5)  # se coloca entre comillas
as.numeric("cinco") # se introduce un NA a pesar de que es un error

as.factor(puntuaciones) # de char a factor pero no le da el orden


as.character(fcp) # de factor a caracter
is.character(fcp) # FALSE, no se ha asignado a una nueva variable
fcp <- as.character(fcp) # ahora si es de tipo char


as.factor(puntuaciones)  #sin embargo tiene la limitación que no permite declarar levels ni orden de categorías

#Coerción: familia parse_*() del paquete readr que viene en tidyverse. Recomendado para tratar caracteres
# parse = segmentar una cadena de caracteres

parse_number("las clases empiezan a las 7 de la noche")
parse_number("6_90r") #solo lo hace para el primer número de izquierda a derecha
parse_number("333.456a3") # interpreta el punto como separador decimal
parse_number("333,456a3") # interpreta la coma como separador de miles



# ventaja usando la función parse_factor() vs factor
# la función parse_factor() avisa cuando existen respuestas diferentes a lo declarado en levels. Coloca NA

puntuaciones_error <- c("Regular","Mala","Muy Mala", "Excelente") # es de tipo caracter
parse_factor(puntuaciones_error,  
             levels=c("Muy Mala", "Mala", "Regular", "Buena", "Muy Buena"), 
             ordered = TRUE)


# Manipulación de datos (Tidyverse) ---------------------------------------


names(data_banco) # ver los nombres de las columnas en R base
data_banco |> names() # ver los nombres de las columnas en sintaxis tidyverse

length(names(data_banco)) # número de columnas en R base)
data_banco |> names() |> length() # número de columnas en sintaxis tidyverse
data_banco |> head(10) |> View("Primeros 10") # ver las primeras 10 entradas del objeto en sintaxis tidyverse
data_banco |> tail(10) |> View("Ultimos 10") # ver las últimas 10 entradas del objeto en sintaxis tidyverse

# extracción de variables / utilizar índices
data_banco[,3] |> head() # r base
data_banco[,1:5] |> head()
data_banco[,c(1,3,5)] |> head()

unique(data_banco$Sucursal) # ver los valores únicos de la variable Sucursal en r base

# convertir data.frame a tibble

data_banco_2 <- as_tibble(data_banco)
class(data_banco_2) # clase del objeto)
glimpse(data_banco_2)

# ver las primeras 6 entradas del objeto
data_banco_2 |> head()
# ver los nombres de las columnas
data_banco_2 |> names()
# número de columnas
data_banco_2 |> names() |> length() 


# Filtrar -----------------------------------------------------------------

# operador distinct para identificar los valores únicas
unique(data_banco_2$Sucursal) # ver los valores únicos de la variable Sucursal en r base
data_banco_2 |> unique(Sucursal) |> view() # error en tidyverse
data_banco_2 |> distinct(Sucursal) |> view() # ver los valores únicos de la variable Sucursal en tidyverse

# filter() actúa sobre las filas (observaciones)

data_banco_2 |> filter(Sucursal == 443) |> view("equivalencia") # con minúscula evita ese problema

db <- data_banco_2 |> filter(Sucursal != 443) |> view("equivalencia negación")
db |> distinct(Sucursal)

# operador "pleca" | 
# filtrar por las transacciones de las sucursales 62 o 85

data_banco_2 |> filter(Sucursal == 62 | Sucursal == 85) |> view("pleca")

#operador %in%
data_banco_2 |> filter(Sucursal %in% c(62, 85, 443)) |> view("in")

#filtrado por excepción o complemento
data_banco_2 |> filter(!(Sucursal %in% c(62,85))) |> view("excepción")

#filtrar por 2 variables
data_banco_2 |> filter(Sucursal %in% c(62,85), Tiempo_Servicio_seg >100) |> view("dos variables")

#operador &
data_banco_2 |> filter(Sucursal==443 & Tiempo_Servicio_seg < 100 & Satisfaccion!="Muy Bueno") |> view("mas de dos variables")



# Seleccionar -------------------------------------------------------------

#la idea es que sea a través del nombre de las columnas
# si utilizo el número de columna es necesario ingresarlas como vector c()

data_banco_2 |> select(Transaccion, Sucursal) |> view()

data_banco_2 |> select(Tiempo_Servicio_seg) |> boxplot()

data_banco_2 |> select(-Cajero) |> view() # excluye la columna Cajero

data_banco_2 |> select(-c("Cajero", "Satisfaccion")) |> view() # excluye las columnas Cajero y Satisfaccion

data_banco_2 |> select(contains("Tra")) |> view() # selecciona las columnas que contienen "Tra"

data_banco_2 |> select(starts_with("S")) |> view() # selecciona las columnas que empiezan con "Tra"

data_banco_2 |> select(starts_with("Tra"), ends_with("on")) |> view() # selecciona las columnas que empiezan con "Tra" y terminan con "on"

data_banco_2 |> select(starts_with("Tra") & ends_with("on")) |> view() # las condiciones en simultáneo

#mover la columna Monto y Transacción al inicio

data_banco_2 |> select(Monto, Transaccion, everything()) |> view()

#relocalización de columnas: relocate()

data_banco_2 |> relocate (Monto) |> view()
data_banco_2 |> relocate (Monto, .before = Transaccion) |> view()

## arrange

data_banco_2 |> arrange(Tiempo_Servicio_seg) |> view() # ordena de menor a mayor

data_banco_2 |> arrange(Transaccion, desc(Tiempo_Servicio_seg)) |> view() # orden anidado por dos criterios

## mutate() transmute()

data_banco_2 |> mutate(Tiempo_Servicio_min = Tiempo_Servicio_seg/60) |> view() 

data_banco_2 |> transmute(Tiempo_Servicio_min = Tiempo_Servicio_seg/60) |> view() # crea la variable en un objeto diferente


# Corrección de la base -------------------------------------------------

data_banco_def<- data_banco_2 |> mutate(Monto= str_replace(Monto, pattern=",", replacement="."))|> 
  mutate(Monto = parse_number(Monto, locale = locale(decimal_mark = "." )))|> 
  mutate(Sucursal = as.character(Sucursal), Cajero=as.character(Cajero),
         Satisfaccion=parse_factor(Satisfaccion, 
                                   levels=c("Muy Malo", "Malo", "Regular", "Bueno", "Muy Bueno"), ordered=TRUE))


# Análisis Exploratorio de Datos (EDA) ------------------------------------


