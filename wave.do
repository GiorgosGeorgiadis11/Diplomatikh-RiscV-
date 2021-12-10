onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label CYCLES /top/cycle_counter
add wave -noupdate -label RST /top/rst
add wave -noupdate -label CLOCK /top/clk
add wave -noupdate -divider {PIPELINE CONTROL}
add wave -noupdate -label FLUSH -radix hexadecimal /top/main/PIPE_FLUSH_SIG
add wave -noupdate -label STALL -radix hexadecimal /top/main/PIPE_STALL_SIG
add wave -noupdate -divider {PC REGISTER}
add wave -noupdate -color Gold -label PC -radix hexadecimal /top/main/PC_OUT
add wave -noupdate -divider FETCH
add wave -noupdate -color Red -label {FETCHED WORD} -radix hexadecimal /top/main/IF_OUT_IFWORD
add wave -noupdate -divider DECODE
add wave -noupdate -color Magenta -label {SHIELD SELECT} /top/main/SHIELD_SELECT
add wave -noupdate -color Magenta -label {RS1 == RD [EXE]} /top/main/ID2/SFW/OR_A
add wave -noupdate -color Magenta -label {RS2 == RD [EXE]} /top/main/ID2/SFW/OR_B
add wave -noupdate -color Magenta -label {LOAD IN EXE} /top/main/ID2//PIPE_LOAD_E
add wave -noupdate -color Magenta -label {FORWARD C} /top/main/ID_OUT_FWD_C
add wave -noupdate -divider {EXE ALU}
add wave -noupdate -color Cyan -label {FORWARD A} -radix unsigned /top/main/PIPE_B/BUF_FWD_A
add wave -noupdate -color Cyan -label {FORWARD B} -radix unsigned /top/main/PIPE_B/BUF_FWD_B
add wave -noupdate -color Cyan -label IMMEDIATE -radix hexadecimal /top/main/PIPE_B/O_IMM_VAL
add wave -noupdate -color Cyan -label {OPERAND A} -radix hexadecimal /top/main/EXE3/A
add wave -noupdate -color Cyan -label {OPERAND B} -radix hexadecimal /top/main/EXE3/B
add wave -noupdate -color Cyan -label {ALU RESULT} -radix hexadecimal /top/main/ALU_RES
add wave -noupdate -color Cyan -label {TAKEN NOT TAKEN} /top/main/EXE3/TNT
add wave -noupdate -divider MEMORY
add wave -noupdate -color White -label {RAW MEMORY} -radix hexadecimal /top/main/MEM4/MEM_DATA
add wave -noupdate -color White -label {MEMORY RESULT} -radix hexadecimal /top/main/MEM_OUT_RES
add wave -noupdate -color White -label {MEMORY ENABLE} /top/main/MEM4/DATA_MEM/altsyncram_component/clocken0
add wave -noupdate -color White -label {WRITE ENABLE} /top/main/MEM4/DATA_MEM/altsyncram_component/wren_a
add wave -noupdate -color White -label ADDRESS -radix hexadecimal /top/main/MEM4/DATA_MEM/address
add wave -noupdate -color White -label {BYTE ENABLE} /top/main/MEM4/DATA_MEM/byteena
add wave -noupdate -divider {SIMULATION PROGRESS}
add wave -noupdate -color Red -label ECALL /top/main/ECALL
add wave -noupdate -color Red -label {GP REGISTER} -radix decimal /top/main/GP_REG_TEST
add wave -noupdate -divider {I$ DEBUG}
add wave -noupdate -label {I$ ADDRESS} -radix hexadecimal sim:/top/main/IF1/MEM/altsyncram_component/address_a
add wave -noupdate -label {I$ DATA} -radix hexadecimal sim:/top/main/IF1/MEM/altsyncram_component/data_a
add wave -noupdate -label {I$ OUTDATA} -radix hexadecimal sim:/top/main/IF1/MEM/altsyncram_component/q_a
add wave -noupdate -label {I$ WRITE EN} sim:/top/main/IF1/MEM/altsyncram_component/wren_a
add wave -noupdate -label {I$ CLOCK EN} sim:/top/main/IF1/MEM/altsyncram_component/clocken0
add wave -noupdate -label {I$ CLOCK} sim:/top/main/IF1/MEM/altsyncram_component/clock0
add wave -noupdate -label {I$ OUT DATA DRIVER} -radix hexadecimal sim:/top/main/IF1/MEM/sub_wire0

add wave -noupdate -label {I$ EXE3 OP} -radix hexadecimal sim:/top/main/EXE3/OP
add wave -noupdate -label {I$ EXE3 RES} -radix hexadecimal sim:/top/main/EXE3/RES
add wave -noupdate -label {I$ EXE3 TNT} -radix hexadecimal sim:/top/main/EXE3/TNT
add wave -noupdate -label {I$ EXE3 ADDER_A_MSB} -radix hexadecimal sim:/top/main/EXE3/ADDER_A_MSB
add wave -noupdate -label {I$ EXE3 ADDER_B_MSB} -radix hexadecimal sim:/top/main/EXE3/ADDER_B_MSB
add wave -noupdate -label {I$ EXE3 ADDER_RES} -radix hexadecimal sim:/top/main/EXE3/ADDER_RES
add wave -noupdate -label {I$ EXE3 A_EXTENDED} -radix hexadecimal sim:/top/main/EXE3/A_EXTENDED
add wave -noupdate -label {I$ EXE3 B_EXTENDED} -radix hexadecimal sim:/top/main/EXE3/B_EXTENDED


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {90669377 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 367
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
WaveRestoreZoom {90086255 ps} {92757250 ps}
