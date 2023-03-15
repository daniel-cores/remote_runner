#!/bin/bash
#SBATCH --job-name=test
#SBATCH --output=job_%j.log
#SBATCH --time=0:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=100
#SBATCH --gres=gpu:a100:1

module load singularity
singularity exec --nv --env NCCL_DEBUG=WARN --bind $SHARE_IADT/datasets:/datasets --bind $SHARE_IADT/models:/models --bind $PROJECT_DIR:/workspace --pwd /workspace $SHARE_IADT/singularity_imgs/detectron2_03_cu113_pytorch110.sif /workspace/my_script.sh