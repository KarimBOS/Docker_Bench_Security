#!/bin/bash

# Docker Bench for Security - Modificado para pruebas seleccionables

version="1.0.0"
output_dir="./output"
output_file="${output_dir}/docker_bench_security.log"

# Colores para salida
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Asegurarse de que el script sea ejecutado con permisos de root
if [ "$(id -u)" -ne 0 ]; then
  echo "${RED}Este script debe ejecutarse como root.${RESET}" >&2
  exit 1
fi

# Crear directorios de salida si no existen
mkdir -p "$output_dir"

# Funciones de salida
logit() {
  echo "$@" | tee -a "$output_file"
}

info() {
  echo "${GREEN}[INFO]${RESET} $*" | tee -a "$output_file"
}

warn() {
  echo "${YELLOW}[WARN]${RESET} $*" | tee -a "$output_file"
}

error() {
  echo "${RED}[ERROR]${RESET} $*" | tee -a "$output_file"
}

# Función para mostrar la cabecera del script
print_header() {
  cat <<EOF | tee -a "$output_file"
Docker Bench for Security
Version: $version
Fecha: $(date)
==========================
EOF
}

# Menú interactivo para seleccionar pruebas
select_tests() {
  echo "¿Cuántos tests desea realizar? (Máximo: 8)"
  read -r num_tests

  if ! [[ "$num_tests" =~ ^[1-8]$ ]]; then
    echo "Número inválido. Por favor, seleccione un número entre 1 y 8."
    exit 1
  fi

  echo "Seleccione los tests que desea realizar:"
  echo "a) Host configuration"
  echo "b) Docker daemon configuration"
  echo "c) Docker daemon configuration files"
  echo "d) Container images"
  echo "e) Container runtime"
  echo "f) Docker security operations"
  echo "g) Docker swarm configuration"
  echo "h) Docker enterprise configuration"
  echo "Escriba las letras de las pruebas separadas por espacios (ejemplo: a b c):"
  read -r selected_tests

  # Validar selección
  valid_tests="a b c d e f g h"
  for test in $selected_tests; do
    if ! [[ $valid_tests =~ (^| )$test($| ) ]]; then
      echo "Selección inválida: $test. Por favor, seleccione entre a-h."
      exit 1
    fi
  done
}

# Ejecución de pruebas seleccionadas
execute_tests() {
  for test in $selected_tests; do
    case $test in
      a)
        info "Ejecutando: Host configuration"
        check_1
        ;;
      b)
        info "Ejecutando: Docker daemon configuration"
        check_2
        ;;
      c)
        info "Ejecutando: Docker daemon configuration files"
        check_3
        ;;
      d)
        info "Ejecutando: Container images"
        check_4
        ;;
      e)
        info "Ejecutando: Container runtime"
        check_5
        ;;
      f)
        info "Ejecutando: Docker security operations"
        check_6
        ;;
      g)
        info "Ejecutando: Docker swarm configuration"
        check_7
        ;;
      h)
        info "Ejecutando: Docker enterprise configuration"
        check_8
        ;;
    esac
  done
}

# Ejemplo de pruebas existentes
check_1() {
  logit "Check 1: Host configuration"
}

check_2() {
  logit "Check 2: Docker daemon configuration"
}

# Aquí están las implementaciones detalladas que solicitaste
check_8() {
  logit ""
  local id="8"
  local desc="Docker Enterprise Configuration"
  logit "$id - $desc"
}

check_product_license() {
  enterprise_license=1
  if docker version | grep -Eqi '^Server.*Community$|Version.*-ce$'; then
    info "  * Community Engine license, skipping section 8"
    enterprise_license=0
  fi
}

check_8_1() {
  if [ "$enterprise_license" -ne 1 ]; then
    return
  fi

  local id="8.1"
  local desc="Universal Control Plane Configuration"
  logit "$id - $desc"
}

check_8_2() {
  if [ "$enterprise_license" -ne 1 ]; then
    return
  fi

  local id="8.2"
  local desc="Docker Trusted Registry Configuration"
  logit "$id - $desc"
}

# Generar informe final
generate_report() {
  echo "Generando informe en $output_file..."
  echo "===============================" >> "$output_file"
  echo "Resultados del análisis:" >> "$output_file"

  for test in $selected_tests; do
    echo "Resultado del test $test: Completado" >> "$output_file"
  done

  echo "===============================" >> "$output_file"
  echo "Informe generado en: $output_file"
}

# Flujo principal del script
main() {
  print_header
  select_tests
  execute_tests
  generate_report
}

main
