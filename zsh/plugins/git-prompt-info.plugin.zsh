function git_prompt_info() {
  local REF 

  REF=$(command git symbolic-ref HEAD 2> /dev/null) || \
  REF=$(command git rev-parse --short HEAD 2> /dev/null) || \
  return 0

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${REF#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function parse_git_dirty() {
  local STATUS=''

  STATUS=$(command git status --porcelain --ignore-submodules=dirty 2> /dev/null | tail -n1)

  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}
