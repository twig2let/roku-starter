function init() as void

    ' FootprintTemplate template elements
    m.footprintTemplate = m.top.findNode("footprintTemplate")
    m.footprintTemplate_titleLabel = m.footprintTemplate.findNode("footprintTemplate_titleLabel")
    m.footprintTemplate_ratingLabel = m.footprintTemplate.findNode("footprintTemplate_ratingLabel")
    m.footprintTemplate_timeRangeLabel = m.footprintTemplate.findNode("footprintTemplate_timeRangeLabel")
    m.footprintTemplate_synopsisLabel = m.footprintTemplate.findNode("footprintTemplate_synopsisLabel")

    ' Focused template elements
    m.focusedTemplate = m.top.findNode("focusedTemplate")
    m.focusedTemplate_titleLabel = m.focusedTemplate.findNode("focusedTemplate_titleLabel")
    m.focusedTemplate_ratingLabel = m.focusedTemplate.findNode("focusedTemplate_ratingLabel")
    m.focusedTemplate_timeRangeLabel = m.focusedTemplate.findNode("focusedTemplate_timeRangeLabel")
    m.focusedTemplate_synopsisLabel = m.focusedTemplate.findNode("focusedTemplate_synopsisLabel")

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

    m.footprintTemplate_titleLabel.text = itemContent.title.Left(30)
    m.footprintTemplate_ratingLabel.text = itemContent.parentalRating
    m.footprintTemplate_timeRangeLabel.text = itemContent.period
    m.footprintTemplate_synopsisLabel.text = itemContent.synopsis

    m.focusedTemplate_titleLabel.text = itemContent.title.Left(30)
    m.focusedTemplate_ratingLabel.text = itemContent.parentalRating
    m.focusedTemplate_timeRangeLabel.text = itemContent.period
    m.focusedTemplate_synopsisLabel.text = itemContent.synopsis

    m.unfocusedTemplate_titleLabel.text = itemContent.title.Left(17) + "..."
    m.unfocusedTemplate_timeRangeLabel.text = itemContent.period
end function

function onFocusPercentChanged(evt as object) as void
    m.focusedTemplate.opacity = abs(1 * m.top.focusPercent - 1)
    m.unfocusedTemplate.opacity = m.top.focusPercent
end function

function onStateChanged(evt as object) as void
    if m.top.state = "footprint"
        m.focusedTemplate.opacity = 0
        m.unfocusedTemplate.opacity = 0
        m.footprintTemplate.opacity = 1
    else if m.top.state = "focused"
        m.focusedTemplate.opacity = 1
        m.unfocusedTemplate.opacity = 0
        m.footprintTemplate.opacity = 0
    end if
end function
