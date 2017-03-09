#!/usr/bin/env bash

##### CONFIG
source config.sh

user_g=${user_github}
user_b=${user_bitbucket}

token_g=${token_github}
token_b=$(curl https://bitbucket.org/site/oauth2/access_token \
              -d grant_type=client_credentials \
              -u ${key_bitbucket}:${secret_bitbucket} | \
              python ./access.py)


##### LIST REPOSITORIES
get_repos () {
    curl -H 'Authorization: Bearer '"$token_b" \
    'https://api.bitbucket.org/2.0/repositories/'"$user_b"'?page='"$2" | \
    python './'"$1"'.py'
}

per_page=10
total=$(bc <<< 'scale = 1; (('"$(get_repos total 1)"'/'"$per_page"')+0.5)/1')
total_pages=$(bc <<< '('"$total"'+0.5)/1')

repos=''
collect_all_repos () {
    current_page=${total_pages}
    while [ ${current_page} -gt 0 ]
    do
        repos+=$(get_repos names ${current_page})
        ((current_page--))
    done
}


##### CREATE REPO
create_repo () {
    curl -H 'Authorization: token '"$token_g" \
        -d "{
            \"name\": \"$1\",
            \"private\": true
        }" \
        https://api.github.com/user/repos
}


##### DELETE REPO
delete_repo () {
    curl -X DELETE -H 'Authorization: token '"$token_g" \
        https://api.github.com/repos/${user_g}/$1
}
delete_all () {
    for name in ${repositories_total[@]}
    do
        delete_repo ${name}
        echo 'Successfully deleted '"$name"
    done
    echo Deleted all successfully.
}


##### IMPORT REPO & CLEAN UP
git_clone () {
    git clone --bare 'https://x-token-auth:'"$token_b"'@bitbucket.org/tribalddbdubai/'"$1"'.git'
}
git_push () {
    cd "$1"'.git' && git push --mirror 'git@github.com:'"$user_g"'/'"$1"'.git'
}
repo_rm () {
    cd .. && rm -rf "$1"'.git'
}
git_import () {
    create_repo $1
    git_clone $1
    git_push $1
    repo_rm $1
}
import_all () {
    i=1
    for name in ${repositories_total[@]}
    do
        git_import ${name}
        echo 'Successfully imported #'"$i"': '"$name"
        ((i++))
    done
    echo "$i"' repositories have been successfully imported.'
}


##### EXECUTE
collect_all_repos
repositories_total=($repos)
import_all