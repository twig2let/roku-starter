function init() as Void
    m.layout = getLayout()

    m.textColorAnimation = m.top.findNode("textColorAnimation")
    m.labelInterps = m.textColorAnimation.getChildren(m.textColorAnimation.getChildCount(), 0)
    m.titleLabelInterp = m.top.findNode("titleLabelInterp")
    m.timeRangeLabelInterp = m.top.findNode("timeRangeLabelInterp")

    m.titleSynopsisGroup = m.top.findNode("titleSynopsisGroup")
    m.titleLabel = m.top.findNode("titleLabel")
    m.timeRangeLabel = m.top.findNode("timeRangeLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    m.top.observeField("itemContent", "onItemContentChanged")
    m.top.observeField("focusPercent", "onFocusPercentChanged")
    m.top.observeField("gridHasFocus", "onGridHasFocusChanged")
end function

function onItemContentChanged(evt as object) as void
    m.titleLabel.text = m.top.itemContent.title
    ' m.ratingLabel.text = m.top.itemContent.parentalRating
    m.synopsisLabel.text = m.top.itemContent.synopsis
end function

function onFocusPercentChanged(evt as object)
    ?"onFocusPercentChanged: " m.top.focusPercent
    m.titleSynopsisGroup.translation = [m.layout.focused.titleLabel.translation[0] * m.top.focusPercent, m.layout.focused.titleLabel.translation[1]]
    m.titleLabelInterp.fraction = m.top.focusPercent
    m.timeRangeLabelInterp.fraction = m.top.focusPercent
end function

function onGridHasFocusChanged(evt as object) as void
    for each interp in m.labelInterps
        interp.reverse = (m.top.focusPercent = 1 and not m.top.gridHasFocus)
    end for

    m.textColorAnimation.control = "start"
end function


function getLayout()
    return {
        focused: {
            titleLabel: {
                color: "0x000000FF"
                translation: [-300, 31]
            }
        }
    }
end function