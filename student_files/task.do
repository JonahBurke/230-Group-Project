vsim SimpleComputer

# display hexadecimal values
radix -hexadecimal

view wave

add wave clock

add wave debug_PC
add wave debug_IR
add wave debug_state
add wave debug_r1
add wave debug_r2
add wave debug_r3
add wave debug_r4
add wave debug_r5
add wave debug_r6
add wave debug_r7
add wave debug_RA
add wave debug_RB
add wave debug_Extension
add wave debug_RZ
add wave debug_RY

force clock 1 0, 0 1000 -repeat 2000
# push KEY0 between 0 and 100 to reset the computer
force KEY 0000 0, 0001 100
force SW 0000000000 0

run 250000


