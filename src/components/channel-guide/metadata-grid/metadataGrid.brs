function init()
    m.metadataGrid = m.top.findNode("metadataGrid")
    m.top.content = createContentNodes()
    m.top.ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onCurrFocusColumnChanged()
end function

function createContentNodes()
    rootNode = CreateObject("roSgNode", "ContentNode")
    for each channel in ChannelGuideJSON()
        for each item in ["now", "next"]
            itemNode = rootNode.createChild("ContentNode")
            itemNode.addFields(channel[item])
            itemNode.addFields({
                isNow: item = "now"
            })
        end for
    end for

    return rootNode
end function