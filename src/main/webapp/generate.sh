#!/bin/bash -e
# The MIT License
#
# Copyright (c) 2004-2009, Sun Microsystems, Inc., Kohsuke Kawaguchi
# Copyright (c) 2014, Oliver Vinn
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# Greenballs provided the original idea and tools available but the outcome and
# use has largely changed (transparency, hue not flash, quality etc..)

colornames=("nobuilt" "yellow" "red" "blue" "aborted" "folder" "grey" "edit-delete" "clock" "disabled")
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

