# git_return	:	displays/returns a variable with branch info
# git_set		:	sets global variable GIT_BRANCH_INFO to be used in PROMPT_COMMAND

# Args:
# 1 - If "1", then add color; "2" also add color to brackets
# 2 - If "1", then add symbols
# 3 - If "1", then add numbers in addition to symbols
# 4 - Set a symbol for untracked changes				default	'!'
# 5 - Set a symbol for tracked changes					default	'+'
# 6 - Set a symbol for starting bracket					default	''
# 7 - Set a symbol for ending bracket					default	''
# 8 - Set an escape code for uncommitted changes		default	'\e[31m' (red)
# 9 - Set an escape code for no changes in repository	default	'\e[32m' (green)

git_return () {
	if [ -n "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]; then
		local loc_color=''
		local loc_reset='\e[39m' # COLOR : RESET
		local loc_post_message=''
		local loc_envelope_start=''
		local loc_envelope_end=${loc_reset}
		local loc_branch=$(git branch --show-current)

		# Add color
		if [ "$1" != '0' ]; then
			if [ -n "$(git status -s)" ]; then
				loc_color='\e[31m' # COLOR : RED
				if [[ $8 ]]; then
					loc_color=$8
				fi
			else
				loc_color='\e[32m' # COLOR : GREEN
				if [[ $9 ]]; then
					loc_color=$9
				fi
			fi
			if [ "$1" == '2' ]; then
				loc_envelope_start+=${loc_color}
				loc_envelope_end+=${loc_color}
			fi
		fi

		# Add symbols (if necessary)
		if [ "$2" == '1' ]; then
			local loc_untracked_sym=''
			local loc_tracked_sym=''
			local loc_combined_n=$(git status -s --porcelain=v1 -unormal | wc -l)
			local loc_tracked_n=$(git status -s --porcelain=v1 -uno | wc -l)
			local loc_untracked_n=$(( loc_combined_n - loc_tracked_n ))
		
			# Check if there are tracked changes
			if [ "$loc_tracked_n" -ne 0 ]; then
				loc_tracked_sym=' +'
				if [[ $5 ]]; then
					loc_tracked_sym=" $5"
				fi
				if [ "$3" == '1' ]; then
					loc_tracked_sym+=" $loc_tracked_n"
				fi
			fi
			
			# Check if there are untracked changes
			if [ "$loc_untracked_n" -ne 0 ]; then
				loc_untracked_sym=' !'
				if [[ $4 ]]; then
					loc_untracked_sym=" $4"
				fi
				if [ "$3" == '1' ]; then
					loc_untracked_sym+=" $loc_untracked_n"
				fi
			fi
			
			loc_post_message="${loc_untracked_sym}${loc_tracked_sym}"
		fi

		if [[ $6 ]]; then
			loc_envelope_start+=$6
		fi

		if [[ $7 ]]; then
			loc_envelope_end+=$7
		fi
		loc_envelope_end+=${loc_reset}

		local loc_message=${loc_envelope_start}
		loc_message+="${loc_color}${loc_branch}${loc_post_message}"
		loc_message+=${loc_envelope_end}
		echo -e $loc_message
	fi
}

git_set () {
	declare -g GIT_BRANCH_INFO=$(git_return $1 $2 $3 $4 $5 $6 $7 $8 $9)
}

# TODO : Convert arguments to options
