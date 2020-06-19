#!/bin/bash

[[ -z ${BUILDDIR} ]] && exit 1
[[ -z ${MACHINE} ]] && exit 2

[[ ! -d ${BUILDDIR}/tmp/deploy/images/${MACHINE} ]] && exit 3

pushd .
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}

RELROOT=$(pwd)/../release/${MACHINE}
FSIMAGE=${FSIMAGE:-"fsl-image-qt5-validation-imx"}

DTBS=$(ls *.dtb | awk '!/Image/' ORS=" ") 
KERNEL="Image modules-${MACHINE}.tgz"
IMAGES="${FSIMAGE}-${MACHINE}.sdcard.bz2 ${FSIMAGE}-${MACHINE}.tar.bz2"

declare -A RDEST=( [DTBS]="kernel/dtb" [KERNEL]="kernel" [IMAGES]="images" )

for var in DTBS KERNEL IMAGES;do
DEST=${RELROOT}/${RDEST[${var}]}
mkdir -p ${DEST}
for _var in ${!var};do
[[ -f ${_var} ]] && cp -v ${_var} ${DEST}/
done
done

tree ${RELROOT}

popd

exit
