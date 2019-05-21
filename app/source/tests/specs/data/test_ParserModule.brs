'@TestSuite [PM] Parser Module Tests

'@BeforeEach
function PM_setUp() as void
    m.mockConfig = {}
    m.parserModule = ParserModule(m.mockConfig)
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests ParserModule is defined
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test ParserModule is defined
function PM_isDefined() as void
    m.AssertNotInvalid(m.parserModule)
end function

'@Test ParserModule interface is as expected
function PM_interface() as void
    m.AssertEqual(m.parserModule.config, m.mockConfig)
    m.AssertType(m.parserModule.parse, "roFunction")
    m.AssertType(m.parserModule._parseEntries, "roFunction")
    m.AssertType(m.parserModule._parseEntry, "roFunction")
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests Parse method
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test Parse sets the correct values on the collection node model
function PM_parseSetsValues() as void
    
    ' Given 
    mockJSON = FormatJSON({"title":"FeedTitle","summary":"Thisisthefeedsummary.","type":"collection","id":"feed_001","entries":[{"type":"video","title":"Thisisvideo1","summary":"Thisisthesummaryforvideo1.","id":"video_001"},{"type":"video","title":"Thisisvideo2","summary":"Thisisthesummaryforvideo2.","id":"video_002"},{"type":"video","title":"Thisisvideo3","summary":"Thisisthesummaryforvideo3.","id":"video_003"}]})
    parsedMockJSON = parseJSON(mockJSON)

    ' When
    parsed = m.parserModule.parse(mockJSON)

    ' Then
    m.AssertEqual(parsed.title, parsedMockJSON.title)
    m.AssertEqual(parsed.description, parsedMockJSON.summary)
    m.AssertEqual(parsed.id, parsedMockJSON.id)
    m.AssertEqual(parsed.itemType, parsedMockJSON.type)

end function


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests ParseEntries method
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test ParseEntries appends children to collectio node
function PM_parseEntriesSetsValues() as void
    
    ' Given 
    mockJSON = FormatJSON({ "entries":[{"type":"video","title":"Thisisvideo1","summary":"Thisisthesummaryforvideo1.","id":"video_001"},{"type":"video","title":"Thisisvideo2","summary":"Thisisthesummaryforvideo2.","id":"video_002"},{"type":"video","title":"Thisisvideo3","summary":"Thisisthesummaryforvideo3.","id":"video_003"}]})
    parsedMockJSON = parseJSON(mockJSON)
    mockCollectionNode = CreateObject("roSgNode", "Item")
    mockCollectionNode.type = "collection"

    ' When
    parsed = m.parserModule._parseEntries(mockCollectionNode, parsedMockJSON.entries)

    ' Then
    m.AssertEqual(parsed.getChildCount(), 3)  
    
    itemOne = parsed.getChild(0)
    itemTwo = parsed.getChild(1)
    itemThree = parsed.getChild(2)

    m.AssertEqual(itemOne.title, parsedMockJSON.entries[0].title)
    m.AssertEqual(itemTwo.description, parsedMockJSON.entries[1].summary)
    m.AssertEqual(itemThree.id, parsedMockJSON.entries[2].id)
end function


'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'@It tests ParseEntry method
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

'@Test ParseEntry sets the correct values on the video node model
'@Params[{"type":"video","title":"Thisisvideo1","summary":"Thisisthesummaryforvideo1.","id":"video_001"}]
'@Params[{"type":"","title":"","summary":"","id":""}]
'@Params[{"type":123,"title":"Satan <3","summary":"The devil inside me!","id": "video_666"}]
function PM_parseEntrySetsValues(entry) as void
    
    ' Given 
    mockJSON = FormatJSON(entry)
    parsedMockJSON = parseJSON(mockJSON)    

    ' When
    parsed = m.parserModule._parseEntry(parsedMockJSON)

    ' Then    
    m.AssertEqual(parsed.title, parsedMockJSON.title)
    m.AssertEqual(parsed.description, parsedMockJSON.summary)
    m.AssertEqual(parsed.id, parsedMockJSON.id)
end function