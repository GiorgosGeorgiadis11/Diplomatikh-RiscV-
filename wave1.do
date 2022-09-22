onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CYCLES /top/CYCLES
add wave -noupdate -label RST /top/RST
add wave -noupdate -label CLOCK /top/CLK
add wave -noupdate -divider {PIPELINE CONTROL}
add wave -noupdate -label FLUSH -radix hexadecimal /top/main/PIPE_FLUSH_SIG
add wave -noupdate -label STALL -radix hexadecimal /top/main/PIPE_STALL_SIG
add wave -noupdate -divider {PC REGISTER}
add wave -noupdate -color Gold -label PC -radix hexadecimal /top/main/PC_OUT
add wave -noupdate -divider FETCH
add wave -noupdate -color Red -label {FETCHED WORD} -radix hexadecimal /top/main/IF_OUT_IFWORD
add wave -noupdate -divider DECODE
add wave -noupdate -label ISMULDIV /top/main/ID2/ISMULDIV
add wave -noupdate -divider {EXE ALU}
add wave -noupdate -label OP /top/main/EXE3/OP
add wave -noupdate -color Cyan -label {FORWARD A} -radix unsigned /top/main/PIPE_B/BUF_FWD_A
add wave -noupdate -color Cyan -label {FORWARD B} -radix unsigned /top/main/PIPE_B/BUF_FWD_B
add wave -noupdate -color Cyan -label IMMEDIATE -radix hexadecimal /top/main/PIPE_B/O_IMM_VAL
add wave -noupdate -color Cyan -label {OPERAND A} -radix hexadecimal /top/main/EXE3/A
add wave -noupdate -color Cyan -label {OPERAND B} -radix hexadecimal /top/main/EXE3/B
add wave -noupdate -color Cyan -label {ALU RESULT} -radix hexadecimal /top/main/ALU_RES
add wave -noupdate -color Cyan -label {TAKEN NOT TAKEN} /top/main/EXE3/TNT
add wave -noupdate -divider MEMORY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90669377 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 239
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {90086255 ps} {93194446 ps}
