#!/bin/bash

echo "===== Estadísticas de Rendimiento del Servidor ====="
echo

# Versión del sistema operativo
echo "Versión del sistema operativo:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo

# Tiempo de actividad
echo "Tiempo de actividad:"
uptime -p
echo

# Promedio de carga
echo "Promedio de carga (1, 5, 15 min):"
uptime | awk -F'load average:' '{ print $2 }'
echo

# Usuarios conectados
echo "Usuarios conectados:"
who | awk '{print $1}' | sort | uniq | xargs
echo

# Uso total de CPU
echo "Uso total de CPU:"
top -bn1 | grep "Cpu(s)" | awk '{print "Usado: " $2+$4 "%, Libre: " 100-($2+$4) "%"}'
echo

# Uso total de memoria
echo "Uso total de memoria:"
free -m | awk 'NR==2{printf "Usada: %sMB (%.2f%%), Libre: %sMB (%.2f%%)\n", $3, $3*100/$2, $4, $4*100/$2 }'
echo

# Uso total de disco
echo "Uso total de disco:"
df -h --total | awk '/total/ {printf "Usada: %s, Libre: %s, Porcentaje usado: %s\n", $3, $4, $5}'
echo

# 5 procesos principales por uso de CPU
echo "Top 5 procesos por uso de CPU:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo

# 5 procesos principales por uso de memoria
echo "Top 5 procesos por uso de memoria:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo

# Objetivo adicional: Intentos de inicio de sesión fallidos (requiere permisos de root)
if [ "$(id -u)" -eq 0 ]; then
    echo "Intentos de inicio de sesión fallidos (últimos 10):"
    lastb -n 10
    echo
fi

echo "===================================================="
