# get input data as string, so we can split it by empty line later
$inputData = Get-Content .\Input.txt

# variables
$validEyeColours = @('amb','blu','brn','gry','grn','hzl','oth')


# split by empty line to get individual records into an array
$passports = $inputData -split '  '

# create array for results
$results = @()

# iterate through passports
Foreach($passport in $passports){
    # split data
    $data = $passport -split ' '
    $tempHashTable = @{}
    $data | Foreach{
        $tempData = $_ -split ':'
        $tempHashTable.add($tempData[0],$tempData[1])
    }

    # create table
    $tempOutput = "" | Select-Object BirthYear,IssueYear,ExpirationYear,Height,HairColour,EyeColour,PassportID,CountryID,Valid
    $tempOutput.BirthYear = $tempHashTable.byr
    $tempOutput.IssueYear = $tempHashTable.iyr
    $tempOutput.ExpirationYear = $tempHashTable.eyr
    $tempOutput.Height = $tempHashTable.hgt
    $tempOutput.HairColour = $tempHashTable.hcl
    $tempOutput.EyeColour = $tempHashTable.ecl
    $tempOutput.PassportID = $tempHashTable.pid
    $tempOutput.CountryID = $tempHashTable.cid

    # validate height
    if(!($tempOutput.Height)){$validHeight = $false}
    elseif($tempOutput.Height.EndsWith('cm')){
        [int]$height = $tempOutput.Height -replace 'cm'
        if($height -ge 150 -and $height -le 193){$validHeight = $true}
        else{$validHeight = $false}
    }
    elseif($tempOutput.Height.EndsWith('in')){
        [int]$height = $tempOutput.Height -replace 'in'
        if($height -ge 59 -and $height -le 76){$validHeight = $true}
        else{$validHeight = $false}
    }
    else{
        $validHeight = $false
    }

    if (($tempOutput.BirthYear -ge 1920 -and $tempOutput.BirthYear -le 2002) -and ($tempOutput.IssueYear -ge 2010 -and $tempOutput.IssueYear -le 2020) -and ($tempOutput.ExpirationYear -ge 2020 -and $tempOutput.ExpirationYear -le 2030) -and ($validHeight -eq $true) -and ($tempOutput.HairColour -match '#[0-9a-f]{6}') -and ($validEyeColours -contains $tempOutput.EyeColour) -and ($tempOutput.PassportID -match '[0-9]{9}')){
        $valid = $true
    }
    else {
        $valid = $false
    }

    # add validity
    $tempOutput.Valid = $valid

    # add to output array
    $results += $tempOutput
}

# get valid and invalid passport count
$validCount = ($results | Where-Object {$_.Valid -eq $true}).count
$invalidCount = ($results | Where-Object {$_.Valid -eq $false}).count

# return results
Return "There are $($validCount) valid and $($invalidCount) invalid passports."