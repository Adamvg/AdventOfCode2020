# get input data as string
[string]$inputData = Get-Content .\Input.txt

# reset variables
$yesCount = 0

# split into groups
[array]$groups = $inputData -split '  '

# iterate through groups
Foreach($answers in $groups){    
    
    # split into individual people's answer
    $individualAnswers = $answers -split ' '

    # reset TempArray for every below foreach
    $answerArrayTemp = @()

    # iterate through individual answers
    Foreach($individualAnswer in $individualAnswers){
        # run through each letter
        for($i=0; $i -lt $individualAnswer.Length; $i++){
            $answerArrayTemp += $individualAnswer[$i]
        }
    }
    
    # add to count
    $yesCount += $answerArrayTemp | Group-Object | Where-Object {$_.Count -eq $individualAnswers.Count} | Measure-Object | Select-Object -ExpandProperty Count
}

Return $yesCount