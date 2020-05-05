function init() as Void
    m.textColorAnimation = m.top.findNode("textColorAnimation")
    m.titleLabelInterps = m.textColorAnimation.getChildren(m.textColorAnimation.getChildCount(), 0)

    m.titleLabel = m.top.findNode("titleLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
    m.timeRangeLabel = m.top.findNode("timeRangeLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    m.top.observeField("itemContent", "onItemContentChanged")
    m.top.observeField("gridHasFocus", "onGridHasFocusChanged")
end function

function onItemContentChanged(evt as object) as void
    m.titleLabel.text = m.top.itemContent.title
    m.ratingLabel.text = m.top.itemContent.parentalRating
    m.timeRangeLabel.text = m.top.itemContent.period
    m.synopsisLabel.text = m.top.itemContent.synopsis
end function

function onGridHasFocusChanged(evt as object) as void

    for each interp in m.titleLabelInterps
        interp.reverse = not m.top.gridHasFocus
    end for

    m.textColorAnimation.control = "start"
end function
