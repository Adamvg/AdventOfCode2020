# get input data
$inputData = Get-Content .\Input.txt

# reset counters
$validPasswords = $null
$invalidPasswords = $null

# iterate through inputData
foreach($entry in $inputData){
    # split entry into 2 objects, places + keyword and password
    $entrySplit = $entry -split ': ' 

    # work with length + keyword to produce lengthMin, lengthMax and keyword
    $placesKeywordSplit = $entrySplit[0] -split ' ' #split on ' ' to separate places and keywords
    $places = $placesKeywordSplit[0] -split '-'

    # get keyword from above split
    $keyword = $placesKeywordSplit[1]

    # get password from inital split
    $password = $entrySplit[1]

    # evaluate if value in correct place
    if(($password[$places[0] -1] -eq $keyword) -xor ($password[$places[1] -1] -eq $keyword)){
        $validPasswords++
    }
    else{
        $invalidPasswords++
    }
}

# return answer
Return "There are $($validPasswords) valid passwords and $($invalidPasswords) invalid passwords."