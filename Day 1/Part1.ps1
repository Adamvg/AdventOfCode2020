# get input data
$inputData = Get-Content .\Input.txt

# iterate through list
Foreach($value in $inputData){
    For($i=0; $i -lt $inputData.Count; $i++){
            if(([int]$value + [int]$inputData[$i]) -eq 2020){
                $product = [int]$value * [int]$inputData[$i]
                Return "The two values are $($value) and $($inputData[$i]). Multiplied together they make $($product)."
        }
    }
}