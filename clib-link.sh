#!/bin/bash

VERSION="0.0.1"

## sets optional variable from environment
opt () { eval "if [ -z "\${$1}" ]; then ${1}=${2}; fi";  }

opt CWD "`pwd`"
opt PREFIX "/usr/local"

## output usage
usage () {
  {
    echo "usage: clib-link [-hV] [name]"
  } >&2
}

## output error
error () {
  {
    printf "error: %s\n" "${@}"
  } >&2
}

init () {
  if ! test -d "${PREFIX}/clibs"; then
    mkdir -p "${PREFIX}/clibs"
  fi
}

make_link () {
  local pkg="${CWD}/package.json"
  local src=""
  local name=""
  local path=""
  local dest=""
  local root=""
  local let i=0

  init

  if ! test -f "${pkg}"; then
    error "Unable to find \`package.json'"
    exit 1
  fi

  name="`cat "${pkg}" | grep '"name"' | sed 's/^\([^:]*:\)\(.*\)/\2/' | sed 's/"\(.*\)",/\1/' | tr -d ' '`"

  if [ -z "${name}" ]; then
    error "Unable to determine clib package name in \`${pkg}'"
    exit 1
  fi

  root="${PREFIX}/clibs/${name}"
  src="`cat ${pkg} | read_source`"

  if [ -z "${src}" ]; then
    error "Unable to determine clib package source in \`${pkg}'"
    exit 1
  fi

  if ! test -d "${root}"; then
    mkdir "${root}"
  fi

  while IFS=' ' read -a paths <<< "${src}"; do
    if [ -z "${paths[$i]}" ]; then break; fi
    path="${paths[$i]}"
    dest="${PREFIX}/clibs/${name}"
    if ! test -f "${dest}"; then
      ln -s "${path}" "${dest}"
      echo "${path} => ${dest}"
    fi
    ((i++))
  done
}

get_link () {
  local name="$1"
  local path="${PREFIX}/clibs/${name}"
  local deps="${CWD}/deps"
  local let i=0;
  local file=""
  local files=""

  if ! test -d "${path}"; then
    error "Unknown clib \`${name}'"
    exit 1
  fi

  files=($(ls ${path}))

  if [ -z "${files}" ]; then
    error "clib \`${name}' has nothing to link"
    exit 1
  fi

  if ! test -d "${deps}"; then
    mkdir "${deps}"
  fi

  if test "${deps}/${name}"; then
    rm -f "${deps}/${name}"
  fi

  ln -s "${path}" "${deps}/${name}"
  echo "${path} => ${deps}/${name}"
}

read_source () {
  local key=""
  local token=""
  local buf=""
  local let in_src=0
  local file=""
  local path=""
  local src=""

  while IFS='' read -r -n1 ch; do
    if [ " " == "${ch}" ]; then
      token="${buf}"
      buf=""
    else
      if [ "," != "${ch}" ]; then
        buf+="${ch}"
      fi
    fi

    if [ -z "${token}" ]; then continue; fi

    if [ "\"src\":" == "${token}" ]; then
      in_src=1
      continue
    fi

    if [ "1" == "${in_src}" ]; then
      if [ "[" == "${token}" ]; then
        continue
      fi

      file="${token//\"/}"
      path="${CWD}/${file}"
      src="${path} ${src}"
    fi
  done
  echo "${src}"
}

## parse opts
{
  for arg in "${@}"; do
    if [ "" = "${arg}" ]; then
      break;
    fi

    if [ "-" != "${arg:0:1}" ]; then
      continue
    fi

    case "${arg}" in

      -V|--version)
        echo "${VERSION}"
        exit 0
        ;;

      -h|--help)
        usage
        exit 0
        ;;

      *)
        error "Unknown option: \`${arg}'"
        usage
        exit 1
        ;;
    esac
    shift
  done
}

case "${#}" in
  ## make link
  0)
    make_link
    ;;

  ## get link
  1)
    get_link "$1"
    ;;

  *)
    usage
    exit
    ;;
esac
