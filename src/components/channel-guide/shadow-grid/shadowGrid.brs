function init()
    m.top.content = createContentNodes()
end function

function createContentNodes()    
    rootNode = CreateObject("roSgNode", "ContentNode")
    for each channel in ChannelGuideJSON()
        for each item in ["now", "next"]
            itemNode = rootNode.createChild("ContentNode")
            itemNode.addFields(channel[item])
            itemNode.addFields({
                isNext: item = "next"
            })
        end for
    end for

    return rootNode
end function