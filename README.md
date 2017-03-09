## import-bitbucket-github

### Description
Easily import all your Bitbucket repositories to GitHub. With almost no pain.

### Usage
1. Clone project.
2. Fill in config file. In `config.sh`:
  * `user_github` is your GitHub account name;
  * `user_token` is your [GitHub token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/);
  * `user_bitbucket` is your Bitbucket account name;
  * `key_bitbucket` and `secret_bitbucket` are key and secret hash pair to generate your [Bitbucket token](https://confluence.atlassian.com/bitbucket/oauth-on-bitbucket-cloud-238027431.html#OAuthonBitbucketCloud-Createaconsumer) (see *'Create a consumer'* section).
3. Run `cd PROJECT_PATH && ./import.sh` in your Terminal.
4. Depends on the amount of repositories and how heavy they are it may take time for script to finish its magic. In the end you should see something like this in your Terminal: `21 repositories have been successfully imported.`.

### Notes
By default it will import all repositories as privates on GitHub. In case you need to change this or add any other parameters for [creating new repository on GitHub](https://developer.github.com/v3/repos/#create) command then you are looking for _line 42_ in `import.sh`.

### License
Feel free to adjust the script to your own needs or use it 'as is'.

**Use it on your own risk** as executing this script may lead to some unexpected and unpredictable results, icluding losing your data!

---

**TODO:**
* Errors catching and colorful logs
* Move create options to config file
* Refresh Bitbucket token after 1 hour