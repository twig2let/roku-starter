function init()
    m.shadowGrid = m.top.findNode("shadowGrid")
    m.metadataGrid = m.top.findNode("metadataGrid")
    
    m.metadataGrid.observeField("currFocusRow", "onItemFocusedChanged")
    m.metadataGrid.observeField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onItemFocusedChanged()
    m.shadowGrid.animateToItem = Cint(m.metadataGrid.currFocusRow) * 2
end function

