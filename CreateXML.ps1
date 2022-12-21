function ParseListToHashTable {
    param (
        [string[]] $KVList
    )
    [hashtable] $hash = @{}
    for ($iter = 0; $iter -lt $KVList.Count; $iter+=2) {
        $hash.Add($KVList[$iter], $KVList[$iter+1])
    }
    return $hash
}

function GenerateXML {
    param (
        [string[]] $list
    )
    try {
        $xmlSettings = New-Object System.Xml.XmlWriterSettings
        $xmlSettings.Indent = $true
        $xmlSettings.IndentChars = "    "
        $XmlWriter = [System.XML.XmlWriter]::Create("file.xml", $xmlsettings)

        $xmlWriter.WriteStartDocument()

        $xmlWriter.WriteStartElement("Root")
            $kv = ParseListToHashTable $list
            $xmlWriter.WriteStartElement("Elements")
                foreach($element in $kv.GetEnumerator()){
                    $xmlWriter.WriteElementString($element.Name, $element.Value)
                }
            $xmlWriter.WriteEndElement()
        $xmlWriter.WriteEndElement()

        $xmlWriter.WriteEndDocument()
        $xmlWriter.Flush()
        $xmlWriter.Close()    
    }
    catch [System.IO.IOException]{
        "Couldn't write file" 
    }
    
}

GenerateXML $args