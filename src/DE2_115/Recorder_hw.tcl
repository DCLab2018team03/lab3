# TCL File Generated by Component Editor 15.0
# Thu Nov 15 17:48:25 CST 2018
# DO NOT MODIFY


# 
# Recorder "Recorder" v1.0
#  2018.11.15.17:48:25
# 
# 

# 
# request TCL package from ACDS 15.0
# 
package require -exact qsys 15.0


# 
# module Recorder
# 
set_module_property DESCRIPTION ""
set_module_property NAME Recorder
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME Recorder
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL Recorder
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file AudioCoreInterpolation.sv SYSTEM_VERILOG PATH AudioCoreInterpolation.sv
add_fileset_file Recorder.sv SYSTEM_VERILOG PATH Recorder.sv TOP_LEVEL_FILE
add_fileset_file RecorderCore.sv SYSTEM_VERILOG PATH RecorderCore.sv
add_fileset_file AudioCore.sv SYSTEM_VERILOG PATH AudioCore.sv


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock i_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock ""
set_interface_property reset synchronousEdges NONE
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset i_rst reset Input 1


# 
# connection point sram
# 
add_interface sram avalon start
set_interface_property sram addressUnits SYMBOLS
set_interface_property sram associatedClock clock
set_interface_property sram associatedReset reset
set_interface_property sram bitsPerSymbol 8
set_interface_property sram burstOnBurstBoundariesOnly false
set_interface_property sram burstcountUnits WORDS
set_interface_property sram doStreamReads false
set_interface_property sram doStreamWrites false
set_interface_property sram holdTime 0
set_interface_property sram linewrapBursts false
set_interface_property sram maximumPendingReadTransactions 0
set_interface_property sram maximumPendingWriteTransactions 0
set_interface_property sram readLatency 0
set_interface_property sram readWaitTime 1
set_interface_property sram setupTime 0
set_interface_property sram timingUnits Cycles
set_interface_property sram writeWaitTime 0
set_interface_property sram ENABLED true
set_interface_property sram EXPORT_OF ""
set_interface_property sram PORT_NAME_MAP ""
set_interface_property sram CMSIS_SVD_VARIABLES ""
set_interface_property sram SVD_ADDRESS_GROUP ""

add_interface_port sram address address Output 21
add_interface_port sram byteenable byteenable Output 2
add_interface_port sram read read Output 1
add_interface_port sram readdata readdata Input 16
add_interface_port sram readdatavalid readdatavalid Input 1
add_interface_port sram write write Output 1
add_interface_port sram writedata writedata Output 16
add_interface_port sram waitrequest waitrequest Input 1


# 
# connection point left_sink
# 
add_interface left_sink avalon_streaming end
set_interface_property left_sink associatedClock clock
set_interface_property left_sink associatedReset reset
set_interface_property left_sink dataBitsPerSymbol 8
set_interface_property left_sink errorDescriptor ""
set_interface_property left_sink firstSymbolInHighOrderBits true
set_interface_property left_sink maxChannel 0
set_interface_property left_sink readyLatency 0
set_interface_property left_sink ENABLED true
set_interface_property left_sink EXPORT_OF ""
set_interface_property left_sink PORT_NAME_MAP ""
set_interface_property left_sink CMSIS_SVD_VARIABLES ""
set_interface_property left_sink SVD_ADDRESS_GROUP ""

add_interface_port left_sink from_adc_left_channel_data data Input 16
add_interface_port left_sink from_adc_left_channel_ready ready Output 1
add_interface_port left_sink from_adc_left_channel_valid valid Input 1


# 
# connection point right_sink
# 
add_interface right_sink avalon_streaming end
set_interface_property right_sink associatedClock clock
set_interface_property right_sink associatedReset reset
set_interface_property right_sink dataBitsPerSymbol 8
set_interface_property right_sink errorDescriptor ""
set_interface_property right_sink firstSymbolInHighOrderBits true
set_interface_property right_sink maxChannel 0
set_interface_property right_sink readyLatency 0
set_interface_property right_sink ENABLED true
set_interface_property right_sink EXPORT_OF ""
set_interface_property right_sink PORT_NAME_MAP ""
set_interface_property right_sink CMSIS_SVD_VARIABLES ""
set_interface_property right_sink SVD_ADDRESS_GROUP ""

add_interface_port right_sink from_adc_right_channel_data data Input 16
add_interface_port right_sink from_adc_right_channel_ready ready Output 1
add_interface_port right_sink from_adc_right_channel_valid valid Input 1


# 
# connection point left_source
# 
add_interface left_source avalon_streaming start
set_interface_property left_source associatedClock clock
set_interface_property left_source associatedReset reset
set_interface_property left_source dataBitsPerSymbol 8
set_interface_property left_source errorDescriptor ""
set_interface_property left_source firstSymbolInHighOrderBits true
set_interface_property left_source maxChannel 0
set_interface_property left_source readyLatency 0
set_interface_property left_source ENABLED true
set_interface_property left_source EXPORT_OF ""
set_interface_property left_source PORT_NAME_MAP ""
set_interface_property left_source CMSIS_SVD_VARIABLES ""
set_interface_property left_source SVD_ADDRESS_GROUP ""

add_interface_port left_source to_dac_left_channel_data data Output 16
add_interface_port left_source to_dac_left_channel_ready ready Input 1
add_interface_port left_source to_dac_left_channel_valid valid Output 1


# 
# connection point right_source
# 
add_interface right_source avalon_streaming start
set_interface_property right_source associatedClock clock
set_interface_property right_source associatedReset reset
set_interface_property right_source dataBitsPerSymbol 8
set_interface_property right_source errorDescriptor ""
set_interface_property right_source firstSymbolInHighOrderBits true
set_interface_property right_source maxChannel 0
set_interface_property right_source readyLatency 0
set_interface_property right_source ENABLED true
set_interface_property right_source EXPORT_OF ""
set_interface_property right_source PORT_NAME_MAP ""
set_interface_property right_source CMSIS_SVD_VARIABLES ""
set_interface_property right_source SVD_ADDRESS_GROUP ""

add_interface_port right_source to_dac_right_channel_data data Output 16
add_interface_port right_source to_dac_right_channel_ready ready Input 1
add_interface_port right_source to_dac_right_channel_valid valid Output 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset reset
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end i_input_event writebyteenable_n Input 16
add_interface_port conduit_end o_event_hold readdata Output 16
add_interface_port conduit_end o_time readdata Output 64

