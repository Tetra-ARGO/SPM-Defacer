dir=$1
images_with_paths="$(find $dir -name "*.nii" -type f)"
images_to_deface=${images_with_paths//$dir/"/mount"}

# # download image if it does not already exist 
if [[ "$(docker images -q argotetra/spm_deface 2> /dev/null)" == "" ]]; then
    echo "Downloading image from argotetra/spm_deface:" 
    docker pull argotetra/spm_deface
fi

container="$(docker run --workdir /mount --rm -dit -v $dir:/mount argotetra/spm_deface)"
echo -e "\nCreating Container: \n$container\n" 

echo -e "Defacing NIFTI images in $dir and all subdirectories: \n$dir\n"
docker exec $container /opt/spm12/spm12 spm.util.deface --images $images_to_deface

echo -e "Deleting Container:" 
docker stop $container