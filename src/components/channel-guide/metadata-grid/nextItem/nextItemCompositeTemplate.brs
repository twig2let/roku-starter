function init() as void
    m.layout = getLayout()

    m.titleLabelColorInterp = m.top.findNode("titleLabelColorInterp")
    m.timeRangeLabelColorInterp = m.top.findNode("timeRangeLabelColorInterp")
    m.titleSynopsisGroup = m.top.findNode("titleSynopsisGroup")
    m.titleLabel = m.top.findNode("titleLabel")
    m.timeRangeLabel = m.top.findNode("timeRangeLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    m.top.observeField("itemContent", "onItemContentChanged")
    m.top.observeField("focusPercent", "onFocusPercentChanged")
    m.top.observeField("state", "onStateChanged")
end function

function onItemContentChanged(evt as object) as void
    m.titleLabel.text = m.top.itemContent.title
    m.synopsisLabel.text = m.top.itemContent.synopsis
    m.timeRangeLabel.text = m.top.itemContent.period
end function

function onFocusPercentChanged(evt as object)
    m.titleSynopsisGroup.translation = [(m.layout.focused.titleSynopsisGroup.translation[0] * m.top.focusPercent), m.layout.focused.titleSynopsisGroup.translation[1]]
    m.titleLabelColorInterp.fraction = m.top.focusPercent
    m.timeRangeLabelColorInterp.fraction = m.top.focusPercent
end function

function onStateChanged(evt as object)
    m.titleSynopsisGroup.setFields(m.layout[m.top.state].titleSynopsisGroup)
    m.titleLabel.setFields(m.layout[m.top.state].titleLabel)
    m.timeRangeLabel.setFields(m.layout[m.top.state].timeRangeLabel)
end function

function getLayout()
    return {
        footprint: {
            titleSynopsisGroup: {
                translation: [0, 31]
            }
            titleLabel: {
                color: "0xFFFFFFFF"
            }
            synopsisLabel: {
            }
            timeRangeLabel: {
                color: "0xFFFFFFFF"
            }
        }
        focused: {
            titleSynopsisGroup: {
                translation: [ - 328, 31]
            }
            titleLabel: {
                color: "0x000000FF"
            }
            timeRangeLabel: {
                color: "0x000000FF"
            }
        }
        unfocused: {
            titleSynopsisGroup: {
                translation: [0, 31]
            }
            titleLabel: {
                color: "0xFFFFFFFF"
            }
            synopsisLabel: {
            }
            timeRangeLabel: {
                color: "0xFFFFFFFF"
            }
        }
        nextColumnFootprint: {
            titleSynopsisGroup: {
                translation: [ - 328, 31]
            }
            titleLabel: {
                color: "0xFFFFFFFF"
            }
            synopsisLabel: {
            }
            timeRangeLabel: {
                color: "0xFFFFFFFF"
            }
        }
    }
end function