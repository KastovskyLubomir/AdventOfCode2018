
/*
 
 --- Day 4: Repose Record ---
 
 You've sneaked into another supply closet - this time, it's across from the prototype suit manufacturing lab. You need to sneak inside and fix the issues with the suit, but there's a guard stationed outside the lab, so this is as close as you can safely get.
 
 As you search the closet for anything that might help, you discover that you're not the first person to want to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past few months secretly observing this guard post! They've been writing down the ID of the one guard on duty that night - the Elves seem to have decided that one guard was enough for the overnight shift - as well as when they fall asleep or wake up while at their post (your puzzle input).
 
 For example, consider the following records, which have already been organized into chronological order:
 
 [1518-11-01 00:00] Guard #10 begins shift
 [1518-11-01 00:05] falls asleep
 [1518-11-01 00:25] wakes up
 [1518-11-01 00:30] falls asleep
 [1518-11-01 00:55] wakes up
 [1518-11-01 23:58] Guard #99 begins shift
 [1518-11-02 00:40] falls asleep
 [1518-11-02 00:50] wakes up
 [1518-11-03 00:05] Guard #10 begins shift
 [1518-11-03 00:24] falls asleep
 [1518-11-03 00:29] wakes up
 [1518-11-04 00:02] Guard #99 begins shift
 [1518-11-04 00:36] falls asleep
 [1518-11-04 00:46] wakes up
 [1518-11-05 00:03] Guard #99 begins shift
 [1518-11-05 00:45] falls asleep
 [1518-11-05 00:55] wakes up
 Timestamps are written using year-month-day hour:minute format. The guard falling asleep or waking up is always the one whose shift most recently started. Because all asleep/awake times are during the midnight hour (00:00 - 00:59), only the minute portion (00 - 59) is relevant for those events.
 
 Visually, these records show that the guards are asleep at these times:
 
 Date   ID   Minute
 000000000011111111112222222222333333333344444444445555555555
 012345678901234567890123456789012345678901234567890123456789
 11-01  #10  .....####################.....#########################.....
 11-02  #99  ........................................##########..........
 11-03  #10  ........................#####...............................
 11-04  #99  ....................................##########..............
 11-05  #99  .............................................##########.....
 The columns are Date, which shows the month-day portion of the relevant day; ID, which shows the guard on duty that day; and Minute, which shows the minutes during which the guard was asleep within the midnight hour. (The Minute column's header shows the minute's ten's digit in the first row and the one's digit in the second row.) Awake is shown as ., and asleep is shown as #.
 
 Note that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.
 
 If you can figure out the guard most likely to be asleep at a specific time, you might be able to trick that guard into working tonight so you can have the best chance of sneaking in. You have two strategies for choosing the best guard/minute combination.
 
 Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?
 
 In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while Guard #99 only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas any other minute the guard was asleep was only seen on one day).
 
 While this example listed the entries in chronological order, your entries are in the order you found them. You'll need to organize them before they can be analyzed.
 
 What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 10 * 24 = 240.)
 
 Your puzzle answer was 143415.
 
 --- Part Two ---
 
 Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?
 
 In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three times in total. (In all other cases, any guard spent any minute asleep at most twice.)
 
 What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 99 * 45 = 4455.)
 
 Your puzzle answer was 49944.
 
 */


let lines = readLinesRemoveEmpty(str: inputString)

func sort(array: Array<String>) -> Array<(String,String)> {
    let separatedDates = array.map { $0.components(separatedBy: ["[","]"]).compactMap { String($0) }.filter { $0 != ""} }
    var sortedDates = [(String, String)]()
    for x in separatedDates {
        sortedDates.append((x[0], x[1]))
    }
    sortedDates = sortedDates.sorted { a, b in
        return a.0 < b.0
    }
    return sortedDates
}

var sorted = sort(array: lines)

func sleep(dates: Array<(String, String)>) -> Dictionary<String, Array<(String, String)>> {
    
    var result = [String:[(String, String)]]()
    var guardNo = ""
    var falls = ""
    var wakes = ""
    for x in dates {
        let args = x.1.components(separatedBy: [" ", ]).compactMap { String($0)}.filter { $0 != ""}
        if args[0] == "Guard" {
            guardNo = args[1]
        }
        
        if args[0] == "falls" {
            let aaa = x.0.components(separatedBy: [" "])
            falls = aaa[1]
        }
        
        if args[0] == "wakes" {
            let aaa = x.0.components(separatedBy: [" "])
            wakes = aaa[1]
            if result[guardNo] == nil {
                result[guardNo] = [(falls, wakes)]
            } else {
                result[guardNo]?.append((falls,wakes))
            }
        }
    }
    return result
}

let sleepIntervals = sleep(dates: sorted)

func sumSleep(sleep: Array<(String, String)>) -> Int {
    var sum = 0
    for x in sleep {
        let a = x.0.components(separatedBy: [":"])
        let b = x.1.components(separatedBy: [":"])
        sum += Int(b[1])! - Int(a[1])!
    }
    return sum
}

func sleptMost(input: Dictionary<String, Array<(String, String)>>) -> String {
    var longestSleep = 0
    var guardNo = ""
    for key in input.keys {
        let sum = sumSleep(sleep: input[key]!)
        if sum > longestSleep {
            guardNo = key
            longestSleep = sum
        }
    }
    return guardNo
}

func bestMinute(sleep: Array<(String, String)>) -> (Int, Int) {
    var minute: Dictionary<Int, Int> = [:]
    for x in sleep {
        let a = x.0.components(separatedBy: [":"])
        let b = x.1.components(separatedBy: [":"])
        for i in Int(a[1])!..<Int(b[1])! {
            if minute[i] == nil {
                minute[i] = 1
            }
            else {
                minute[i] = minute[i]! + 1
            }
        }
    }
    var best = 0
    var time = 0
    for key in minute.keys {
        if minute[key]! > time {
            best = key
            time = minute[key]!
        }
    }
    return (best, time)
}

let guardSleptMost = Int(String(Array(sleptMost(input: sleepIntervals)).filter { $0 != "#"}))!
let topMinute = bestMinute(sleep: sleepIntervals[sleptMost(input: sleepIntervals)]!).0

print("1. result: ", topMinute*guardSleptMost)

func mostFrequentMinute(intervals: Dictionary<String, Array<(String, String)>>) -> (Int, Int) {
    var guardNo = ""
    var bMinute = 0
    var time = 0
    for key in sleepIntervals.keys {
        let bbb = bestMinute(sleep: sleepIntervals[key]!)
        if bbb.1 > time {
            bMinute = bbb.0
            time = bbb.1
            guardNo = key
        }
    }
    let gNo = Int(String(Array(guardNo).filter { $0 != "#"}))!
    return (gNo, bMinute)
}

let res = mostFrequentMinute(intervals: sleepIntervals)
print("2. result: ", res.0 * res.1)
