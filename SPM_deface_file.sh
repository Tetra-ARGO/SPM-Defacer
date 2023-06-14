dir=$1
parentdir="$(dirname "$dir")"
filename="$(basename "$dir")"
if [[ "$(docker images -q argotetra/spm_deface 2> /dev/null)" == "" ]]; then
    echo "Downloading image from argotetra/spm_deface:" 
    docker pull argotetra/spm_deface
fi

container="$(docker run --rm -dit -v $parentdir:/mount argotetra/spm_deface)"
echo -e "\nCreating Container: \n$container\n" 

echo -e "Defacing: \n$dir\n"
docker exec $container ./spm12 spm.util.deface --images /mount/$filename

echo -e "Deleting Container:" 
docker stop $container
