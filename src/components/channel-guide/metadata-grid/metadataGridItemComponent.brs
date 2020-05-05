function init() as void
    m.layout = getLayout()

    m.constants = {
        NOW_COLUMN_INDEX: 0
        NEXT_COLUMN_INDEX: 1
    }

    ' Assigned the now or next component template
    m.template = invalid

    m.grid = m.top.getParent()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.focusPoster = m.top.findNode("focusPoster")
    m.patch = m.top.findNode("patch")
    m.templateContainer = m.top.findNode("templateContainer")

    ' We observe the grid's currFocusColumn field so that we know when to update an item
    ' (in its respective column) to reflect the appropriate focused/unfocused states when
    ' e.g. when a user switches column.
    m.grid.ObserveField("currFocusColumn", "onCurrFocusColumnChanged")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
end function

function onItemContentChanged(evt as object) as void
    reset()

    itemContent = m.top.itemContent

    if isFirstColumnItem()
        m.backgroundPoster.setFields(m.layout.now.backgroundPoster)
        m.focusPoster.setFields(m.layout.now.focusPoster)
        m.patch.setFields(m.layout.now.patch)

        if m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX then m.focusPoster.setFields(m.layout.now.focused.focusPoster)

        m.template = m.templateContainer.createChild("nowItemCompositeTemplate")
    else
        m.backgroundPoster.setFields(m.layout.next.backgroundPoster)
        m.focusPoster.setFields(m.layout.next.focusPoster)

        if m.grid.currFocusColumn = m.constants.NEXT_COLUMN_INDEX then m.focusPoster.setFields(m.layout.next.focused.focusPoster)

        m.template = m.templateContainer.createChild("nextItemCompositeTemplate")
    end if

    ' These field's observers depend on the existence of m.template so we don't want to
    ' observe them until m.template has been set.
    m.top.ObserveFieldScoped("gridHasFocus", "onGridHasFocusChanged")
    m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")

    ' Fire the GridHasFocus callback so any new item subscribers get the current state.
    onGridHasFocusChanged()

    m.template.itemContent = itemContent
end function

function onFocusPercentChanged(evt as object) as void
    m.template.focusPercent = m.top.focusPercent
end function

function onCurrFocusColumnChanged(evt as object) as void

    ' If the first column is fully focused ...
    if m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX
        ' Set all first column items to their focused layout
        if isFirstColumnItem()
            m.focusPoster.setFields(m.layout.now.focused.focusPoster)
        else
            ' Set all second column items to their unfocused layout
            m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
        end if
        ' Else if the second column is fully focused...
    else if m.grid.currFocusColumn = m.constants.NEXT_COLUMN_INDEX
        if isFirstColumnItem()
            ' Set all first column items to their unfocused layout
            m.focusPoster.setFields(m.layout.now.unfocused.focusPoster)
        else
            ' Set all second column items to their focused layout
            m.focusPoster.setFields(m.layout.next.focused.focusPoster)
        end if
        ' Else focus is still transitioning
    else
        ' We perform the focus poster transitions in this block using m.top.focusPercent
        if isFirstColumnItem()
            m.focusPoster.translation = [abs(m.layout.now.focusPoster.unfocused.xCoordOffset * m.top.focusPercent - m.layout.now.focusPoster.unfocused.xCoordOffset), 0]
        else
            m.focusPoster.width = abs(m.layout.next.focused.focusPoster.width * m.top.focusPercent)
        end if
    end if
end function

' ToDo: Fix this, hiding/showing focus highlight when focus moves on and off grid
function onGridHasFocusChanged(evt = {} as object)
    ?"onGridHasFocusChanged"
    if not m.top.gridHasFocus
        m.focusPoster.setFields(m.layout.footprint.focusPoster)
    else
        if m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX
            if isFirstColumnItem() then m.focusPoster.setFields(m.layout.now.focused.focusPoster)
        end if
    end if

    m.template.gridHasFocus = m.top.gridHasFocus
end function

function reset()
    m.top.unobserveField("gridHasFocus")
    m.top.unobserveField("focusPercent")

    m.templateContainer.removeChildrenIndex(m.templateContainer.getChildCount(), 0)
end function

function isFirstColumnItem() as boolean
    return m.top.index MOD 2 = 0
end function



' Layout.brs
function getLayout()

    itemHeight = 152
    itemPadding = 31

    ' The "item" widths never change, we grow/shrink the focus poster and offset item metadata to give the impression of scaling items
    nowItemWidth = 1036
    nowItemUnfocusedWidth = 708

    nextItemWidth = 560
    nextItemFocusedWidth = 888

    ' Even with a width of 0 (unfocused.focusPoster) the 9 Patch is 10px wide
    phantomWidth = 10

    return {
        footprint: {
            focusPoster: {
                opacity: 0
            }
        }
        now: {
            backgroundPoster: {
                width: nowItemWidth
                height: itemHeight
                uri: "pkg://images/generic_left.9.png"
                blendColor: "#222222"
                translation: [0, 0]
            }
            focusPoster: {
                unfocused: {
                    ' The offset we animate the translation to when unfocused
                    xCoordOffset: nowItemUnfocusedWidth + 1 ' We plus 1 pixel so the rounded corner is hidden but we still achieve the transition effect
                }
            }
            patch: {
                opacity: 1
                color: "#FCCC12"
                width: nowItemWidth - nowItemUnfocusedWidth
                height: itemHeight
                translation: [nowItemWidth - (nowItemWidth - nowItemUnfocusedWidth), 0]
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
                patch: {
                    opacity: 1
                }
            }
            unfocused: {
                focusPoster: {
                    opacity: 1
                    height: itemHeight
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FCCC12"
                    translation: [nowItemUnfocusedWidth, 0]
                }
                patch: {
                    opacity: 1
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
            focusPoster: {
                opacity: 1
                width: 0
                height: itemHeight
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#FCCC12"
                translation: [ - phantomWidth, 0]
            }
            focused: {
                focusPoster: {
                    opacity: 1
                    ' Plus the phantomWidth to account for the -phantomWidth offset required to hide (camouflage)
                    ' the now item focus poster in its unfocuse state.
                    width: nextItemWidth + phantomWidth
                }
            }
            unfocused: {
                focusPoster: {
                    width: 0
                    translation: [ - phantomWidth, 0]
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
'     if not m.top.itemContent.isNow
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