#!/bin/bash

link=$1
if [[ -z "$token"  ]]
  then
    if [[ $link == *".git"* ]];
    then
      repo="https://"$(echo $link |  cut -d'/' -f4 )@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5)
    else
      repo="https://"$(echo $link |  cut -d'/' -f4 )@$(echo $link | cut -d'/' -f3)/$(echo $link |  cut -d'/' -f4)/$(echo $link |  cut -d'/' -f5).git
    fi
fi
git clone $repo

ppathBuild=$(echo $link |  cut -d'/' -f5 | cut -f1 -d".")

cd $pathBuild

find . -name dist -type d -exec rm -rf {} +
find . -name build -type d -exec rm -rf {} +


arrayBefore=($(ls -d */))

npm install

PACKAGE_VERSION=$(cat package.json \
  | grep build \
  | head -1 \
  | awk -F: '{ print $1 }' \
  | sed 's/[",]//g')
if [ $PACKAGE_VERSION == "build" ]
then
        npm run build
else
  PACKAGE_CLI=$(cat package.json \
    | grep prod \
    | head -1 \
    | awk -F: '{ print $1 }' \
    | sed 's/[",]//g')
  echo $PACKAGE_CLI
  npm run $PACKAGE_CLI
fi

rm -rf node_modules/


arrayAfter=($(ls -d */))
diff(){
  awk 'BEGIN{RS=ORS=" "}
       {NR==FNR?a[$0]++:a[$0]--}
       END{for(k in a)if(a[k])print k}' <(echo -n "${!1}") <(echo -n "${!2}")
}
folder=$(diff arrayBefore[@] arrayAfter[@])

#echo $folder
myPathWithIndex=$(find $folder -name "index.html" | sed 's|\(.*\)/.*|\1|')
echo $myPathWithIndex


mv $myPathWithIndex/* /home/jacqueax/MyApp
rm -rf ../$pathBuild
rc-service nginx reload
