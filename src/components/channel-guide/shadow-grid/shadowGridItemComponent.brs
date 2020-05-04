function init()
    m.logoPoster = m.top.findNode("logoPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.containerLayoutGroup = m.top.findNode("containerLayoutGroup")
    m.metadataGrid = m.top.GetParent().getParent().findNode("MetadataGrid")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.metadataGrid.ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onFocusPercentChanged()
end function

function onItemContentChanged(evt = {} as object) as Void
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title

    if itemContent.isNow m.logoPoster.visible = true
end function

function onCurrFocusColumnChanged(evt as Object) as Void

    ' Next Item
    if not m.top.itemContent.isNow
        m.containerLayoutGroup.translation = [-250 * evt.getData(), 55]
    end if
end function