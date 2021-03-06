#Requires -module powershell-yaml
#Using Module Datum

function Get-FileProviderData {
    [CmdletBinding()]
    Param(
        $Path,

        [AllowNull()]
        $DataOptions
    )
    Write-Verbose "Getting File Provider Data for Path: $Path"
    $File = Get-Item -Path $Path
    switch ($File.Extension) {
        '.psd1' { Import-PowerShellDataFile $File }
        '.json' { Get-Content -Raw $Path | ConvertFrom-Json | ConvertTo-Hashtable }
        '.yml'  { convertfrom-yaml (Get-Content -raw $Path) | ConvertTo-Hashtable }
        '.ejson'{ Get-Content -Raw $Path | ConvertFrom-Json | ConvertTo-ProtectedDatum -UnprotectOptions $DataOptions}
        '.eyaml'{ ConvertFrom-Yaml (Get-Content -Raw $Path) | ConvertTo-ProtectedDatum -UnprotectOptions $DataOptions}
        '.epsd1'{ Import-PowerShellDatafile $File | ConvertTo-ProtectedDatum -UnprotectOptions $DataOptions}
        Default { Get-Content -Raw $Path }
    }
}