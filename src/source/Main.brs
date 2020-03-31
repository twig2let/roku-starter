sub Main()

    ' Comment this in to run tests.
    ' if (type(Rooibos__Init) = "Function") then Rooibos__Init()

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    m.scene = screen.CreateScene("MainScene")
    screen.show()

    executeStartupSequence()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub


function executeStartupSequence()

    ' Retrieve configuration
    config = {}

    ' Create dependencies
    parser = ParserModule(config)

    ' Get some data and parse it
    json = getData()
    content = parser.parse(json)

    ' Create main view and initialise it
    m.mainView = m.scene.createChild("MainView")
    m.mainView.callFunc("initialise", content)
end function

function getData()
  return ReadAsciiFile("pkg://source/data/stub.json")
end function
