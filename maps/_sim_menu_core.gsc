#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_sim_util;

/*
 * Entry point
 */
sim_main() {
    self thread init_globals();
    self thread load_menu_options();
    wait 0.1;
    self thread input_loop();	
}

init_globals() {
    self.menu = spawnStruct();
    self.menu.is_open = false;
    self.menu.cursor = 0;
    self.menu.depth = 0;
    self.menu.layer = [];
    self.menu.views = [];
    self.menu.active_layers = [];
    self.menu.view_count = 0;
    self.menu.selected_view = 0;
    self.menu.active_layer_count = 0;
}

load_menu_options() {

    view = "Basic Mods";
    register_view(view);
    register_op(view, "Godmode", ::godmode);
    register_op(view, "Something1", ::something);
    register_op(view, "Something2", ::something);
    register_op(view, "Something3", ::something);

    view = "View 1";
    register_view(view);
    register_op(view, "Something4", ::something);
    register_op(view, "Something5", ::something);
    register_op(view, "Something6", ::something);
    register_op(view, "Something7", ::something);

    view = "View 2";
    register_view(view);
    register_op(view, "something8", ::something);
    register_op(view, "something9", ::something);
    register_op(view, "somethingA", ::something);
    register_op(view, "somethingB", ::something);
    register_op(view, "somethingC", ::something);

    view = "View 3";
    register_view(view);
    register_op(view, "somethingD", ::something);
    register_op(view, "somethingE", ::something);
    register_op(view, "somethingF", ::something);
    register_op(view, "something10", ::something);
    register_op(view, "something11", ::something);
    register_op(view, "something12", ::something);
    register_op(view, "something13", ::something);
    register_op(view, "something14", ::something);
    register_op(view, "something15", ::something);
    register_op(view, "something16", ::something);
    register_op(view, "something17", ::something);

    view = "View 4";
    register_view(view);
    register_op(view, "something18", ::something);
    register_op(view, "something19", ::something);
    register_op(view, "something1A", ::something);
    register_op(view, "something1B", ::something);
    register_op(view, "something1C", ::something);
    register_op(view, "something1D", ::something);
    register_op(view, "something1E", ::something);
    register_op(view, "something1F", ::something);
    register_op(view, "something20", ::something);
    register_op(view, "something2A", ::something);
    register_op(view, "something2B", ::something);

    view = "View 5";
    register_view(view);
    register_op(view, "something2C", ::something);
    register_op(view, "something2D", ::something);
    register_op(view, "something2E", ::something);
    register_op(view, "something2F", ::something);
    register_op(view, "something30", ::something);
    register_op(view, "something31", ::something);
    register_op(view, "something32", ::something);
    register_op(view, "something33", ::something);
    register_op(view, "something34", ::something);
    register_op(view, "something35", ::something);
    register_op(view, "something36", ::something);
}

something() {
    self iPrintln("exec something");
}

godmode(enable) {
    if (enable) {
        self EnableInvulnerability();
        self iPrintln("Godmode: ^2ON");
    } else {
        self DisableInvulnerability();
        self iPrintln("Godmode: ^1OFF");
    }
}

register_view(view_name) {
    index = self.menu.view_count;
    
    /* Create new struct to hold view options */
    self.menu.views[index] = spawnStruct();
    self.menu.views[index].text = view_name;
    self.menu.views[index].op_count = 0;
    self.menu.views[index].ops = [];

    /* Number of views +1 */
    self.menu.view_count += 1;
}

get_view_index(view_name) {
    for (i = 0; i < self.menu.view_count; i++) {
        if (self.menu.views[i].text == view_name)
            return i;
    }
    return -1;
}

register_op(view_name, op_name, func) {
    view_index = get_view_index(view_name);
    op_index = self.menu.views[view_index].op_count;

    /* Create new option struct and add the option */
    self.menu.views[view_index].ops[op_index] = spawnStruct();
    self.menu.views[view_index].ops[op_index].text = op_name;
    self.menu.views[view_index].ops[op_index].func = func;
    self.menu.views[view_index].ops[op_index].enabled = false;

    /* Number of operations in this view +1 */
    self.menu.views[view_index].op_count++;
}

draw_menu() {
    self.menu.layer["background"] = self createRectangle("LEFT", "LEFT", -80, 0, 80, 120, (0, 0, 0), "white", 1, 0.8);
    self.menu.layer["cursor"] = self createRectangle("LEFT", "LEFT", 0, -40, 2, 17, (255, 255, 255), "white", 2, 0.8);

    /* Move background on to screen */
    self.menu.layer["background"] moveOverTime(0.15);
    self.menu.layer["background"].x += 80;

    self.menu.cursor = 0; /* Reset cursor */

    self.menu.active_layers = [];

    /* Draw views text if at menu root */
    if (self.menu.depth == 0) {
        for (i = 0; i < self.menu.view_count; i++) {
            self.menu.active_layers[i] = self createText("default", 1, "LEFT", "LEFT", 10, -40 + i*25, 3, 0, self.menu.views[i].text, root_text_col());
            /* Fade in */
            self.menu.active_layers[i] fadeOverTime(0.15);
            if (i < 4)
                self.menu.active_layers[i].alpha = 1;
        }
        self.menu.active_layer_count = self.menu.view_count;
    }
    /* Draw options text if not at menu root */
    if (self.menu.depth == 1) {
        for (i = 0; i < self.menu.views[self.menu.cursor].op_count; i++) {
            self.menu.active_layers[i] = self createText("default", 1, "LEFT", "LEFT", 10, -40 + i*25, 3, 1, self.menu.views[self.menu.cursor].ops[i].text, ops_text_col());
            /* Fade in */
            self.menu.active_layers[i] fadeOverTime(0.15);
            self.menu.active_layers[i].alpha = 1;
        }
        self.menu.active_layer_count = self.menu.views[self.menu.cursor].op_count;
    }
}

destroy_menu() {
    self.menu.layer["background"] moveOverTime(0.15);
    self.menu.layer["background"].x -= 80;

    self.menu.layer["cursor"] fadeOverTime(0.15);
    self.menu.layer["cursor"].alpha = 0;
    self.menu.layer["cursor"] moveOverTime(0.15);
    self.menu.layer["cursor"].x -= 80;

    wait 0.15;
    self.menu.layer["background"] destroy();
    self.menu.layer["cursor"] destroy();

    for (i = 0; i < self.menu.active_layer_count; i++){
        self.menu.active_layers[i] fadeOverTime(0.15);
        self.menu.active_layers[i].alpha = 0;
    }
    wait 0.15;
    for (i = 0; i < self.menu.active_layer_count; i++){
         self.menu.active_layers[i] destroy();
    }
       
}

menu_move_up() {
    /* If at root of menu */
    if (self.menu.depth == 0 && self.menu.view_count > 0) {
        if (self.menu.cursor == self.menu.view_count - 1)
            return ;
        /* Top most element fades away on scroll */
        self.menu.active_layers[self.menu.cursor] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor].alpha = 0;
        for (i = 0; i < self.menu.view_count; i++) {
            self.menu.active_layers[i] moveOverTime(0.2);
            self.menu.active_layers[i].y -= 25;
        }
        /* Bottom most element fades in on scroll - Array overrun doesn't matter */
        self.menu.active_layers[self.menu.cursor + 4] fadeOverTime(0.25);
        self.menu.active_layers[self.menu.cursor + 4].alpha = 1;
    }
    /* If NOT at root of menu */
    else {
        /* Don't overrun */
        if (self.menu.cursor == self.menu.views[self.menu.selected_view].op_count - 1)
            return ;
        /* Top most element fades away on scroll */
        self.menu.active_layers[self.menu.cursor] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor].alpha = 0;
        for (i = 0; i < self.menu.active_layer_count; i++) {
            self.menu.active_layers[i] moveOverTime(0.2);
            self.menu.active_layers[i].y -= 25;
        }
        /* Bottom most element fades in on scroll */
        self.menu.active_layers[self.menu.cursor + 4] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor + 4].alpha = 1;
    }

    self.menu.cursor++;
}

menu_move_down() {
    if (self.menu.cursor == 0)
        return ;
     /* If at root of menu */
    if (self.menu.depth == 0 && self.menu.view_count > 0) {
        /* Top most element fades in on scroll */
        self.menu.active_layers[self.menu.cursor - 1] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor - 1].alpha = 1;
        for (i = 0; i < self.menu.view_count; i++) {
            self.menu.active_layers[i] moveOverTime(0.2);
            self.menu.active_layers[i].y += 25;
        }
        /* Bottom most element fades out on scroll */
        self.menu.active_layers[self.menu.cursor + 3] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor + 3].alpha = 0;

    }
    /* If NOT at root of menu */
    else {
        /* Top most element fades in on scroll */
        self.menu.active_layers[self.menu.cursor - 1] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor - 1].alpha = 1;
        for (i = 0; i < self.menu.active_layer_count; i++) {
            self.menu.active_layers[i] moveOverTime(0.2);
            self.menu.active_layers[i].y += 25;
        }
        /* Bottom most element fades out on scroll */
        self.menu.active_layers[self.menu.cursor + 3] fadeOverTime(0.1);
        self.menu.active_layers[self.menu.cursor + 3].alpha = 0;
    }

    self.menu.cursor--;
}

menu_enter_selected_view() {
    /* Destroy text options */
    for (i = 0; i < self.menu.view_count; i++)
        self.menu.active_layers[i] destroy();

    /* Move menu off screen */
    self.menu.layer["background"] moveOverTime(0.15);
    self.menu.layer["background"].x -= 90;

    /* Draw options */
    for (i = 0; i < self.menu.views[self.menu.cursor].op_count; i++) {
        self.menu.active_layers[i] = self createText("default", 1, "LEFT", "LEFT", -40 + 10, -40 + i*25, 3, 0, self.menu.views[self.menu.cursor].ops[i].text, ops_text_col());
        self.menu.active_layers[i] moveOverTime(0.15);
        self.menu.active_layers[i] fadeOverTime(0.15);
        self.menu.active_layers[i].x += 40;
        self.menu.active_layers[i].alpha = 1;
        /* Hide overflowing layers */
        if (i >= 4) {
            self.menu.active_layers[i].alpha = 0;
        }
    }

    self.menu.active_layer_count = self.menu.views[self.menu.cursor].op_count;
        
    
    /* Move menu back onto screen */
    self.menu.layer["background"] moveOverTime(0.15);
    self.menu.layer["background"].x += 90;

    self.menu.selected_view = self.menu.cursor;

    self.menu.cursor = 0;
    self.menu.depth++;
}

menu_exit_view() {
    /* Destroy text options */
    for (i = 0; i < self.menu.active_layer_count; i++)
        self.menu.active_layers[i] destroy();

    self.menu.layer["background"] moveOverTime(0.15);
    self.menu.layer["background"].x -= 80;

    /* Draw root menu options */
    for (i = 0; i < self.menu.view_count; i++) {
        self.menu.active_layers[i] = self createText("default", 1, "LEFT", "LEFT", -40 + 10, -40 + i*25, 3, 1, self.menu.views[i].text, root_text_col());
        self.menu.active_layers[i].alpha = 0;
        self.menu.active_layers[i] moveOverTime(0.15);
        self.menu.active_layers[i] fadeOverTime(0.15);
        self.menu.active_layers[i].x += 40;
        if (i < 4)
            self.menu.active_layers[i].alpha = 1;
    }

    self.menu.layer["background"] moveOverTime(0.15);
    self.menu.layer["background"].x += 80;

    self.menu.active_layer_count = self.menu.view_count;

    self.menu.selected_view = 0;
    self.menu.cursor = 0;
    self.menu.depth--;
}

input_loop() {
    for (;;) {
        /* Scroll up in menu */
        if (self attackButtonPressed() && self.menu.is_open) {
            menu_move_up();
            wait 0.1;
        }
        /* Scroll down in menu */
        else if (self adsButtonPressed() && self.menu.is_open) {
            menu_move_down();
            wait 0.1;
        }
        /* Select in menu */
        else if (self useButtonPressed() && self.menu.is_open) {
            /* Root menu */
            if (self.menu.depth == 0) {
                menu_enter_selected_view();
            } 
            /* An option */
            else {
                /* Enable this selection */
                enabled = !self.menu.views[self.menu.selected_view].ops[self.menu.cursor].enabled;
                /* Update the enabled status */
                self.menu.views[self.menu.selected_view].ops[self.menu.cursor].enabled = enabled;
                /* Thread the function */
                self thread [[self.menu.views[self.menu.selected_view].ops[self.menu.cursor].func]](enabled);
            }
            wait 0.1;
        }

        else if (self meleeButtonPressed()) {
            /* Close menu */
            if (self.menu.is_open && self.menu.depth <= 0) {
                destroy_menu();
                self.menu.is_open = false;
            }
            /* Open menu */
            else if (!self.menu.is_open) {
                draw_menu();
                self.menu.depth = 0;
                self.menu.is_open = true;
            }
            /* Go back in menu */
            else
                menu_exit_view();
            wait 0.1;
        }

        wait 0.03;
    }
}
