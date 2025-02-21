
try {
    . ./set-vars.ps1
    pushd ../src

    foreach ($component in $components) {
        echo "*** Building: $component with unit tests"
        pushd $component
        docker build -t "$component-test" --target test .
        popd
    }
}
finally {
    popd
}