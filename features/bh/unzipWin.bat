$zipFolder = ".\DataCNPJ\zip"
$unzipFolder = ".\DataCNPJ\unzipped"

foreach ($file in Get-ChildItem -Path $zipFolder -Filter *.zip) {
    Expand-Archive -Path $file.FullName -DestinationPath $unzipFolder -Force
}

Write-Host "Descompactação e renomeação concluídas."
