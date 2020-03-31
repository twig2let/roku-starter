function init()
    ? "Initialising shadow grid item component"
    m.titleLabel = m.top.findNode("titleLabel")

    m.top.ObserveField("itemContent", "onItemContentChanged")
end function

function onItemContentChanged(evt = {} as object) as void
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title
end function