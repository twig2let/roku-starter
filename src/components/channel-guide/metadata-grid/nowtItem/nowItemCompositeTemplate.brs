function init() as void
    m.textColorAnimation = m.top.findNode("textColorAnimation")
    m.labelInterps = m.textColorAnimation.getChildren(m.textColorAnimation.getChildCount(), 0)

    m.colorTransitions = {
        focused: ["0xFFFFFFFF", "0x000000FF"]
        footprint: ["0x000000FF", "0xFFFFFFFF"]
        nextColumnFootprint: ["0x000000FF", "0xFFFFFFFF"]
        unfocused: ["0x000000FF", "0xFFFFFFFF"]
    }
    ' Active & Focused template elements
    m.activeAndFocusedTemplate = m.top.findNode("activeAndFocusedTemplate")
    m.activeFocused_titleLabel = m.activeAndFocusedTemplate.findNode("activeAndFocusedTemplate_titleLabel")
    m.activeFocused_ratingLabel = m.activeAndFocusedTemplate.findNode("activeAndFocusedTemplate_ratingLabel")
    m.activeFocused_timeRangeLabel = m.activeAndFocusedTemplate.findNode("activeAndFocusedTemplate_timeRangeLabel")
    m.activeFocused_synopsisLabel = m.activeAndFocusedTemplate.findNode("activeAndFocusedTemplate_synopsisLabel")

    ' Unfocused template elements
    m.unfocusedTemplate = m.top.findNode("unfocusedTemplate")
    m.unfocusedTemplate_titleLabel = m.unfocusedTemplate.findNode("unfocusedTemplate_titleLabel")
    m.unfocusedTemplate_timeRangeLabel = m.unfocusedTemplate.findNode("unfocusedTemplate_timeRangeLabel")

    m.top.observeField("itemContent", "onItemContentChanged")
    m.top.observeField("focusPercent", "onFocusPercentChanged")
    m.top.observeField("state", "onStateChanged")
end function

function onItemContentChanged(evt as object) as void
    itemContent = m.top.itemContent

    m.activeFocused_titleLabel.text = itemContent.title.Left(30)
    m.activeFocused_ratingLabel.text = itemContent.parentalRating
    m.activeFocused_timeRangeLabel.text = itemContent.period
    m.activeFocused_synopsisLabel.text = itemContent.synopsis

    m.unfocusedTemplate_titleLabel.text = itemContent.title.Left(17) + "..."
    m.unfocusedTemplate_timeRangeLabel.text = itemContent.period
end function

function onFocusPercentChanged(evt as object) as void
    m.activeAndFocusedTemplate.opacity = abs(1 * m.top.focusPercent - 1)
    m.unfocusedTemplate.opacity = m.top.focusPercent
end function

function onStateChanged(evt as object) as void
    for each interp in m.labelInterps
        interp.keyValue = m.colorTransitions[m.top.state]
    end for
    m.textColorAnimation.control = "start"
end function
