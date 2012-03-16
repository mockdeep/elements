Set up instructions
===================

Install rvm
-----------
* At the command line
* `bash < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)`
* Quit the shell and restart
* `rvm install 1.9.3`

Fork the project
----------------
* Go to https://github.com/mockdeep/elements
* Click the 'Fork' button

Clone the project
-----------------
* Copy the git url
* At the command line:
  * `git clone [git url]`
  * `cd elements`
  * `git remote add rob https://github.com/mockdeep/elements`

Install required packages
-------------------------
* Install nodejs
* Run `bundle` from the project directory

Starting a new feature
----------------------
* Check out our list of things to do:
  https://workflowy.com/shared/e136ab83-e114-4a93-76b5-1a64dcfff8b0/
* Create a new branch:
  * `git checkout -b my_cool_new_feature`
* Make changes
* Add files and commit
  * `git add .`
  * `git commit -m 'my commit message'`
* Push to your remote branch
  * `git push origin my_cool_new_feature`
* Make a pull request
  * On github, go to your elements fork
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
