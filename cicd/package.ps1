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

    if (-not $NoPush) {
        echo 'Tagging images with release tag'
        foreach ($component in $components) {
            $target = "$env:REGISTRY/$env:REPOSITORY/ch16-$($component):2e-$env:DOCKER_BUILD_OS$env:OS_VERSION_TAG-$env:DOCKER_BUILD_CPU"
            $source = "$($target)-$env:BUILD_NUMBER"
            echo "*** Tagging: $source to: $target"
            docker tag $source $target
        }  

        $releaseComposeFiles = $composeFiles + @(        
            '-f', 'docker-compose-release-tags.yml'
        )
    
        echo 'Pushing images with release tag'
        docker compose $releaseComposeFiles push --quiet
    }
}
finally {
    popd
}