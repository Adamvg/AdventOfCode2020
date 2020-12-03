# get input data
$inputData = Get-Content .\Input.txt

# reset variables
$trees = $null
$openSpaces = $null

# set positions
$posX = 3 # car starts on position 3 of line 1
$posXMoved = 3 # distance moved on X per line

# we are checking the posX of current line
For($i=1;$i -lt $inputData.Count;$i++){
    # get current line
    $line = $inputData[$i]

    # if line has to repeat
    if($posX -ge $line.length){$posX = $posX - $line.length}

    # check posX of line
    if($line){
        if($line[$posX] -eq '#'){$trees++}
        else{$openSpaces++}
    }

    # update posX
    $posX = $posX + $posXMoved
}

Return "The route taken encounters $($trees) trees and $($openSpaces) open spaces."