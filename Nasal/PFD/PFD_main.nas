# Space Shuttle PFD
# ---------------------------
# PFD has many pages; the classes here support multiple pages, menu
# operation and the update loop.
# Based on F-15 MPCD
# ---------------------------
# Richard Harrison: 2015-01-23 : rjh@zaretto.com
# ---------------------------

#
#
# in the SVG each page is a named group - the group name is used to define each page
setprop ("/sim/startup/terminal-ansi-colors",0);

var PFDcanvas= canvas.new({
        "name": "STS PFD",
            "size": [1758,1884], 
            "view": [512,512],                       
            "mipmapping": 1     
            });                          
                          
PFDcanvas.addPlacement({"node": "DisplayL1"});
PFDcanvas.setColorBackground(0,0,0, 0);


# Create a group for the parsed elements
var PFDsvg = PFDcanvas.createGroup();
 
# Parse an SVG file and add the parsed elements to the given group
print("PFD : Load SVG ",canvas.parsesvg(PFDsvg, "Nasal/PFD/PFD.svg"));
PFDsvg.setTranslation (20, 30);

#
# Menu Id's
# 18           6            
# 19           7            
# 20           8            
# 21           9            
# 22           10            
# 23           11          
# Top: 12..17
# Bot: 0..5
var PFD_MenuItem = {
    new : func (menu_id, title, page)
    {
		var obj = {parents : [PFD_MenuItem] };
        obj.page = page;
        obj.menu_id = menu_id;
        obj.title = title;
#        printf("New MenuItem %s,%s,%s",menu_id, title, page);
        return obj;
    },
};

#
#
# Create a new PFD Page 0 needs page id, svg and layer id
var PFD_Page = {
	new : func (title, layer_id, device)
    {
		var obj = {parents : [PFD_Page] };
        obj.title = title;
        obj.device = device;
        obj.layer_id = layer_id;
        obj.menus = [];
#        print("Load page ",title);
        obj.svg = PFDsvg.getElementById(layer_id);
        if(obj.svg == nil)
            printf("Error loading %s: svg layer %s ",title, layer_id);

        return obj;
    },
    setVisible : func(vis)
    {
        if(me.svg != nil)
            me.svg.setVisible(vis);
#        print("Set visible ",me.layer_id);

        if (vis)
        {
            foreach(mi ;  me.menus)
            {
#                printf("load menu %s %\n",mi.title, mi);
            }
        }
    },
#
#
# Perform action when button is pushed
    notifyButton : func(button_id) 
    {        foreach(var mi; me.menus)
             {
                 if (mi.menu_id == button_id)
                 {
                     printf("Page: found button %s, selecting page\n",mi.title);
                     me.device.selectPage(mi.page);
                     break;
                 }
             }
    },
# 
# Add an item to a menu
# Params:
#  menu button id (that is set in controls/PFD/button-pressed by the model)
#  title of the menu for the label
#  page that will be selected when pressed
# 
# The corresponding menu for the selected page will automatically be loaded
    addMenuItem : func(menu_id, title, page)
    {
        var nm = PFD_MenuItem.new(menu_id, title, page);
#        printf("New menu %s %s on page ", menu_id, title, page.layer_id);
        append(me.menus, nm);
#        printf("Page %s: add menu %s [%s]",me.layer_id, menu_id, title);
#            foreach(mi ; me.menus)
        #            {
#                printf("--menu %s",mi.title);
        #            }
        return nm;
    },
    update : func
    {
    },
};
var num_menu_buttons = 6; # Number of menu buttons; starting from the bottom left then right, then top, then left.
var PFD_Device =
{
    new : func(svg)
    {
		var obj = {parents : [PFD_Device] };
        obj.svg = svg;
        obj.current_page = nil;
        obj.pages = [];
        obj.buttons = setsize([], num_menu_buttons);

        for(var idx = 0; idx < num_menu_buttons; idx += 1)
        {
            var label_name = sprintf("MI_%d",idx);
            var msvg = obj.svg.getElementById(label_name);
            if (msvg == nil)
                printf("Failed to load  %s",label_name);
            else
            {
                obj.buttons[idx] = msvg;
                obj.buttons[idx].setText(sprintf("M",idx));
            }
        }
#        for(var idx = 0; idx < size(obj.buttons); idx += 1)
        #        {
#            printf("Button %d %s",idx,obj.buttons[idx]);
        #        }
        return obj;
    },
    notifyButton : func(button_id)
    {
        #
        #
# by convention the buttons we have are 0 based; however externally 0 is used
# to indicate no button pushed.
        if (button_id > 0)
        {
            button_id = button_id - 1;
            if (me.current_page != nil)
            {
                printf("Button routing to %s",me.current_page.title);
                me.current_page.notifyButton(button_id);
            }
            else
                printf("Could not locate page for button ",button_id);
        }
    },
    addPage : func(title, layer_id)
    {
        var np = PFD_Page.new(title, layer_id, me);
        append(me.pages, np);
        np.setVisible(0);
        return np;
    },
    update : func
    {
        if (me.current_page != nil)
            me.current_page.update();
    },
    selectPage : func(p)
    {
        if (me.current_page != nil)
            me.current_page.setVisible(0);
        if (me.buttons != nil)
        {
            foreach(var mb ; me.buttons)
                if (mb != nil)
                    mb.setVisible(0);

            foreach(var mi ; p.menus)
            {
                printf("selectPage: load menu %d %s",mi.menu_id, mi.title);
                if (me.buttons[mi.menu_id] != nil)
                {
                    me.buttons[mi.menu_id].setText(mi.title);
                    me.buttons[mi.menu_id].setVisible(1);
                }
                else
                    printf("No corresponding item '%s'",mi.menu_id);
            }
        }
        p.setVisible(1);
        me.current_page = p;
    },
};

var PFD =  PFD_Device.new(PFDsvg);

setlistener("sim/model/shuttle/controls/PFD/button-pressed", func(v)
            {
                if (v != nil)
                {
                    if (v.getValue())
                        pfd_button_pushed = v.getValue();
                    else
                    {
                        printf("Button %d",pfd_button_pushed);
                        PFD.notifyButton(pfd_button_pushed);
                        pfd_button_pushed = 0;
                    }
                }
            });
var pfd_mode = 1;

# SVG access to all common elements in DPS and MEDS page structures

var MEDS_menu_title = PFDsvg.getElementById("MEDS_title");

var DPS_menu_time = PFDsvg.getElementById("dps_menu_time");
var DPS_menu_crt_time = PFDsvg.getElementById("dps_menu_crt_time");
var DPS_menu_ops = PFDsvg.getElementById("dps_menu_OPS");
var DPS_menu_title = PFDsvg.getElementById("dps_menu_title");
var DPS_menu_fault_line = PFDsvg.getElementById("dps_menu_fault_line");
var DPS_menu_scratch_line = PFDsvg.getElementById("dps_menu_scratch_line");
var DPS_menu_gpc_driver = PFDsvg.getElementById("dps_menu_gpc_driver");

# helper function to turn DPS display items off in MEDS pages

var set_DPS_off = func {

DPS_menu_time.setText(sprintf("%s",""));
DPS_menu_crt_time.setText(sprintf("%s",""));
DPS_menu_ops.setText(sprintf("%s",""));
DPS_menu_title.setText(sprintf("%s",""));
DPS_menu_fault_line.setText(sprintf("%s",""));
DPS_menu_scratch_line.setText(sprintf("%s",""));
DPS_menu_gpc_driver.setText(sprintf("%s",""));
}

var update_common_DPS = func {

DPS_menu_time.setText(sprintf("%s","000/"~getprop("/sim/time/gmt-string")));
DPS_menu_crt_time.setText(sprintf("%s", "000/"~" 0:00:00"));
DPS_menu_scratch_line.setText(sprintf("%s",getprop("/fdm/jsbsim/systems/dps/command-string")));
DPS_menu_gpc_driver.setText(sprintf("%s","1"));
}




# Set listener on the PFD mode button; this could be an on off switch or by convention
# it will also act as brightness; so 0 is off and anything greater is brightness.
# ranges are not pre-defined; it is probably sensible to use 0..10 as an brightness rather
# than 0..1 as a floating value; but that's just my view.
setlistener("sim/model/shuttle/controls/PFD/mode", func(v)
            {
                if (v != nil)
                {
                    var pfd_mode = v.getValue();
#                    print("PFD Mode ",pfd_mode);
#    if (!pfd_mode)
#        PFDcanvas.setVisible(0);
#    else
#        PFDcanvas.setVisible(1);
                }
            });

var p_pfd = PFD.addPage("PFD", "p_pfd");

#
#
# PFD page update
p_pfd.keas = PFDsvg.getElementById("p_pfd_keas");
p_pfd.beta = PFDsvg.getElementById("p_pfd_beta");

p_pfd.update = func
{
    # these really need to be deleted when leaving the ascent page - do we have
    # an 'upon exit' functionality here
    p_traj_plot.removeAllChildren();
    p_ascent_shuttle_sym.setScale(0.0);

    set_DPS_off();
    MEDS_menu_title.setText(sprintf("%s","FLIGHT INSTRUMENT MENU"));
    p_pfd.beta.setText(sprintf("%5.1f",getprop("fdm/jsbsim/aero/beta-deg")));
    p_pfd.keas.setText(sprintf("%5.0f",getprop("velocities/airspeed-kt")));
};

#
PFD.selectPage(p_pfd);

#################################################################
# the main menu page showing just selection buttons
#################################################################

var p_main = PFD.addPage("MainMenu", "p_main");


p_main.update = func
{
set_DPS_off();
MEDS_menu_title.setText(sprintf("%s","      MAIN MENU"));
}

#################################################################
# the ascent/entry PFD page showing the vertical trajectory status
#################################################################

var p_ascent = PFD.addPage("Ascent", "p_ascent");

#
#
# Ascent page update
var p_ascent_view = PFDsvg.getElementById("ascent_view");
var p_traj_plot = PFDcanvas.createGroup();
SpaceShuttle.fill_traj1_data();
var p_ascent_time = 0;
var p_ascent_next_update = 0;


var p_ascent_shuttle_sym = PFDcanvas.createGroup();
canvas.parsesvg( p_ascent_shuttle_sym, "/Nasal/canvas/map/Images/boeingAirplane.svg");
p_ascent_shuttle_sym.setScale(0.3);

p_ascent.update = func
{

MEDS_menu_title.setText(sprintf("%s","       DPS MENU"));

update_common_DPS();



p_traj_plot.removeAllChildren();

SpaceShuttle.ascent_traj_update_set();

if (SpaceShuttle.traj_display_flag == 2)
	{
	DPS_menu_title.setText(sprintf("%s","ASCENT TRAJ 2"));
	DPS_menu_ops.setText(sprintf("%s","1031/     /"));
	}
else if  (SpaceShuttle.traj_display_flag == 3)
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 1"));
	DPS_menu_ops.setText(sprintf("%s","3041/     /"));
	}
else if (SpaceShuttle.traj_display_flag == 4)
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 2"));
	}
else if (SpaceShuttle.traj_display_flag == 5)
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 3"));
	}
else if (SpaceShuttle.traj_display_flag == 6)
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 4"));
	}
else if (SpaceShuttle.traj_display_flag == 7)
	{
	DPS_menu_title.setText(sprintf("%s","ENTRY TRAJ 5"));
	}



var plot = p_traj_plot.createChild("path", "data")
                                   .setStrokeLineWidth(2)
                                   .setColor(0.5,0.6,0.5)
                                   .moveTo(traj_data[0][0],traj_data[0][1]); 

		for (var i = 1; i< (size(traj_data)-1); i=i+1)
			{
			var set = traj_data[i+1];
			plot.lineTo(set[0], set[1]);	
			}

var velocity = SpaceShuttle.ascent_traj_update_velocity();
var altitude = getprop("/position/altitude-ft");

var x = 0;
var y = 0;

if (SpaceShuttle.traj_display_flag < 3)
	{
	 x = SpaceShuttle.parameter_to_x(velocity, SpaceShuttle.traj_display_flag);
	 y = SpaceShuttle.parameter_to_y(altitude, SpaceShuttle.traj_display_flag);
	}
else
	{
	var range = getprop("/fdm/jsbsim/systems/entry_guidance/remaining-distance-nm");
 	 x = SpaceShuttle.parameter_to_x(range, SpaceShuttle.traj_display_flag);
	 y = SpaceShuttle.parameter_to_y(velocity, SpaceShuttle.traj_display_flag);
	}

p_ascent_shuttle_sym.setScale(0.3);
p_ascent_shuttle_sym.setTranslation(x,y);


};

#
PFD.selectPage(p_pfd);

#
#
# Add the menus to each page. The selected set of menu items is automatically managed

p_ascent.addMenuItem(0, "UP", p_pfd);
p_ascent.addMenuItem(4, "MSG RST", p_ascent);
p_ascent.addMenuItem(5, "MSG ACK", p_ascent);

p_pfd.addMenuItem(0, "UP", p_main);
p_pfd.addMenuItem(1, "A/E", p_pfd);
p_pfd.addMenuItem(2, "ORBIT", p_pfd);
p_pfd.addMenuItem(3, "DATA", p_pfd);
p_pfd.addMenuItem(4, "MSG RST", p_pfd);
p_pfd.addMenuItem(5, "MSG ACK", p_pfd);

p_main.addMenuItem(0, "FLT", p_pfd);
p_main.addMenuItem(1, "SUB", p_main);
p_main.addMenuItem(2, "DPS", p_ascent);
p_main.addMenuItem(3, "MAINT", p_main);
p_main.addMenuItem(4, "MSG RST", p_main);
p_main.addMenuItem(5, "MSG ACK", p_main);

var pfd_button_pushed = 0;

var updatePFD = func 
{    if(pfd_mode)
        PFD.update();
}

# update displays at nominal 5hz
var rtExec_loop = func
{
    updatePFD();
    settimer(rtExec_loop, 0.2);	 # 0.2 is 5hz
}
    
rtExec_loop();
