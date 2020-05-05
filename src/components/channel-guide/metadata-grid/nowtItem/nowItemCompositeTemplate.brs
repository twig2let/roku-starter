function init() as Void
    m.titleLabel = m.top.findNode("titleLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
    m.timeRangeLabel = m.top.findNode("timeRangeLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    m.top.observeField("itemContent", "onItemContentChanged")
end function

function onItemContentChanged(evt as object) as void
    m.titleLabel.text = m.top.itemContent.title
    m.ratingLabel.text = m.top.itemContent.parentalRating
    m.timeRangeLabel.text = m.top.itemContent.period
    m.synopsisLabel.text = m.top.itemContent.synopsis
end function


' What were you doing?
' Tryin to figure out the best way to pass the itemFocusPercent down, probably best to go with the same tiles do it?