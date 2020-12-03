# get input data
$inputData = Get-Content .\Input.txt

# reset variables
$trees = $null
$openSpaces = $null

# set positions
$posX = 1 # car starts on position 0 of line 0, so set position = 1

# iterate through lines, car always moves down 1 so Y pos can be done via foreach
Foreach($line in $inputData){
    # X position
    $posXStart = $posX
    $posXFinish = $posX + 3

    # if line repeats
    if($posXFinish -gt ($line.length - 1)){$posXFinish = $posXFinish - $line.length + 1}

    # check starting position
    if($line[$posXStart] -eq '#'){$trees++}
    elseif($line[$posXStart] -eq '.'){$openSpaces++}
    else{Write-Error "Unknown tile $($line[$posXStart]) encountered"}

    # check ending position
    if($line[$posXFinish] -eq '#'){$trees++}
    elseif($line[$posXFinish] -eq '.'){$openSpaces++}
    else{Write-Error "Unknown tile $($line[$posXFinish]) encountered"}

    # set posX for next iteration
    $posX = $posXFinish
}

Return "The route taken encounters $($trees) trees and $($openSpaces) open spaces."