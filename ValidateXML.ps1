function ValidateXML {
    param (
        [string[]] $tagNames
    )
    
    [XML]$xmlFile = Get-Content ./file.xml

    foreach ($node in ($xmlFile.SelectNodes("/Root/Elements/*"))){
        Write-Host $node.Name
    }
}

ValidateXML