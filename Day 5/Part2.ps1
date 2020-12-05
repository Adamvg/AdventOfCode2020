# get input data
$inputData = Get-Content .\Input.txt

# variables
$rowRange = 128 # 0..127
$colRange = 8 # 0..7

# create row array
$rowArray = @()
for($i=0; $i -le 127; $i++){
    $rowArray += $i
}

# create column array
$columnArray = @()
for($i=0; $i -le 7; $i++){
    $columnArray += $i
}

# create output array
$output = @()

# iterate through boarding passes
Foreach($boardingPass in $inputData){
    # split boardingPass into array
    $boardingPass = $boardingPass -split ''

    # split into two arrays, row/column.
    [array]$rows = $boardingPass[1..7]
    [array]$columns = $boardingPass[8..10]

    # set variables before below 2 foreach statements
    $rowArrayTemp = $rowArray
    $columnArrayTemp = $columnArray
    $rowRangeTemp = $rowRange
    $colRangeTemp = $colRange

    # rows
    Foreach($row in $rows){
        $rowRangeTemp = $rowRangeTemp / 2
        if($row -eq 'F'){$rowArrayTemp = $rowArrayTemp[0..($rowRangeTemp - 1)]}
        elseif($row -eq 'B'){$rowArrayTemp = $rowArrayTemp[($rowArrayTemp.Count - $rowRangeTemp)..($rowArrayTemp.Count - 1)]}
        else{Write-Error "Something has gone wrong."}
    }

    # columns
    Foreach($column in $columns){
        $colRangeTemp = $colRangeTemp / 2
        if($column -eq 'L'){$columnArrayTemp = $columnArrayTemp[0..($colRangeTemp - 1)]}
        elseif($column -eq 'R'){$columnArrayTemp = $columnArrayTemp[($columnArrayTemp.Count - $colRangeTemp)..($columnArrayTemp.Count - 1)]}
        else{Write-Error "Something has gone wrong."}
    }

    # calculate seatID
    $seatID = ($rowArrayTemp[0] * 8) + $columnArrayTemp[0]
    
    # create temp output table
    $tempOutput = "" | Select-Object row,column,seatID
    $tempOutput.row = $rowArrayTemp[0]
    $tempOutput.column = $columnArrayTemp[0]
    $tempOutput.seatID = $seatID

    # add data to output table
    $output += $tempOutput
}

# sort by seatID to allow to check if next number in sequence exists
$output = $output | Sort-Object seatID

# check which numbers are missing
for($i=0; $i -lt ($inputData.Count - 1); $i++){
    if($output.seatID[$i+1] -ne ($output.seatID[$i] + 1)){
        Write-Host "Seat ID $($output.seatID[$i] + 1) is missing. This must be your seat!"
    }
}