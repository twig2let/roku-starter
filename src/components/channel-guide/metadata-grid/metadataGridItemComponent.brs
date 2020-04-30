function init() as void
    m.layout = getLayout()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.focusPoster = m.top.findNode("focusPoster")

    ' Metadata
    m.logoPoster = m.top.findNode("logoPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")
    m.ratingLabel = m.top.findNode("ratingLabel")
    m.timeLabel = m.top.findNode("timeLabel")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")
    m.top.getParent().ObserveField("currFocusColumn", "onCurrFocusColumnChanged")

    m.columnIndex = 0
end function

function onItemContentChanged(evt = {} as object) as void
    itemContent = m.top.itemContent

    m.titleLabel.text = itemContent.title
    m.ratingLabel.text = itemContent.parentalRating
    m.timeLabel.text = itemContent.period
    m.synopsisLabel.text = itemContent.synopsis

    if itemContent.isNext
        m.logoPoster.visible = false
        m.synopsisLabel.visible = false
        m.titleLabel.setFields(m.layout.next.focused.title)
        m.backgroundPoster.setFields(m.layout.next.unfocused.backgroundPoster)

        if m.columnIndex = 0
            m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
        else
            m.focusPoster.setFields(m.layout.next.focused.focusPoster)
        end if
    else
        m.logoPoster.visible = true
        m.backgroundPoster.setFields(m.layout.now.footprint.backgroundPoster)

        ' If Now Column is focused...
        if m.columnIndex = 0
            m.focusPoster.setFields(m.layout.now.focused.focusPoster)
            m.titleLabel.setFields(m.layout.now.focused.titleLabel)
            m.ratingLabel.setFields(m.layout.now.focused.ratingLabel)
            m.timeLabel.setFields(m.layout.now.focused.timeLabel)
            m.timeLabel.translation = [m.layout.now.focused.width - m.timeLabel.boundingRect().width - m.layout.now.itemPadding, m.layout.now.itemPadding]
            m.synopsisLabel.setFields(m.layout.now.focused.synopsisLabel)
        else
            m.focusPoster.setFields(m.layout.now.unfocusedWide.focusPoster)
            m.titleLabel.setFields(m.layout.now.unfocusedWide.titleLabel)
            m.ratingLabel.setFields(m.layout.now.unfocusedWide.ratingLabel)
            m.timeLabel.setFields(m.layout.now.unfocusedWide.timeLabel)
            m.synopsisLabel.setFields(m.layout.now.unfocusedWide.synopsisLabel)
            m.focusPoster.setFields(m.layout.now.unfocusedWide.focusPoster)
        end if
    end if
end function

function onFocusPercentChanged()
end function

function onItemHasFocusChanged()
end function

' When user changes the column focus then set the focused states for
' all the items in that column.
function onCurrFocusColumnChanged(evt as object) as void
    m.columnIndex = evt.getData()

    ' Now Item
    if not m.top.itemContent.isNext
        ' 0 when focused
        ' 740 when unfocused (uses abs to get a positive integer e.g. -740 becomes 740)
        m.focusPoster.translation = [abs(740 * m.top.focusPercent - 740), 0]

        ' Fade out the metadata we don't want to see when the item is in its narrow state
        m.synopsisLabel.opacity = m.top.focusPercent
        m.timeLabel.opacity = m.top.focusPercent
        m.ratingLabel.opacity = m.top.focusPercent

        ?"m.top.focusPercent: "; m.top.focusPercent
    end if

    ' Next Item
    if m.top.itemContent.isNext
        m.focusPoster.width = 1004 * m.top.focusPercent
    end if

    ' Now Column
    ' Set the atomic item style states, when the focus transition has completed e.g. we have a whole number, 0 or 1
    if m.columnIndex = 0 and not m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.now.focused.focusPoster)
        m.focusPoster.setFields(m.layout.now.focused.focusPoster)
        m.titleLabel.setFields(m.layout.now.focused.titleLabel)
        m.ratingLabel.setFields(m.layout.now.focused.ratingLabel)
        m.timeLabel.setFields(m.layout.now.focused.timeLabel)
        m.synopsisLabel.setFields(m.layout.now.focused.synopsisLabel)
    end if

    if m.columnIndex = 1 and not m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.now.unfocusedNarrow.focusPoster)
        m.focusPoster.setFields(m.layout.now.unfocusedNarrow.focusPoster)
        m.titleLabel.setFields(m.layout.now.unfocusedNarrow.titleLabel)
        m.ratingLabel.setFields(m.layout.now.unfocusedNarrow.ratingLabel)
        m.timeLabel.setFields(m.layout.now.unfocusedNarrow.timeLabel)
        m.synopsisLabel.setFields(m.layout.now.unfocusedNarrow.synopsisLabel)
    end if

    ' Next Column
    if m.columnIndex = 0 and m.top.itemContent.isNext then m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
    if m.columnIndex = 1 and m.top.itemContent.isNext then m.focusPoster.setFields(m.layout.next.focused.focusPoster)
end function


' Layout.brs
function getLayout()

    itemHeight = 152
    itemPadding = 31

    nowItemWideWidth = 1036
    nowItemUnfocusedNarrowWidth = 708

    return {
        now: {
            itemPadding: itemPadding
            footprint: {
                backgroundPoster: {
                    width: nowItemWideWidth
                    height: itemHeight
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#222222"
                    translation: [0, 0]
                }
            }
            focused: {
                width: nowItemWideWidth
                focusPoster: {
                    width: nowItemWideWidth
                    height: itemHeight
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FDCD00"
                    translation: [0, 0]
                }
                titleLabel: {
                    opacity: 1
                    color: "#000000"
                }
                ratingLabel: {
                    opacity: 1
                    color: "#000000"
                }
                timeLabel: {
                    ' Can't offset from the right on Roku, translation must be determined after setting the label text and we know the width
                    ' translation: [nowItemWideWidth - itemPadding, itemPadding]
                    color: "#000000"
                    opacity: 1
                }
                synopsisLabel: {
                    opacity: 1
                    color: "#000000"
                }
            }
            unfocusedWide: {
                focusPoster: {
                    width: nowItemWideWidth
                    height: itemHeight
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FDCD00"
                    translation: [nowItemUnfocusedNarrowWidth, 0]
                }
                titleLabel: {
                    opacity: 1
                    color: "#ffffff"
                }
                ratingLabel: {
                    opacity: 1
                }
                timeLabel: {
                    opacity: 1
                    color: "#ffffff"
                }
                synopsisLabel: {
                    opacity: 1
                }
            }
            unfocusedNarrow: {
                focusPoster: {
                    width: nowItemWideWidth
                    height: itemHeight
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FDCD00"
                    translation: [nowItemUnfocusedNarrowWidth, 0]
                }
                titleLabel: {
                    opacity: 1
                    color: "#ffffff"
                }
                ratingLabel: {
                    opacity: 0
                }
                timeLabel: {
                    opacity: 0
                    color: "#ffffff"
                }
                synopsisLabel: {
                    opacity: 0
                }
            }
        }
        next: {
            unfocused: {
                backgroundPoster: {
                    width: 592
                    height: itemHeight
                    uri: "pkg://images/generic_right.9.png"
                    blendColor: "#222222"
                }
                focusPoster: {
                    visible: false
                    width: 0
                    height: itemHeight
                    uri: "pkg://images/generic_right.9.png"
                    blendColor: "#FDCD00"
                    translation: [ - 412, 0]
                }
            }
            focused: {
                title: {
                    translation: [ - 166, 45]
                    color: "#000000"
                }
                focusPoster: {
                    visible: true
                    width: 888
                    height: itemHeight
                    uri: "pkg://images/generic_right.9.png"
                    blendColor: "#FDCD00"
                    ' 1036 (width of now column) - 708 (Unfocused width of now column) = 328
                    translation: [ - 328, 0]
                }
            }
        }
    }
end function