# get input data as string, so we can split it by empty line later
$inputData = Get-Content .\Input.txt

# variables
$minByr = 1920
$maxByr = 2002
$minIyr = 2010
$maxIyr = 2020
$minEyr = 2020
$maxEyr = 2030
$minHgtCm = 150
$maxHgtCm = 193
$minHgtIn = 59
$maxHgtIn = 76
$hclMatch = '#[0-9a-f]{6}'
$validEyeColours = @('amb','blu','brn','gry','grn','hzl','oth')
$pidMatch = '\b[0-9]{9}\b' # need word boundaries to match EXACTLY 9 digits

# split by empty line to get individual records into an array
$passports = $inputData -split '  '

# create array for results
$results = @()

# iterate through passports
Foreach($passport in $passports){
    # split data
    $data = $passport -split ' '
    $tempHashTable = @{}
    $data | ForEach-Object{
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
        if($height -ge $minHgtCm -and $height -le $maxHgtCm){$validHeight = $true}
        else{$validHeight = $false}
    }
    elseif($tempOutput.Height.EndsWith('in')){
        [int]$height = $tempOutput.Height -replace 'in'
        if($height -ge $minHgtIn -and $height -le $maxHgtIn){$validHeight = $true}
        else{$validHeight = $false}
    }
    else{$validHeight = $false} # i dont think this will do anything but idfk

    # validate everything else
    if (($tempOutput.BirthYear -ge $minByr -and $tempOutput.BirthYear -le $maxByr) -and ($tempOutput.IssueYear -ge $minIyr -and $tempOutput.IssueYear -le $maxIyr) -and ($tempOutput.ExpirationYear -ge $minEyr -and $tempOutput.ExpirationYear -le $maxEyr) -and ($validHeight -eq $true) -and ($tempOutput.HairColour -match $hclMatch) -and ($validEyeColours -contains $tempOutput.EyeColour) -and ($tempOutput.PassportID -match $pidMatch)){
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