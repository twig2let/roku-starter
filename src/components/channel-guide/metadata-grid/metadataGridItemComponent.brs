function init() as void
    m.layout = getLayout()

    m.constants = {
        NOW_COLUMN_INDEX: 0
        NEXT_COLUMN_INDEX: 1
    }

    ' Assigned either the now or next item component template
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
    ' m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")

    ' Fire the GridHasFocus callback so any new item subscribers get the current state.
    onGridHasFocusChanged()

    m.template.itemContent = itemContent
end function

' function onFocusPercentChanged(evt as object) as void
'     m.template.focusPercent = m.top.focusPercent
' end function

function onCurrFocusColumnChanged(evt as object) as void
    ?"onCurrFocusColumnChanged: " m.grid.currFocusColumn
    ' If the first column is fully focused ...
    if m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX
        ' Set all first column items to their focused layout
        if isFirstColumnItem()
            ' User can unfocus the grid whilst grid item focus is transitioning
            if not m.top.gridHasFocus
                m.focusPoster.setFields(m.layout.now.footprint.focusPoster)
            else
                m.focusPoster.setFields(m.layout.now.focused.focusPoster)
            end if
        else
            ' Set all second column items to their unfocused layout
            m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
        end if
        ' Else if the second column is fully focused...
    else if m.grid.currFocusColumn = m.constants.NEXT_COLUMN_INDEX
        if isFirstColumnItem()
            ' Set all first column items to their unfocused layout
            if not m.top.gridHasFocus
                m.focusPoster.setFields(m.layout.now.footprint.focusPoster)
                m.patch.setFields(m.layout.now.footprint.patch)
            else
                m.focusPoster.setFields(m.layout.now.unfocused.focusPoster)
            end if
        else
            if not m.top.gridHasFocus
                ' Set all second column items to their focused layout
                m.focusPoster.setFields(m.layout.next.footprint.focusPoster)
            else
                m.focusPoster.setFields(m.layout.next.focused.focusPoster)
            end if
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

    m.template.focusPercent = m.grid.currFocusColumn
end function

' ToDo: Fix this, hiding/showing focus highlight when focus moves on and off grid
function onGridHasFocusChanged(evt = {} as object)
    ' If the grid has been unfocused
    if not m.top.gridHasFocus
        ?"not GridHasFocus"
        ' If the first column was last focused
        if m.grid.currFocusColumn < m.constants.NEXT_COLUMN_INDEX
            m.focusPoster.setFields(m.layout.now.footprint.focusPoster)
            if isFirstColumnItem()
                m.patch.setFields(m.layout.now.footprint.patch)
            else
                m.focusPoster.setFields(m.layout.next.footprint.focusPoster)
            end if
        else
            if isFirstColumnItem()
                ' Technically the patch "belongs" to the now item layou but we leverage it
                ' to achieve the impression of a wider, unfoucsed next item
                m.patch.setFields(m.layout.next.footprint.patch)
            else
                m.focusPoster.setFields(m.layout.next.footprint.focusPoster)
            end if
        end if
    else
        ?"GridHasFocus"
        if m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX
            if isFirstColumnItem()
                m.focusPoster.setFields(m.layout.now.focused.focusPoster)
                m.patch.setFields(m.layout.now.patch)
            else
                m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
            end if
        else
            m.focusPoster.setFields(m.layout.next.focused.focusPoster)
            if isFirstColumnItem() then m.patch.setFields(m.layout.now.unfocused.patch)
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
            footprint: {
                focusPoster: {
                    opacity: 0
                }
                patch: {
                    opacity: 0
                }
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
                    color: "#FCCC12"
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
                    color: "#FCCC12"
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
            footprint: {
                focusPoster: {
                    opacity: 0
                }
                patch: {
                    opacity: 1
                    color: "#000000"
                }
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
                    opacity: 1
                    width: 0
                    translation: [ - phantomWidth, 0]
                }
            }
        }
    }
end function

