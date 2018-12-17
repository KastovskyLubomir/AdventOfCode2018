//
//  main.swift
//  AOC2018_16
//
//  Created by Lubomír Kaštovský on 17/12/2018.
//  Copyright © 2018 Lubomír Kaštovský. All rights reserved.
//

import Foundation

struct Registers {
    var reg: Array<Int>
}

struct CodeLine {
    var opCode: Int
    var a: Int
    var b: Int
    var c: Int
}

struct Sample {
    var before: Registers
    var codeLine: CodeLine
    var after: Registers
}

enum Opcode {
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

typealias OpcodeMapping = Dictionary<Int, Opcode>

let lines = readLinesRemoveEmpty(str: inputString)

func loadSamples(lines: Array<String>) -> Array<Sample> {
    var result = Array<Sample>()
    var i = 0
    while i < lines.count {
        let args = lines[i].components(separatedBy: [":", " ", ",", "[", "]"]).compactMap { String($0) }
        if args[0] == "Before" {
            let before = Registers(reg: [Int(args[3])!, Int(args[5])!, Int(args[7])!, Int(args[9])!])
            i += 1
            let args1 = lines[i].components(separatedBy: [" "]).compactMap { Int($0) }
            let code = CodeLine(opCode: args1[0], a: args1[1], b: args1[2], c: args1[3])
            i += 1
            let args2 = lines[i].components(separatedBy: [":", " ", ",", "[", "]"]).compactMap { String($0) }
            let after = Registers(reg: [Int(args2[4])!, Int(args2[6])!, Int(args2[8])!, Int(args2[10])!])
            result.append(Sample(before: before, codeLine: code, after: after))
        }
        i += 1
    }
    return result
}

func loadProgram(lines: Array<String>) -> Array<CodeLine> {
    var result = Array<CodeLine>()
    var i = 0
    while i < lines.count {
        let args = lines[i].components(separatedBy: [":", " ", ",", "[", "]"]).compactMap { String($0) }
        if args[0] == "Before" {
            i += 3
        } else {
            let args1 = lines[i].components(separatedBy: [" "]).compactMap { Int($0) }
            let code = CodeLine(opCode: args1[0], a: args1[1], b: args1[2], c: args1[3])
            result.append(code)
            i += 1
        }
    }
    return result
}

let allOpcodes = [Opcode.addr, Opcode.addi, Opcode.mulr, Opcode.muli, Opcode.banr, Opcode.bani,
                    Opcode.borr, Opcode.bori, Opcode.setr, Opcode.seti, Opcode.gtir, Opcode.gtri,
                    Opcode.gtrr, Opcode.eqir, Opcode.eqri, Opcode.eqrr]

func evalInstruction(opCode: Opcode, codeLine: CodeLine, registers: Registers) -> Registers {
    var resRegs = Registers(reg: registers.reg)
    switch opCode {
    case Opcode.addr:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] + registers.reg[codeLine.b]
    case Opcode.addi:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] + codeLine.b
    case Opcode.mulr:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] * registers.reg[codeLine.b]
    case Opcode.muli:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] * codeLine.b
    case Opcode.banr:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] & registers.reg[codeLine.b]
    case Opcode.bani:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] & codeLine.b
    case Opcode.borr:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] | registers.reg[codeLine.b]
    case Opcode.bori:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a] | codeLine.b
    case Opcode.setr:
        resRegs.reg[codeLine.c] = registers.reg[codeLine.a]
    case Opcode.seti:
        resRegs.reg[codeLine.c] = codeLine.a
    case Opcode.gtir:
        resRegs.reg[codeLine.c] = (codeLine.a > registers.reg[codeLine.b]) ? 1 : 0
    case Opcode.gtri:
        resRegs.reg[codeLine.c] = (registers.reg[codeLine.a] > codeLine.b) ? 1 : 0
    case Opcode.gtrr:
        resRegs.reg[codeLine.c] = (registers.reg[codeLine.a] > registers.reg[codeLine.b]) ? 1 : 0
    case Opcode.eqir:
        resRegs.reg[codeLine.c] = (codeLine.a == registers.reg[codeLine.b]) ? 1 : 0
    case Opcode.eqri:
        resRegs.reg[codeLine.c] = (registers.reg[codeLine.a] == codeLine.b) ? 1 : 0
    case Opcode.eqrr:
        resRegs.reg[codeLine.c] = (registers.reg[codeLine.a] == registers.reg[codeLine.b]) ? 1 : 0
    }
    return resRegs
}

func registersSame(reg1: Registers, reg2: Registers) -> Bool {
    for i in 0..<reg1.reg.count {
        if reg1.reg[i] != reg2.reg[i] {
            return false
        }
    }
    return true
}

func instructionsFitCount(sample: Sample) -> Int {
    var count = 0
    for instr in allOpcodes {
        let registers = evalInstruction(opCode: instr, codeLine: sample.codeLine, registers: sample.before)
        if registersSame(reg1: sample.after, reg2: registers) {
            count += 1
        }
    }
    return count
}

func samplesFitToInstructionsCount(samples: Array<Sample>, fitCount: Int) -> Int {
    var count = 0
    for sample in samples {
        if instructionsFitCount(sample: sample) >= fitCount {
            count += 1
        }
    }
    return count
}

func opcodesFitToSample(sample: Sample) -> Set<Opcode> {
    var result: Set<Opcode> = Set<Opcode>()
    for instr in allOpcodes {
        let registers = evalInstruction(opCode: instr, codeLine: sample.codeLine, registers: sample.before)
        if registersSame(reg1: sample.after, reg2: registers) {
            result.insert(instr)
        }
    }
    return result
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
    }
}

func opcodePossibleCodes(samples: Array<Sample>) -> OpcodeMapping {
    var dict = [Int:Set<Opcode>]()
    var result = OpcodeMapping()
    for sample in samples {
        let number = sample.codeLine.opCode
        let res = opcodesFitToSample(sample: sample)
        if let set = dict[number] {
            let setUnion = set.union(res)
            dict[number] = setUnion
        } else {
            dict[number] = res
        }
    }
    
    for key in dict.keys {
        var str = String(key) + ": "
        let arr = dict[key]!.compactMap { $0 }
        for a in arr {
            str += opcodeToString(opcode: a) + ", "
        }
        print(str)
    }
    
    print("-----------")
    
    var found = true
    var newDict = dict
    while found {
        dict = newDict
        found = false
        for key in dict.keys {
            if dict[key]!.count == 1 {
                found = true
                let opco = dict[key]!.first!
                print(String(key)," : ", opcodeToString(opcode: opco))
                result[key] = opco
                var ss: Set<Opcode> = Set<Opcode>()
                ss.insert(opco)
                for k in dict.keys {
                    newDict[k] = dict[k]!.subtracting(ss)
                }
                break
            }
        }
    }
    return result
}

let samples = loadSamples(lines: lines)
let program = loadProgram(lines: lines)
//print(samples)
//print(program)

print(samplesFitToInstructionsCount(samples: samples, fitCount: 3))

var opcodeMapping = opcodePossibleCodes(samples: samples)
//print(opcodeMapping)

func runProgram(code: Array<CodeLine>, opMapping: OpcodeMapping) -> Int {
    var registers = Registers(reg: [0,0,0,0])
    for line in code {
        let opcode = opMapping[line.opCode]!
        registers = evalInstruction(opCode: opcode, codeLine: line, registers: registers)
    }
    return registers.reg[0]
}

print(runProgram(code: program, opMapping: opcodeMapping))

