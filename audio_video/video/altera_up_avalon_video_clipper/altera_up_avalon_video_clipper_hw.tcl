# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


# +----------------------------------------------------------------------------+
# |                                                                            |
# | Any megafunction design, and related net list (encrypted or decrypted),    |
# |  support information, device programming or simulation file, and any other |
# |  associated documentation or information provided by Altera or a partner   |
# |  under Altera's Megafunction Partnership Program may be used only to       |
# |  program PLD devices (but not masked PLD devices) from Altera.  Any other  |
# |  use of such megafunction design, net list, support information, device    |
# |  programming or simulation file, or any other related documentation or     |
# |  information is prohibited for any other purpose, including, but not       |
# |  limited to modification, reverse engineering, de-compiling, or use with   |
# |  any other silicon devices, unless such use is explicitly licensed under   |
# |  a separate agreement with Altera or a megafunction partner.  Title to     |
# |  the intellectual property, including patents, copyrights, trademarks,     |
# |  trade secrets, or maskworks, embodied in any such megafunction design,    |
# |  net list, support information, device programming or simulation file, or  |
# |  any other related documentation or information provided by Altera or a    |
# |  megafunction partner, remains with Altera, the megafunction partner, or   |
# |  their respective licensors.  No other licenses, including any licenses    |
# |  needed under any third party's intellectual property, are provided herein.|
# |  Copying or modifying any file, or portion thereof, to which this notice   |
# |  is attached violates this copyright.                                      |
# |                                                                            |
# | THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
# | IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   |
# | FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    |
# | THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER |
# | LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    |
# | FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  |
# | IN THIS FILE.                                                              |
# |                                                                            |
# | This agreement shall be governed in all respects by the laws of the State  |
# |  of California and by the laws of the United States of America.            |
# |                                                                            |
# +----------------------------------------------------------------------------+

# TCL File Generated by Altera University Program
# DO NOT MODIFY

source "../../../lib/aup_version.tcl"
source "../../../lib/aup_ip_generator.tcl"

# +-----------------------------------
# | module altera_up_avalon_video_clipper
# | 
set_module_property DESCRIPTION "Video Clipper for DE-Series Boards"
set_module_property NAME altera_up_avalon_video_clipper
set_module_property VERSION $aup_version
set_module_property GROUP "University Program/Audio & Video/Video"
set_module_property AUTHOR "Altera University Program"
set_module_property DISPLAY_NAME "Clipper"
set_module_property DATASHEET_URL "[pwd]/../doc/Video.pdf"
#set_module_property TOP_LEVEL_HDL_FILE altera_up_avalon_video_clipper.v
#set_module_property TOP_LEVEL_HDL_MODULE altera_up_avalon_video_clipper
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property HIDE_FROM_QUARTUS true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate
set_module_property GENERATION_CALLBACK generate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
#add_file altera_up_avalon_video_clipper.v {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_video_clipper_add.v" {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_video_clipper_drop.v" {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_video_clipper_counters.v" {SYNTHESIS SIMULATION}

# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter width_in natural "720"
set_parameter_property width_in DISPLAY_NAME "Width (# of pixels)"
set_parameter_property width_in GROUP "Incoming Frame Resolution"
set_parameter_property width_in UNITS None
set_parameter_property width_in AFFECTS_ELABORATION true
set_parameter_property width_in AFFECTS_GENERATION true
set_parameter_property width_in VISIBLE true
set_parameter_property width_in ENABLED true

add_parameter height_in natural "244"
set_parameter_property height_in DISPLAY_NAME "Height (# of lines)"
set_parameter_property height_in GROUP "Incoming Frame Resolution"
set_parameter_property height_in UNITS None
set_parameter_property height_in AFFECTS_ELABORATION true
set_parameter_property height_in AFFECTS_GENERATION true
set_parameter_property height_in VISIBLE true
set_parameter_property height_in ENABLED true

add_parameter drop_left natural 40
set_parameter_property drop_left DISPLAY_NAME "Columns to remove from the left side"
set_parameter_property drop_left GROUP "Reduce Frame Size"
set_parameter_property drop_left UNITS None
set_parameter_property drop_left AFFECTS_ELABORATION true
set_parameter_property drop_left AFFECTS_GENERATION true
set_parameter_property drop_left VISIBLE true
set_parameter_property drop_left ENABLED true

add_parameter drop_right natural 40
set_parameter_property drop_right DISPLAY_NAME "Columns to remove from the right side"
set_parameter_property drop_right GROUP "Reduce Frame Size"
set_parameter_property drop_right UNITS None
set_parameter_property drop_right AFFECTS_ELABORATION true
set_parameter_property drop_right AFFECTS_GENERATION true
set_parameter_property drop_right VISIBLE true
set_parameter_property drop_right ENABLED true

add_parameter drop_top natural 2
set_parameter_property drop_top DISPLAY_NAME "Rows to remove from the top"
set_parameter_property drop_top GROUP "Reduce Frame Size"
set_parameter_property drop_top UNITS None
set_parameter_property drop_top AFFECTS_ELABORATION true
set_parameter_property drop_top AFFECTS_GENERATION true
set_parameter_property drop_top VISIBLE true
set_parameter_property drop_top ENABLED true

add_parameter drop_bottom natural 2
set_parameter_property drop_bottom DISPLAY_NAME "Rows to remove from the bottom"
set_parameter_property drop_bottom GROUP "Reduce Frame Size"
set_parameter_property drop_bottom UNITS None
set_parameter_property drop_bottom AFFECTS_ELABORATION true
set_parameter_property drop_bottom AFFECTS_GENERATION true
set_parameter_property drop_bottom VISIBLE true
set_parameter_property drop_bottom ENABLED true

add_parameter add_left natural 0
set_parameter_property add_left DISPLAY_NAME "Columns to add to the left side"
set_parameter_property add_left GROUP "Enlarge Frame Size"
set_parameter_property add_left UNITS None
set_parameter_property add_left AFFECTS_ELABORATION true
set_parameter_property add_left AFFECTS_GENERATION true
set_parameter_property add_left VISIBLE true
set_parameter_property add_left ENABLED true

add_parameter add_right natural 0
set_parameter_property add_right DISPLAY_NAME "Columns to add to the right side"
set_parameter_property add_right GROUP "Enlarge Frame Size"
set_parameter_property add_right UNITS None
set_parameter_property add_right AFFECTS_ELABORATION true
set_parameter_property add_right AFFECTS_GENERATION true
set_parameter_property add_right VISIBLE true
set_parameter_property add_right ENABLED true

add_parameter add_top natural 0
set_parameter_property add_top DISPLAY_NAME "Rows to add to the top"
set_parameter_property add_top GROUP "Enlarge Frame Size"
set_parameter_property add_top UNITS None
set_parameter_property add_top AFFECTS_ELABORATION true
set_parameter_property add_top AFFECTS_GENERATION true
set_parameter_property add_top VISIBLE true
set_parameter_property add_top ENABLED true

add_parameter add_bottom natural 0
set_parameter_property add_bottom DISPLAY_NAME "Rows to add to the bottom"
set_parameter_property add_bottom GROUP "Enlarge Frame Size"
set_parameter_property add_bottom UNITS None
set_parameter_property add_bottom AFFECTS_ELABORATION true
set_parameter_property add_bottom AFFECTS_GENERATION true
set_parameter_property add_bottom VISIBLE true
set_parameter_property add_bottom ENABLED true

#add_parameter add_data integer 0
#set_parameter_property add_data DISPLAY_NAME "Color for added pixels (hex)"
#set_parameter_property add_data GROUP "Enlarge Frame Size"
#set_parameter_property add_data UNITS None
#set_parameter_property add_data AFFECTS_ELABORATION true
#set_parameter_property add_data AFFECTS_GENERATION true
#set_parameter_property add_data DERIVED true
#set_parameter_property add_data VISIBLE true
#set_parameter_property add_data ENABLED true

add_parameter add_value_plane_1 integer 0
set_parameter_property add_value_plane_1 DISPLAY_NAME "Added pixel value for plane 1"
set_parameter_property add_value_plane_1 DISPLAY_HINT hexadecimal
set_parameter_property add_value_plane_1 GROUP "Enlarge Frame Size"
set_parameter_property add_value_plane_1 UNITS None
set_parameter_property add_value_plane_1 AFFECTS_ELABORATION true
set_parameter_property add_value_plane_1 AFFECTS_GENERATION true
set_parameter_property add_value_plane_1 VISIBLE true
set_parameter_property add_value_plane_1 ENABLED true

add_parameter add_value_plane_2 integer 0
set_parameter_property add_value_plane_2 DISPLAY_NAME "Added pixel value for plane 2"
set_parameter_property add_value_plane_2 DISPLAY_HINT hexadecimal
set_parameter_property add_value_plane_2 GROUP "Enlarge Frame Size"
set_parameter_property add_value_plane_2 UNITS None
set_parameter_property add_value_plane_2 AFFECTS_ELABORATION true
set_parameter_property add_value_plane_2 AFFECTS_GENERATION true
set_parameter_property add_value_plane_2 VISIBLE true
set_parameter_property add_value_plane_2 ENABLED true

add_parameter add_value_plane_3 integer 0
set_parameter_property add_value_plane_3 DISPLAY_NAME "Added pixel value for plane 3"
set_parameter_property add_value_plane_3 DISPLAY_HINT hexadecimal
set_parameter_property add_value_plane_3 GROUP "Enlarge Frame Size"
set_parameter_property add_value_plane_3 UNITS None
set_parameter_property add_value_plane_3 AFFECTS_ELABORATION true
set_parameter_property add_value_plane_3 AFFECTS_GENERATION true
set_parameter_property add_value_plane_3 VISIBLE true
set_parameter_property add_value_plane_3 ENABLED true

add_parameter add_value_plane_4 integer 0
set_parameter_property add_value_plane_4 DISPLAY_NAME "Added pixel value for plane 4"
set_parameter_property add_value_plane_4 DISPLAY_HINT hexadecimal
set_parameter_property add_value_plane_4 GROUP "Enlarge Frame Size"
set_parameter_property add_value_plane_4 UNITS None
set_parameter_property add_value_plane_4 AFFECTS_ELABORATION true
set_parameter_property add_value_plane_4 AFFECTS_GENERATION true
set_parameter_property add_value_plane_4 VISIBLE true
set_parameter_property add_value_plane_4 ENABLED false

add_parameter color_bits positive 8
set_parameter_property color_bits DISPLAY_NAME "Color Bits"
set_parameter_property color_bits GROUP "Pixel Format"
set_parameter_property color_bits UNITS None
set_parameter_property color_bits AFFECTS_ELABORATION true
set_parameter_property color_bits AFFECTS_GENERATION true
set_parameter_property color_bits VISIBLE true
set_parameter_property color_bits ENABLED true

add_parameter color_planes integer 3
set_parameter_property color_planes DISPLAY_NAME "Color Planes"
set_parameter_property color_planes GROUP "Pixel Format"
set_parameter_property color_planes UNITS None
set_parameter_property color_planes AFFECTS_ELABORATION true
set_parameter_property color_planes AFFECTS_GENERATION true
set_parameter_property color_planes ALLOWED_RANGES {1 2 3 4}
set_parameter_property color_planes VISIBLE true
set_parameter_property color_planes ENABLED true
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk enabled true

add_interface_port clk clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point reset
# | 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset enabled true
set_interface_property reset synchronousEdges DEASSERT

add_interface_port reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | Validation function
# | 
proc validate {} {
	set width_in 			[ get_parameter_value "width_in" ]
	set height_in 			[ get_parameter_value "height_in" ]
	set drop_left 			[ get_parameter_value "drop_left" ]
	set drop_right 			[ get_parameter_value "drop_right" ]
	set drop_top 			[ get_parameter_value "drop_top" ]
	set drop_bottom 		[ get_parameter_value "drop_bottom" ]
	set add_left 			[ get_parameter_value "add_left" ]
	set add_right	 		[ get_parameter_value "add_right" ]
	set add_top 			[ get_parameter_value "add_top" ]
	set add_bottom 			[ get_parameter_value "add_bottom" ]
	set add_value_plane_1 	[ get_parameter_value "add_value_plane_1" ]
	set add_value_plane_2 	[ get_parameter_value "add_value_plane_2" ]
	set add_value_plane_3 	[ get_parameter_value "add_value_plane_3" ]
	set add_value_plane_4 	[ get_parameter_value "add_value_plane_4" ]
	set color_bits 			[ get_parameter_value "color_bits" ]
	set color_planes 		[ get_parameter_value "color_planes" ]

	set width_out	[ expr ($width_in - $drop_left - $drop_right + $add_left + $add_right) ]
	set height_out	[ expr ($height_in - $drop_top - $drop_bottom + $add_top + $add_bottom) ]
	if { (($width_in ==  0) || ($height_in == 0)) } {
		set width_out	$add_left
		set height_out	$add_top

		send_message info "Output Resolution: $width_out x $height_out"
	} else {
		send_message info "Change in Resolution: $width_in x $height_in -> $width_out x $height_out"
	}	

	if { ($width_in <= $drop_left + $drop_right) & ($width_in > 0) } {
		send_message error "Width In must be greater than left side reduction + right side reduction"
	}
	if { ($height_in <= $drop_top + $drop_bottom) & ($height_in > 0) } {
		send_message error "Height In must be greater than top reduction + bottom reduction"
	}
#	if { (($width_in ==  0) || ($height_in == 0)) } {
#		if { !($add_right == 0) } {
#			send_message error "Add right must be zero when creating a new frame!1"
#		}
#		if { !($add_bottom == 0) } {
#			send_message error "Height In > Top clipping + Bottom clipping"
#		}
#	}

	set_parameter_property drop_left ENABLED false
	set_parameter_property drop_right ENABLED false
	set_parameter_property drop_top ENABLED false
	set_parameter_property drop_bottom ENABLED false
	set_parameter_property add_right ENABLED false
	set_parameter_property add_bottom ENABLED false

	if { (($width_in >  0) && ($height_in > 0)) } {
		set_parameter_property drop_left ENABLED true
		set_parameter_property drop_right ENABLED true
		set_parameter_property drop_top ENABLED true
		set_parameter_property drop_bottom ENABLED true
		set_parameter_property add_right ENABLED true
		set_parameter_property add_bottom ENABLED true
	}

	set_parameter_property add_value_plane_2 ENABLED false
	set_parameter_property add_value_plane_3 ENABLED false
	set_parameter_property add_value_plane_4 ENABLED false
	if { $color_planes >  1 } {
		set_parameter_property add_value_plane_2 ENABLED true
		if { $color_planes >  2 } {
			set_parameter_property add_value_plane_3 ENABLED true
			if { $color_planes >  3 } {
				set_parameter_property add_value_plane_4 ENABLED true
			}
		}
	}

#	if { $add_value_plane_1 < 0 } {
#		set_parameter_value add_value_plane_1 0
#	} elseif { $add_value_plane_1 > [ expr (pow(2, $color_bits)) - 1 ] } {
#		set_parameter_value add_value_plane_1 [ expr (pow(2, $color_bits)) - 1 ]
#	}
#	if { $color_planes >  1 } {
#		if { $add_value_plane_2 < 0 } {
#			set_parameter_value add_value_plane_2 0
#		} elseif { $add_value_plane_2 > [ expr (pow(2, $color_bits)) - 1 ] } {
#			set_parameter_value add_value_plane_2 [ expr (pow(2, $color_bits)) - 1 ]
#		}
#		if { $color_planes >  2 } {
#			if { $add_value_plane_3 < 0 } {
#				set_parameter_value add_value_plane_3 0
#			} elseif { $add_value_plane_3 > [ expr (pow(2, $color_bits)) - 1 ] } {
#				set_parameter_value add_value_plane_3 [ expr (pow(2, $color_bits)) - 1 ]
#			}
#			if { $color_planes >  3 } {
#				if { $add_value_plane_4 < 0 } {
#					set_parameter_value add_value_plane_4 0
#				} elseif { $add_value_plane_4 > [ expr (pow(2, $color_bits)) - 1 ] } {
#					set_parameter_value add_value_plane_4 [ expr (pow(2, $color_bits)) - 1 ]
#				}
#			}
#		}
#	}
	set max_value [ expr (pow(2, $color_bits)) - 1 ]
	if { ($add_value_plane_1 < 0) || ($add_value_plane_1 > $max_value) } {
		send_message error [ format "The value for plane 1 must be in between 0 and %.0f" $max_value ]
	}
	if { $color_planes >  1 } {
		if { ($add_value_plane_2 < 0) || ($add_value_plane_2 > $max_value) } {
			send_message error [ format "The value for plane 2 must be in between 0 and %.0f" $max_value ]
		}
		if { $color_planes >  2 } {
			if { ($add_value_plane_3 < 0) || ($add_value_plane_3 > $max_value) } {
				send_message error [ format "The value for plane 3 must be in between 0 and %.0f" $max_value ]
			}
			if { $color_planes >  3 } {
				if { ($add_value_plane_4 < 0) || ($add_value_plane_4 > $max_value) } {
					send_message error [ format "The value for plane 4 must be in between 0 and %.0f" $max_value ]
				}
			}
		}
	}
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration function
# | 
proc elaborate {} {
	set width_in 			[ get_parameter_value "width_in" ]
	set height_in 			[ get_parameter_value "height_in" ]
	set drop_left 			[ get_parameter_value "drop_left" ]
	set drop_right 			[ get_parameter_value "drop_right" ]
	set drop_top 			[ get_parameter_value "drop_top" ]
	set drop_bottom 		[ get_parameter_value "drop_bottom" ]
	set add_left 			[ get_parameter_value "add_left" ]
	set add_right	 		[ get_parameter_value "add_right" ]
	set add_top 			[ get_parameter_value "add_top" ]
	set add_bottom 			[ get_parameter_value "add_bottom" ]
	set add_value_plane_1 	[ get_parameter_value "add_value_plane_1" ]
	set add_value_plane_2 	[ get_parameter_value "add_value_plane_2" ]
	set add_value_plane_3 	[ get_parameter_value "add_value_plane_3" ]
	set add_value_plane_4 	[ get_parameter_value "add_value_plane_4" ]
	set color_bits 			[ get_parameter_value "color_bits" ]
	set color_planes 		[ get_parameter_value "color_planes" ]

	set dw [ expr $color_bits * $color_planes ]

	if { ($color_planes == 4) || ($color_planes == 3) } {
		set ew 2
	} else {
		set ew 1
	}

	if { ($width_in > 0) && ($height_in > 0)} {
		# +-----------------------------------
		# | connection point avalon_clipper_sink
		# | 
		add_interface avalon_clipper_sink avalon_streaming end 
		set_interface_property avalon_clipper_sink associatedClock clk
		set_interface_property avalon_clipper_sink associatedReset reset
		set_interface_property avalon_clipper_sink dataBitsPerSymbol $color_bits
		set_interface_property avalon_clipper_sink errorDescriptor ""
		set_interface_property avalon_clipper_sink maxChannel 0
		set_interface_property avalon_clipper_sink readyLatency 0
		set_interface_property avalon_clipper_sink symbolsPerBeat $color_planes

		add_interface_port avalon_clipper_sink stream_in_data data Input $dw
		add_interface_port avalon_clipper_sink stream_in_startofpacket startofpacket Input 1
		add_interface_port avalon_clipper_sink stream_in_endofpacket endofpacket Input 1
#		add_interface_port avalon_clipper_sink stream_in_empty empty Input $ew
		add_interface_port avalon_clipper_sink stream_in_valid valid Input 1
		add_interface_port avalon_clipper_sink stream_in_ready ready Output 1
		# | 
		# +-----------------------------------
	}

	# +-----------------------------------
	# | connection point avalon_clipper_source
	# | 
	add_interface avalon_clipper_source avalon_streaming start 
	set_interface_property avalon_clipper_source associatedClock clk
	set_interface_property avalon_clipper_source associatedReset reset
	set_interface_property avalon_clipper_source dataBitsPerSymbol $color_bits
	set_interface_property avalon_clipper_source errorDescriptor ""
	set_interface_property avalon_clipper_source maxChannel 0
	set_interface_property avalon_clipper_source readyLatency 0
	set_interface_property avalon_clipper_source symbolsPerBeat $color_planes

	add_interface_port avalon_clipper_source stream_out_ready ready Input 1
	add_interface_port avalon_clipper_source stream_out_data data Output $dw
	add_interface_port avalon_clipper_source stream_out_startofpacket startofpacket Output 1
	add_interface_port avalon_clipper_source stream_out_endofpacket endofpacket Output 1
#	add_interface_port avalon_clipper_source stream_out_empty empty Output $ew
	add_interface_port avalon_clipper_source stream_out_valid valid Output 1
	# | 
	# +-----------------------------------
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Generation function
# | 
proc generate {} {
	send_message info "Starting generation of the video clipper"

	# get parameter values
	set width_in 			[ get_parameter_value "width_in" ]
	set height_in 			[ get_parameter_value "height_in" ]
	set drop_left 			[ get_parameter_value "drop_left" ]
	set drop_right 			[ get_parameter_value "drop_right" ]
	set drop_top 			[ get_parameter_value "drop_top" ]
	set drop_bottom 		[ get_parameter_value "drop_bottom" ]
	set add_left 			[ get_parameter_value "add_left" ]
	set add_right	 		[ get_parameter_value "add_right" ]
	set add_top 			[ get_parameter_value "add_top" ]
	set add_bottom 			[ get_parameter_value "add_bottom" ]
	set add_value_plane_1 	[ get_parameter_value "add_value_plane_1" ]
	set add_value_plane_2 	[ get_parameter_value "add_value_plane_2" ]
	set add_value_plane_3 	[ get_parameter_value "add_value_plane_3" ]
	set add_value_plane_4 	[ get_parameter_value "add_value_plane_4" ]
	set color_bits 			[ get_parameter_value "color_bits" ]
	set color_planes 		[ get_parameter_value "color_planes" ]

	set width_out	[ expr ($width_in - $drop_left - $drop_right + $add_left + $add_right) ]
	set height_out	[ expr ($height_in - $drop_top - $drop_bottom + $add_top + $add_bottom) ]
	if { (($width_in ==  0) || ($height_in == 0)) } {
		set width_out	$add_left
		set height_out	$add_top
	}

	set dw	[ format "DW:%d" [ expr (($color_bits * $color_planes) - 1) ] ]
	if { ($color_planes == 4) || ($color_planes == 3) } {
		set ew "EW:1"
	} else {
		set ew "EW:0"
	}

	set width_in_p		"WIDTH_IN:$width_in"
	set height_in_p		"HEIGHT_IN:$height_in"
	set ww_in			[ format "WW_IN:%.0f" [ expr ceil ((log ($width_in) / (log (2))) - 1.0) ] ]
	set hw_in			[ format "HW_IN:%.0f" [ expr ceil ((log ($height_in) / (log (2))) - 1.0) ] ]

	set drop_left_p		"DROP_PIXELS_AT_START:$drop_left"
	set drop_right_p	"DROP_PIXELS_AT_END:$drop_right"
	set drop_top_p		"DROP_LINES_AT_START:$drop_top"
	set drop_bottom_p	"DROP_LINES_AT_END:$drop_bottom"

	set width_out_p		"WIDTH_OUT:$width_out"
	set height_out_p	"HEIGHT_OUT:$height_out"
	set ww_out			[ format "WW_OUT:%.0f" [ expr ceil ((log ($width_out) / (log (2))) - 1.0) ] ]
	set hw_out			[ format "HW_OUT:%.0f" [ expr ceil ((log ($height_out) / (log (2))) - 1.0) ] ]
	
	set add_left_p		"ADD_PIXELS_AT_START:$add_left"
	set add_right_p		"ADD_PIXELS_AT_END:$add_right"
	set add_top_p		"ADD_LINES_AT_START:$add_top"
	set add_bottom_p	"ADD_LINES_AT_END:$add_bottom"
	if { (($width_in ==  0) || ($height_in == 0)) } {
		set add_right_p		"ADD_PIXELS_AT_END:0"
		set add_bottom_p	"ADD_LINES_AT_END:0"
	}

	set add_data $add_value_plane_1
	if { $color_planes >  1 } {
		set add_data [ expr floor(($add_value_plane_2 * pow(2, $color_bits)) + $add_data) ]
		if { $color_planes >  2 } {
			set add_data [ expr floor(($add_value_plane_3 * pow(2, 2 * $color_bits)) + $add_data) ]
			if { $color_planes >  3 } {
				set add_data [ expr floor(($add_value_plane_4 * pow(2, 3 * $color_bits)) + $add_data) ]
			}
		}
	}
	set add_data_p		[ format "ADD_DATA:%d'd%.0f" [ expr ($color_bits * $color_planes) ] $add_data ]

	# set section values
	set use_clipper_drop "USE_CLIPPER_DROP:1"
	if { (($width_in ==  0) || ($height_in == 0)) } {
		set use_clipper_drop "USE_CLIPPER_DROP:0"
	}

	# set arguments
	set params "$dw;$ew;$width_in_p;$height_in_p;$ww_in;$hw_in;$drop_left_p;$drop_right_p;$drop_top_p;$drop_bottom_p;$width_out_p;$height_out_p;$ww_out;$hw_out;$add_left_p;$add_right_p;$add_top_p;$add_bottom_p;$add_data_p"
	set sections "$use_clipper_drop" 

	# get generation settings
#	set dest_language	[ get_generation_property HDL_LANGUAGE ]
	set dest_dir 		[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name		[ get_generation_property OUTPUT_NAME ]
	
	add_file "$dest_dir$dest_name.v" {SYNTHESIS SIMULATION}
	# add_file "$dest_dir/altera_up_video_clipper_add.v" SYNTHESIS
	# add_file "$dest_dir/altera_up_video_clipper_drop.v" SYNTHESIS
	# add_file "$dest_dir/altera_up_video_clipper_counters.v" SYNTHESIS

	# Generate HDL
	alt_up_generate "$dest_dir$dest_name.v" "hdl/altera_up_avalon_video_clipper.v" "altera_up_avalon_video_clipper" $dest_name $params $sections
	# file copy -force "hdl/altera_up_video_clipper_add.v" $dest_dir
	# file copy -force "hdl/altera_up_video_clipper_drop.v" $dest_dir
	# file copy -force "hdl/altera_up_video_clipper_counters.v" $dest_dir
}
# | 
# +-----------------------------------

