function init()
    ? "Initialising shadow grid item component"
    m.logoPoster = m.top.findNode("logoPoster")
    m.titleLabel = m.top.findNode("titleLabel")

    m.nextColumnItemAlignmentAnimation = m.top.findNode("nextColumnItemAlignmentAnimation")
    m.nextColumnItemAlignmentInterp = m.top.findNode("nextColumnItemAlignmentInterp")
    m.metadataGrid = m.top.GetParent().getParent().findNode("MetadataGrid")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.metadataGrid.ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onItemContentChanged(evt = {} as object) as Void
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title

    if itemContent.isNext m.logoPoster.visible = false
end function

function onCurrFocusColumnChanged() as Void
    if not m.top.itemContent.isNext return

    ' Next column focused...
    if m.metadataGrid.currFocusColumn > 0
        ? "Next column focused..."
        m.nextColumnItemAlignmentInterp.reverse = false
        if m.nextColumnItemAlignmentAnimation.state <> "running" then m.nextColumnItemAlignmentAnimation.control = "start"
    end if

    if m.metadataGrid.currFocusColumn = 0
        ? "Now column focused..."
        m.nextColumnItemAlignmentInterp.reverse = true
        if m.nextColumnItemAlignmentAnimation.state <> "running" then m.nextColumnItemAlignmentAnimation.control = "start"
    end if
end function