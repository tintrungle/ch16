param(
    [switch]$NoPull=$false
)

$exitCode = 0

try {
    . ./set-vars.ps1
    pushd ../src

    if (-not $NoPull) {
        docker compose $stagingComposeFiles pull --ignore-pull-failures
    }

    docker compose $stagingComposeFiles up -d
    sleep 10

    $project = docker compose ls --format json | ConvertFrom-Json
    if ($project.Status -eq 'running(3)') {
        echo 'Compose project running!'
    }
    else {
        echo 'FAILED'
        echo $response
        $exitCode = 1
    }
    
    $response = Invoke-WebRequest http://localhost:8011/image
    if ($response.StatusCode -eq '200') {
        echo 'API OK!'
    }
    else {
        echo 'FAILED API'
        echo $response
        $exitCode = 2
    }

    $response = Invoke-WebRequest http://localhost:8010
    if ($response.StatusCode -eq '200' -and $response.Images.Count -eq 1) {
        echo 'Web tests OK!'
    }
    else {
        echo 'FAILED web'
        echo $response
        $exitCode = 2
    }
}
catch {
    echo "ERROR: $($_.Exception.Message)"
    docker compose $stagingComposeFiles logs
    $exitCode = 3
}
finally {
    docker compose $stagingComposeFiles down
    popd
}

exit $exitCode