#!/bin/bash
# create symlinks for the dotfiles in the home directory
# the original files will be backed up

now=`date "+%Y%m%d-%H%M%S"`

# expects one argument (file or dir name) and creates a link in the home directory for it
# no need to the . in front of it. It will be added automatically
function create_link {
   file=~/.$1
   # files exists and is not a link -> rename
   if [ -e $file -a ! -L $file ]; then
      echo "file ~/.$file exists -> rename"
      mv $file $file-$now
   fi
   # link does not exists -> create link
   if [ ! -e $file ]; then
      echo "create link ~/.$file"
      ln -s ~/.dotfiles/$1 $file
   else
      echo "link for $file exists"
   fi
}

# expects two arguments (a folder name and a filename). It creates the folder and inside the link
# don't put the . in fron of the folder name. It will be added automatically.
# the filename argument will be used as it is
function create_link_subfolder {
   folder=~/.$1
   file=~/.$1/$2
   #if the subfolder does not exists it will be created
   if [ ! -e ~/.$1 ]; then
      echo "create dir ~/.$1"
      mkdir ~/.$1
   fi

   # files exists and is not a link -> move
   if [ -e $file -a ! -L $file ]; then
      echo "file $file exists  -> rename"
      mv $file $file-$now
   fi
   # link does not exists -> create link
   if [ ! -e $file ]; then
      echo "create link $file"
      ln -s ~/.dotfiles/$1/$2 $file
   else
      echo "link for $file exists"
   fi
}

create_link bashrc
create_link zshrc

create_link alias
create_link dir_colors
create_link Xdefaults

create_link curlrc
create_link screenrc
create_link gitconfig
create_link gitignore_global

create_link vim
create_link vimrc

create_link_subfolder clusterssh config
create_link_subfolder ssh config
create_link_subfilder ssh verified_hosts

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 770 ~/.dotfiles
chmod 770 ~/.clusterssh

