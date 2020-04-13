function init()
    m.layout = getLayout()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.logoPoster = m.top.findNode("logoPoster")
    m.focusPoster = m.top.findNode("focusPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")
    ' m.top.getParent().ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onItemContentChanged(evt = {} as object) as void
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title
    m.synopsisLabel.text = itemContent.synopsis

    if itemContent.isNext
        m.logoPoster.visible = true
        m.synopsisLabel.visible = false
        m.titleLabel.setFields(m.layout.next.focused.title)
        m.backgroundPoster.setFields(m.layout.next.unfocused.backgroundPoster)
        m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
    else
        m.backgroundPoster.setFields(m.layout.now.footprint.backgroundPoster)
        m.focusPoster.setFields(m.layout.now.focused.focusPoster)
    end if
end function

function onFocusPercentChanged()
    ' ? "onFocusPercentChanged..."
    ?"item index: "; m.top.index; " focus percent: "; m.top.focusPercent

    ' Now Item
    if not m.top.itemContent.isNext
        m.focusPoster.translation = [abs(740*m.top.focusPercent-740), 0]
    end if

    ' Next Item
    if m.top.itemContent.isNext
        m.focusPoster.width = 1003 * m.top.focusPercent
    end if
end function

function onItemHasFocusChanged()

end function

' When user changes the column focus then set the focused states for
' all the items in that column.
function onCurrFocusColumnChanged(evt as object) as void

end function


' Layout.brs
function getLayout()
    return {
        now: {
            footprint: {
                backgroundPoster: {
                    width: 1152
                    height: 169
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#222222"
                    translation: [0, 0]
                }
            }
            focused: {
                focusPoster: {
                    width: 1152
                    height: 169
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FDCD00"
                    translation: [0, 0]
                }
            }
            unfocused: {
                focusPoster: {
                    width: 1152
                    height: 169
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FDCD00"
                    translation: [740, 0]
                }
            }
        }
    next: {
        unfocused: {
            backgroundPoster: {
                width: 592
                height: 169
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#222222"
            }
            focusPoster: {
                width: 0
                height: 169
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#FDCD00"
                translation: [-412, 0]
            }
        }
        focused: {
            title: {
                translation: [ - 166, 45]
                color: "#000000"
            }
            focusPoster: {
                width: 1002
                height: 169
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#FDCD00"
                ' 1152 (width of now column) - 740 (Unfocused width of now column) = 412
                translation: [-412, 0]
            }
        }
    }
}
end function