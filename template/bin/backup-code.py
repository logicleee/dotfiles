#!/usr/bin/env python3
import subprocess
import os

#archive_repo () {
    #git archive --format=tar.gz          \
        #-o "$output_file"                \
        #--prefix="${PROJ}/" $BRANCH
#}

HOME = os.path.expanduser("~")
SRC_PATH = "{}/code".format(HOME)
DEST_PATH = "{}/Dropbox/git-archives".format(HOME)
BRANCHES = ['master', 'develop']


def archive_branch(proj, branch, src_path, dest_file):
    owd = os.getcwd()
    os.chdir(src_path)
    try:
        subprocess.call([
            'git', 'archive'
            '--format=tar.gz'
            '-o', dest_file,
            '--prefix={}/'.format(proj), branch
        ])
    except:
        pass

    os.chdir(owd)


#TODO : make dest folder if not exists
#TODO : try just one to see if it works
#TODO : try just one with wrong branch before a good one to see what happens


#SOURCE=$HOME/code
#DEST=$HOME/Dropox/git-archives
#PROJECTS=$(\ls $SOURCE/)
#BRANCHES=("master" "develop")
#
#[ ! -d ${DEST} ] && mkdir -pv ${DEST}
#
#for pj in ${PROJECTS[@]}
#do
    #cd ${SOURCE}/${pj}
    #for branch in ${BRANCHES[@]}
    #do
        #output_file="$DEST/${pj}-${branch}".tar.gz
        ##archive_repo ${pj} ${branch} "$output_file"
        #echo "${pj} ${branch} $output_file"
    #done
    #cd -
#done
