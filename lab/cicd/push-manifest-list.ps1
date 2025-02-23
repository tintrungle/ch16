try {
    . ./set-vars.ps1
    pushd ../src

    $multiPlatformComposeFiles = $composeFiles + @(
        '-f', 'docker-compose-multi-platform-tags.yml'
    )
    $spec = docker compose $multiPlatformComposeFiles config --format json | ConvertFrom-Json

    $variants = @(
        "linux-amd64",
        "windows-ltsc2022-amd64"
    )

    foreach ($component in $components) {
        $target = ($spec.services.PSObject.properties | where { $_.Name -eq $component }).Value.image
        echo "Creating manifest list for: $target"
        
        $variantList = @()
        foreach ($variant in $variants) {
            $ref = "$($target)-$variant"
            $variantList += $ref
        }

        docker manifest rm $target
        docker manifest create $target @variantList
        docker manifest push $target
    }
}
finally {
    popd
}