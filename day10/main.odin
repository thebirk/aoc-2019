package day10

import "core:fmt"
import "core:mem"
import "core:math"
import linalg "core:math/linalg"

part1 :: proc(input: string) {
    parse_input :: proc(input: string) -> ([]bool, int, int) {
        width := 0;
        w_in := input;
        for w_in[0] != '\n' {
            width += 1;
            w_in = w_in[1:];
        }

        result: [dynamic]bool;
        input := input;
        y := 0;
        for input != "" {
            for x in 0..<width {
                append(&result, input[0] == '#' ? true : false);
                input = input[1:];
            }
            if input != "" do input = input[1:];
            y += 1;
        }

        return result[:], width, y;
    };

    cast_ray :: proc(m: []bool, m_w, m_h: int, start: [2]f32, dir: [2]f32) -> (bool, int, int) {
        pos := start + dir;
        dir := linalg.normalize(dir) / 1024.0;

        for {
            if pos.x < 0 || pos.x >= f32(m_w) || pos.y < 0  || pos.y >= f32(m_h) do return false, 0, 0;

            if m[int(pos.x)+int(pos.y)*m_w] == true {
                centre := [2]f32{math.floor(pos.x) + 0.5, math.floor(pos.y) + 0.5};

                if linalg.length(centre - pos) < 0.1 {
                    return true, int(pos.x), int(pos.y);
                }
            }

            pos += dir;
        }

        return false, 0, 0;
    }

    m, w, h := parse_input(input);

    best_visible_asteroids := -1;
    best_pos := [2]int{0, 0};

    marked_map := make([]bool, w*h);
    totals := make([]int, w*h);

    SUBDIVISIONS :: 1000;
    angle_step := f32(math.PI*2 / SUBDIVISIONS);
    angle_cos := math.cos(angle_step);
    angle_sin := math.sin(angle_step);

    for y in 0..<h {
        for x in 0..<w {
            if m[x+y*w] == false do continue;

            visible_asteroids := 0;

            marked_map[x+y*w] = true;

            pos := [2]f32{f32(x)+0.5, f32(y)+0.5};
            dir := [2]f32{1, 0};
            for i in 0..<SUBDIVISIONS {
                hit, hx, hy := cast_ray(m, w, h, pos, dir);
                if hit && marked_map[hx+hy*w] == false {
                    visible_asteroids += 1;
                    marked_map[hx+hy*w] = true;
                }

                dir = {
                    f32(dir.x) * angle_cos - f32(dir.y) * angle_sin,
                    f32(dir.x) * angle_sin + f32(dir.y) * angle_cos
                };
            }

            if visible_asteroids > best_visible_asteroids {
                best_visible_asteroids = visible_asteroids;
                best_pos = {x, y};
            }

            totals[x+y*w] = visible_asteroids;
            mem.zero_slice(marked_map);
        }
    }

    for y in 0..<h {
        for x in 0..<w {
            if totals[x+y*w] == 0 do fmt.printf(".");
            else do fmt.printf("%v", totals[x+y*w]);
        }
        fmt.println();
    }

    // (30, 34), 344

    if best_visible_asteroids != -1 {
        fmt.printf("part1: asteroid at (%v, %v) is best suited with %v observable asteroids\n", best_pos.x, best_pos.y, best_visible_asteroids);
    } else {
        fmt.println("part1: didnt find any suitable asteroid wtf?");
    }
}

part2 :: proc(input: string) {

}

main :: proc() {
    part1(`.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##`);
    //part2(input);
}

input := `....#.....#.#...##..........#.......#......
.....#...####..##...#......#.........#.....
.#.#...#..........#.....#.##.......#...#..#
.#..#...........#..#..#.#.......####.....#.
##..#.................#...#..........##.##.
#..##.#...#.....##.#..#...#..#..#....#....#
##...#.............#.#..........#...#.....#
#.#..##.#.#..#.#...#.....#.#.............#.
...#..##....#........#.....................
##....###..#.#.......#...#..........#..#..#
....#.#....##...###......#......#...#......
.........#.#.....#..#........#..#..##..#...
....##...#..##...#.....##.#..#....#........
............#....######......##......#...#.
#...........##...#.#......#....#....#......
......#.....#.#....#...##.###.....#...#.#..
..#.....##..........#..........#...........
..#.#..#......#......#.....#...##.......##.
.#..#....##......#.............#...........
..##.#.....#.........#....###.........#..#.
...#....#...#.#.......#...#.#.....#........
...####........#...#....#....#........##..#
.#...........#.................#...#...#..#
#................#......#..#...........#..#
..#.#.......#...........#.#......#.........
....#............#.............#.####.#.#..
.....##....#..#...........###........#...#.
.#.....#...#.#...#..#..........#..#.#......
.#.##...#........#..#...##...#...#...#.#.#.
#.......#...#...###..#....#..#...#.........
.....#...##...#.###.#...##..........##.###.
..#.....#.##..#.....#..#.....#....#....#..#
.....#.....#..............####.#.........#.
..#..#.#..#.....#..........#..#....#....#..
#.....#.#......##.....#...#...#.......#.#..
..##.##...........#..........#.............
...#..##....#...##..##......#........#....#
.....#..........##.#.##..#....##..#........
.#...#...#......#..#.##.....#...#.....##...
...##.#....#...........####.#....#.#....#..
...#....#.#..#.........#.......#..#...##...
...##..............#......#................
........................#....##..#........#`;
