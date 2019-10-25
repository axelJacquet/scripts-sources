#!/bin/bash
link=$1



usage()
{
        cat <<-EOF
        Create managed vps server on cloud v2.
        Script used for automation with beanstalk worker.
        Arguments
          -c: cpu flavor
          -d: disk size
          -C: commande id
          -I: item id
EOF
        exit 0

}
#help
[[ -z $@ ]] && usage



# Options
#
while getopts "htp" OPTION
do
        case $OPTION in
                h)
                        usage
                        ;;
                t)      token=$OPTARG



                        ;;
                p)      pathBuild_form=$OPTARG

                        ;;
        esac
done




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




if [[ ! -z "$pathBuild_form"  ]]
 then
   mv $pathBuild/$pathBuild_form/* /www/MyApp
 else
   var=$(ls $pathBuild/dist)
   if [[ $var == *"index"* ]]; then
     mv $pathBuild/dist/* /www/MyApp
   else
     mv dist/$var/* /www/MyApp
   fi
fi
rm -rf $pathBuild
