using namespace System.Collections
#
## Replace Cases v 1.6 #
# + added trimming connectors space
#
# How to use:
#   replace-Cases "string to replace" [-replaceSpecialChars] [-reloadTable] [-trim [-trimSeparators [main_separator,char_toRemove1,char_ToRemove2, ... ]]
#
# replaceSpecialChars : will replace chars with the pattern stored in the special chars csv file
# dontTouchSpaces : will replace special chars but without replacing spaces
# reloadTable : will reload replacemen data source when function called
#				-if omitted, only first execution will load the data table
# trimSeparators : will trim the data from doubled spaces if no values entered
#					if entered characters table, the first char (zero position) will be set as the leading character
#					next chars from the table will be removed from the surrounding of the leading character
#					repetitions of chars from the table will be reduced to one between "words" (other chains)
# trim : if trimSeparators table is not present, will remove unnecessary spaces
#
[psobject] $caseReplacementTable = @{}
[psobject] $specialCasesReplacementTable = @{}

[string] $casesdatafile = "$PSScriptRoot\casedata.csv"
[string] $specialcasesdatafile = "$PSScriptRoot\specialcharsdata.csv"
#
function replace-Cases (
            [Parameter (position=0)] [string] $sourcestring,
            [switch] $replaceSpecialChars=$false,
            [switch] $dontTouchSpaces=$false,
            [switch] $trim=$false,
            [Parameter (position=1)] [ArrayList] $trimSeparators=$null,
            [switch] $reloadTable=$false
        )
{
    if (($caseReplacementTable.Count -eq 0) -or ($reloadTable -eq $true))
    {
        load-replacementData
    }

    [char[]] $sourcechars_ = [char[]]$sourcestring
    [ArrayList] $result_ = @(,""*$sourcechars_.Count)
    [psobject] $replacementTable_ = @{}
    
    [char] $trimkeychar_ = " "
    [char] $character_ = $null
    [char] $nextchar_ = $null
    [int] $trimpos_ = -1
    [psobject] $trimlist_ = @{}
    [bool] $trimmed_ = $false

    if ($replaceSpecialChars -eq $true)
    {
        $replacementTable_ = $specialCasesReplacementTable
    }
    else
    {
        $replacementTable_ = $caseReplacementTable
    }

    if ($trim.ToBool() -eq $true)
    {
        if ($trimSeparators -eq $null)
        {
            $trimSeparators = @(" ")
        }
    }
    <#
    Write-Host "Sourcestring: $sourcestring, replaceSpecialChars: $replaceSpecialChars,`r
     trim: $trim, trimSeparators: " -NoNewline
     Write-host "$trimSeparators" -BackgroundColor Cyan
    #>

    #$replacementTable_
    #
    for ($i = 0; $i -lt $sourcechars_.Length; $i++)
    {
        #"$($sourcechars_[$i]) $($replacementTable_[$sourcechars_[$i]].Count)"
        if (
            (($replacementTable_["$($sourcechars_[$i])"].Count) -eq 0) `
            -or (($dontTouchSpaces.ToBool() -eq $true) -and ($sourcechars_[$i] -eq " "))
           )
        {
            $result_[$i] = $sourcechars_[$i]
        }
        else
        {
            #Write-Host "replaced: $($sourcechars_[$i]) with $(($replacementTable_["$($sourcechars_[$i])"]).char)"
            $result_[$i] = "$(($replacementTable_["$($sourcechars_[$i])"]).char)"
        }
    }

    $result_ = [char[]] ($result_ -join "")

    if ($trimSeparators.Count -eq 0) 
    {
        #finishing without trimming
        return ($result_ -join "")
    }

    #trimmming start...

    $trimkeychar_ = $trimSeparators[0]
    $trimpos_ = 0
    #Write-Host "$($result_ -join ",") $($trimSeparators.Count)" -NoNewline
    #Write-host $trimSeparators -BackgroundColor DarkYellow

    #build trim chars table
    
    $i = 0
    do
    {
        #Write-Host "$i, '$($trimSeparators[$i])'" -BackgroundColor red
        $trimlist_[$trimSeparators[$i]] = $true
        #removing "manually" trim chars from start or end
        do {
            $trimmed_ = $false
            #Write-Host "'$($result_[0])' '$($result_[($result_.Count)-1])'" -BackgroundColor Blue
            #
            if ($result_[0] -eq $trimSeparators[$i])
            {
                #Write-Host "rimmed @0... $($result_[0])"
                $result_.RemoveAt(0)
                $trimmed_ = $true
            }
            if ($result_[$result_.Count-1] -eq $trimSeparators[$i])
            {
                #Write-Host "rimmed @end... $($result_.Count-1)"
                $result_.RemoveAt($result_.Count-1)
                $trimmed_ = $true
            }
        } while ($trimmed_)

        $i++

    } while ($i -lt $trimSeparators.Count)

    #if (
    #$result_ = ((($result_ -join "").Replace($trimkeychar_," ")).trim()) -split ""
    #
    $i = 0
    #
    do
    {
        $character_ = $result_[$i]
        $nextchar_ = $result_[$i+1]
        if ($trimlist_["$character_"] -eq $true)
        {
            #Write-Host "$character_" -BackgroundColor Red -NoNewline
            #   # Write-Host "if(('$character_' -eq '$trimkeychar_') -or ('$nextchar_' -eq '$trimkeychar_'))"
           if ($trimlist_["$nextchar_"])
            {
                #Write-Host "$nextchar_" -BackgroundColor Red

                if(("$character_" -eq "$trimkeychar_") -or ("$nextchar_" -eq "$trimkeychar_"))
                {
                    $result_[$i] = $trimkeychar_
                }
                $result_.RemoveAt($i+1)
                $i-=1
            }
            else
            {
                #Write-Host "$nextchar_" -BackgroundColor Blue
            }
        }
        #Write-Host "$character_" -BackgroundColor Cyan

        $i++

    } while ($i -lt $result_.Count)
    #
    #final finish
    #
    return ($result_ -join "")
}

function load-replacementData ()
{
    [string[]] $casesdata_ = @()
    [string[]] $row_ = @("char","ALT CODE","letter")

    #regional charcters data
    #
    if (Test-Path $casesdatafile -PathType Leaf)
    {
        $casesdata_ = Get-Content $casesdatafile -Encoding UTF8
    }
    $casesdata_|
    %{
        $row_ = $_.Split("`t")
        #
        if (($row_[0]).Length -eq 1)
        {
            $caseReplacementTable["$($row_[0])"] = @{ALT = $row_[1]; char = $row_[2]}
        }
    }

    #special chars data
    #
    if (Test-Path $specialcasesdatafile -PathType Leaf)
    {
        $casesdata_ = Get-Content $specialcasesdatafile -Encoding UTF8
    }
    #
    $casesdata_|
    %{
        $row_ = $_.Split("`t")
        #
        if (($row_[0]).Length -eq 1)
        {
            $specialCasesReplacementTable["$($row_[0])"] = @{ALT = $row_[1]; char = $row_[2]}
        }
    }

}

Write-host "## Replace Cases v 1.6 #"
