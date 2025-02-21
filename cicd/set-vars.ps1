# sets common variables used in other scripts

$components = (
    'access-log',
    'image-gallery',
    'image-of-the-day'
)

$info = docker version -f json | ConvertFrom-Json
$env:DOCKER_BUILD_OS = $info.Server.Os.ToLower()
$env:DOCKER_BUILD_CPU = $info.Server.Arch.ToLower()
$env:OS_VERSION_TAG=''
if ($env:DOCKER_BUILD_OS -eq 'windows') {
    $env:OS_VERSION_TAG="-ltsc2022"
}