#!/bin/bash

token=$2

link=$1

if [[ $link == *".git"* ]];

then

  repo="https://"$(echo $link |  cut -d'/' -f4 ):$token@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5)

else

  repo="https://"$(echo $link |  cut -d'/' -f4 ):$token@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5).git

fi

git clone $repo

cd $(echo $link |  cut -d'/' -f5)

npm run build
