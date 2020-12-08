# get input data as array
[array]$inputData = Get-Content .\ExampleInput.txt

# set variables
$bags = @()

# iterate through array to create bags array
foreach($rule in $inputData){
    # get bag colour
    $bagColour = $rule -replace ' bags.*' -replace ' '

    # only add if doesnt already exist
    if($bags | Where-Object {$_.bagColour -eq $bagColour}){break}

    # get bag contents
    if($rule -match 'no other bags'){
        $bagContents = $null
    }
    else{
        $bagContents = $rule -replace '.* contain ' -replace 'bags?' -replace ' ' -replace '\.' -split ','
    }

    # create temp table to add to overall array
    $bagsTemp = '' | Select-Object bagColour,bagContents
    $bagsTemp.bagColour = $bagColour
    $bagsTemp.bagContents = $bagContents

    $bags += $bagsTemp
}

# get empty bags into an array
$emptyBags = $bags | Where-Object {$_.bagContents -eq $null} | Select-Object -ExpandProperty bagColour

# remove empty bags from list
$bags = $bags | Where-Object {$_.bagContents -ne $null}

# iterate through bags array to remove empty bags
for($i=0; $i -lt $bags.Count; $i++){
    # get bag contents
    $bagContents = $bags[$i].bagContents

    # get bag colour
    $bagColour = $bags[$i].bagColour

    # remove empty bags
    foreach($bagContent in $bagContents){
        $bagContentColour = $bagContent -replace '[0-9]'
        $tempArray = @()

        if($emptyBags -contains $bagContentColour){
            $bagContentTemp = $bagContent | Where-Object {$_ -match $bagContentColour}
            $tempArray += $bagContentTemp
        }
        ($bags | Where-Object {$_.bagColour = $bagContentColour}).bagContents = $tempArray
    }
}

### everything below this is a fucking disaster and i dont know what im doing

foreach($bag in ($bags | Where-Object {$_.bagColour -notmatch 'shinygold'})){
    foreach($bagContent in ($bag.bagContents | Where-Object {$_ -notmatch 'shinygold'})){
        [string]$bagContentColour = $bagContent -replace '[0-9]*'
        [int]$bagContentCount = $bagContent -replace '[a-z]*'

        $otherBag = $bags | Where-Object {$_.bagColour = $bagContentColour}
        if($otherBag){
            $tempArray = @()
            foreach($otherBagContent in $otherBag.bagContent){
                [string]$otherBagContentColour = $otherBagContent -replace '[0-9]*'
                [int]$otherBagContentCount = $otherBagContent -replace '[a-z]*'

                $otherBagContentCount = $otherBagContentCount * $bagContentCount
                [string]$otherBagContentNew = "$($otherBagContentCount)$($otherBagContentColour)"
                $tempArray += $otherBagContentNew
            }
            ($bags | Where-Object {$_.bagColour = $bagContentColour}).bagContents = $tempArray
        }
    }
}

foreach($bag in $bags){
    # ignore shinygold
    if($bag.bagColour -ne 'shinygold'){
        # go through each bag content
        foreach($bagContent in $bag.bagContents){
            $bagContentColour = $bagContent -replace '[0-9]*'
            $bagContentCount = $bagContent -replace '[a-z]*'
            if(($bags.bagColour -contains $bagContentColour) -and ($bags.bagColour -ne 'shinygold')){
                # simplify
                $otherBags = $bags | Where-Object {$_.bagColour -eq $bagContentColour}

                if($otherBags){
                    $newBagContents = @()
                    foreach($otherBag in $otherBags){
                        $otherBagContents = $otherBag.bagContents
                        Foreach($otherBagContent in $otherBagContents){
                            $otherBagContentColour = $otherBagContent -replace '[0-9]*'
                            $otherBagContentCount = $otherBagContent -replace '[a-z]*'

                            $otherBagContentCount = [int]$otherBagContentCount * [int]$bagContentCount
                            $otherBagContent = [string]$otherBagContentCount + $otherBagContentColour

                            # set in bags array
                            $newBagContents += $otherBagContent
                        }
                    }
                    ($bags | Where-Object {$_.bagColour -eq $bagContentColour}).bagContents = $newBagContents
                }
            }
        }
    }
}

# iterate through to simplify bags
for($i=0; $i -lt $bags.Count; $i++){
    # get bag contents
    $bagContents = $bags[$i].bagContents

    foreach($bagContent in $bagContents){
        # don't simplify anything with shinygold
        $match = $bagContent -match 'shinygold'
        if(!($match)){
            $bagContentColour = $bagContent -replace '[0-9]'
            [int]$bagContentCount = $bagContent.subString(0,1)
            $otherBag = $bags | Where-Object {$_.bagColour -eq $bagContentColour}

            if($otherBag){
                # deal with other bag
                $otherBagContents = $otherBag.bagContents
                $otherBagContentsNew = @()
                foreach($otherBagContent in $otherBagContents){
                    [int]$otherBagContentCount = $otherBagContent.subString(0,1)
                    $otherBagContentColour = $otherBagContent -replace '[0-9]'

                    $outputBagContent = ($otherBagContentCount * $bagContentCount) + $otherBagContentColour
                    $otherBagContentsNew += $outputBagContent
                }
                ($bags | Where-Object {$_.bagColour -eq $otherBag.bagColour}).bagContents = $otherBagContentsNew
            }
        }
    }
}