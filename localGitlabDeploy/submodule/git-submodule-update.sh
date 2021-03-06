#!/bin/sh
destination_dir="$1"
destination_branch="$2"
destination_host="$3"
#/var/www/jianghu_entertain
cd "$destination_dir"
git reset --hard origin/$destination_branch;
git fetch --all;
git checkout -f $destination_branch;
git reset --hard;
git fetch --all;
git submodule foreach --recursive 'git reset HEAD . || :'
git submodule foreach --recursive 'git checkout -- . || :'
git pull origin $destination_branch;
              cat > ${destination_dir}/.gitmodules <<EOL
[submodule "phpcs-rule"]
    path = phpcs-rule
    url = ssh://git@${destination_host}:2289/php/phpcs-rule.git
[submodule "jianghu_entertain_composer"]
	path = jianghu_entertain_composer
	url = ssh://git@${destination_host}:2289/php/jianghu_entertain_composer.git
[submodule "app/Game"]
	path = app/Game
	url = ssh://git@${destination_host}:2289/php/jianghu_game_modules.git
EOL
        chmod 777 ${destination_dir}/.gitmodules;
        if [[ ! -e ${destination_dir}/phpcs-rule ]]; then
            git submodule add -f ssh://git@${destination_host}:2289/php/phpcs-rule.git phpcs-rule;
        fi;
        if [[ ! -e ${destination_dir}/jianghu_entertain_composer ]]; then
            git submodule add -f ssh://git@${destination_host}:2289/php/jianghu_entertain_composer.git jianghu_entertain_composer;
        fi;
        if [[ ! -e ${destination_dir}/app/Game ]]; then
            git submodule add -f ssh://git@${destination_host}:2289/php/jianghu_game_modules.git app/Game;
        fi;
        git submodule update --init --recursive
        git submodule foreach --recursive git clean -d -f -f -x
        chmod 777 ${destination_dir}/phpcs-rule;
        cd ${destination_dir}/phpcs-rule;
        git -c credential.helper= -c core.quotepath=false -c log.showSignature=false checkout master --;
        git -c credential.helper= -c core.quotepath=false -c log.showSignature=false fetch origin --progress --prune;
        git pull origin master;
        chmod 777 ${destination_dir}/jianghu_entertain_composer;
        cd ${destination_dir}/jianghu_entertain_composer;
        git -c credential.helper= -c core.quotepath=false -c log.showSignature=false checkout master --;
        git -c credential.helper= -c core.quotepath=false -c log.showSignature=false fetch origin --progress --prune;
        git pull origin master;
        chmod 777 ${destination_dir}/app/Game;
        cd ${destination_dir}/app/Game;
        git -c credential.helper= -c core.quotepath=false -c log.showSignature=false checkout master --;
        git -c credential.helper= -c core.quotepath=false -c log.showSignature=false fetch origin --progress --prune;
        git pull origin master;