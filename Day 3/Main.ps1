# get input data
$inputData = Get-Content .\Input.txt

# reset variables
$trees = $null
$openSpaces = $null

# set positions
$posX = 3 # starting X position
$posXMoved = 3 # distance moved on X each time
$posY = 1 # starting Y position
$posYMoved = 1 # distance moved on Y each time

# we are checking the posX of current line
For($i=$posY; $i -lt $inputData.Count; $i=$i+$posYMoved){
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