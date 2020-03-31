' @Namespace ParserModule
function ParserModule(config as Object)
    logMethod("ParserModule Constructor")

    return {
        ' dependencies
        config: config

        ' public
        parse: PM_parse

        ' private
        _parseEntries: PM_parseEntries
        _parseEntry: PM_parseEntry
    }
end function


' /**
'  * 
'  * @member parse
'  * @memberof ParserModule
'  * @description Takes a raw data string and returns a collection of item nodes
'  * @param {string} data - A string of text data
'  * @return {node} A node of content nodes
'  *
'  */
function PM_parse(json as string)
    logMethod("PM_parse")
    feed = ParseJSON(json)

    node = CreateObject("roSGNode", "Item")
    node.itemType = feed.type

    if type(feed.title) = "String"
        node.title = feed.title
    end if

    if type(feed.summary) = "String"
        node.description = feed.summary
    end if

    if type(feed.id) = "String"
        node.id = feed.id
    end if

    m._parseEntries(node, feed.entries)

    return node    
end function

' /**
'  * 
'  * @member parseEntries
'  * @memberof ParserModule
'  * @description Loops through collection entry items
'  * @param {node} node - Collection model node 
'  * @param {object} entries - Feed entries array
'  * @return {node} A node of content nodes
'  *
'  */
function PM_parseEntries(node as Object, entries as Object) as Object
    
    entryNodes = []
    for each entry in entries
        entryNodes.push(m._parseEntry(entry))
    end for

    node.appendChildren(entryNodes)

    return node
end function

' /**
'  * 
'  * @member parseEntry
'  * @memberof ParserModule
'  * @description Creates a video model item for each entry
'  * @param {object} data - Collection entry items
'  * @return {node} A node of content nodes
'  *
'  */
function PM_parseEntry(entry as Object) as Object
    node = CreateObject("roSGNode", "Item")
    node.itemType = entry.type

    if type(entry.title) = "String"
        node.title = entry.title
    end if

    if type(entry.summary) = "String"
        node.description = entry.summary
    end if

    if type(entry.id) = "String"
        node.id = entry.id
    end if

    return node
end function