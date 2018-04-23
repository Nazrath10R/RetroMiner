
# tmux new-session -d -s work    
# tmux send-keys 'sh PeptideShaker.sh PXD002117 10 > log_PXD002117.txt' C-m   
# tmux detach -s work

# tmux send -t work.0 A ENTER


# tmux new-session -d -s work    
# tmux send-keys 'sh run_reanalysis.sh PXD000651 1 20' C-m   
# tmux detach -s work


cd /data/SBCS-BessantLab/naz/pride_reanalysis/scripts

#########################################################

tmux new-session -d -s PXD000652    
tmux send-keys 'sh run_reanalysis.sh PXD000652 3 20' C-m   
tmux detach -s PXD000652

#########################################################



#########################################################
#########################################################
#########################################################


tmux new-session -d -s PXD000653    
tmux send-keys 'sh run_reanalysis.sh PXD000653 3 20 10' C-m   
tmux detach -s PXD000653

#########################################################
#########################################################
#########################################################


tmux new-session -d -s PXD000654    
tmux send-keys 'sh run_reanalysis.sh PXD000654 3 20' C-m   
tmux detach -s PXD000654

tmux send-keys 'A' C-m   

#########################################################


tmux new-session -d -s PXD000655    
tmux send-keys 'sh run_reanalysis.sh PXD000655 1 20' C-m   
tmux detach -s PXD000655



tmux new-session -d -s PXD000656    
tmux send-keys 'sh run_reanalysis.sh PXD000656 1 20' C-m   
tmux detach -s PXD000656



tmux new-session -d -s PXD000657    
tmux send-keys 'sh run_reanalysis.sh PXD000657 1 20' C-m   
tmux detach -s PXD000657




#-------------------------------------------------------#

tmux new-session -d -s PXD002117    
tmux send-keys 'nice -n 20 sh PeptideShaker.sh PXD002117 20 > /data/SBCS-BessantLab/naz/pride_reanalysis/logs/PXD002117/ps_log.txt' C-m
tmux send-keys 'nice -n 20 sh Data_Filtering.sh PXD002117 20 > /data/SBCS-BessantLab/naz/pride_reanalysis/logs/PXD002117/df_log.txt' C-m
tmux detach -s PXD002117

#-------------------------------------------------------#




#########################################################
#                 inflammation datasets                 #
#########################################################

tmux new-session -d -s PXD003406    
tmux send-keys 'sh run_reanalysis.sh PXD003406 3 16' C-m   
tmux detach -s PXD003406


tmux new-session -d -s PXD003407    
tmux send-keys 'sh run_reanalysis.sh PXD003407 1 20' C-m   
tmux detach -s PXD003407


tmux new-session -d -s PXD003408    
tmux send-keys 'sh run_reanalysis.sh PXD003408 1 20' C-m   
tmux detach -s PXD003408


tmux new-session -d -s PXD003409    
tmux send-keys 'sh run_reanalysis.sh PXD003409 1 20' C-m   
tmux detach -s PXD003409


tmux new-session -d -s PXD003410    
tmux send-keys 'sh run_reanalysis.sh PXD003410 1 20' C-m   
tmux detach -s PXD003410


tmux new-session -d -s PXD003411    
tmux send-keys 'sh run_reanalysis.sh PXD003411 1 20' C-m   
tmux detach -s PXD003411


tmux new-session -d -s PXD003412    
tmux send-keys 'sh run_reanalysis.sh PXD003412 1 20' C-m   
tmux detach -s PXD003412


tmux new-session -d -s PXD003413    
tmux send-keys 'sh run_reanalysis.sh PXD003413 1 20' C-m   
tmux detach -s PXD003413


tmux new-session -d -s PXD003414    
tmux send-keys 'sh run_reanalysis.sh PXD003414 1 20' C-m   
tmux detach -s PXD003414


tmux new-session -d -s PXD003415    
tmux send-keys 'sh run_reanalysis.sh PXD003415 1 20' C-m   
tmux detach -s PXD003415


tmux new-session -d -s PXD003416    
tmux send-keys 'sh run_reanalysis.sh PXD003416 1 20' C-m   
tmux detach -s PXD003416


tmux new-session -d -s PXD003417    
tmux send-keys 'sh run_reanalysis.sh PXD003417 1 20' C-m   
tmux detach -s PXD003417


