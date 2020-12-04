# get input data as string, so we can split it by empty line later
$inputData = Get-Content .\Input.txt

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

    # validate
    if ($tempOutput.BirthYear -and $tempOutput.IssueYear -and $tempOutput.ExpirationYear -and $tempOutput.Height -and $tempOutput.HairColour -and $tempOutput.EyeColour -and $tempOutput.PassportID){
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