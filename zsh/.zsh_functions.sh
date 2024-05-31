
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

# tmux helpers
function tmux_new_session() {
  tmux new -s $1
}

function tmux_attach_session() {
  tmux attach -t $1
}
