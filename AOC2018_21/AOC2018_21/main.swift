//
//  main.swift
//  AOC2018_21
//
//  Created by Lubomír Kaštovský on 21/12/2018.
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
        //print("ip:", ip, "\t", opcodeToString(opcode: program[ip].opCode),
        //      program[ip].a, program[ip].b, program[ip].c, regs2,
        //      "  ", regs)
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
    return counter
}


let lines = readLinesRemoveEmpty(str: inputString)
let program = loadProgram(lines: lines)

//print(runProgram(program: program.0, ipPointer: program.1, registers: [Int].init(repeating: 0, count: 6), limitCycles: nil))

/*
var regs1 = [Int].init(repeating: 0, count: 6)
regs1[0] = 1
print(runProgram(program: program.0, ipPointer: program.1, registers: regs1, limitCycles: 100))
*/

/*
let cycleLimit = 100000
for i in 0..<10000 {
    var regs = [Int].init(repeating: 0, count: 6)
    regs[0] = i
    let counter = runProgram(program: program.0, ipPointer: program.1, registers: regs, limitCycles: cycleLimit)
    if counter < cycleLimit {
        print(i, counter)
    }
    if (i % 100) == 0 {
        print(i)
    }
}
*/


func rewritenCode(reg0: Int) -> Dictionary<Int, Int> {
    var results = Dictionary<Int, Int>()
    var counter = 0
    var reg = [Int].init(repeating: 0, count: 6)
    reg[0] = reg0
    
    reg[5] = 123
    while reg[5] != 72 {
        reg[5] = reg[5] & 456
    }

    reg[5] = 0
    repeat {
        counter += 1
        reg[4] = 0x10000 | reg[5]
        reg[5] = 0xc8ccc9
        repeat {
            reg[3] = reg[4] & 0xff
            reg[5] = reg[3] + reg[5]
            reg[5] = reg[5] & 0xffffff
            reg[5] = reg[5] * 0x1016b
            reg[5] = reg[5] & 0xffffff
            
            if 256 <= reg[4] {
                /*
                reg[3] = 0
                repeat {
                    reg[2] = reg[3] + 1
                    reg[2] = reg[2] * 256
                    if reg[2] > reg[4] {
                        break
                    }
                    reg[3] = reg[3] + 1
                } while true
                reg[4] = reg[3]
                */
                
                // replaced by
                reg[4] = reg[4] / 256
            } else {
                break
            }
            
        } while true
        
        /*
        // solution 1
        print(reg[5])
        break
        */
        
        if results.keys.contains(reg[5]) {
            break
        }
        else {
            results[reg[5]] = counter
        }
        
    } while (reg[5] != reg[0])
    
    return results
}

let res = rewritenCode(reg0: 0)
//print(res)
print(res.count)

var max = 0
var result = 0
for key in res.keys {
    if let x = res[key] {
        if x > max {
            result = key
            max = x
        }
    }
}
print(result)

/*
var max = 0
var stooper = 0
for key in res.keys {
    var regs = [Int].init(repeating: 0, count: 6)
    regs[0] = key
    let counter = runProgram(program: program.0, ipPointer: program.1, registers: regs, limitCycles: nil)
    print("stopper:", key, "after instructions: ", counter)
    if counter > max {
        stooper = key
        max = counter
    }
}

print(max)
*/
