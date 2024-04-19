# git_return	:	displays/returns a variable with branch info
# git_set		:	sets global variable GIT_BRANCH_INFO to be used in PROMPT_COMMAND

# Args:
#
#    -v : Adds untracked, unstaged, staged, added, deleted, modified files information.
#
#    -c : Enables prompt color
#    -b : Enables bracket color (enables -c).
#    -U [value]: Sets unchanged repo prompt color with an escape sequence (enables -c).
#    -M [value]: Sets modified repo prompt color with an escape sequence (enables -c).
#
#    -O [value]: Sets opening bracket symbol
#    -C [value]: Sets closing bracket symbol
#    -n [value]: Sets untracked info symbol
#    -u [value]: Sets unstaged info symbol
#    -s [value]: Sets staged info symbol
#    -a [value]: Sets added info symbol
#    -d [value]: Sets deleted info symbol
#    -m [value]: Sets modified info symbol
#
#    -S [value]: Sets the type of info to suppress in verbose mode
#    	Example:
#    		-S 'da' # Omits added and deleted file information from prompt
#
#

git_return () {
	if [ -n "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]; then

		local verbose=false
		local color=false
		local color_bracket=false
		local unmodified_color='\e[32m' 
		local modified_color='\e[31m' 
		local open_bracket=''
		local close_bracket=''
		local untracked_symbol='?'
		local unstaged_symbol='U'
		local staged_symbol='S'
		local added_symbol='A'
		local deleted_symbol='D'
		local modified_symbol='M'
		local suppress_options=''
		local branch=$(git branch --show-current)
		local status_color=''
		local reset_color='\e[39m' 

		while getopts ":vcbU:M:O:C:n:u:s:a:d:m:S:" opt; do
			case $opt in
				v) verbose=true ;;
				c) color=true ;;
				b) color_bracket=true; color=true ;;
				U) unmodified_color="$OPTARG"; color=true ;;
				M) modified_color="$OPTARG"; color=true ;;
				O) open_bracket="$OPTARG" ;;
				C) close_bracket="$OPTARG" ;;
				n) untracked_symbol="$OPTARG" ;;
				u) unstaged_symbol="$OPTARG" ;;
				s) staged_symbol="$OPTARG" ;;
				a) added_symbol="$OPTARG" ;;
				d) deleted_symbol="$OPTARG" ;;
				m) modified_symbol="$OPTARG" ;;
				S) suppress_options="$OPTARG" ;;
				\?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
				:) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
			esac
		done

		if $color; then

			local diff_status=$(git status -s)

			if [ -n "$diff_status" ]; then
				status_color=$modified_color
			else
				status_color=$unmodified_color
			fi

			if $color_bracket; then
				open_bracket=${status_color}${open_bracket}
				close_bracket=${status_color}${close_bracket}${reset_color}
			fi
		fi

		if [ -z "$branch" ]; then
			# If a commit is checked out instead of a branch
			branch=$(git --no-pager show --oneline -s)
			if $color; then
				status_color=$modified_color
			fi
		fi

		if $verbose; then
			branch+=$(_simple_git_verbose \
					"$suppress_options" \
					"$untracked_symbol" "$unstaged_symbol" "$staged_symbol" \
					"$added_symbol" "$deleted_symbol" "$modified_symbol")
		fi

		echo -e ${open_bracket}${status_color}${branch}${reset_color}${close_bracket}
	fi
}

git_set () {
	declare -g GIT_BRANCH_INFO=$(git_return $@)
}

_simple_git_verbose () {
		local suppress_untracked=false
		local suppress_unstaged=false
		local suppress_staged=false
		local suppress_added=false
		local suppress_deleted=false
		local suppress_modified=false
		local suppress_options=$1

		for ((i = 0; i < ${#suppress_options}; i++)); do
			char="${suppress_options:i:1}"
			case $char in
				u|U) suppress_untracked=true ;;
				s|S) suppress_unstaged=true ;;
				t|T) suppress_staged=true ;;
				a|A) suppress_added=true ;;
				d|D) suppress_deleted=true ;;
				m|M) suppress_modified=true ;;
				*) echo "Unknown suppression option: $char. Full option: ${suppress_options}" >&2; exit 1 ;;
			esac
		done

		local untracked_symbol=$2
		local unstaged_symbol=$3
		local staged_symbol=$4
		local added_symbol=$5
		local deleted_symbol=$6
		local modified_symbol=$7
	
		local n=0
		local status=$(git status --porcelain=v1)
		local info=''

		if ! $suppress_untracked; then
			n=$(echo "$status" | grep -E '^\?\?' | wc -l)
			if [ "$n" -ne 0 ]; then
				info+=" ${n}${untracked_symbol}"
			fi
		fi

		if ! $suppress_unstaged; then 
			n=$(echo "$status" | grep -E '^.[MADRC]' | wc -l)
			if [ "$n" -ne 0 ]; then
				info+=" ${n}${unstaged_symbol}"
			fi
		fi

		if ! $suppress_staged; then
			n=$(echo "$status" | grep -E '^[MADRC].' | wc -l)
			if [ "$n" -ne 0 ]; then
				info+=" ${n}${staged_symbol}"
			fi
		fi

		if ! $suppress_added; then
			n=$(echo "$status" | grep -E '^.?A' | wc -l)
			if [ "$n" -ne 0 ]; then
				info+=" ${n}${added_symbol}"
			fi
		fi

		if ! $suppress_deleted; then
			n=$(echo "$status" | grep -E '^.?D' | wc -l)
			if [ "$n" -ne 0 ]; then
				info+=" ${n}${deleted_symbol}"
			fi
		fi

		if ! $suppress_modified; then
			n=$(echo "$status" | grep -E '^.?M' | wc -l)
			if [ "$n" -ne 0 ]; then
				info+=" ${n}${modified_symbol}"
			fi
		fi

		echo "$info"
}
