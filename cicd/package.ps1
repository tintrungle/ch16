param(
    [switch]$NoPush=$false
)

try {
    . ./set-vars.ps1
    pushd ../src

    $composeFiles = @(
        '-f', 'docker-compose.yml',
        '-f', 'docker-compose-build.yml'
    )

    $buildComposeFiles = $composeFiles + @(        
        '-f', 'docker-compose-build-tags.yml'
    )

    echo "Building images with build number tag: $env:BUILD_NUMBER"
    docker compose $buildComposeFiles build --pull
    
    if (-not $NoPush) {
        echo "Pushing images with build number tag: $env:BUILD_NUMBER"
        docker compose $buildComposeFiles push
    }

    $releaseComposeFiles = $composeFiles + @(        
        '-f', 'docker-compose-release-tags.yml'
    )

    echo 'Building images with release tag'
    docker compose $releaseComposeFiles build --quiet    
    
    if (-not $NoPush) {
        echo 'Pushing images with release tag'
        docker compose $releaseComposeFiles push --quiet
    }
}
finally {
    popd
}