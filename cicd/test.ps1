
$composeFiles = @(
    '-f', 'docker-compose.yml',
    '-f', 'docker-compose-release-tags.yml'
)
$exitCode = 0

try {
    . ./set-vars.ps1
    pushd ../src

    docker compose $composeFiles pull --ignore-pull-failures
    docker compose $composeFiles up -d

    $response = Invoke-WebRequest http://localhost:8010
    if ($response.StatusCode -eq '200' -and $response.Images.Count -eq 1) {
        echo 'Smoke tests OK!'
    }
    else {
        echo 'FAILED'
        echo $response
        $exitCode = 2
    }
}
catch {
    $exitCode = 1
}
finally {
    docker compose $composeFiles down
    popd
}

exit $exitCode