function ValidateXML {
    param (
        [string] $XmlFile,
        [string] $SchemaFile,
        [scriptblock] $ValidationEventHandler = { Write-Error $args[1].Exception }
    )
    Write-Host $XmlFile $SchemaFile

    $schemaReader = New-Object System.Xml.XmlTextReader $SchemaFile
    $schema = [System.Xml.Schema.XmlSchema]::Read($schemaReader, $ValidationEventHandler)

    $ret = $true
    try {
    $xml = New-Object System.Xml.XmlDocument
    $xml.Schemas.Add($schema) | Out-Null
    $xml.Load($XmlFile)
    $xml.Validate({
            throw ([PsCustomObject] @{
                SchemaFile = $SchemaFile
                XmlFile = $XmlFile
                Exception = $args[1].Exception
            })
        })
    } catch {
        Write-Error $_
        $ret = $false
    } 
    finally {
        $schemaReader.Close()
    }
}

ValidateXML $args[0] $args[1]