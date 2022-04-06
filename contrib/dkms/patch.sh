#!/bin/bash
set -e

VERSION=${1:-$(uname -r | grep -o "^[0-9]*[.][0-9]*")}

echo "Patching for kernel ${VERSION}"

wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa.h?h=linux-${VERSION}.y" -O hpsa.h
wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa.c?h=linux-${VERSION}.y" -O hpsa.c
wget "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/scsi/hpsa_cmd.h?h=linux-${VERSION}.y" -O hpsa_cmd.h

shopt -s nullglob
for PATCH in ../../kernel/"${VERSION}"*/*.patch; do
    echo "Applying ${PATCH}"
    patch --no-backup-if-mismatch -Np3 < "${PATCH}"
done

echo "Incrementing the module version"

sed -i 's/3.4.20-200/3.4.20-201/g' hpsa.c
