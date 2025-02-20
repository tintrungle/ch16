
try {
    pushd ../src
    $components = (
        'access-log',
        'image-gallery',
        'image-of-the-day'
    )
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