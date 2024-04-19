# Git prompt for Bash

A minimal and customizable Bash script for dynamically retrieving and displaying the current Git branch in the shell prompt.

The script provides two functions, `git_return()` displays or returns the current branch information and `git_set()` sets global variable `GIT_BRANCH_INFO` containing the same value. Both functions can receive the same arguments. 

![Prompt-example-demonstration](/assets/images/promp-example.gif "Example prompt demonstration")

## Usage

### Arguments

```
-v : Adds untracked, unstaged, staged, added, deleted, modified files information.

-c : Enables prompt color
-b : Enables bracket color (enables -c).
-U [value]: Sets unchanged repo prompt color with an escape sequence (enables -c).
-M [value]: Sets modified repo prompt color with an escape sequence (enables -c).

-O [value]: Sets opening bracket symbol
-C [value]: Sets closing bracket symbol
-n [value]: Sets untracked info symbol
-u [value]: Sets unstaged info symbol
-s [value]: Sets staged info symbol
-a [value]: Sets added info symbol
-d [value]: Sets deleted info symbol
-m [value]: Sets modified info symbol

-S [value]: Sets the type of info to suppress in verbose mode
	Example:
		-S 'da' # Omits added and deleted file information from prompt
```

### Prompt

1. Include the script in `.bashrc` by `source path/to/file/bash-git.sh`

2. Either use the function directly in PS1 or set a global variable in `.bashrc`:

```shell
PS1="[...] \$(git_return <ARG1> <ARG2> ...) [...]"
```
or
```shell
PROMPT_COMMAND='git_set <ARG1> <ARG2> ...'
PS1="[...] \$GIT_BRANCH_INFO [...]"
```

## TODO
- Separately customize information for (un)tracked, (un)staged etc. files
- Add more complex information and customization (e.g. unstaged modified, staged added files)
