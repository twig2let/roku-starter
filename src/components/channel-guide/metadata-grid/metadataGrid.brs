function init()
    ? "Initialising the shadow grid"
    m.metadataGrid = m.top.findNode("metadataGrid")
    m.top.content = createContentNodes()
    m.top.setFocus(true)

    m.top.ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function


function onCurrFocusColumnChanged()

end function


function createContentNodes()
    nowNextData = [
        {
            now: {
                "period": "5:30 - 7:30pm",
                "title": "Shrek",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
            next: {
                "period": "7:30 - 8:30pm",
                "title": "Parenthood",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
        },
        {
            now: {
                "period": "5:30 - 7:30pm",
                "title": "SNL: Harry Styles",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
            next: {
                "period": "7:30 - 8:30pm",
                "title": "SNL: Justin Timberlake",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
        },
        {
            now: {
                "period": "5:30 - 7:30pm",
                "title": "Definitely Maybe",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
            next: {
                "period": "7:30 - 8:30pm",
                "title": "Love Happens",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
        },
         {
            now: {
                "period": "5:30 - 7:30pm",
                "title": "Manchester United vs Chelsea",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
            next: {
                "period": "7:30 - 8:30pm",
                "title": "Arsenal vs Liverpool",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
        },
         {
            now: {
                "period": "5:30 - 7:30pm",
                "title": "Stars of Tokyo - Simone Biles",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
            next: {
                "period": "7:30 - 8:30pm",
                "title": "The Worlds Longest Splinters",
                "synopsis": "Adipisicing ad aliquip ullamco commodo nostrud labore excepteur mollit occaecat."
            }
        }
    ]

    rootNode = CreateObject("roSgNode", "ContentNode")
    for each channel in nowNextData
        for each item in ["now", "next"]
            itemNode = rootNode.createChild("ContentNode")
            itemNode.addFields(channel[item])
            if item = "next" then itemNode.addFields({isNext: true}) else itemNode.addFields({isNext: false})
        end for
    end for

    return rootNode
end function