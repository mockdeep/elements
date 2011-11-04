Set up instructions
===================

Install rvm
-----------
* At the command line
* `bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)`
* quit the shell and restart
* `rvm install 1.9.3`

Fork the project
----------------
* Go to https://github.com/mockdeep/todo
* Click the 'Fork' button

Clone the project
-----------------
* copy the git url
* At the command line:
  * `git clone [git url]`
  * `cd todo`
  * `git remote add rob https://github.com/mockdeep/todo`

Install required packages
-------------------------
* install nodejs
* run `bundle` from the project directory

Starting a new feature
----------------------
* Create a new branch:
  * `git checkout -b my_cool_new_feature`
* Make changes
* Add files and commit
  * `git add .`
  * `git commit -m 'my commit message'`
* Push to your remote branch
  * `git push origin my_cool_new_feature`
* Make a pull request
  * On github, go to your todo fork
  * Click on `Pull request`
  * In the right box type your branch name and click next
  * Review and click submit
* Once somebody has reviewed your code you can click merge

Getting up to date with the main repo
-------------------------------------
* Check out your master branch
  * `git checkout master`
* Pull from the main repo
  * `git pull rob master`
* Update your working branch
  * `git co my_feature_branch`
  * `git merge master`
* Watch for conflicts and manually fix the files mentioned
