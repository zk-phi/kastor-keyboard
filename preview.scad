module keyboard () {
  translate([0, 0, 7 + 5]) import("top-plate/switch42.stl");
  translate([0, 0, 7]) import("pcb/switch42.stl");
  import("bottom-plate/switch42.stl");
}

keyboard();
translate([250, 0, 0]) mirror([1, 0]) keyboard();