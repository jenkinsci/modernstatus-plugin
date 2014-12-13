#!/bin/bash -e
# Oliver Vinn 2014

colornames=("nobuilt" "yellow" "red" "blue" "aborted" "folder" "grey" "edit-delete" "clock")
levels=("grey" "orange" "red" "green" "grey" "blue" "grey" "purple" "black")
sizes="16x16 24x24 32x32 48x48"


for ((i=0;i<${#colornames[@]};++i));
do
  color=${colornames[i]}
  level=${levels[i]}

  test -f 48x48/${color}.png && \
       echo "[PNG2GIF] ${color}" && \
       convert 48x48/${color}.png -channel OA -alpha remove -transparent white 48x48/${color}.gif

  for sz in $sizes
  do
      test -f 48x48/$color.png && \
           echo "[RESIZE] $sz" && \
           convert 48x48/$color.png -resize $sz $sz/$color.png > /dev/null && \
           pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB $sz/$color.png $sz/$color~.png 2> /dev/null && \
           mv $sz/$color~.png $sz/$color.png

      test -f $sz/${color}.png && \
           echo "[PNG2GIF] $sz/${color}.gif" && \
           convert $sz/${color}.png -channel OA -alpha remove -transparent white $sz/${color}.gif

      test -f 48x48/waiting.gif && \
           echo "[COLORGIF] $sz/${color}_anime.gif" && \
           convert 48x48/waiting.gif -resize $sz -transparent white \
                                     +level-colors ${level}, $sz/${color}_anime.gif;
  done
done

