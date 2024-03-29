package day5

import "core:fmt"

run_once :: proc(input: []int, user_input: []int) -> int {
    //disasm();

    ip := 0;
    uip := 0;

    decode_instruction :: proc(instr: int) -> (a, b, c, op: int) {
        instr := instr;

        if instr > 0 {
            op = instr % 100;
            instr /= 100;
        }

        if instr > 0 {
            c = instr % 10;
            instr /= 10;
        }

        if instr > 0 {
            b = instr % 10;
            instr /= 10;
        }

        a = instr;

        return;
    }

    get_value :: proc(input: []int, arg, mode: int) -> int {
        return mode == 0 ? input[arg] : arg;
    }

    loop:
    for {
        instruction := input[ip];

        mode_a, mode_b, mode_c, op := decode_instruction(instruction);

        switch op {
            case 1:
                a := input[ip+1];
                b := input[ip+2];
                r := input[ip+3];

                input[r] =
                    get_value(input, a, mode_c) +
                    get_value(input, b, mode_b);

                ip += 4;
            case 2:
                a := input[ip+1];
                b := input[ip+2];
                r := input[ip+3];

                input[r] =
                    get_value(input, a, mode_c) *
                    get_value(input, b, mode_b);

                ip += 4;
            case 3:
                dst := input[ip+1];

                input[dst] = user_input[uip];
                uip += 1;

                ip += 2;
            case 4:
                src := input[ip+1];

                fmt.printf("%d\n", get_value(input, src, mode_c));

                ip += 2;
            case 5:
                cond := input[ip+1];
                dst := input[ip+2];

                if (get_value(input, cond, mode_c)) != 0 {
                    ip = get_value(input, dst, mode_b);
                } else {
                    ip += 3;
                }
            case 6:
                cond := input[ip+1];
                dst := input[ip+2];

                if (get_value(input, cond, mode_c)) == 0 {
                    ip = get_value(input, dst, mode_b);
                } else {
                    ip += 3;
                }
            case 7:
                a := input[ip+1];
                b := input[ip+2];
                dst := input[ip+3];

                input[dst] =
                    (get_value(input, a, mode_c) <
                    get_value(input, b, mode_b)) ? 1: 0;

                ip += 4;
             case 8:
                a := input[ip+1];
                b := input[ip+2];
                dst := input[ip+3];

                input[dst] =
                    (get_value(input, a, mode_c) ==
                    get_value(input, b, mode_b)) ? 1: 0;

                ip += 4;
            case 99:
                break loop;
            case:
                fmt.panicf("Invalid opcode at %d: %v", ip, op);
        }
    }

    return input[0];
}

step1 :: proc() {
    copy := input;
    run_once(copy[:], []int{1});
    fmt.println();
}


step2 :: proc() {
    fmt.printf("step2: ");
    copy := input;
    run_once(copy[:], []int{5});
    fmt.println();
}

main :: proc() {
    step1();
    step2();
}

input := [?]int{
3,225,1,225,6,6,1100,1,238,225,104,0,1101,34,7,225,101,17,169,224,1001,224,-92,224,4,224,1002,223,8,223,1001,224,6,224,1,224,223,223,1102,46,28,225,1102,66,83,225,2,174,143,224,1001,224,-3280,224,4,224,1002,223,8,223,1001,224,2,224,1,224,223,223,1101,19,83,224,101,-102,224,224,4,224,102,8,223,223,101,5,224,224,1,223,224,223,1001,114,17,224,1001,224,-63,224,4,224,1002,223,8,223,1001,224,3,224,1,223,224,223,1102,60,46,225,1101,7,44,225,1002,40,64,224,1001,224,-1792,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1101,80,27,225,1,118,44,224,101,-127,224,224,4,224,102,8,223,223,101,5,224,224,1,223,224,223,1102,75,82,225,1101,40,41,225,1102,22,61,224,1001,224,-1342,224,4,224,102,8,223,223,1001,224,6,224,1,223,224,223,102,73,14,224,1001,224,-511,224,4,224,1002,223,8,223,101,5,224,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,677,224,1002,223,2,223,1006,224,329,1001,223,1,223,1007,226,226,224,1002,223,2,223,1005,224,344,101,1,223,223,1008,226,226,224,1002,223,2,223,1006,224,359,101,1,223,223,8,226,677,224,102,2,223,223,1006,224,374,101,1,223,223,1107,677,226,224,1002,223,2,223,1005,224,389,101,1,223,223,1008,677,226,224,102,2,223,223,1006,224,404,1001,223,1,223,1108,677,677,224,102,2,223,223,1005,224,419,1001,223,1,223,1107,677,677,224,102,2,223,223,1006,224,434,1001,223,1,223,1108,226,677,224,1002,223,2,223,1006,224,449,101,1,223,223,8,677,226,224,1002,223,2,223,1005,224,464,101,1,223,223,108,226,677,224,102,2,223,223,1005,224,479,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,494,101,1,223,223,108,677,677,224,1002,223,2,223,1005,224,509,1001,223,1,223,7,677,226,224,1002,223,2,223,1006,224,524,101,1,223,223,1007,677,677,224,1002,223,2,223,1006,224,539,1001,223,1,223,107,226,226,224,102,2,223,223,1006,224,554,101,1,223,223,107,677,677,224,102,2,223,223,1006,224,569,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,584,101,1,223,223,108,226,226,224,102,2,223,223,1006,224,599,1001,223,1,223,7,226,226,224,102,2,223,223,1006,224,614,1001,223,1,223,8,226,226,224,1002,223,2,223,1006,224,629,1001,223,1,223,7,226,677,224,1002,223,2,223,1005,224,644,101,1,223,223,1108,677,226,224,102,2,223,223,1006,224,659,101,1,223,223,107,226,677,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226
};
