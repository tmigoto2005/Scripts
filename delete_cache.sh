#!/bin/bash
#cd /mnt/html/dsop.com.br/portalescolas/cache/jq-dailypopup/
cd /home/tmigoto/teste/
shopt -s extglob
rm !(index.html) -rfv > /home/tmigoto/excluidos.txt

