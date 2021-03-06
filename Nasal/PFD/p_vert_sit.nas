#---------------------------------------
# SpaceShuttle PFD Page include:
#        Page: p_vert_sit
# Description: the vertical situation PFD page showing the TAEM guidance
#      Author: Thorsten Renk, 2015
#---------------------------------------

var PFD_addpage_p_vert_sit = func(device)
{
    var p_vert_sit = device.addPage("VertSit", "p_vert_sit");

    p_vert_sit.group = device.svg.getElementById("p_vert_sit");
    p_vert_sit.group.setColor(dps_r, dps_g, dps_b);
    
    p_vert_sit.speedbrake = device.svg.getElementById("p_vert_sit_speedbrake");


    
    
    
    p_vert_sit.ondisplay = func
    {


        SpaceShuttle.fill_vert_sit1_nom_data();
        SpaceShuttle.fill_vert_sit1_SB_data();
        SpaceShuttle.fill_vert_sit1_maxLD_data();
        SpaceShuttle.traj_display_flag = 8;
        #device.p_ascent_shuttle_sym.setScale(0.3);
        device.MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));
        device.DPS_menu_ops.setText(sprintf("%s","3051/     /"));
        device.DPS_menu_title.setText(sprintf("%s","VERT SIT 1"));
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(traj_data[0][0],traj_data[0][1]); 
    
        for (var i = 1; i< (size(traj_data)-1); i=i+1)
        {
            var set = traj_data[i+1];
            plot.lineTo(set[0], set[1]);	
        }
    
        var plot_limit1 = device.limit1_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit1_data[0][0],limit1_data[0][1]); 
    
        for (var i = 1; i< (size(limit1_data)-1); i=i+1)
        {
            var set = limit1_data[i+1];
            plot_limit1.lineTo(set[0], set[1]);	
        }
    
        var plot_limit2 = device.limit2_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r,dps_g,dps_b)
        .moveTo(limit2_data[0][0],limit2_data[0][1]); 
    
        for (var i = 1; i< (size(limit2_data)-1); i=i+1)
        {
            var set = limit2_data[i+1];
            plot_limit2.lineTo(set[0], set[1]);	
        }


	var data = SpaceShuttle.draw_shuttle_side();
	 
	p_vert_sit.shuttle_sym = device.symbols.createChild("path", "shuttle_sym")
        .setStrokeLineWidth(0.25)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit.shuttle_sym.lineTo(set[0], set[1]);
		}

	p_vert_sit.shuttle_sym.setScale(6.0);

	data = SpaceShuttle.draw_tmarker_right();
	p_vert_sit.theta = device.symbols.createChild("path", "theta")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit.theta.lineTo(set[0], set[1]);
		}

 


    
    }
    
    p_vert_sit.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.limit1_traj_plot.removeAllChildren();
        device.limit2_traj_plot.removeAllChildren();
	device.symbols.removeAllChildren();
        #device.p_ascent_shuttle_sym.setScale(0.0);
        device.set_DPS_off();
    }
    
    p_vert_sit.update = func
    {
    
        device.update_common_DPS();
    
    
    
    
    
        if (SpaceShuttle.TAEM_guidance_available == 1)
    	{
            var altitude = getprop("/position/altitude-ft") - SpaceShuttle.TAEM_threshold.elevation;
            var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
            var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
            var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
    	
            if (range < 20.0) {device.selectPage(device.p_vert_sit2);}

	    var vspeed = getprop("/velocities/vertical-speed-fps");
	    var mach = getprop("/velocities/mach");
	    if (mach< 0.5) {mach = 0.5;}	
	    var rot = vspeed * 0.005 /mach;
	    rot = SpaceShuttle.clamp(rot, -1.57, 1.57);
	    p_vert_sit.shuttle_sym.setRotation(rot);
    

            p_vert_sit.shuttle_sym.setTranslation(x,y);

    	}

	    var pitch = getprop("/orientation/pitch-deg");
	    var yp = 254.0 - (pitch -5.0) * 5.6;
	    p_vert_sit.theta.setTranslation(467,yp);
    
        p_vert_sit.speedbrake.setText(sprintf("%3.0f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));
    
    
    };

return p_vert_sit;
}
    

var PFD_addpage_p_vert_sit2 = func(device)
{    

    
    var p_vert_sit2 = device.addPage("VertSit2", "p_vert_sit2");
    
    p_vert_sit2.speedbrake = device.svg.getElementById("p_vert_sit2_speedbrake");
    p_vert_sit2.group = device.svg.getElementById("p_vert_sit2");
    p_vert_sit2.group.setColor(dps_r, dps_g, dps_b);
    
    
    p_vert_sit2.ondisplay = func
    {
        SpaceShuttle.fill_vert_sit2_nom_data();
        SpaceShuttle.fill_vert_sit2_SB_data();
        SpaceShuttle.fill_vert_sit2_maxLD_data();
        SpaceShuttle.traj_display_flag = 9;
        #device.p_ascent_shuttle_sym.setScale(0.3);
        device.MEDS_menu_title.setText("       DPS MENU");
        device.DPS_menu_ops.setText("3051/     /");
        device.DPS_menu_title.setText("VERT SIT 2");
    
    
        var plot = device.nom_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(2)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(traj_data[0][0],traj_data[0][1]); 
    
        for (var i = 1; i< (size(traj_data)-1); i=i+1)
        {
            var set = traj_data[i+1];
            plot.lineTo(set[0], set[1]);	
        }
    
        var plot_limit1 = device.limit1_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit1_data[0][0],limit1_data[0][1]); 
    
        for (var i = 1; i< (size(limit1_data)-1); i=i+1)
        {
            var set = limit1_data[i+1];
            plot_limit1.lineTo(set[0], set[1]);	
        }
    
        var plot_limit2 = device.limit2_traj_plot.createChild("path", "data")
        .setStrokeLineWidth(1)
        .setColor(dps_r, dps_g, dps_b)
        .moveTo(limit2_data[0][0],limit2_data[0][1]); 
    
        for (var i = 1; i< (size(limit2_data)-1); i=i+1)
        {
            var set = limit2_data[i+1];
            plot_limit2.lineTo(set[0], set[1]);	
        }

	var data = SpaceShuttle.draw_shuttle_side();
	 
	p_vert_sit2.shuttle_sym = device.symbols.createChild("path", "shuttle_sym")
        .setStrokeLineWidth(0.25)
        .setColor(0.8, 0.8, 0.4)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit2.shuttle_sym.lineTo(set[0], set[1]);
		}

	p_vert_sit2.shuttle_sym.setScale(6.0);

	data = SpaceShuttle.draw_tmarker_right();
	p_vert_sit2.theta = device.symbols.createChild("path", "theta")
        .setStrokeLineWidth(1.0)
        .setColor(dps_r, dps_g, dps_b)
	.moveTo(data[0][0], data[0][1]);

	for (var i = 0; (i< size(data)-1); i=i+1)
        	{
		var set = data[i+1]; 
		p_vert_sit2.theta.lineTo(set[0], set[1]);
		}

    
    }
    
    p_vert_sit2.offdisplay = func
    {
        device.nom_traj_plot.removeAllChildren();
        device.limit1_traj_plot.removeAllChildren();
        device.limit2_traj_plot.removeAllChildren();
	device.symbols.removeAllChildren();
        #device.p_ascent_shuttle_sym.setScale(0.0);
        device.set_DPS_off();
    }
    
    p_vert_sit2.update = func
    {
    
        device.update_common_DPS();
    
    
    
        if (SpaceShuttle.TAEM_guidance_available == 1)
    	{
            var altitude = getprop("/position/altitude-ft") - SpaceShuttle.TAEM_threshold.elevation;
            var range = getprop("/fdm/jsbsim/systems/taem-guidance/distance-to-runway-nm");
            var x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
            var y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
    	
            var vspeed = getprop("/velocities/vertical-speed-fps");
	    var mach = getprop("/velocities/mach");
	    if (mach< 0.5) {mach = 0.5;}	
	    var rot = vspeed * 0.005 /mach;
	    rot = SpaceShuttle.clamp(rot, -1.57, 1.57);
	    p_vert_sit2.shuttle_sym.setRotation(rot);
	    p_vert_sit2.shuttle_sym.setTranslation(x,y);

    	}

	    var pitch = getprop("/orientation/pitch-deg");
	    var yp = 254.0 - (pitch -5.0) * 5.6;
	    p_vert_sit2.theta.setTranslation(467,yp);
    
        p_vert_sit2.speedbrake.setText(sprintf("%3.0f", 100.0 * getprop("/fdm/jsbsim/fcs/speedbrake-pos-norm")));
    
    
    };
    
    
    
    return p_vert_sit2;
}
