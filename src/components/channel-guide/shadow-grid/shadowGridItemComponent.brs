function init()
    ? "Initialising shadow grid item component"
    m.logoPoster = m.top.findNode("logoPoster")
    m.titleLabel = m.top.findNode("titleLabel")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
end function

function onItemContentChanged(evt = {} as object) as void
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title

    if itemContent.isNext m.logoPoster.visible = false
end function