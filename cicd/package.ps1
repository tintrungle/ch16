
try {
    . ./set-vars.ps1
    pushd ../src
    docker compose $composeFiles build
    docker compose $composeFiles push
}
finally {
    popd
}