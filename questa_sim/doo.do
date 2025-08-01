vlib work
vmap work work
vlog project_DSP_final.v project_DSP_final_tb.v
vsim -voptargs=+acc work.DSP_48_tb
add wave *
sim:/DSP_48_tb/A0REG \
sim:/DSP_48_tb/A1REG \
sim:/DSP_48_tb/B0REG \
sim:/DSP_48_tb/B1REG \
sim:/DSP_48_tb/CREG \
sim:/DSP_48_tb/DREG \
sim:/DSP_48_tb/MREG \
sim:/DSP_48_tb/PREG \
sim:/DSP_48_tb/CARRYINREG \
sim:/DSP_48_tb/CARRYOUTREG \
sim:/DSP_48_tb/OPMODEREG \
sim:/DSP_48_tb/CARRYINSEL \
sim:/DSP_48_tb/B_INPUT \
sim:/DSP_48_tb/A \
sim:/DSP_48_tb/B \
sim:/DSP_48_tb/C \
sim:/DSP_48_tb/D \
sim:/DSP_48_tb/CARRYIN \
sim:/DSP_48_tb/M \
sim:/DSP_48_tb/P \
sim:/DSP_48_tb/CARRYOUT \
sim:/DSP_48_tb/CARRYOUTF \
sim:/DSP_48_tb/CLK \
sim:/DSP_48_tb/OPMODE \
sim:/DSP_48_tb/CEA \
sim:/DSP_48_tb/CEB \
sim:/DSP_48_tb/CEC \
sim:/DSP_48_tb/CECARRYIN \
sim:/DSP_48_tb/CED \
sim:/DSP_48_tb/CEM \
sim:/DSP_48_tb/CEOPMODE \
sim:/DSP_48_tb/CEP \
sim:/DSP_48_tb/RSTA \
sim:/DSP_48_tb/RSTB \
sim:/DSP_48_tb/RSTC \
sim:/DSP_48_tb/RSTCARRYIN \
sim:/DSP_48_tb/RSTD \
sim:/DSP_48_tb/RSTM \
sim:/DSP_48_tb/RSTOPMODE \
sim:/DSP_48_tb/RSTP \
sim:/DSP_48_tb/BCIN \
sim:/DSP_48_tb/BCOUT \
sim:/DSP_48_tb/PCIN \
sim:/DSP_48_tb/PCOUT

run -all
#quit -sim