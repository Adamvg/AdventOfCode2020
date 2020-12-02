# get input data
$inputData = Get-Content .\Input.txt

# reset counters
$validPasswords = $null
$invalidPasswords = $null

# iterate through inputData
foreach($entry in $inputData){
    # split entry into 2 objects, length + keyword and password
    $entrySplit = $entry -split ': ' 

    # work with length + keyword to produce lengthMin, lengthMax and keyword
    $lengthKeywordSplit = $entrySplit[0] -split ' ' #split on ' ' to separate lengths and keywords
    $length = $lengthKeywordSplit[0] -split '-' #split on '-' to get min and max of keyword
    $lengthMin = [int]$length[0]
    $lengthMax = [int]$length[1]

    # get keyword from above split
    $keyword = $lengthKeywordSplit[1]

    # get password from inital split
    $password = $entrySplit[1]

    # get match count
    $matchCount = ([regex]::Matches($password, $keyword)).count

    # evaluate if within range
    if(($matchCount -ge $lengthMin) -and ($matchCount -le $lengthMax)){
        $validPasswords++
    }
    else{
        $invalidPasswords++
    }
}

# return answer
Return "There are $($validPasswords) valid passwords and $($invalidPasswords) invalid passwords."