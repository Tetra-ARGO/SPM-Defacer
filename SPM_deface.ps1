$parent = split-path -parent $args[0]
$leaf = split-path -leaf $args[0]

if (!(docker images -q argotetra/spm_deface)) { 
    Write-Output "Downloading image from argotetra/spm_deface:" 
    docker pull argotetra/spm_deface 
  }

$container = docker run --rm -dit -v ${parent}:/mount argotetra/spm_deface
Write-Output `n "Creating Container:" $container `n

Write-Output "Defacing:" $args[0] `n
docker exec $container ./spm12 spm.util.deface --images /mount/${leaf}

Write-Output "Deleting Container:" 
docker stop $container
