import osproc, strutils, strformat, algorithm, cligen, terminaltables, os,
        sequtils, json


proc run(cmd: string): string =
    # TODO handle error
    var (output, _) = execCmdEx(cmd)
    output.stripLineEnd()
    return output


proc dbus(cmd: string): string =
    return run("qdbus org.kde.yakuake " & cmd)


proc dbusMany(cmd: string): seq[string] =
    return dbus(cmd).split(',')


type Tab = object
    title: string
    command: string
    workingDirectory: string


proc getPwd(pid: int): string =
    return run(fmt"pwdx {pid}").split(":")[1].strip()


proc getCmd(pid: int, fgpid: int): string =
    if fgpid != pid:
        return run(fmt"ps --format command --no-headers --pid {fgpid}")
    return ""


iterator getTabs(): Tab =
    for i, _ in dbusMany(fmt"/yakuake/sessions sessionIdList"):
        # in yakuake you can have multiple terminals per tab
        # yakuakep currently supports only one terminal per tab
        var sessionId = dbus(fmt"/yakuake/tabs sessionAtTab {i}")

        var terminalIdsRaw = dbusMany(fmt"/yakuake/sessions terminalIdsForSessionId {session_id}")
        # TODO how to sort by int in nim?
        var terminalIds = newSeq[int](0)
        for x in terminalIdsRaw:
            terminalIds.add(x.parseInt)
        terminalIds.sort()
        var terminalId = terminalIds[0]
        var title = dbus(fmt"/yakuake/tabs tabTitle {sessionId}")
        var sid = terminalId + 1
        var pid = dbus(fmt"/Sessions/{sid} processId").parseInt
        var fgpid = dbus(fmt"/Sessions/{sid} foregroundProcessId").parseInt
        var command = getCmd(pid, fgpid)
        var workingDirectory = getPwd(pid)
        yield Tab(command: command, workingDirectory: workingDirectory, title: title)


proc printTable(t: TerminalTable) =
    ## Docker ps style table
    t.separateRows = false
    t.style = Style(colSeparator: "\t")
    for line in splitLines(t.render()):
        if line != "":
            echo line.strip()


proc ps() =
    ## Show yakuake session
    var table = newTerminalTable()
    table.setHeaders(@["TITLE", "WORKING DIRECTORY", "COMMAND"])
    for tab in getTabs():
        table.addRow(@[tab.title, tab.workingDirectory, tab.command])
    printTable(table)
    discard


proc save() =
    ## Save yakuake session to a file
    let configDirPath = joinPath(getConfigDir(), "yakuakep")
    discard existsOrCreateDir(configDirPath)
    let tabs = toSeq(getTabs())
    let filepath = joinPath(configDirPath, "default.json")
    writeFile(filepath, $(pretty(%*tabs)))
    echo(fmt"Yakuake tabs saved successfully to {filepath}")
    discard


proc restore() =
    ## Restore yakuake session from a file
    echo "TODO restore"
    discard


when isMainModule:
    dispatchMulti([ps], [save], [restore])
