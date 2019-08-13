$fn = 100;

$unit_h = 19.05; // DONE
$unit_v = 19.05; // DONE
$pcb_grid = 0.297658; // DONE

$100mil = 2.54;

// ---- screw hole size
$screw_hole = (2 + 0.1) / 2;

// ---- wall size
$kadomaru_r = 2;
$pcb_slop = 0.5;
$wall_thickness = 5 + $pcb_slop;
$screw_position = ($wall_thickness + $pcb_slop) / 2;

// ---- top plate placements
$switch_hole = 14;

// ---- bottom plate placements
$slop = 1.5;
$promicro_height  = 7 * $100mil;
$promicro_width = 13 * $100mil;
$trrs_height = 6 + 5 * $pcb_grid; // DONE
$trrs_width = 12.1;
$reset_height = 8; // DONE
$reset_width = 3.5; // DONE
$promicro_contact_height = 13; // incl. slop, not in the datasheet

// ---- positions
$pcb_width = 6.50 * $unit_h; // DONE
$promicro_y = 2.5 * $unit_v; // DONE
$promicro_x_left = $promicro_width / 2 - 13 * $pcb_grid; // DONE
$promicro_x_right = $promicro_x_left; // DONE
$trrs_y = 3 * $unit_v + 2.5 * $pcb_grid; // DONE
$trrs_x = - 10 * $pcb_grid; // DONE
$reset_y = 2.5 * $unit_v - 5 * $pcb_grid; // DONE
$reset_x = 6.25 * $unit_h + 4 * $pcb_grid; // DONE

// ---- case shape

// DONE
module shape (pad = 0, right = false) {
    polygon([
        // clockwise from the left bottom
        [               - pad,                            $unit_v - pad],
        [               - pad,                        4 * $unit_v + pad],
        [6.50 * $unit_h + pad,                        4 * $unit_v + pad],
        [6.50 * $unit_h + pad,                            $unit_v - pad],
    ]);
}

module shape_top (pad = 0, right = false) {
    polygon(concat(
        // clockwise from the left bottom
        [
            [               - pad,                            $unit_v - pad],
        ],
        right ? [
            [               - pad,                        2 * $unit_v - pad],
            [0.25 * $unit_h - pad,                        2 * $unit_v - pad],
            [0.25 * $unit_h - pad,                        3 * $unit_v - pad],
            [               - pad,                        3 * $unit_v - pad],
        ] : [],
        [
            [               - pad,                        4 * $unit_v + pad],
        ],
        !right ? [
            [6.00 * $unit_h + pad,                        4 * $unit_v + pad],
            [6.00 * $unit_h + pad,                        3 * $unit_v + pad],
            [6.25 * $unit_h + pad,                        3 * $unit_v + pad],
            [6.25 * $unit_h + pad,                        2 * $unit_v + pad],
            [6.50 * $unit_h + pad,                        2 * $unit_v + pad],
        ] : [
            [6.50 * $unit_h + pad,                        4 * $unit_v + pad],
        ],
        [
            [6.50 * $unit_h + pad,                            $unit_v - pad],
        ]
    ));
}

// DONE
module shape_pcb (pad = 0, right = false) {
    if (right) {
        translate([6.5 * $unit_h, 0, 0]) mirror([1, 0, 0]) shape_pcb(pad);
    } else {
    polygon([
        // clockwise from the left bottom
        [               - pad,                          $unit_v - pad],
        // promicro
        [               - pad,                        2 * $unit_v - pad - $pcb_grid * 11],
        [               - pad - 13 * $pcb_grid,       2 * $unit_v - pad + $pcb_grid *  2],
        [               - pad - 13 * $pcb_grid,       3 * $unit_v + pad - $pcb_grid *  2],
        [               - pad,                        3 * $unit_v + pad + $pcb_grid * 11],
        // ----
        [               - pad,                        4 * $unit_v + pad],
        [6.50 * $unit_h + pad,                        4 * $unit_v + pad],
        // trrs
        [6.50 * $unit_h + pad,                        3 * $unit_v + pad + $pcb_grid * 25],
        [6.50 * $unit_h + pad + 10 * $pcb_grid,       3 * $unit_v + pad + $pcb_grid * 15],
        [6.50 * $unit_h + pad + 10 * $pcb_grid,       3 * $unit_v - pad - $pcb_grid * 10],
        [6.50 * $unit_h + pad,                        3 * $unit_v - pad - $pcb_grid * 20],
        // ----
        [6.50 * $unit_h + pad,                            $unit_v - pad],
    ]);
    }
}

// DONE
module switch_pos (right = false, scale = false) {
    switch_positions = !right ? [
        [3, 0.00, 0.00], [3, 1.00, 0], [3, 2.00, 0], [3, 3.00, 0], [3, 4.00, 0], [3, 5.00, 0],
        [2, 0.00, 0.25], [2, 1.25, 0], [2, 2.25, 0], [2, 3.25, 0], [2, 4.25, 0], [2, 5.25, 0],
        [1, 0.00, 0.50], [1, 1.50, 0], [1, 2.50, 0], [1, 3.50, 0], [1, 4.50, 0], [1, 5.50, 0],
    ] : [
        [3, 0.00, 0.00], [3, 1.00, 0], [3, 2.00, 0], [3, 3.00, 0], [3, 4.00, 0], [3, 5.00, 0.50],
        [2, 0.25, 0.00], [2, 1.25, 0], [2, 2.25, 0], [2, 3.25, 0], [2, 4.25, 0], [2, 5.25, 0.25],
        [1, 0.00, 0.00], [1, 1.00, 0], [1, 2.00, 0], [1, 3.00, 0], [1, 4.00, 0], [1, 5.00, 0.50],
    ];
    for (pos = switch_positions)
        translate([(pos[1] + 0.5) * $unit_h, (pos[0] + 0.5) * $unit_v])
            translate([pos[2] / 2 * $unit_h, 0])
                scale([scale ? pos[2] + 1 : 1, 1, 1])
                    children();
}

// DONE
module skrew_pos (right = false) {
    // clockwise from the left bottom
    translate([               - $screw_position,     $unit_v - $screw_position]) children();
    translate([               - $screw_position, 4 * $unit_v + $screw_position]) children();
    translate([3.25 * $unit_h,                   4 * $unit_v + $screw_position]) children();
    translate([6.50 * $unit_h + $screw_position, 4 * $unit_v + $screw_position]) children();
    translate([6.50 * $unit_h + $screw_position,     $unit_v - $screw_position]) children();
    translate([3.25 * $unit_h + $screw_position,     $unit_v - $screw_position]) children();
    // promicro, trrs
    if (!right) {
        translate([               - $screw_position, 2.5 * $unit_v - $screw_position - 39 * $pcb_grid]) children();
        translate([               - $screw_position, 2.5 * $unit_v + $screw_position + 39 * $pcb_grid]) children();
        translate([6.50 * $unit_h + $screw_position, 2.5 * $unit_v + $screw_position + 53 * $pcb_grid]) children();
        translate([6.50 * $unit_h + $screw_position, 2.5 * $unit_v - $screw_position + 16 * $pcb_grid]) children();
    } else {
        translate([6.50 * $unit_h + $screw_position, 2.5 * $unit_v - $screw_position - 39 * $pcb_grid]) children();
        translate([6.50 * $unit_h + $screw_position, 2.5 * $unit_v + $screw_position + 39 * $pcb_grid]) children();
        translate([               - $screw_position, 2.5 * $unit_v + $screw_position + 53 * $pcb_grid]) children();
        translate([               - $screw_position, 2.5 * $unit_v - $screw_position + 16 * $pcb_grid]) children();
    }
}

module promicro (right, pins_only = false) {
    offset = pins_only ? $100mil : 0;
    x_pos = right ? $pcb_width - $promicro_x_right - offset / 2 : $promicro_x_left + offset / 2;
    width = $promicro_width - offset;
    translate([x_pos, $promicro_y])
        square([width + $slop, $promicro_height + $slop], center = true);
}

module promicro_contact (right) {
    x_pos = right ? $pcb_width + $wall_thickness / 2 : - $wall_thickness / 2;
    translate([x_pos, $promicro_y])
        square([$wall_thickness, $promicro_contact_height], center = true);
}

module trrs_contact (right) {
    x_pos = right ? - $wall_thickness / 2 : $pcb_width + $wall_thickness / 2;
    translate([x_pos, $trrs_y])
        square([$wall_thickness, $trrs_height + $slop], center = true);
}

module trrs (right) {
    x_pos = right ? $trrs_x + $trrs_width / 2 : $pcb_width - $trrs_x - $trrs_width / 2;
    translate([x_pos, $trrs_y])
        square([$trrs_width + $slop, $trrs_height + $slop], center = true);
}

module reset_sw (right) {
    translate([right ? $pcb_width - $reset_x : $reset_x, $reset_y])
        square([$reset_width + $slop, $reset_height + $slop], center = true);
}

module reset_tsumayouji (right) {
    translate([right ? $pcb_width - $reset_x : $reset_x, $reset_y])
        circle(d = 2);
}

// ---- model

module kadomaru (r) {
    offset (r = r) offset (r = -r)  children();
}

module skrew_holes (right = false) {
    skrew_pos(right) circle(r = $screw_hole);
}

module switch_holes (right) {
    switch_pos(right) square([$switch_hole, $switch_hole], center = true);
}

module bottomplate (right = false) {
    difference () {
        kadomaru($kadomaru_r) difference () {
            shape($wall_thickness, right);
            trrs_contact(right);
            promicro_contact(right);
        }
        promicro(right);
        trrs(right);
        reset_sw(right);
        skrew_holes(right);
    }
}

module bottomplate2 (right = false) {
    difference () {
        kadomaru($kadomaru_r) shape($wall_thickness, right);
        skrew_holes(right);
        reset_tsumayouji(right);
    }
}

module topplate (right = false) {
    difference () {
        kadomaru($kadomaru_r) shape($wall_thickness, right);
        switch_holes(right);
        skrew_holes(right);
    }
}

module lower_topplate (right = false) {
    difference () {
        kadomaru($kadomaru_r) shape($wall_thickness, right);
        switch_holes(right);
        promicro(right, true);
        trrs(right);
        reset_sw(right);
        skrew_holes(right);
    }
}

module middleframe (right = false) {
    difference () {
        kadomaru($kadomaru_r) difference () {
            shape($wall_thickness, right);
            trrs_contact(right);
            promicro_contact(right);
        }
        shape_pcb($pcb_slop, right);
        skrew_holes(right);
    }
}

module lower_middleframe (right = false) {
    difference () {
        kadomaru($kadomaru_r) difference () {
            shape($wall_thickness, right);
            trrs_contact(right);
            promicro_contact(right);
        }
        switch_holes(right);
        promicro(right);
        trrs(right);
        reset_sw(right);
        skrew_holes(right);
    }
}

module topframe (right = false) {
    difference () {
        kadomaru($kadomaru_r) shape($wall_thickness, right);
        shape_top($pcb_slop, right);
        skrew_holes(right);
    }
}

// ---- preview model

$acryl_color = [1, 1, 1, 0.7];

module single_keycap () {
    hull () {
        translate([0, 0, 6]) cube([13, 13, 0.001], center = true);
        cube([18.5, 18.5, 0.001], center = true);
    }
}

module preview_keycap (right) {
    switch_pos(right, true) single_keycap();
}

module preview_pcb_kicad (right = false) {
    if (right) {
        translate([6 * $unit_h, 3.5 * $unit_v, 0])
            rotate([0, 180, 0])
                import("../pcb/switch42-right.stl");
    } else {
        translate([0.5 * $unit_h, 3.5 * $unit_v, 1.6])
            import("../pcb/switch42-left.stl");
    }
}

module preview_pcb (right = false) {
    shape_pcb(0, right);
}

module preview (diff = 0, right = false) {
    // 1.2mm pcb
    // - pcb bottom must be placed at least z >= 6.6 (2.5 + 2.5 + 1.6 .. promicro thicc)
    // - distance between pcb top and plate top is 5mm (MX)
    // - pcb bottom position will be [(topplate_pos + topplate_thickness) - 5mm - 1.2mm]
    // - thus [topplate_pos + 3mm - 5mm - 1.2mm >= 6.6mm]
    // - thus [topplate_pos >= 6.6mm - 3mm + 5mm + 1.2mm = 9.8mm
    // - when topplate_pos = 10mm (> 9.8) then pcb_pos = 10mm - 2mm - 1.2mm = 6.8mm
    // -------------
    // corne's plate top = 1.6 + 6.5 + 1.6 = 9.7
    // kator's plate top = 10 + 3 = 13
    // -------------
    // - minimum distance between pcb top and bottomplate top is 3.3mm (MX)
    // - minimum distance between pcb bottom and bottomplate top is 3.3 - 1.2 = 2.1mm
    // - when pcb_pos = 6.8 then bottomplate top < 4.7
    translate([0, 0, 20 - (1.6 - 1.2) + diff * 4]) color([0.6, 0.8, 1.0]) preview_keycap(right);
    translate([0, 0, 13 + diff * 5]) color($acryl_color) linear_extrude(4) topframe(right);
    translate([0, 0, 10 + diff * 4]) color($acryl_color) linear_extrude(3) topplate(right);
//    translate([0, 0, 6.8 + diff * 4]) color([.3, .3, .3]) linear_extrude(1.2) preview_pcb(right);
    translate([0, 0, 6.8 + diff * 4]) color([.3, .3, .3]) preview_pcb_kicad(right);
    translate([0, 0, 8 + diff * 3]) color($acryl_color) linear_extrude(2) lower_topplate(right);
    translate([0, 0, 6 + diff * 2]) color($acryl_color) linear_extrude(2) middleframe(right);
    translate([0, 0, 3 + diff]) color($acryl_color) linear_extrude(3) lower_middleframe(right);
    translate([0, 0, 0]) color($acryl_color) linear_extrude(3) bottomplate(right);
//    translate([0, 0, -2 - diff]) color($acryl_color) linear_extrude(2) bottomplate2(right);
}

// ---- cut model

module middleframe_lower (right) {
    intersection () {
        middleframe(right);
        translate([- $wall_thickness, - $wall_thickness - $pcb_grid * 23])
            square([7.25 * $unit_h + $wall_thickness * 2,  2.5 * $unit_v + ($wall_thickness + $pcb_grid * 23)]);
    }
}

module middleframe_upper (right) {
    difference () {
        middleframe(right);
        translate([- $wall_thickness, - $wall_thickness - $pcb_grid * 23])
            square([7.25 * $unit_h + $wall_thickness * 2,  2.5 * $unit_v + ($wall_thickness + $pcb_grid * 23)]);
    }
}

margin = 3;
pitch_v = $unit_v * 3 + $wall_thickness * 2 + margin;
pitch_h = $unit_h * 6.5 + $wall_thickness * 2 + margin;

module pos_plate () {
    translate([$wall_thickness, - $unit_h + $wall_thickness]) children();
}

module acryl_2mm (guide = false) {
    difference () {
        if (guide) square([300, 300]);
        translate([margin, margin]) {
            translate([          0,           0]) pos_plate() middleframe(false);
            translate([          0, pitch_v * 1]) pos_plate() lower_topplate(false);
            translate([          0, pitch_v * 2]) pos_plate() topframe(false);
            translate([          0, pitch_v * 3]) pos_plate() topframe(false);
            translate([pitch_h * 1, pitch_v * 0]) pos_plate() middleframe(true);
            translate([pitch_h * 1, pitch_v * 1]) pos_plate() lower_topplate(true);
            translate([pitch_h * 1, pitch_v * 2]) pos_plate() topframe(true);
            translate([pitch_h * 1, pitch_v * 3]) pos_plate() topframe(true);
        }
    }
}

module acryl_3mm (guide = false) {
    difference () {
        if (guide) square([300, 300]);
        translate([margin, margin]) {
            translate([          0,           0]) pos_plate() bottomplate(false);
            translate([          0, pitch_v * 1]) pos_plate() lower_middleframe(false);
            translate([          0, pitch_v * 2]) pos_plate() topplate(false);
            translate([          0, pitch_v * 3]) pos_plate() middleframe(false); // spare
            translate([pitch_h * 1, pitch_v * 0]) pos_plate() bottomplate(true);
            translate([pitch_h * 1, pitch_v * 1]) pos_plate() lower_middleframe(true);
            translate([pitch_h * 1, pitch_v * 2]) pos_plate() topplate(true);
            translate([pitch_h * 1, pitch_v * 3]) pos_plate() middleframe(true); // spare
        }
    }
}

preview(0);
translate([160, 0, 0]) preview(0, right = true);
//acryl_2mm(true);
//acryl_3mm(true);
