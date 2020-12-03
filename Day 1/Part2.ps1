# get input data
$inputData = Get-Content .\Input.txt

# iterate through list
Foreach($value in $inputData){
    For($i=0; $i -lt $inputData.Count; $i++){
        for($x=0;$x -lt $inputData.Count; $x++){
            if(([int]$value + [int]$inputData[$i] + [int]$inputData[$x]) -eq 2020){
                $product = [int]$value * [int]$inputData[$i] * [int]$inputData[$x]
                Return "The three values are $($value), $($inputData[$i]) and $($inputData[$x]). Multiplied together they make $($product)."
            }
        }
    }
}