
try {
    . ./set-vars.ps1
    pushd ../src
    docker pull diamol/node:2e
    docker compose $composeFiles build accesslog
    docker compose $composeFiles push
}
finally {
    popd
}