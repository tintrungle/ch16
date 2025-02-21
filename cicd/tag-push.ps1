param(
    [string]$From,
    [string]$To,
    [switch]$NoPush=$false
)

try {
    . ./set-vars.ps1
    pushd ../src

    echo "Tagging images from; $From to: $To"

    $fromComposeFiles = $composeFiles + @(        
        '-f', "docker-compose-$From-tags.yml"
    )       
    $toComposeFiles = $composeFiles + @(        
        '-f', "docker-compose-$To-tags.yml"
    )

    $fromSpec = docker compose $fromComposeFiles config --format json | ConvertFrom-Json
    $toSpec = docker compose $toComposeFiles config --format json | ConvertFrom-Json

    foreach ($component in $components) {
        $source = ($fromSpec.services.PSObject.properties | where { $_.Name -eq $component }).Value.image
        $target = ($toSpec.services.PSObject.properties | where { $_.Name -eq $component }).Value.image
        echo "*** Tagging: $source to: $target"
        docker tag $source $target
    }  

    if (-not $NoPush) {
        echo "Pushing images with: $To tag"
        docker compose $toComposeFiles push --quiet
    }
}
finally {
    popd
}