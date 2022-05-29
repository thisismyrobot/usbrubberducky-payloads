$w=80
$h=30

[Console]::SetWindowSize($w, $h)
[Console]::SetBufferSize($w, $h)
[System.Console]::CursorVisible = 0
cls

$state = @{}
$state.score = 0
$state.ship = $w / 2
$state.enemies = New-Object System.Collections.Generic.List[System.Object]
$state.enemies.Add(@($w / 2, 0))
$state.missiles = New-Object System.Collections.Generic.List[System.Object]
$state.explosions = New-Object System.Collections.Generic.List[System.Object]

function text($x, $y, $t) {
    [Console]::SetCursorPosition($x, $y)
    [Console]::Write($t)
}

function draw(){
    cls
    foreach ($e in $state.enemies) {
        text $e[0] $e[1] 'W'
    }
    foreach ($m in $state.missiles) {
        text $m[0] $m[1] '.'
    }
    foreach ($x in $state.explosions) {
        text $x[0][0] $x[0][1] '*'
    }
    text $state.ship ($h - 1) '^'
    text 1 1 $state.score
}

function step([int]$i){

    # Controls
    if (($Host.UI.RawUI.KeyAvailable)) {
        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,IncludeKeyUp")
        $host.UI.RawUI.FlushInputBuffer()
        if ($key.KeyDown) {
            switch($key.VirtualKeyCode) {
                37 { $state.ship-- }
                39 { $state.ship++ }
                32 {
                    $state.missiles.Add(@($state.ship, ($h - 2)))
                    $state.score-=1
                }
            }
        }
    }

    # Enemies
    if ($i%20 -eq 0) {
        foreach ($e in $state.enemies) {
            $e[1]++
        }
        $r = Get-Random -Minimum 1 -Maximum 100
        if ($r -gt 80) {
            $x = Get-Random -Minimum 0 -Maximum ($w - 1)
            $state.enemies.Add(@($x, 0))
        }
    }

    # Collisions
    $state.ship = [math]::max($state.ship, 0)
    $state.ship = [math]::min($state.ship, $w - 1)
    $toDelShips = New-Object System.Collections.Generic.List[System.Object]
    foreach ($m in $state.missiles) {
        if ($m[1] -eq 0) {
            $state.explosions.Add(@($m, 50))
        }
        foreach ($e in $state.enemies) {
            if ($e[0] -eq $m[0] -And $e[1] -eq $m[1]) {
                $state.explosions.Add(@($m, 50))
                $toDelShips.Add($e)
                $state.score+=50
            }
        }
    }
    foreach($d in $toDelShips) {
        $state.enemies.Remove($d) | Out-Null
    }
    $toDelExplosions = New-Object System.Collections.Generic.List[System.Object]
    foreach ($x in $state.explosions) {
        $state.missiles.Remove($x[0]) | Out-Null
        $x[1]--
        if ($x[1] -lt 0) {
            $toDelExplosions.Add($x)
        }
    }
    foreach ($d in $toDelExplosions) {
        $state.explosions.Remove($d)
    }

    # Missiles
    if ($i%5 -eq 0) {
        foreach ($m in $state.missiles) {
            $m[1]--
        }
    }
}

function main() {
    try{
        $i = 0
        while($true)
        {
            draw
            step $i
            start-sleep -m 10
            $i++
        }
    }
    catch {
        cls
        text (($w / 2) - 5) (($h / 2) - 3) 'Game Over!'
        text (($w / 2) - 7) (($h / 2)) "You scored: $($state.score)"
        Read-Host
    }
    finally {
        [System.Console]::CursorVisible = 1
        cls
    }
}

main