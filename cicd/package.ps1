
try {
    pushd ../src
    docker compose build --pull
    docker compose push
}
finally {
    popd
}