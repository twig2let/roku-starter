function init() as void
    m.layout = getLayout()

    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.focusPoster = m.top.findNode("focusPoster")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")
    ' We observe the grid event so all item components can be update to reflect their focused/unfocused states
    m.top.getParent().ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onItemContentChanged(evt as object) as void
    reset()

    itemContent = m.top.itemContent

    if itemContent.isNow
        m.backgroundPoster.setFields(m.layout.now.backgroundPoster)
        m.focusPoster.setFields(m.layout.now.focusPoster)
    else
        m.backgroundPoster.setFields(m.layout.next.backgroundPoster)
        m.focusPoster.setFields(m.layout.next.focusPoster)
    end if
end function

function onFocusPercentChanged(evt as object) as void
    ' m.focusPoster.width = abs(m.layout.now.focused.focusPoster.width * m.top.focusPercent - 1)

        ' if isFirstColumnItem()
        '     ?"onFocusPercentChanged: " m.top.index
        '     m.focusPoster.translation = [abs(m.layout.now.focused.focusPoster.width * m.top.focusPercent + m.layout.now.unfocused.focusPoster.width), 0]
        ' else
        '     m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
        ' end if

        ' if isFirstColumnItem()
        '     m.focusPoster.setFields(m.layout.now.unfocused.focusPoster)
        ' else
        '     m.focusPoster.setFields(m.layout.next.focused.focusPoster)
        ' end if
end function

' Update all items, so when the user scrolls all items (within the currently focused column) are in their correct state
function onCurrFocusColumnChanged(evt as object) as void
    ' If this is a NOW item
    if evt.getData() = 0
        ?"onCurrFocusColumnChanged: " m.top.index
        if isFirstColumnItem()
            m.focusPoster.setFields(m.layout.now.focused.focusPoster)
        else
            m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
        end if
    end if

    if evt.getData() = 1 ' If this is a NEXT item
        if isFirstColumnItem()
            m.focusPoster.setFields(m.layout.now.unfocused.focusPoster)
        else
            m.focusPoster.setFields(m.layout.next.focused.focusPoster)
        end if
    end if
end function

function reset()
end function

function isFirstColumnItem() as boolean
    return m.top.index MOD 2 = 0
end function


' Layout.brs
function getLayout()

    itemHeight = 152
    itemPadding = 31

    ' The item widths never change, we use grow/shrink the focus poster and offset metadata to give the impression of scaling items
    nowItemWidth = 1036

    nextItemWidth = 560

    return {
        now: {
            backgroundPoster: {
                width: nowItemWidth
                height: itemHeight
                uri: "pkg://images/generic_left.9.png"
                blendColor: "#222222"
                translation: [0, 0]
            }
            focused: {
                focusPoster: {
                    opacity: 1
                    width: nowItemWidth
                    height: itemHeight
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FCCC12"
                    translation: [0, 0]
                }
            }
            unfocused: {
                focusPoster: {
                    opacity: 0
                    width: 0
                    height: 0
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FCCC12"
                    translation: [0, 0]
                }
            }
        }
        next: {
            backgroundPoster: {
                width: nowItemWidth
                height: itemHeight
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#000000"
                translation: [0, 0]
            }
            focused: {
                focusPoster: {
                    opacity: 1
                    width: nextItemWidth
                    height: itemHeight
                    uri: "pkg://images/generic_right.9.png"
                    blendColor: "#FCCC12"
                    translation: [0, 0]
                }
            }
            unfocused: {
                focusPoster: {
                    opacity: 0
                    width: 0
                    height: 0
                    uri: "pkg://images/generic_right.9.png"
                    blendColor: "#FCCC12"
                    translation: [0, 0]
                }
            }
        }
    }
end function


' function init() as void
'     m.layout = getLayout()
'     m.backgroundPoster = m.top.findNode("backgroundPoster")
'     m.focusPoster = m.top.findNode("focusPoster")

'     ' Metadata

'     ' NOW ITEM
'     m.focusedMetadataLayoutGroup = m.top.findNode("focusedMetadataLayoutGroup")
'     m.unfocusedMetadataLayoutGroup = m.top.findNode("unfocusedMetadataLayoutGroup")

'     ' Animation
'     m.testAnimation = m.top.findNode("testAnimation")

'     ' NEXT ITEM
'     m.nextItemUnfocusedMetadataLayoutGroup = m.top.findNode("nextItemUnfocusedMetadataLayoutGroup")
'     m.nextTitleLabel = m.top.findNode("nextTitleLabel")
'     m.nextSynopsisLabel = m.top.findNode("nextSynopsisLabel")

'     m.logoPoster = m.top.findNode("logoPoster")
'     m.titleLabel = m.top.findNode("titleLabel")
'     m.titleLabel_truncated = m.top.findNode("titleLabel_truncated")
'     m.synopsisLabel = m.top.findNode("synopsisLabel")
'     m.ratingLabel = m.top.findNode("ratingLabel")
'     m.timeLabel = m.top.findNode("timeLabel")
'     m.timeLabel_unfocused = m.top.findNode("timeLabel_unfocused")

'     m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
'     m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")
'     m.top.getParent().ObserveField("currFocusColumn", "onCurrFocusColumnChanged")

'     m.columnIndex = 0
' end function

' function onItemContentChanged(evt = {} as object) as void
'     itemContent = m.top.itemContent

'     reset()

'     if itemContent.isNow
'         m.unfocusedMetadataLayoutGroup.opacity = 0 ' next item
'         m.nextItemUnfocusedMetadataLayoutGroup.opacity = 1

'         m.backgroundPoster.setFields(m.layout.next.unfocusedNarrow.backgroundPoster)
'         m.logoPoster.visible = false
'         m.synopsisLabel.visible = false
'         m.nextTitleLabel.setFields(m.layout.next.unfocusedNarrow.title)
'         m.nextTitleLabel.text = itemContent.title

'         m.nextSynopsisLabel.setFields(m.layout.next.unfocusedNarrow.synopsis)
'         m.nextSynopsisLabel.text = itemContent.synopsis

'         if m.columnIndex = 0
'             m.focusPoster.setFields(m.layout.next.unfocusedNarrow.focusPoster)
'         else
'             m.focusPoster.setFields(m.layout.next.focused.focusPoster)
'         end if
'     else
'         m.logoPoster.visible = true
'         m.backgroundPoster.setFields(m.layout.now.footprint.backgroundPoster)
'         m.titleLabel.text = itemContent.title
'         m.ratingLabel.text = itemContent.parentalRating
'         m.timeLabel.text = itemContent.period
'         m.timeLabel_unfocused.text = itemContent.period
'         m.synopsisLabel.text = itemContent.synopsis

'         ' If Now Column is focused...
'         if m.columnIndex = 0

'             ' Now Item
'             if not itemContent.isNow
'                 m.focusPoster.setFields(m.layout.now.focused.focusPoster)
'                 m.titleLabel.setFields(m.layout.now.focused.titleLabel)
'                 m.titleLabel_truncated.text = itemContent.title.Left(17) + "..."
'                 m.ratingLabel.setFields(m.layout.now.focused.ratingLabel)
'                 m.timeLabel.setFields(m.layout.now.focused.timeLabel)
'                 m.timeLabel.translation = [m.layout.now.focused.width - m.timeLabel.boundingRect().width - m.layout.now.itemPadding, m.layout.now.itemPadding]
'                 m.synopsisLabel.setFields(m.layout.now.focused.synopsisLabel)
'             else
'                 ' Next Item
'                 m.focusPoster.setFields(m.layout.next.unfocusedNarrow.focusPoster)
'                 m.titleLabel.setFields(m.layout.next.unfocusedNarrow.titleLabel)
'             end if
'         else
'             ' Now Item
'             m.focusPoster.setFields(m.layout.now.unfocusedWide.focusPoster)
'             m.titleLabel.setFields(m.layout.now.unfocusedWide.titleLabel)
'             m.ratingLabel.setFields(m.layout.now.unfocusedWide.ratingLabel)
'             m.timeLabel.setFields(m.layout.now.unfocusedWide.timeLabel)
'             m.synopsisLabel.setFields(m.layout.now.unfocusedWide.synopsisLabel)
'             m.focusPoster.setFields(m.layout.now.unfocusedWide.focusPoster)
'         end if
'     end if
' end function

' function reset()
'     m.focusedMetadataLayoutGroup.opacity = 0
'     m.unfocusedMetadataLayoutGroup.opacity = 1
'     m.nextItemUnfocusedMetadataLayoutGroup.opacity = 0
' end function

' function onFocusPercentChanged()
' end function

' function onItemHasFocusChanged()
' end function

' ' When user changes the column focus then set the focused states for
' ' all the items in that column.
' function onCurrFocusColumnChanged(evt as object) as void
'     m.columnIndex = evt.getData()

'     ' Now Item
'     if m.top.itemContent.isNow
'         ' 0 when focused
'         ' 740 when unfocused (uses abs to get a positive integer e.g. -740 becomes 740)
'         m.focusPoster.translation = [abs(m.layout.now.unfocusedNarrow.nowItemUnfocusedNarrowWidth * m.top.focusPercent - m.layout.now.unfocusedNarrow.nowItemUnfocusedNarrowWidth), 0]

'         ' Fade out the metadata we don't want to see when the item is in its narrow state
'         m.focusedMetadataLayoutGroup.opacity = m.top.focusPercent
'         m.unfocusedMetadataLayoutGroup.opacity = abs(1 * m.top.focusPercent - 1)
'     end if

'     ' Next Item
'     if m.top.itemContent.isNow
'         m.focusPoster.width = abs(m.layout.next.focused.width  * m.top.focusPercent - 1)
'         m.nextItemUnfocusedMetadataLayoutGroup.translation = [m.layout.next.focused.nextItemUnfocusedMetadataLayoutGroup.translation[0] * m.top.focusPercent, m.layout.next.focused.nextItemUnfocusedMetadataLayoutGroup.translation[1]]
'     end if

'     ' Now Column
'     ' Set the atomic item style states, when the focus transition has completed e.g. we have a whole number, 0 or 1 ... actually necessary?
'     if m.columnIndex = 0 and not m.top.itemContent.isNow
'         m.focusPoster.setFields(m.layout.now.focused.focusPoster)
'         m.logoPoster.setFields(m.layout.now.focused.logoPoster)

'         m.unfocusedMetadataLayoutGroup.opacity = 0
'         m.focusedMetadataLayoutGroup.opacity = 1
'     end if

'     if m.columnIndex = 1 and not m.top.itemContent.isNow
'         m.focusPoster.setFields(m.layout.now.unfocusedNarrow.focusPoster)
'         m.logoPoster.setFields(m.layout.now.unfocusedNarrow.logoPoster)

'         m.unfocusedMetadataLayoutGroup.opacity = 1
'         m.focusedMetadataLayoutGroup.opacity = 0
'     end if

'     ' Next Column
'     if m.columnIndex = 0 and m.top.itemContent.isNow then m.focusPoster.setFields(m.layout.next.unfocusedNarrow.focusPoster)
'     if m.columnIndex = 1 and m.top.itemContent.isNow then m.focusPoster.setFields(m.layout.next.focused.focusPoster)
' end function


' ' Layout.brs
' function getLayout()

'     itemHeight = 152
'     itemPadding = 31

'     nowItemWideWidth = 1036
'     nowItemUnfocusedNarrowWidth = 708

'     nextItemWideWidth = 888
'     nextItemUnfocusedNarrowWidth = 560

'     return {
'         now: {
'             itemPadding: itemPadding
'             footprint: {
'                 backgroundPoster: {
'                     width: nowItemWideWidth
'                     height: itemHeight
'                     uri: "pkg://images/generic_left.9.png"
'                     blendColor: "#222222"
'                     translation: [0, 0]
'                 }
'             }
'             focused: {
'                 width: nowItemWideWidth
'                 focusPoster: {
'                     width: nowItemWideWidth
'                     height: itemHeight
'                     uri: "pkg://images/generic_left.9.png"
'                     blendColor: "#FDCD00"
'                     translation: [0, 0]
'                 }
'                 logoPoster: {
'                     blendColor: "#000000"
'                 }
'                 titleLabel: {
'                     color: "#000000"
'                 }
'                 ratingLabel: {
'                     color: "#000000"
'                 }
'                 timeLabel: {
'                     ' Can't offset from the right on Roku, translation must be determined after setting the label text and we know the width
'                     ' translation: [nowItemWideWidth - itemPadding, itemPadding]
'                     color: "#000000"
'                 }
'                 synopsisLabel: {
'                     color: "#000000"
'                 }
'             }
'             unfocusedWide: {
'                 focusPoster: {
'                     width: nowItemWideWidth
'                     height: itemHeight
'                     uri: "pkg://images/generic_left.9.png"
'                     blendColor: "#FDCD00"
'                     translation: [nowItemUnfocusedNarrowWidth, 0]
'                 }
'                 logoPoster: {
'                     blendColor: "#FFFFFF"
'                 }
'                 titleLabel: {
'                 }
'                 ratingLabel: {
'                 }
'                 timeLabel: {
'                 }
'                 synopsisLabel: {
'                 }
'             }
'             unfocusedNarrow: {
'                 nowItemUnfocusedNarrowWidth: nowItemUnfocusedNarrowWidth
'                 focusPoster: {
'                     width: nowItemWideWidth
'                     height: itemHeight
'                     uri: "pkg://images/generic_left.9.png"
'                     blendColor: "#FDCD00"
'                     translation: [nowItemUnfocusedNarrowWidth, 0]
'                 }
'                 logoPoster: {
'                     blendColor: "#FFFFFF"
'                 }
'                 titleLabel: {
'                 }
'                 ratingLabel: {
'                 }
'                 timeLabel: {
'                 }
'                 synopsisLabel: {
'                 }
'             }
'         }
'         next: {
'             unfocusedNarrow: {
'                 width: nextItemUnfocusedNarrowWidth
'                 backgroundPoster: {
'                     width: nextItemUnfocusedNarrowWidth
'                     height: itemHeight
'                     uri: "pkg://images/generic_right.9.png"
'                     blendColor: "#222222"
'                 }
'                 focusPoster: {
'                     width: 0
'                     height: itemHeight
'                     uri: "pkg://images/generic_right.9.png"
'                     blendColor: "#FDCD00"
'                     translation: [0, 0]
'                 }
'                 title: {
'                     color: "#FFFFFF"
'                 }
'                 synopsis: {
'                     color: "#000000"
'                     opacity: 0
'                 }
'             }
'             focused: {
'                 width: nextItemWideWidth
'                 nextItemUnfocusedMetadataLayoutGroup: {
'                     translation: [-300, itemPadding]
'                 }
'                 focusPoster: {
'                     width: nextItemWideWidth
'                     height: itemHeight
'                     uri: "pkg://images/generic_right.9.png"
'                     blendColor: "#FDCD00"
'                     ' 1036 (width of now column) - 708 (now item unfocusedNarrow width) = 328
'                     translation: [-328, 0]
'                 }
'                 title: {
'                     color: "#000000"
'                 }
'                 synopsis: {
'                     color: "#000000"
'                     opacity: 1
'                 }
'             }
'         }
'     }
' end function