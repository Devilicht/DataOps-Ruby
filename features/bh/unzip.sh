#!/bin/bash

pasta_zip='./DataCNPJ/zip'
pasta_unzip='./DataCNPJ/unzipped'

for arquivo_zip in "$pasta_zip"/*.zip
do

  unzip -q "$arquivo_zip" -d "$pasta_unzip"

done
echo "Descompactação concluídas."
