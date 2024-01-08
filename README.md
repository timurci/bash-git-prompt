# Git prompt for Bash

A minimal and customizable Bash script for dynamically retrieving and displaying the current Git branch in the shell prompt.

The script provides two functions, `git_return()` displays or returns the current branch information and `git_set()` sets global variable `GIT_BRANCH_INFO` containing the same value. Both functions can receive the same arguments. 

## Usage

### Arguments

The script allows for customization through command-line arguments. While all arguments are optional, the user should specify all previous arguments that comes before a chosen argument.

```
1 - If "1", then add color; "2" also add color to brackets
2 - If "1", then add symbols
3 - If "1", then add numbers in addition to symbols
4 - Set a symbol for untracked changes					default	'!'
5 - Set a symbol for tracked changes					default	'+'
6 - Set a symbol for starting bracket					default	''
7 - Set a symbol for ending bracket					default	''
8 - Set an escape sequence for uncommitted changes			default	'\e[31m' (red)
9 - Set an escape sequence for no changes in repository			default	'\e[32m' (green)
```

### Prompt

1. Include the script in `.bashrc` by `source path/to/file/bash-git.sh`

2. Either use the function directly in PS1 or set a global variable in `.bashrc`:

-  ```shell
		PS1="[...] \$(git_return <ARG1> <ARG2> ...) [...]"
	```
	or
-  ```shell
		PROMPT_COMMAND='git_set <ARG1> <ARG2> ...'
		PS1="[...] \$GIT_BRANCH_INFO [...]"
	```
