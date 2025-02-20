
try {
    $info = docker version -f json | ConvertFrom-Json
    $env:DOCKER_BUILD_OS = $info.Server.Os.ToLower()
    $env:DOCKER_BUILD_CPU = $info.Server.Arch.ToLower()
    $env:OS_VERSION_TAG=''
    if ($env:DOCKER_BUILD_OS -eq 'windows') {
        $env:OS_VERSION_TAG="-ltsc2022"
    }

    $composeFiles = @(
        '-f', 'docker-compose.yml',
        '-f', 'docker-compose-package.yml'
    )

    pushd ../src
    docker compose $composeFiles build --pull
    docker compose $composeFiles push
}
finally {
    popd
}