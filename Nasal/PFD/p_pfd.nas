#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_pfd
# Description: PFD page
#      Author: Thorsten Renk, 2015
#---------------------------------------




var pfd_segment_draw = func (data, plot) {

	if (size(data) < 2) {return;}

	plot.moveTo(data[0][0],data[0][1]); 

        for (var i = 0; i< (size(data)-1); i=i+1)
        {
            var set = data[i+1];
	    if (set[2] == 1)
            	{plot.lineTo(set[0], set[1]);}
	    else
		{plot.moveTo(set[0], set[1]);}	
        }


}

var place_compass_label = func (group, text, angle, radius, flag, xoffset, yoffset) {

	var placement = SpaceShuttle.compass_label_pos(radius, angle);

	var canvas_text = group.createChild("text")
      	.setText(text)
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(angle * math.pi/180.0 * flag)
	.setTranslation(placement[0] + xoffset,-placement[1] + yoffset);


}

var write_sphere_label = func (group, text, angle, coords) {


if (coords[2] ==1)
	{

	var canvas_text = group.createChild("text")
      	.setText(text)
        .setColor(1,1,1)
	.setColorFill(0.2,0.2,0.2)
	.setFontSize(12)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(angle + coords[3] * 0.8 * math.pi/2.0)
	.setTranslation(coords[0], coords[1]);

	canvas_text.setDrawMode(canvas_text.FILLEDBOUNDINGBOX + canvas_text.TEXT);
	}

}

var write_tape_label = func (group, text, coords, color) {


if (coords[2] ==1)
	{
	var canvas_text = group.createChild("text")
      	.setText(text)
        .setColor(color[0],color[1],color[2])
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(coords[0], coords[1]);
	}

}

var write_tape_label_bg = func (group, text, coords, color, bg_color) {


if (coords[2] ==1)
	{
	var canvas_text = group.createChild("text")
      	.setText(text)
        .setColor(color[0],color[1],color[2])
        .setColorFill(bg_color[0],bg_color[1],bg_color[2])
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(coords[0], coords[1]);

	canvas_text.setDrawMode(canvas_text.FILLEDBOUNDINGBOX + canvas_text.TEXT);
	}

}


var PFD_addpage_p_pfd = func(device)
{
    var p_pfd = device.addPage("PFD", "p_pfd");
    
    #
    #
    # device page update
    p_pfd.group = device.svg.getElementById("p_pfd");
    p_pfd.group.setColor(1, 1, 1);

    p_pfd.keas = device.svg.getElementById("p_pfd_keas");
    p_pfd.beta = device.svg.getElementById("p_pfd_beta");

    p_pfd.r = device.svg.getElementById("p_pfd_r");
    p_pfd.p = device.svg.getElementById("p_pfd_p");
    p_pfd.y = device.svg.getElementById("p_pfd_y");
    
    p_pfd.dap = device.svg.getElementById("p_pfd_dap");
    p_pfd.throt = device.svg.getElementById("p_pfd_throt");


    p_pfd.ondisplay = func
    {
        device.set_DPS_off();
        device.dps_page_flag = 0;
        device.MEDS_menu_title.setText("FLIGHT INSTRUMENT MENU");

	# draw the fixed elements

	# ADI ################################################

	# upper compass rose

	var plot_compass_upper = device.symbols.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);

	var data = SpaceShuttle.draw_compass_scale(71.25,12, 1.1, 6, 1.05);
	pfd_segment_draw(data, plot_compass_upper);

	data = SpaceShuttle.draw_circle(71.25, 30);
	pfd_segment_draw(data, plot_compass_upper);

	data = SpaceShuttle.draw_circle(95.0, 30);
	pfd_segment_draw(data, plot_compass_upper);

	plot_compass_upper.setTranslation (255, 175);

	place_compass_label(device.symbols, "0", 0.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "33", 30.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "30", 60.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "27", 90.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "24", 120.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "21", 150.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "18", 180.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "15", 210.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "12", 240.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "9", 270.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "6", 300.0, 85.0, 0,255,180);
	place_compass_label(device.symbols, "3", 330.0, 85.0, 0,255,180);

	# nose position indicator

	data = [[0.0, -26.0, 0], [0.0, -26.0, 1], [0.0, 26.0,1], [-28.0,0.0,0],[-23.0,0.0,1],[23.0,0.0,0],[28.0,0.0,1], [-10,0,0], [-8.6, 5.0, 1], [-5.0, 8.6, 1], [0.0,10.0,1],[5.0,8.6,1],[8.6,5.0,1],[10.0,0.0,1]];
	var plot_cross_thick = device.symbols.createChild("path", "cross_thick")
        .setStrokeLineWidth(2)
        .setColor(0.4, 0.9, 0.7);
	pfd_segment_draw(data, plot_cross_thick);
	plot_cross_thick.setTranslation (255, 175);

	data = [[-23.0, 0.0, 0], [-23.0, 0.0, 1], [23.0,0.0,1]];
	var plot_cross_thin = device.symbols.createChild("path", "cross_thin")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7);
	pfd_segment_draw(data, plot_cross_thin);
	plot_cross_thin.setTranslation (255, 175);


	# ADI error needles

	var adi_errors = device.symbols.createChild("group");

	var plot_error_arcs = adi_errors.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(0.9, 0.1, 0.85);
	data = SpaceShuttle.draw_arc (92, 10, 335, 385);
	pfd_segment_draw(data, plot_error_arcs);

	data = SpaceShuttle.draw_arc (92, 10, 65, 115);
	pfd_segment_draw(data, plot_error_arcs);

	data = SpaceShuttle.draw_arc (92, 10, 155, 205);
	pfd_segment_draw(data, plot_error_arcs);

	p_pfd.att_error_needles = adi_errors.createChild("group");

	p_pfd.att_error_pitch = p_pfd.att_error_needles.createChild("path")
        .setStrokeLineWidth(3)
        .setColor(0.9, 0.1, 0.85);

	data = [[28.0, 0.0, 0], [95.0,0.0, 1]];
	pfd_segment_draw(data, p_pfd.att_error_pitch);

	p_pfd.att_error_yaw = p_pfd.att_error_needles.createChild("path")
        .setStrokeLineWidth(3)
        .setColor(0.9, 0.1, 0.85);

	data = [[0.0, 28, 0], [0.0,95.0, 1]];
	pfd_segment_draw(data, p_pfd.att_error_yaw);
	
	p_pfd.att_error_roll = p_pfd.att_error_needles.createChild("path")
        .setStrokeLineWidth(3)
        .setColor(0.9, 0.1, 0.85);

	data = [[0.0, -28, 0], [0.0,-95.0, 1]];
	pfd_segment_draw(data, p_pfd.att_error_roll);
	

	#p_pfd.att_error_needles.setTranslation (255, 175);

	
	 adi_errors.setTranslation (255, 175);

	# ADI rate indicators ################################################

	# ADI rate ladders

	data = SpaceShuttle.draw_ladder (130, 3, 0.07, 4, 0.04, 0, 0 , 1);
	var plot_ADI_rate_roll = device.symbols.createChild("path", "ADI_rate_roll")
        .setStrokeLineWidth(1)
        .setColor(1, 1, 1);
	pfd_segment_draw(data, plot_ADI_rate_roll);
	plot_ADI_rate_roll.setTranslation(255, 70);

	data = SpaceShuttle.draw_ladder (130, 3, 0.07, 4, 0.04, 0, 1, 1);
	var plot_ADI_rate_yaw = device.symbols.createChild("path", "ADI_rate_yaw")
        .setStrokeLineWidth(1)
        .setColor(1, 1, 1);
	pfd_segment_draw(data, plot_ADI_rate_yaw);
	plot_ADI_rate_yaw.setTranslation(255, 280);

	data = SpaceShuttle.draw_ladder (130, 3, 0.07, 4, 0.04, 1, 1, 1);
	var plot_ADI_rate_pitch = device.symbols.createChild("path", "ADI_rate_pitch")
        .setStrokeLineWidth(1)
        .setColor(1, 1, 1);
	pfd_segment_draw(data, plot_ADI_rate_pitch);
	plot_ADI_rate_pitch.setTranslation(360, 175);

	# ADI rate needles

	data = SpaceShuttle.draw_tmarker_down();
	p_pfd.adi_roll_rate_needle = device.symbols.createChild("path", "ADI_roll_rate_needle")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7)
	.setColorFill(0.4, 0.9, 0.7)
	.moveTo(data[0][0], data[0][1]);
	for (var i = 0; (i< size(data)-1); i=i+1) 
		{p_pfd.adi_roll_rate_needle.lineTo(data[i+1][0], data[i+1][1]);}

	data = SpaceShuttle.draw_tmarker_left();
	p_pfd.adi_pitch_rate_needle = device.symbols.createChild("path", "ADI_pitch_rate_needle")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7)
	.setColorFill(0.4, 0.9, 0.7)
	.moveTo(data[0][0], data[0][1]);
	for (var i = 0; (i< size(data)-1); i=i+1) 
		{p_pfd.adi_pitch_rate_needle.lineTo(data[i+1][0], data[i+1][1]);}

	data = SpaceShuttle.draw_tmarker_up();
	p_pfd.adi_yaw_rate_needle = device.symbols.createChild("path", "ADI_yaw_rate_needle")
        .setStrokeLineWidth(1)
        .setColor(0.4, 0.9, 0.7)
	.setColorFill(0.4, 0.9, 0.7)
	.moveTo(data[0][0], data[0][1]);
	for (var i = 0; (i< size(data)-1); i=i+1) 
		{p_pfd.adi_yaw_rate_needle.lineTo(data[i+1][0], data[i+1][1]);}
	

	# HSI ################################################

	# common clipping for all elements

	device.HSI.set("clip", "rect(0px, 512px, 460px, 0px)");

	var HSI_static_group = device.HSI.createChild("group");
	p_pfd.HSI_dynamic_group = device.HSI.createChild("group");

	# lower HSI compass rose


	var plot_compass_lower = HSI_static_group.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(95.0, 30);
	pfd_segment_draw(data, plot_compass_lower);

	data = SpaceShuttle.draw_compass_scale(95.0,8, 1.05, 1, 1.0);
	pfd_segment_draw(data, plot_compass_lower);


	# inner lower HSI compass rose 


	var plot_inner_compass_lower = p_pfd.HSI_dynamic_group.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.5, 0.5, 0.5)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(84.0, 30);
	pfd_segment_draw(data, plot_inner_compass_lower);

	data = SpaceShuttle.draw_compass_scale(84,36, 0.9, 2, 0.95);
	pfd_segment_draw(data, plot_inner_compass_lower);

	data = SpaceShuttle.draw_circle(58.0, 30);
	pfd_segment_draw(data, plot_inner_compass_lower);

	place_compass_label(p_pfd.HSI_dynamic_group, "N", 0.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "E", 90.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "S", 180.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "W", 270.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "3", 30.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "6", 60.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "12", 120.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "15", 150.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "21", 210.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "24", 240.0, 63.0, 1,0,0);    
	place_compass_label(p_pfd.HSI_dynamic_group, "30", 300.0, 63.0, 1,0,0);
	place_compass_label(p_pfd.HSI_dynamic_group, "33", 330.0, 63.0, 1,0,0);

	# HSI bearing pointers 
	
	# earth-relative

	p_pfd.bearing_earth_relative = p_pfd.HSI_dynamic_group.createChild("group");

	var bearing_earthrel_symbol = p_pfd.bearing_earth_relative.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1,0.3,0.15)	
	.setTranslation(0.0,-108.0)
        .setColor(0,0,0);

	data = SpaceShuttle.draw_bearing_pointer_up();
	pfd_segment_draw(data, bearing_earthrel_symbol);

	var bearing_earthrel_label = p_pfd.bearing_earth_relative.createChild("text")
      	.setText("E")
        .setColor(0,0,0)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(0.0, -95.0);



	# inertial

	p_pfd.bearing_inertial = p_pfd.HSI_dynamic_group.createChild("group");

	var bearing_inertial_symbol = p_pfd.bearing_inertial.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1,1,1)	
	.setTranslation(0.0,-98.0)
        .setColor(0,0,0);

	data = SpaceShuttle.draw_bearing_pointer_up();
	pfd_segment_draw(data, bearing_inertial_symbol);

	var bearing_inertial_label = p_pfd.bearing_inertial.createChild("text")
      	.setText("I")
        .setColor(0,0,0)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(0.0, -85.0);

	p_pfd.bearing_inertial.setRotation(45.0 * math.pi/180.0);

	# HAC WP 1

	p_pfd.bearing_HAC_H = p_pfd.HSI_dynamic_group.createChild("group");

	var bearing_HAC_H_symbol = p_pfd.bearing_HAC_H.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1,1,1)	
	.setTranslation(0.0,-101.0)
        .setColor(0,0,0);

	data = SpaceShuttle.draw_runway_pointer_up();
	pfd_segment_draw(data, bearing_HAC_H_symbol);

	var bearing_HAC_H_label = p_pfd.bearing_HAC_H.createChild("text")
      	.setText("H")
        .setColor(0,0,0)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(0.0, -88.0);

	#p_pfd.bearing_HAC_H.setRotation(90.0 * math.pi/180.0);

	# HAC center

	p_pfd.bearing_HAC_C = p_pfd.HSI_dynamic_group.createChild("group");

	var bearing_HAC_C_symbol = p_pfd.bearing_HAC_C.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1,1,1)	
	.setTranslation(0.0,-98.0)
        .setColor(0,0,0);

	data = SpaceShuttle.draw_runway_pointer_up();
	pfd_segment_draw(data, bearing_HAC_C_symbol);

	var bearing_HAC_C_label = p_pfd.bearing_HAC_C.createChild("text")
      	.setText("C")
        .setColor(0,0,0)
	.setFontSize(10)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setRotation(0.0)
	.setTranslation(0.0, -85.0);

	#p_pfd.bearing_HAC_C.setRotation(120.0 * math.pi/180.0);

	# HSI course arrow 

	p_pfd.course_arrow = p_pfd.HSI_dynamic_group.createChild("group");

	var course_arrow_symbol = p_pfd.course_arrow.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.9, 0.1, 0.85)
	.setTranslation(0.0,-80.0)
        .setColor(0,0,0);

	data = SpaceShuttle.draw_course_arrow();
	pfd_segment_draw(data, course_arrow_symbol);


	# CDI

	p_pfd.cdi = p_pfd.HSI_dynamic_group.createChild("group");

	#var cdi_center = p_pfd.cdi.createChild("path")
	var cdi_center = HSI_static_group.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(0.0, -20.0)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_cdi_center();
	pfd_segment_draw(data, cdi_center);

	var cdi_dot1 = p_pfd.cdi.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(20.0,0)
        .setColor(1,1,1);

	data = SpaceShuttle.draw_circle(4, 10);
	pfd_segment_draw(data, cdi_dot1);

	var cdi_dot2 = p_pfd.cdi.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(40.0,0)
        .setColor(1,1,1);
	pfd_segment_draw(data, cdi_dot2);

	var cdi_dot3 = p_pfd.cdi.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(-20.0,0)
        .setColor(1,1,1);
	pfd_segment_draw(data, cdi_dot3);

	var cdi_dot4 = p_pfd.cdi.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(-40.0,0)
        .setColor(1,1,1);
	pfd_segment_draw(data, cdi_dot4);

	# CDI needle
	
	p_pfd.cdi_needle = p_pfd.cdi.createChild("path")
	.setStrokeLineWidth(3)
        .setColor(0.9, 0.1, 0.85);

	data = [[0.0,-35.0,0],[0.0, 35.0, 1]];
	pfd_segment_draw(data, p_pfd.cdi_needle);



	# KEAS tape ################################################

	# common clipping for tape group

	device.tapes.set("clip", "rect(105px, 512px, 295px, 0px)");

	var keas_group = device.tapes.createChild("group");

	# frame
	var plot_keas_tape = keas_group.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	data= SpaceShuttle.draw_rect(45, 190);
	pfd_segment_draw(data, plot_keas_tape);
	plot_keas_tape.setTranslation (70, 200);

	# inner tape

	p_pfd.keas_tape = keas_group.createChild("group");

	p_pfd.keas_tape_background = p_pfd.keas_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 10800);
	pfd_segment_draw(data1, p_pfd.keas_tape_background);

	p_pfd.keas_tape_ladder = p_pfd.keas_tape.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(0,0,0);	
	data1 = SpaceShuttle.draw_ladder(10800, 280, 0.001296, 0, 0, 1, 1, 0);
	pfd_segment_draw(data1, p_pfd.keas_tape_ladder);
	p_pfd.keas_tape_ladder.setTranslation(-10,0);

	p_pfd.keas_tape.labels = p_pfd.keas_tape.createChild("group");
	draw_mach_labels(p_pfd.keas_tape.labels);

	# display box

	p_pfd.keas_display_box = keas_group.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0, 0, 0)
        .setColor(1,1,1);
	data1= SpaceShuttle.draw_rect(48, 20);
	pfd_segment_draw(data1, p_pfd.keas_display_box);
	p_pfd.keas_display_box.setTranslation (70, 200);

	p_pfd.keas_display_text = keas_group.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(70,205)
	.setRotation(0.0);




	
	

	# alpha tape ################################################

	var alpha_group = device.tapes.createChild("group");

	# frame

	var plot_alpha_tape = alpha_group.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot_alpha_tape);
	plot_alpha_tape.setTranslation (120, 200);

	# inner tape

	p_pfd.alpha_tape = alpha_group.createChild("group");


	p_pfd.alpha_tape_background1 = p_pfd.alpha_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(0.0, -855.0)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 1710);
	pfd_segment_draw(data1, p_pfd.alpha_tape_background1);

	p_pfd.alpha_tape_background2 = p_pfd.alpha_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.5, 0.5, 0.5)
	.setTranslation(0.0, 855.0)
        .setColor(1,1,1);
	pfd_segment_draw(data1, p_pfd.alpha_tape_background2);

	p_pfd.alpha_tape_ladder_upper = p_pfd.alpha_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(10,-855.0)
        .setColor(0,0,0);	
	data1 = SpaceShuttle.draw_ladder(1710, 180, 0.5*0.01169, 0, 0, 1, 0, 0);
	pfd_segment_draw(data1, p_pfd.alpha_tape_ladder_upper);

	p_pfd.alpha_tape_ladder_lower = p_pfd.alpha_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(10,855.0)
        .setColor(1,1,1);	
	pfd_segment_draw(data1, p_pfd.alpha_tape_ladder_lower);

	p_pfd.alpha_tape.labels_upper = p_pfd.alpha_tape.createChild("group");
	draw_alpha_labels_upper(p_pfd.alpha_tape.labels_upper);

	p_pfd.alpha_tape.labels_lower = p_pfd.alpha_tape.createChild("group");
	draw_alpha_labels_lower(p_pfd.alpha_tape.labels_lower);

	# display box

	p_pfd.alpha_display_box = alpha_group.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0, 0, 0)
        .setColor(1,1,1);
	data1= [[-24, -10,0], [-24, 10, 1], [16, 10, 1], [22,0,1], [16,-10,1],[-24,-10,1], [-24,-10,1]];
	pfd_segment_draw(data1, p_pfd.alpha_display_box);
	p_pfd.alpha_display_box.setTranslation (120, 200);

	p_pfd.alpha_display_text = alpha_group.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(120,205)
	.setRotation(0.0);




	# H tape  ################################################

	var H_group = device.tapes.createChild("group");

	p_pfd.H_tape = H_group.createChild("group");

	# frame

	var plot_H_tape = H_group.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot_H_tape);
	plot_H_tape.setTranslation (400, 200);

	# inner tape

	p_pfd.H_tape_background1 = p_pfd.H_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(0.0, -750.0)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 1500.0);
	pfd_segment_draw(data1, p_pfd.H_tape_background1);

	p_pfd.H_tape_background2 = p_pfd.H_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.5, 0.5, 0.5)
	.setTranslation(0.0, 50.0)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 100.0);
	pfd_segment_draw(data1, p_pfd.H_tape_background2);

	p_pfd.H_tape_ladder_upper = p_pfd.H_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(-5,-750)
        .setColor(0,0,0);	
	data1 = SpaceShuttle.draw_ladder(1500, 100, 0.01, 0, 0, 1, 0, 0);
	pfd_segment_draw(data1, p_pfd.H_tape_ladder_upper);

	p_pfd.H_tape_ladder_lower = p_pfd.H_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(-5, 50)
        .setColor(1,1,1);	
	data1 = SpaceShuttle.draw_ladder(100, 10, 0.1, 0, 0, 1, 0, 0);
	pfd_segment_draw(data1, p_pfd.H_tape_ladder_lower);

	p_pfd.H_tape.labels_upper_miles = p_pfd.H_tape.createChild("group");
	draw_H_labels_upper_miles(p_pfd.H_tape.labels_upper_miles);

	p_pfd.H_tape.labels_lower_miles = p_pfd.H_tape.createChild("group");
	draw_H_labels_lower_miles(p_pfd.H_tape.labels_lower_miles);

	p_pfd.H_tape.labels_upper_2k = p_pfd.H_tape.createChild("group");
	draw_H_labels_upper_2k(p_pfd.H_tape.labels_upper_2k);

	p_pfd.H_tape.labels_lower_2k = p_pfd.H_tape.createChild("group");
	draw_H_labels_lower_2k(p_pfd.H_tape.labels_lower_2k);

	p_pfd.H_tape.labels_upper_30k = p_pfd.H_tape.createChild("group");
	draw_H_labels_upper_30k(p_pfd.H_tape.labels_upper_30k);

	p_pfd.H_tape.labels_lower_30k = p_pfd.H_tape.createChild("group");
	draw_H_labels_lower_30k(p_pfd.H_tape.labels_lower_30k);

	p_pfd.H_tape.labels_upper_100k = p_pfd.H_tape.createChild("group");
	draw_H_labels_upper_100k(p_pfd.H_tape.labels_upper_100k);

	p_pfd.H_tape.labels_lower_100k = p_pfd.H_tape.createChild("group");
	draw_H_labels_lower_100k(p_pfd.H_tape.labels_lower_100k);

	p_pfd.H_tape.labels_upper_400k = p_pfd.H_tape.createChild("group");
	draw_H_labels_upper_400k(p_pfd.H_tape.labels_upper_400k);

	p_pfd.H_tape.labels_lower_400k = p_pfd.H_tape.createChild("group");
	draw_H_labels_lower_400k(p_pfd.H_tape.labels_lower_400k);

	# display box

	p_pfd.H_display_box = H_group.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0, 0, 0)
        .setColor(1,1,1);
	data1= SpaceShuttle.draw_rect(48, 20);
	pfd_segment_draw(data1, p_pfd.H_display_box);
	p_pfd.H_display_box.setTranslation (400, 200);

	p_pfd.H_display_text = H_group.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(400,205)
	.setRotation(0.0);




	# Hdot tape ##############################################

	var Hdot_group = device.tapes.createChild("group");

	p_pfd.Hdot_tape = Hdot_group.createChild("group");


	var plot_Hdot_tape = Hdot_group.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	pfd_segment_draw(data, plot_Hdot_tape);
	plot_Hdot_tape.setTranslation (450, 200);


	# inner tape

	p_pfd.Hdot_tape_background1 = p_pfd.Hdot_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(1, 1, 1)
	.setTranslation(0.0, -900.0)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 1800.0);
	pfd_segment_draw(data1, p_pfd.Hdot_tape_background1);

	p_pfd.Hdot_tape_background2 = p_pfd.Hdot_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.5, 0.5, 0.5)
	.setTranslation(0.0, 900.0)
        .setColor(1,1,1);
	var data1 = SpaceShuttle.draw_rect(43, 1800.0);
	pfd_segment_draw(data1, p_pfd.Hdot_tape_background2);

	p_pfd.Hdot_tape_ladder_upper = p_pfd.Hdot_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(-5,-900)
        .setColor(0,0,0);	
	data1 = SpaceShuttle.draw_ladder(1800, 60, 0.0055, 0, 0, 1, 0, 0);
	pfd_segment_draw(data1, p_pfd.Hdot_tape_ladder_upper);

	p_pfd.Hdot_tape_ladder_lower = p_pfd.Hdot_tape.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(-5, 900)
        .setColor(1,1,1);	
	data1 = SpaceShuttle.draw_ladder(1800, 60, 0.0055, 0, 0, 1, 0, 0);
	pfd_segment_draw(data1, p_pfd.Hdot_tape_ladder_lower);

	p_pfd.Hdot_tape.labels_upper = p_pfd.Hdot_tape.createChild("group");
	draw_Hdot_labels_upper(p_pfd.Hdot_tape.labels_upper);

	p_pfd.Hdot_tape.labels_lower = p_pfd.Hdot_tape.createChild("group");
	draw_Hdot_labels_lower(p_pfd.Hdot_tape.labels_lower);

	# display box

	p_pfd.Hdot_display_box = Hdot_group.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0, 0, 0)
        .setColor(1,1,1);
	data1= SpaceShuttle.draw_rect(48, 20);
	pfd_segment_draw(data1, p_pfd.Hdot_display_box);
	p_pfd.Hdot_display_box.setTranslation (450, 200);

	p_pfd.Hdot_display_text = Hdot_group.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(450,205)
	.setRotation(0.0);


	device.HSI.setTranslation (255, 425);

	# accelerometer #############################################

	var acc_arc = device.symbols.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	data= SpaceShuttle.draw_arc(35, 20, 135.0, 360.0);
	pfd_segment_draw(data, acc_arc);

	data = SpaceShuttle.draw_arc_scale(35 ,6, 1.15, 0, 1.0, 135.0,360.0);
	pfd_segment_draw(data, acc_arc);

	var acc_labels = device.symbols.createChild("group");
	draw_acc_labels(acc_labels);

	acc_arc.setTranslation (95, 400);
	acc_labels.setTranslation (95, 405);

	# display box

	p_pfd.acc_display_box = device.symbols.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);
	data = SpaceShuttle.draw_rect(48, 20);
	pfd_segment_draw(data, p_pfd.acc_display_box);
	p_pfd.acc_display_box.setTranslation (118, 377);

	p_pfd.acc_display_text = device.symbols.createChild("text")
	.setText("0.0g")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(118,384)
	.setRotation(0.0);

	var acc_label = device.symbols.createChild("text")
	.setText("Accel")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(118,400)
	.setRotation(0.0);

	# marker arrow


	p_pfd.acc_needle = device.symbols.createChild("path")
        .setStrokeLineWidth(2)
	.setColorFill(0.4, 0.9, 0.7)
        .setColor(0.4, 0.9, 0.7);
	
	data = draw_slim_arrow_down();
	pfd_segment_draw(data, p_pfd.acc_needle);
	p_pfd.acc_needle.setTranslation (95, 400);

	# numerical values #############################################

	# X-Trk

	p_pfd.xtrk = device.symbols.createChild("group");

	p_pfd.xtrk_display_box = p_pfd.xtrk.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(450,360)
        .setColor(1,1,1);
	data = SpaceShuttle.draw_rect(48, 20);
	pfd_segment_draw(data, p_pfd.xtrk_display_box);

	p_pfd.xtrk_display_text = p_pfd.xtrk.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(450,365)
	.setRotation(0.0);

	var xtrk_label =p_pfd.xtrk.createChild("text")
	.setText("X-Trk")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(400,365)
	.setRotation(0.0);
	
	# Delta-Inc

	p_pfd.dInc = device.symbols.createChild("group");

	p_pfd.dInc_display_box = p_pfd.dInc.createChild("path")
        .setStrokeLineWidth(1)
	.setTranslation(445,390)
        .setColor(1,1,1);
	data = SpaceShuttle.draw_rect(58, 20);
	pfd_segment_draw(data, p_pfd.dInc_display_box);

	p_pfd.dInc_display_text = p_pfd.dInc.createChild("text")
	.setText("0.0")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(450,395)
	.setRotation(0.0);

	var dInc_label = p_pfd.dInc.createChild("text")
	.setText("ΔInc")
        .setColor(1,1,1)
	.setFontSize(14)
	.setFont("LiberationFonts/LiberationMono-Bold.ttf")
	.setAlignment("center-bottom")
	.setTranslation(395,395)
	.setRotation(0.0);



	}

    
    p_pfd.offdisplay = func
    {
	device.symbols.removeAllChildren();
	device.HSI.removeAllChildren();
	device.tapes.removeAllChildren();
	device.nom_traj_plot.removeAllChildren();
	device.nom_traj_plot.setTranslation(0,0);
    }
    
    p_pfd.update = func
    {

        device.nom_traj_plot.removeAllChildren();

	# get mission-specific parameters and manage devices #########################################

	var major_mode = getprop("/fdm/jsbsim/systems/dps/major-mode");

	var pitch = getprop("/orientation/pitch-deg");
	var yaw = getprop("/orientation/heading-deg");
	var roll = getprop("/orientation/roll-deg");

	var launch_stage = getprop("/fdm/jsbsim/systems/ap/launch/stage");

	var altitude = getprop("/position/altitude-ft");
	var beta_deg = getprop("/fdm/jsbsim/aero/beta-deg");
	var alpha_deg = getprop("/fdm/jsbsim/aero/alpha-deg");

	var pitch_error = 0.0;
	var yaw_error = 0.0;
	var roll_error = 0.0;
	
	var Delta_inc = 0.0;
	var hsi_course = - yaw;
	var course_arrow = 0.0;

	var bearing_earthrel = 0.0;
	var bearing_inertial = 0.0;
	var bearing_HAC_C = 0.0;
	var bearing_HAC_H = 0.0;

	var dap_text = "CSS";
	var throt_text = "";

	if ((major_mode == 101) or (major_mode == 102) or (major_mode == 103))
		{
		p_pfd.bearing_HAC_H.setVisible(0);
		p_pfd.bearing_HAC_C.setVisible(0);
		p_pfd.bearing_inertial.setVisible(1);
		if (altitude < 200000.0)
			{p_pfd.bearing_earth_relative.setVisible(1);}
		else
			{p_pfd.bearing_earth_relative.setVisible(0);}
		p_pfd.dInc.setVisible(1);
		p_pfd.xtrk.setVisible(1);


		if (getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-master") == 1)
			{
			var auto_pitch = getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-pitch-channel");
			var auto_roll_yaw = getprop("/fdm/jsbsim/systems/ap/launch/autolaunch-roll-yaw-channel");

			throt_text = "Auto";
		
			if ((auto_pitch == 1) and (auto_roll_yaw == 1)) {dap_text = "Auto";}
			}

		if ((launch_stage > 0) and (launch_stage < 5) and (altitude > 500.0)) # we have launch guidance
		{



		var tgt_inc = getprop("/fdm/jsbsim/systems/ap/launch/inclination-target");
		var current_inc = getprop("/fdm/jsbsim/systems/orbital/inclination-deg");

		var groundtrack_course_deg = getprop("/fdm/jsbsim/systems/entry_guidance/groundtrack-course-deg");
		var inertial_course_deg = yaw + beta_deg;

		bearing_earthrel = groundtrack_course_deg - yaw;
		bearing_inertial = inertial_course_deg - yaw;

		Delta_inc = tgt_inc - current_inc;

		hsi_course = Delta_inc;

		if (launch_stage == 1)
			{
			roll_error = -math.asin(getprop("/fdm/jsbsim/systems/ap/launch/stage1-course-error")) * 180.0/math.pi;
			}

		else if ((launch_stage > 1) and (launch_stage < 5))
			{
			pitch_error = getprop("/fdm/jsbsim/systems/ap/launch/stage"~launch_stage~"-pitch-error");
			yaw_error = getprop("/fdm/jsbsim/systems/ap/launch/stage"~launch_stage~"-yaw-error");
			roll_error = getprop("/fdm/jsbsim/systems/ap/launch/stage"~launch_stage~"-roll-error");
			}
		}
	

		if (altitude < 500.0) #zero motion of HSI and alpha tape before liftoff
			{
			hsi_course = 0.0;
			alpha_deg = 0.0;
			}

		}

	if ((major_mode == 304) or (major_mode == 305))
		{
		p_pfd.bearing_inertial.setVisible(0);
		p_pfd.bearing_earth_relative.setVisible(0);
		p_pfd.dInc.setVisible(0);
		p_pfd.xtrk.setVisible(0);

		if (SpaceShuttle.TAEM_guidance_available == 1)
			{
			p_pfd.bearing_HAC_H.setVisible(1);
			p_pfd.bearing_HAC_C.setVisible(1);
	
			var pos = geo.aircraft_position();
			var dist = pos.distance_to(TAEM_WP_1) / 1853.0;
			var course_WP1 = pos.course_to (TAEM_WP_1);
			var course_HAC_C = pos.course_to (TAEM_HAC_center);
			
			hsi_course = -yaw;
			bearing_HAC_C = course_HAC_C;
			bearing_HAC_H = course_WP1;
			course_arrow = SpaceShuttle.TAEM_threshold.heading;
			

			}
		else
			{
			p_pfd.bearing_HAC_H.setVisible(1);
			p_pfd.bearing_HAC_C.setVisible(1);
			}
		}


	# ADI sphere animation ##############################################

	var adi_sphere_bg = device.nom_traj_plot.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.15,0.15,0.15)
        .setColor(1,1,1);

	var adi_sphere_bg_bright = device.nom_traj_plot.createChild("path")
        .setStrokeLineWidth(1)
	.setColorFill(0.3,0.3,0.3)
        .setColor(1,1,1);

	var adi_sphere = device.nom_traj_plot.createChild("path")
        .setStrokeLineWidth(1)
        .setColor(1,1,1);

	# projection vecs for labels
	var p_vecs = SpaceShuttle.projection_vecs(-pitch, yaw, -roll);

	# ADI sphere
	var data = SpaceShuttle.draw_circle(0.75*95, 30);
	pfd_segment_draw(data,adi_sphere_bg);

	data = SpaceShuttle.draw_adi_bg(pitch, yaw, roll);
	pfd_segment_draw(data,adi_sphere_bg_bright);

	draw_adi_sphere(adi_sphere, p_vecs);

	draw_sphere_labels(device.nom_traj_plot, p_vecs, pitch, yaw, roll);
	
	# ADI error needles




	var pitch_error_ntrans = SpaceShuttle.clamp(pitch_error, -5.0, 5.0) * -8.0;
	var yaw_error_ntrans = SpaceShuttle.clamp(yaw_error, -5.0, 5.0) * -8.0;
	var roll_error_ntrans = SpaceShuttle.clamp(roll_error, -5.0, 5.0) * -8.0;

	p_pfd.att_error_pitch.setTranslation(0.0, pitch_error_ntrans);
	p_pfd.att_error_yaw.setTranslation(yaw_error_ntrans, 0.0);
	p_pfd.att_error_roll.setTranslation(roll_error_ntrans,0.0);
	
	p_pfd.att_error_pitch.setScale(math.sqrt(9025. - pitch_error_ntrans*pitch_error_ntrans)/95.0,1.0);
	p_pfd.att_error_yaw.setScale(1.0,math.sqrt(9025. - yaw_error_ntrans*yaw_error_ntrans)/95.0);
	p_pfd.att_error_roll.setScale(1.0,math.sqrt(9025. - roll_error_ntrans*roll_error_ntrans)/95.0);
	

	# ADI rate needles

	var roll_rate = getprop("/fdm/jsbsim/velocities/p-rad_sec") * 57.2957;
	roll_rate = SpaceShuttle.clamp(roll_rate, -5.0, 5.0);
	p_pfd.adi_roll_rate_needle.setTranslation(255 + 13.0 * roll_rate, 70);

	var pitch_rate = getprop("/fdm/jsbsim/velocities/q-rad_sec") * 57.2957;
	pitch_rate = SpaceShuttle.clamp(pitch_rate, -5.0, 5.0);
	p_pfd.adi_pitch_rate_needle.setTranslation(360, 175 - 13.0 * pitch_rate);

	var yaw_rate = getprop("/fdm/jsbsim/velocities/r-rad_sec") * 57.2957;
	yaw_rate = SpaceShuttle.clamp(yaw_rate, -5.0, 5.0);
	p_pfd.adi_yaw_rate_needle.setTranslation(255+13.0 * yaw_rate, 280.0);

	device.nom_traj_plot.setTranslation (255, 175);

	# HSI

	p_pfd.HSI_dynamic_group.setRotation(hsi_course * math.pi/180.0);

	p_pfd.bearing_earth_relative.setRotation(bearing_earthrel * math.pi/180.0);
	p_pfd.bearing_inertial.setRotation(bearing_inertial * math.pi/180.0);

	p_pfd.bearing_HAC_C.setRotation(bearing_HAC_C * math.pi/180.0);
	p_pfd.bearing_HAC_H.setRotation(bearing_HAC_H * math.pi/180.0);


	p_pfd.course_arrow.setRotation(course_arrow *  math.pi/180.0);
	p_pfd.cdi.setRotation(course_arrow * math.pi/180.0);
    
	# KEAS /Mach tape

	var mach = getprop("/fdm/jsbsim/velocities/mach");
	p_pfd.keas_tape.setTranslation (70, 200 - 5400 + 381.0 * mach);       
	p_pfd.keas_display_text.setText(sprintf("%2.1f",mach));

	# alpha tape
	

	p_pfd.alpha_display_text.setText(sprintf("%2.1f",alpha_deg));
	p_pfd.alpha_tape.setTranslation (120, 200 + 9.5 * alpha_deg);

	# H tape

	if (altitude > 400000.0)
		{
		var H_miles = altitude / 6076.1154;
		var tape_offset = (H_miles - 70.0) * 10.0;
		if (tape_offset<0.0) {tape_offset = 0.0;}
		p_pfd.H_display_text.setText(sprintf("%3.1f",H_miles)~"M");
		p_pfd.H_tape.setTranslation (400, 200 + tape_offset);

		p_pfd.H_tape.labels_upper_2k.setVisible(0);
		p_pfd.H_tape.labels_lower_2k.setVisible(0);
		p_pfd.H_tape.labels_upper_30k.setVisible(0);
		p_pfd.H_tape.labels_lower_30k.setVisible(0);
		p_pfd.H_tape.labels_upper_100k.setVisible(0);
		p_pfd.H_tape.labels_lower_100k.setVisible(0);
		p_pfd.H_tape.labels_upper_400k.setVisible(0);
		p_pfd.H_tape.labels_lower_400k.setVisible(0);
		p_pfd.H_tape.labels_upper_miles.setVisible(1);
		p_pfd.H_tape.labels_lower_miles.setVisible(1);
		}
	else if (altitude > 100000.0)
		{
		var tape_offset = (altitude - 100000.0)/50000.0 * 50.0;
		if (tape_offset<0.0) {tape_offset = 0.0;}
		p_pfd.H_display_text.setText(sprintf("%3.0f",altitude/1000)~"k");
		p_pfd.H_tape.setTranslation (400, 200 + tape_offset);

		p_pfd.H_tape.labels_upper_2k.setVisible(0);
		p_pfd.H_tape.labels_lower_2k.setVisible(0);
		p_pfd.H_tape.labels_upper_30k.setVisible(0);
		p_pfd.H_tape.labels_lower_30k.setVisible(0);
		p_pfd.H_tape.labels_upper_100k.setVisible(0);
		p_pfd.H_tape.labels_lower_100k.setVisible(0);
		p_pfd.H_tape.labels_upper_400k.setVisible(1);
		p_pfd.H_tape.labels_lower_400k.setVisible(1);
		p_pfd.H_tape.labels_upper_miles.setVisible(0);
		p_pfd.H_tape.labels_lower_miles.setVisible(0);
		}
	else if (altitude > 30000.0)
		{
		var tape_offset = (altitude - 30000.0)/1000.0 * 10.0;
		if (tape_offset<0.0) {tape_offset = 0.0;}
		p_pfd.H_display_text.setText(sprintf("%4.0f",altitude));
		p_pfd.H_tape.setTranslation (400, 200 + tape_offset);

		p_pfd.H_tape.labels_upper_2k.setVisible(0);
		p_pfd.H_tape.labels_lower_2k.setVisible(0);
		p_pfd.H_tape.labels_upper_30k.setVisible(0);
		p_pfd.H_tape.labels_lower_30k.setVisible(0);
		p_pfd.H_tape.labels_upper_100k.setVisible(1);
		p_pfd.H_tape.labels_lower_100k.setVisible(1);
		p_pfd.H_tape.labels_upper_400k.setVisible(0);
		p_pfd.H_tape.labels_lower_400k.setVisible(0);
		p_pfd.H_tape.labels_upper_miles.setVisible(0);
		p_pfd.H_tape.labels_lower_miles.setVisible(0);
		}
	else if (altitude > 2000.0)
		{
		var tape_offset = (altitude - 2000.0)/1000.0 * 50.0;
		if (tape_offset<0.0) {tape_offset = 0.0;}
		p_pfd.H_display_text.setText(sprintf("%4.0f",altitude));
		p_pfd.H_tape.setTranslation (400, 200 + tape_offset);

		p_pfd.H_tape.labels_upper_2k.setVisible(0);
		p_pfd.H_tape.labels_lower_2k.setVisible(0);
		p_pfd.H_tape.labels_upper_30k.setVisible(1);
		p_pfd.H_tape.labels_lower_30k.setVisible(1);
		p_pfd.H_tape.labels_upper_100k.setVisible(0);
		p_pfd.H_tape.labels_lower_100k.setVisible(0);
		p_pfd.H_tape.labels_upper_400k.setVisible(0);
		p_pfd.H_tape.labels_lower_400k.setVisible(0);
		p_pfd.H_tape.labels_upper_miles.setVisible(0);
		p_pfd.H_tape.labels_lower_miles.setVisible(0);
		}
	else
		{
		var tape_offset = altitude/100.0 * 50.0;
		if (tape_offset<0.0) {tape_offset = 0.0;}
		p_pfd.H_display_text.setText(sprintf("%4.0f",altitude));
		p_pfd.H_tape.setTranslation (400, 200 + tape_offset);

		p_pfd.H_tape.labels_upper_2k.setVisible(1);
		p_pfd.H_tape.labels_lower_2k.setVisible(1);
		p_pfd.H_tape.labels_upper_30k.setVisible(0);
		p_pfd.H_tape.labels_lower_30k.setVisible(0);
		p_pfd.H_tape.labels_upper_100k.setVisible(0);
		p_pfd.H_tape.labels_lower_100k.setVisible(0);
		p_pfd.H_tape.labels_upper_400k.setVisible(0);
		p_pfd.H_tape.labels_lower_400k.setVisible(0);
		p_pfd.H_tape.labels_upper_miles.setVisible(0);
		p_pfd.H_tape.labels_lower_miles.setVisible(0);
		}


	# Hdot tape

	var vspeed = -getprop("/fdm/jsbsim/velocities/v-down-fps");

	var tape_offset = SpaceShuttle.clamp(vspeed, -2900.0, 2900.0) * 0.6;
	p_pfd.Hdot_tape.setTranslation (450, 200 + tape_offset);
	p_pfd.Hdot_display_text.setText(sprintf("%4.0f",vspeed));

	# accelerometer needle

	var acceleration = getprop("/fdm/jsbsim/accelerations/a-pilot-ft_sec2") * 0.03108095;

	var acc_needle_rot = acceleration * 45.0 * math.pi/180.0;

	p_pfd.acc_needle.setRotation(acc_needle_rot);
	p_pfd.acc_display_text.setText(sprintf("%1.1f",acceleration)~"g");

	# numerical values

	if (altitude < 200000.0)
       		{p_pfd.beta.setText(sprintf("%1.1f",beta_deg));}
	else
		{p_pfd.beta.setText("");}

        p_pfd.keas.setText(sprintf("%3.0f",getprop("/velocities/equivalent-kt")));

	p_pfd.r.setText(sprintf("%d", roll));
	p_pfd.p.setText(sprintf("%d", pitch));
	p_pfd.y.setText(sprintf("%d", yaw));
	p_pfd.dInc_display_text.setText(sprintf("%2.2f", Delta_inc));


	# mode texts

	p_pfd.dap.setText(dap_text);
    	p_pfd.throt.setText(throt_text);

    };
    
    return p_pfd;
}




# batch functions for label drawing

var label_from_degree = func (angle, flag) {

if (angle == 0.0) 
	{
	if (flag == 1) {return "N";}
	else {return "0";}
	}
else if (angle == 30.0)
	{return "3";}
else if (angle == 60.0)
	{return "6";}
else if (angle == 90.0)
	{
	if (flag == 1) {return "E";}	
	else	{return "9";}
	}
else if (angle == 120.0)
	{return "12";}
else if (angle == 15.0)
	{return "15";}
else if (angle == 180.0)
	{
	if (flag == 1) {return "S";}
	else {return "18";}
	}
else if (angle == 210.0)
	{return "21";}
else if (angle == 240.0)
	{return "24";}
else if (angle == 270.0)
	{	
	if (flag == 1) {return "W";}
	else {return "27";}
	}
else if (angle == 300.0)
	{return "30";}
else if (angle == 330.0)
	{return "33";}
else return "";
}


var draw_sphere_labels = func (group, p_vecs, pitch, yaw, roll) {

var coords = [];
var label = "";
var lon = 0;


var lat = 15;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs, pitch, yaw);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

var lat = 45;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs, pitch, yaw);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

var lat = -15;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs, pitch, yaw);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

var lat = -45;
for (var i=0; i< 12; i=i+1)
	{
	lon = 30.0 * i;
	label = label_from_degree(lon, 0);
	coords = SpaceShuttle.label_coords_sphere(lat, lon, p_vecs, pitch, yaw);
	write_sphere_label(group, label, -roll * math.pi/180.0, coords);
	}

}

var draw_mach_labels = func (group)
{

for (var i=0; i< 140; i=i+1)
	{
	var y = 5385 - i * 76.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%2.1f", 0.2 * i);

	write_tape_label(group, label, coords, [0,0,0]);
	}

}

var draw_alpha_labels_upper = func (group)
{

for (var i=0; i< 36; i=i+1)
	{
	var y = 5.0 - i * 47.5;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 5 * i);

	write_tape_label(group, label, coords, [0,0,0]);
	}

}

var draw_alpha_labels_lower = func (group)
{

for (var i=0; i< 36; i=i+1)
	{
	var y = 5.0 + i * 47.5;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", -5 * i);

	write_tape_label(group, label, coords, [1,1,1]);
	}

}


var draw_H_labels_upper_miles = func (group)
{

for (var i=0; i< 20; i=i+1)
	{
	var y = 5.0 - i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 70 + 5* i);
	label=label~"M";
	if (i>0)
		{write_tape_label_bg(group, label, coords, [0,0,0], [1,1,1]);}
	else
		{write_tape_label(group, label, coords, [0,0,0]);}
	}

}

var draw_H_labels_lower_miles = func (group)
{

for (var i=0; i< 2; i=i+1)
	{
	var y = 5.0 + i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 70 - 5* i);
	label=label~"M";

	write_tape_label(group, label, coords, [1,1,1]);
	}

}


var draw_H_labels_upper_2k = func (group)
{

for (var i=0; i< 20; i=i+1)
	{
	var y = 5.0 - i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 100 * i);
	if (i>0)
		{write_tape_label_bg(group, label, coords, [0,0,0], [1,1,1]);}
	else
		{write_tape_label(group, label, coords, [0,0,0]);}
	}
}

var draw_H_labels_lower_2k = func (group)
{

for (var i=0; i< 2; i=i+1)
	{
	var y = 5.0 + i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 100 *  i);

	write_tape_label(group, label, coords, [1,1,1]);
	}
}

var draw_H_labels_upper_30k = func (group)
{

for (var i=0; i< 29; i=i+1)
	{
	var y = 5.0 - i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 2 + i);
	label=label~"k";
	if (i>0)
		{write_tape_label_bg(group, label, coords, [0,0,0], [1,1,1]);}
	else
		{write_tape_label(group, label, coords, [0,0,0]);}
	}
}

var draw_H_labels_lower_30k = func (group)
{

for (var i=0; i< 2; i=i+1)
	{
	var y = 5.0 + i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 2 - i);
	label=label~"k";

	write_tape_label(group, label, coords, [1,1,1]);
	}
}

var draw_H_labels_upper_100k = func (group)
{

for (var i=0; i< 14; i=i+1)
	{
	var y = 5.0 - i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 30 + 5*i);
	label=label~"k";
	if (i>0)
		{write_tape_label_bg(group, label, coords, [0,0,0], [1,1,1]);}
	else
		{write_tape_label(group, label, coords, [0,0,0]);}
	}
}

var draw_H_labels_lower_100k = func (group)
{

for (var i=0; i< 2; i=i+1)
	{
	var y = 5.0 + i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 30 - 5*i);
	label=label~"k";

	write_tape_label(group, label, coords, [1,1,1]);
	}
}

var draw_H_labels_upper_400k = func (group)
{

for (var i=0; i< 6; i=i+1)
	{
	var y = 5.0 - i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 100 + 50*i);
	label=label~"k";
	if (i>0)
		{write_tape_label_bg(group, label, coords, [0,0,0], [1,1,1]);}
	else
		{write_tape_label(group, label, coords, [0,0,0]);}
	}
}

var draw_H_labels_lower_400k = func (group)
{

for (var i=0; i< 2; i=i+1)
	{
	var y = 5.0 + i * 50.0;
	var coords = [0.0, y, 1];

	var label = sprintf("%d", 100 - 50*i);
	label=label~"k";
	write_tape_label(group, label, coords, [1,1,1]);
	}
}


var draw_Hdot_labels_upper = func (group)
{

for (var i=0; i< 30; i=i+1)
	{
	var y = 5.0 - i * 60.0;
	var coords = [0.0, y, 1];

	var label_value = i * 100;
	var label = "";

	if (label_value < 1000)
		{label = sprintf("%d", label_value);}
	else
		{label = sprintf("%1.1f", label_value/1000)~"k";}
	write_tape_label(group, label, coords, [0,0,0]);
	}
}

var draw_Hdot_labels_lower = func (group)
{

for (var i=0; i< 30; i=i+1)
	{
	var y = 5.0 + i * 60.0;
	var coords = [0.0, y, 1];

	var label_value = -i * 100;
	var label = "";

	if (label_value > -1000)
		{label = sprintf("%d", label_value);}
	else
		{label = sprintf("%d", label_value/1000)~"k";}
	write_tape_label(group, label, coords, [1,1,1]);
	}
}

var draw_acc_labels = func (group)
{

for (var i=0; i<5; i=i+1)
	{
	var ang = 135.0 + i * 45;
	ang = math.pi/180.0 * ang;

	var x = 45 * math.sin(ang);	
	var y = -45 * math.cos(ang);

	var coords = [x,y,1];
	var label = sprintf("%d", -1+i);

	write_tape_label(group, label, coords, [1,1,1]);
	}


}



var draw_adi_sphere = func (group, p_vecs) {

var meridian_res = 60;
var circle_res = 90;

var data = [];

for (var i = 0; i<12; i=i+1)
	{
	data = SpaceShuttle.draw_meridian(i * 30.0, meridian_res, p_vecs );
	pfd_segment_draw(data, group);

	data = SpaceShuttle.draw_meridian_ladder(i * 30.0 + 15.0, 5, p_vecs );
	pfd_segment_draw(data, group);
	}


data = SpaceShuttle.draw_coord_circle(0.0, circle_res, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_circle_ladder(15.0, 12, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_coord_circle(30.0, circle_res, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_circle_ladder(-15.0, 12, p_vecs );
pfd_segment_draw(data, group);


data = SpaceShuttle.draw_coord_circle(-30.0, circle_res, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_circle_ladder(45.0, 12, p_vecs );
pfd_segment_draw(data, group);


data = SpaceShuttle.draw_coord_circle(60.0, circle_res, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_circle_ladder(-45.0, 12, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_coord_circle(-60.0, circle_res, p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_coord_circle(85.0, int(0.3 * circle_res), p_vecs );
pfd_segment_draw(data, group);

data = SpaceShuttle.draw_coord_circle(-85.0, int (0.3 * circle_res), p_vecs );
pfd_segment_draw(data, group);

}

