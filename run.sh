#!/bin/bash
source $HOME/.remote_runner/config.cfg # installing path

remote__status(){
    if [ "$#" -ne  "1" ]
    then
        echo "usage: remote run <cluster>"
    else
      cluster=$1; shift
      host_var=${cluster}_host
      user_var=${cluster}_user
      gres_map_var=${cluster}_gres_name

      ssh ${!user_var}@${!host_var} "sinfo -N -r -O NodeList,CPUsState,Memory,FreeMem,Gres,GresUsed" | uniq | awk '{if ($5 !~ /(null)/) print}'
    fi
}

remote__run(){
    if [ "$#" -lt  "2" ]
    then
        echo "usage: remote run <cluster> <job_script> <job_args>"
    else
        cluster=$1; shift
        host_var=${cluster}_host
        user_var=${cluster}_user
        tmp_dir=${cluster}_tmp_dir
        script=$1; shift


        #check if script exists
        if [ ! -f "${PWD}/${script}" ]; then
            echo "Error: $script does not exist"
            return
        fi

        remote_temp_dir=${!tmp_dir}/${!user_var}/$(date +%s)
        ssh ${!user_var}@${!host_var} "mkdir -p ${remote_temp_dir}" # create temp dir

        echo "Copying project to ${!host_var}..."
        rsync -az --delete $PWD ${!user_var}@${!host_var}:${remote_temp_dir} # copy project folder

        echo "Running job..."
        project_dir=`basename $PWD`
        ssh ${!user_var}@${!host_var} "cd /${remote_temp_dir}/$project_dir; export PROJECT_DIR=/${remote_temp_dir}/$project_dir; sbatch -o ~/job_%j.log $script $@ | tee ${remote_temp_dir}/job.info" # run job
    fi
}

remote__queue(){
    if [ "$#" -ne  "1" ]
    then
        echo "usage: remote queue <cluster>"
    else
        cluster=$1; shift
        host_var=${cluster}_host
        user_var=${cluster}_user

        ssh ${!user_var}@${!host_var} "squeue --start --user ${!user_var}"
    fi
}

remote__help(){
    echo "usage: remote <command> <cluster> <args>"
    echo "commands:"
    echo "  status: print cluster status"
    echo "  run: run job on cluster"
    echo "  queue: print cluster queue for current user"
    echo "  help: print this help message"
}

# From: https://stackoverflow.com/questions/37257551/defining-subcommands-that-take-arguments-in-bash
remote() {
  if [ "$#" -eq  "0" ]
  then
    remote__help
  else
    local cmdname=$1; shift
    if type "remote__$cmdname" >/dev/null 2>&1; then
      "remote__$cmdname" "$@"
    else
      echo "Function $cmdname not recognized" >&2
    fi
  fi
}


# if the functions above are sourced into an interactive interpreter, the user can
# just call "yum download" or "yum maintenance" with no further code needed.

# if invoked as a script rather than sourced, call function named on argv via the below;
# note that this must be the first operation other than a function definition
# for $_ to successfully distinguish between sourcing and invocation:
[[ $_ != $0 ]] && return

# make sure we actually *did* get passed a valid function name
if declare -f "$1" >/dev/null 2>&1; then
  # invoke that function, passing arguments through
  "$@" # same as "$1" "$2" "$3" ... for full argument list
else
  echo "Function $1 not recognized" >&2
  exit 1
fi