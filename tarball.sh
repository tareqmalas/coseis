#!/bin/bash

cd ..

gtar -hzvc -f sord/save/sord.tgz sord/*.m sord/readme sord/tarball.sh sord/*.f sord/makefile

cd sord/save

tag=$( date +%Y-%m-%d-%H-%M-%S )
cp sord.tgz "sord-$tag.tgz"

