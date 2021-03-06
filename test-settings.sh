#!/bin/bash

usage() {  1>&2; exit 1; }

while getopts "ltp" o; do
    case "${o}" in

        l)
            link=${OPTARG}
            ;;


        t)
            token=${OPTARG}
            ;;
        p)
            pathBuild_form=${OPTARG}
            ;;

    esac
done
shift $((OPTIND-1))

echo "token = ${token}"




if [[ -z "${token}"  ]]
  then
    if [[ $link == *".git"* ]];
    then
      repo="https://"$(echo $link |  cut -d'/' -f4 )@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5)
    else
      repo="https://"$(echo $link |  cut -d'/' -f4 )@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5).git
    fi
  else
    if [[ $link == *".git"* ]];
    then
      repo="https://"$(echo $link |  cut -d'/' -f4 ):$token@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5)
    else
      repo="https://"$(echo $link |  cut -d'/' -f4 ):$token@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5).git
    fi
fi
git clone $repo

pathBuild=$(echo $link |  cut -d'/' -f5 | cut -f1 -d".")

npm install --prefix ./$pathBuild
npm run build --prefix ./$pathBuild




if [[ ! -z "$pathBuild_form"  ]]
 then
   mv $pathBuild/$pathBuild_form/* /www/MyApp
 else
   var=$(ls $pathBuild/dist)
   if [[ $var == *"index"* ]]; then
     mv $pathBuild/dist/* /www/MyApp
   else
     mv $pathBuild/dist/$var/* /www/MyApp
   fi
fi
rm -rf $pathBuild
