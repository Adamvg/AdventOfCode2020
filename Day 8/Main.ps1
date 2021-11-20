$data = Get-Content .\Input.txt

$acc = 0
$op = 0

$doneArray = @()

while($false -eq $doneArray.contains($op)){
    $doneArray += $op
    $a = $inputData[$op]
    switch($a.Substring(0,3)){
        nop {$op++}
        jmp {$op = $op + ($a -split ' ')[1]}
        acc {
            $acc = $acc + ($a -split ' ')[1]
            $op++
        }
    }
}

Write-Output $acc

$op++
while($op -lt $inputData.Count-1){
    $a = $inputData[$op]
    switch($a.Substring(0,3)){
        nop {$op++}
        jmp {$op = $op + ($a -split ' ')[1]}
        acc {
            $acc = $acc + ($a -split ' ')[1]
            $op++
        }
    }
}


0..($data.Count - 1) |where-object {$data[$_] -match 'nop|jmp'} |ForEach-Object{

    $data = Get-Content .\Input.txt

if     ($data[$_] -match 'jmp') { $data[$_] = $data[$_] -replace 'jmp', 'nop' }
elseif ($data[$_] -match 'nop') { $data[$_] = $data[$_] -replace 'nop', 'jmp' }

    $pc = 0
    $visitedPCs = [System.Collections.Generic.HashSet[int]]::new()

    $accum = 0

    while($pc -lt $data.Count) {

        if ($visitedPCs.Contains($pc)) { break }
        $null = $visitedPCs.Add($pc)

        [string]$opCode, [int]$num = $data[$pc].Split(' ')

        switch ($opCode)
        {
            'acc' { $accum += $num; $pc++;}

            'jmp' { $pc += $num}

            'nop' { $pc++ }
        }
    }

    if ($pc -ge $data.Count) {
        "success! changepoint $_ accum: $accum"
        break
    }
    "acc: $accum"
}