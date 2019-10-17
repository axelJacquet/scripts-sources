#!/bin/bash

token=$2
link=$1
if [[ -z "$token"  ]]
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


if [[ -z "$3"  ]]
 then
   mv $3/* /www/MyApp
 else
   var=$(ls dist/)
   if [[ $var == *"index"* ]]; then
     mv dist/* /www/MyApp
   else
     mv dist/$var/* /www/MyApp
   fi
fi
rm -rf $pathBuild
