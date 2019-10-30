#!/bin/bash
link=$1

    if [[ $link == *".git"* ]];
    then
      repo="https://"$(echo $link |  cut -d'/' -f4 )@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5)
    else
      repo="https://"$(echo $link |  cut -d'/' -f4 )@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5).git
    fi

git clone $repo

pathBuild=$(echo $link |  cut -d'/' -f5 | cut -f1 -d".")

npm install --prefix ./$pathBuild
npm run build --prefix ./$pathBuild


pathBuild_form=$2

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
rc-service nginx reload
