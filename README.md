#  Hash

## Descripción

Script de Bash para generación de hash con características avanzadas de seguridad, utilizando  salt y pepper.

## Características

- Generación de hash con múltiples capas de complejidad
- Interfaz de usuario interactiva
- Uso de sal y pepper para mayor seguridad

##Requisitos

- Bash
- OpenSSL
- Sistemas Unix/Linux

## Instalación

```bash
git clone https://github.com/ALetsee/Hashing.SH/tree/main
cd Hashing
chmod +x Hashing.sh
```

## Uso

1. Ejecutar el script:
```bash
Hashing.sh
```

2. Opciones del menú:
- Generar Hash
- Crear nueva Sal y Pepper
- Salir

##Funcionamiento

1. Genera sal y pepper de forma segura
2. Transforma texto en hash mediante:
   - Conversión a ASCII
   - Múltiples iteraciones de transformación
   - Mezcla de bits
   - Incorporación de sal y pepper

## Precauciones

- Guarde valores de sal y pepper de forma segura
- No comparta archivos `salt.txt` y `pepper.txt`
