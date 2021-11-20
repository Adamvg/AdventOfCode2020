#import the bag rules
$inputData = get-content -path .\Input.txt

#Bag To Search For
$searchForBag = 'shiny gold'

#create and populate the hash table with the input rules
$bagTable = @{}
$subBagTable = @{}

foreach ($rule in $inputData) {
    $containsTable = @{}
    $rule = $rule -split " bags contain "
    $key = $rule[0]
    $containsRules = ($rule[1] -split ", ").replace(".", "")
    foreach ($cr in $containsRules) {
        $cr = $cr.replace(" bags", "")
        $cr = $cr.replace(" bag", "")
        $amount = $cr.substring(0, $cr.indexOf(" "))

        if ($amount -ne "no") {            
            $bagName = $cr.substring($cr.indexOf(" ") + 1)
            $containsTable.Add($bagName, $amount)
        }       
    }

    $bagTable.Add($key, $containsTable)
}

#check-bag
#Takes in the name of the bag to check and the name of the bag you are looking for
#Returns $true if the bag you are looking for is contained in the bag being checked
function check-bag {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$bagToCheck,
        [string]$lookingForBag
    )
    $bagFound = $false
    if ($bagTable.$bagToCheck.keys -contains $lookingForBag) {
        $bagFound = $true
    }
    else {
        foreach ($bag in $bagTable.$bagToCheck.keys) {
            if (check-bag -bagToCheck $bag -lookingForBag $lookingForBag) {
                $bagFound = $true
                break
            }
        }
    }
    return $bagFound
}

#count-subBags
#Takes in the name of a bag and
#Returns the count of bags contained within the bag
function Count-SubBags {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$lookingForBag
    )
    $subBags = $bagTable.$lookingForBag
    $thisSubCount = 0

    foreach ($sub in $subBags.getEnumerator()) {
        $subCount = count-subBags -lookingForBag $sub.Name
        if ($subCount -eq 0) {
            $thisSubCount += [int]$sub.Value
        }
        else {
            $thisSubCount += ([int]$subCount * $sub.Value) + $sub.Value
        }
    }
    return [int]$thisSubCount
}


# part1
#Loop through each bag and check if $searchForBag is contained within them
$bagsContaining = 0
foreach ($bag in $bagTable.getEnumerator()) {
    if (check-bag -bagToCheck $bag.Name -lookingForBag $searchForBag) {
        $bagsContaining++
    }
}

Write-Host "Total Bags Containing $searchForBag`: $bagsContaining"

# part2
#Count the sub bags of $searchForBag
Write-Host "Total Sub Bags of $searchForBag`:" (count-subBags -lookingForBag $searchForBag)