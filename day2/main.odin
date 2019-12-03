package day2

import "core:fmt"

disasm :: proc() {
    for i := 0; i < len(input); i += 4 {
        op := input[i];

        switch op {
        case 1:
            a := input[i+1];
            b := input[i+2];
            r := input[i+3];
            fmt.printf("ADD [%v] [%v] -> [%v]\n", a, b, r);
        case 2:
            a := input[i+1];
            b := input[i+2];
            r := input[i+3];
            fmt.printf("MUL [%v] [%v] -> [%v]\n", a, b, r);
        case 99:
            fmt.printf("HLT\n");
        }
    }
}

main :: proc() {
    // 1202 patch
    input[1] = 53;
    input[2] = 98;

    //disasm();

    ip := 0;

    loop:
    for {
        op := input[ip];
        switch op {
            case 1:
                a := input[ip+1];
                b := input[ip+2];
                r := input[ip+3];

                input[r] = input[a] + input[b];

                ip += 4;
            case 2:
                a := input[ip+1];
                b := input[ip+2];
                r := input[ip+3];

                input[r] = input[a] * input[b];

                ip += 4;
            case 99:
                break loop;
            case:
                fmt.panicf("Invalid opcode at %d: %v", ip, op);
        }
    }

    fmt.printf("input[0] = %v\n", input[0]);
}

input := []int{
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,6,1,19,2,19,9,23,1,23,5,27,2,6,27,31,1,31,5,35,1,35,5,39,2,39,6,43,2,43,10,47,1,47,6,51,1,51,6,55,2,55,6,59,1,10,59,63,1,5,63,67,2,10,67,71,1,6,71,75,1,5,75,79,1,10,79,83,2,83,10,87,1,87,9,91,1,91,10,95,2,6,95,99,1,5,99,103,1,103,13,107,1,107,10,111,2,9,111,115,1,115,6,119,2,13,119,123,1,123,6,127,1,5,127,131,2,6,131,135,2,6,135,139,1,139,5,143,1,143,10,147,1,147,2,151,1,151,13,0,99,2,0,14,0
};
