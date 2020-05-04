function init()
    m.button = m.top.findNode("button")

    m.shadowGrid = m.top.findNode("shadowGrid")
    m.metadataGrid = m.top.findNode("metadataGrid")

    m.metadataGrid.observeField("currFocusRow", "onItemFocusedChanged")
    m.metadataGrid.observeField("currFocusColumn", "onCurrFocusColumnChanged")

    m.metadataGrid.setFocus(true)
end function

function onKeyEvent(key as String, press as Boolean) as Boolean

    handled = true

    if key = "down" and m.button.hasFocus()
        m.metadataGrid.setFocus(true)
    end if

    if key = "up" and m.metadataGrid.hasFocus()
        m.button.setFocus(true)
    end if

    return handled
end function

function onItemFocusedChanged()
    m.shadowGrid.animateToItem = Cint(m.metadataGrid.currFocusRow) * 2
end function

