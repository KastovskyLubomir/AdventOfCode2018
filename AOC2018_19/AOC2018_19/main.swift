//
//  main.swift
//  AOC2018_19
//
//  Created by Lubomír Kaštovský on 19/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

typealias Registers = Array<Int>

enum Opcode {
    case unknown
    case addr
    case addi
    case mulr
    case muli
    case banr
    case bani
    case borr
    case bori
    case setr
    case seti
    case gtir
    case gtri
    case gtrr
    case eqir
    case eqri
    case eqrr
}

struct CodeLine {
    var opCode: Opcode
    var a: Int
    var b: Int
    var c: Int
}

func stringToOpcode(str: String) -> Opcode {
    switch str {
    case "addr": return Opcode.addr
    case "addi": return Opcode.addi
    case "mulr": return Opcode.mulr
    case "muli": return Opcode.muli
    case "banr": return Opcode.banr
    case "bani": return Opcode.bani
    case "borr": return Opcode.borr
    case "bori": return Opcode.bori
    case "setr": return Opcode.setr
    case "seti": return Opcode.seti
    case "gtir": return Opcode.gtir
    case "gtri": return Opcode.gtri
    case "gtrr": return Opcode.gtrr
    case "eqir": return Opcode.eqir
    case "eqri": return Opcode.eqri
    case "eqrr": return Opcode.eqrr
    default: return Opcode.unknown
    }
}

func opcodeToString(opcode: Opcode) -> String {
    switch opcode {
    case Opcode.addr: return "addr"
    case Opcode.addi: return "addi"
    case Opcode.mulr: return "mulr"
    case Opcode.muli: return "muli"
    case Opcode.banr: return "banr"
    case Opcode.bani: return "bani"
    case Opcode.borr: return "borr"
    case Opcode.bori: return "bori"
    case Opcode.setr: return "setr"
    case Opcode.seti: return "seti"
    case Opcode.gtir: return "gtir"
    case Opcode.gtri: return "gtri"
    case Opcode.gtrr: return "gtrr"
    case Opcode.eqir: return "eqir"
    case Opcode.eqri: return "eqri"
    case Opcode.eqrr: return "eqrr"
    default: return "unknown"
    }
}

func loadProgram(lines: Array<String>) -> (Array<CodeLine>, Int) {
    var ip = 0
    var result = Array<CodeLine>()
    for line in lines {
        let args = line.components(separatedBy: [" "]).compactMap { String($0) }.filter { !$0.isEmpty }
        if args[0] == "#ip" {
            ip = Int(args[1])!
        } else {
            let code = CodeLine(opCode: stringToOpcode(str: args[0]), a: Int(args[1])!, b: Int(args[2])!, c: Int(args[3])!)
            result.append(code)
        }
    }
    return (result, ip)
}

let allOpcodes = [Opcode.addr, Opcode.addi, Opcode.mulr, Opcode.muli, Opcode.banr, Opcode.bani,
                  Opcode.borr, Opcode.bori, Opcode.setr, Opcode.seti, Opcode.gtir, Opcode.gtri,
                  Opcode.gtrr, Opcode.eqir, Opcode.eqri, Opcode.eqrr]

func evalInstruction(codeLine: CodeLine, registers: Registers) -> Registers {
    var resRegs = registers
    switch codeLine.opCode {
    case .addr:
        resRegs[codeLine.c] = registers[codeLine.a] + registers[codeLine.b]
    case .addi:
        resRegs[codeLine.c] = registers[codeLine.a] + codeLine.b
    case .mulr:
        resRegs[codeLine.c] = registers[codeLine.a] * registers[codeLine.b]
    case .muli:
        resRegs[codeLine.c] = registers[codeLine.a] * codeLine.b
    case .banr:
        resRegs[codeLine.c] = registers[codeLine.a] & registers[codeLine.b]
    case .bani:
        resRegs[codeLine.c] = registers[codeLine.a] & codeLine.b
    case .borr:
        resRegs[codeLine.c] = registers[codeLine.a] | registers[codeLine.b]
    case .bori:
        resRegs[codeLine.c] = registers[codeLine.a] | codeLine.b
    case .setr:
        resRegs[codeLine.c] = registers[codeLine.a]
    case .seti:
        resRegs[codeLine.c] = codeLine.a
    case .gtir:
        resRegs[codeLine.c] = (codeLine.a > registers[codeLine.b]) ? 1 : 0
    case .gtri:
        resRegs[codeLine.c] = (registers[codeLine.a] > codeLine.b) ? 1 : 0
    case .gtrr:
        resRegs[codeLine.c] = (registers[codeLine.a] > registers[codeLine.b]) ? 1 : 0
    case .eqir:
        resRegs[codeLine.c] = (codeLine.a == registers[codeLine.b]) ? 1 : 0
    case .eqri:
        resRegs[codeLine.c] = (registers[codeLine.a] == codeLine.b) ? 1 : 0
    case .eqrr:
        resRegs[codeLine.c] = (registers[codeLine.a] == registers[codeLine.b]) ? 1 : 0
    case .unknown:
        break
    }
    return resRegs
}

func runProgram(program: Array<CodeLine>, ipPointer: Int, registers: Registers, limitCycles: Int?) -> Int {
    var maxCycles = Int.max
    if let cycles = limitCycles {
        maxCycles = cycles
    }
    var counter = 0
    var regs = registers
    var regs2 = regs
    var ip = 0
    while ((ip >= 0) && (ip < program.count)) && (counter < maxCycles) {
        regs[ipPointer] = ip
        regs2 = regs
        regs = evalInstruction(codeLine: program[ip], registers: regs)
        //if regs[0] != regs2[0] {
            print("ip:", ip, "\t", opcodeToString(opcode: program[ip].opCode),
                  program[ip].a, program[ip].b, program[ip].c, regs2,
                  "  ", regs)
        //}
        ip = regs[ipPointer]
        ip += 1
        counter += 1
    }
    /*
    print("ip:", ip, "\t", opcodeToString(opcode: program[ip].opCode),
          program[ip].a, program[ip].b, program[ip].c, regs2,
          "  ", regs)
 */
    return regs[0]
}


let lines = readLinesRemoveEmpty(str: inputString)
let program = loadProgram(lines: lines)

//print(runProgram(program: program.0, ipPointer: program.1, registers: [Int].init(repeating: 0, count: 6), limitCycles: nil))

var regs1 = [Int].init(repeating: 0, count: 6)
regs1[0] = 1

print(runProgram(program: program.0, ipPointer: program.1, registers: regs1, limitCycles: 50))


var r0 = 0
var r1 = 1
var r2 = 1
var r3 = 0
var r4 = 10551378
var r5 = 1


r5 = 1
while r5 <= r4 {
    r2 = 1
    while (r2*r5) <= r4 {
        if (r4 == (r2*r5)) {
            r0 = r5 + r0
            print(r0)
        }
        r2 = r2 + 1
    }
    r5 = r5 + 1
}

/*
for i in 1...r4 {
    if (r4 % i) == 0 {
        r0 = r0 + i
        print(r0)
    }
}
*/
print(r0)
