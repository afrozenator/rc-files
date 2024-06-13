
function make_venv() {
  # afro@afrozs-air Code % python3 -m venv ~/jax-metal
  # afro@afrozs-air Code % source ~/jax-metal/bin/activate
  
  python3 -m venv ~/venvs/$1
  source ~/venvs/$1/bin/activate
}

function act_venv() {
  source ~/venvs/$1/bin/activate
}

# function deactivate_venv() {
#   venv=$VIRTUAL_ENV
#   echo "Deactivating virtual env: ${VIRTUAL_ENV}"
#   source ~/venvs/$venv/bin/
# }

function jax_venv() {
  source ~/VirtualEnvs/jax-metal/bin/activate
}

# tmux helpers
function tmux_new_session() {
  tmux new -s $1
}

function tmux_attach_session() {
  tmux attach -t $1
}

# cd many levels up in a single go.
function .. {
  local levels=${1:-1}
  local path=""

  for ((i=0; i<levels; i++)); do
    path="../${path}"
  done

  cd $path
}

# Generate ToC for the README.md file.
function generate_toc() {
  # From
  # https://medium.com/@acrodriguez/one-liner-to-generate-a-markdown-toc-f5292112fd14
  cat /Users/afroz/Code/recipes/Recipes.md | \
  grep -E "^#{${1:-1},${2:-5}} " | \
  sed -E 's/(#+) (.+)/\1:\2:\2/g' | \
  awk -F ":" '{ gsub(/#/,"  ",$1); gsub(/[ ]/,"-",$3); print $1 "- [" $2 "](#" tolower($3) ")" }'
}
