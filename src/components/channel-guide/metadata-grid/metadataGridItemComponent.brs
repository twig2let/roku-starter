function init() as void
    m.layout = getLayout()

    m.constants = {
        NOW_COLUMN_INDEX: 0
        NEXT_COLUMN_INDEX: 1
    }

    m.states = {
        unfocused: "unfocused"
        focused: "focused"
        footprint: "footprint"
        nextColumnFootprint: "nextColumnFootprint"
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

function setState(state as string) as void
    ? "Changing state from: " m.state " to: " state
    m.state = state
    applyState(m.state)
end function

' Set the backgroundPoster, focusPoster and patch states in here
function applyState(state as string) as void
    m.backgroundPoster.setFields(m.layout[getColumnKey()][state].backgroundPoster)
    m.focusPoster.setFields(m.layout[getColumnKey()][state].focusPoster)
    m.patch.setFields(m.layout[getColumnKey()][state].patch)
end function

function onItemContentChanged(evt as object) as void
    reset()

    ' Set default layout values when we know item type we are e.g. now or next
    m.backgroundPoster.setFields(m.layout[getColumnKey()].backgroundPoster)
    m.focusPoster.setFields(m.layout.[getColumnKey()].focusPoster)
    m.patch.setFields(m.layout.[getColumnKey()].patch)

    ' Set the state of the new item
    if isFirstColumnFocused()
        if isFirstColumnItem() then setState(m.states.focused) else setState(m.states.unfocused)
    else
        if isFirstColumnItem() then setState(m.states.unfocused) else setState(m.states.focused)
    end if

    ' Append the now or next item template
    m.template = m.templateContainer.createChild(Substitute("{0}ItemCompositeTemplate", getColumnKey()))

    ' These observers depend on the existence of m.template so we don't want to
    ' observe them until m.template has been set
    m.top.ObserveFieldScoped("gridHasFocus", "onGridHasFocusChanged")

    m.template.itemContent = m.top.itemContent
end function

function onCurrFocusColumnChanged(evt as object) as void
    ' Don't update anything if the focus moved away from the grid whilst
    ' the currently focused column was changing
    if not m.top.gridHasFocus then return

    ' Here we are updating all items in a column to the correct state, once the column
    ' transition has finished e.g. m.grid.currFocusColumn = 0 or 1
    if m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX
        if isFirstColumnItem() then setState(m.states.focused) else setState(m.states.unfocused)
    else if m.grid.currFocusColumn = m.constants.NEXT_COLUMN_INDEX
        if isFirstColumnItem() then setState(m.states.unfocused) else setState(m.states.focused)
    else
        ' We're handling the focus poster transition in this block
        if isFirstColumnItem()
            m.focusPoster.translation = [abs(m.layout.now.focusPoster.unfocused.xCoordOffset * m.top.focusPercent - m.layout.now.focusPoster.unfocused.xCoordOffset), 0]
        else
            m.focusPoster.width = abs(m.layout.next.focused.focusPoster.width * m.top.focusPercent)
        end if
    end if

    ' Set the focus percentage on the template so we can use it to animate the metadata
    m.template.focusPercent = m.grid.currFocusColumn
end function

' ToDo: Add the grid unfocusing when the next column is focused e.g. show the patch
function onGridHasFocusChanged(evt = {} as object)

    if not m.top.gridHasFocus
        setState(m.states.footprint)
        if not isFirstColumnFocused() then setState(m.states.nextColumnFootprint)
    else
        if isFirstColumnFocused()
            if isFirstColumnItem() then setState(m.states.focused) else setState(m.states.unfocused)
        else
            if isFirstColumnItem() then setState(m.states.unfocused) else setState(m.states.focused)
        end if
    end if'
end function

function reset()
    m.top.unobserveField("gridHasFocus")
    m.top.unobserveField("focusPercent")

    m.templateContainer.removeChildrenIndex(m.templateContainer.getChildCount(), 0)
end function

' Helpers
function isFirstColumnFocused()
    ' On initial load the grid's currFocusColumn field is -1
    return m.grid.currFocusColumn = m.constants.NOW_COLUMN_INDEX or m.grid.currFocusColumn = -1
end function

function isFirstColumnItem() as boolean
    return m.top.index MOD 2 = 0
end function

function getColumnKey() as string
    return ["now", "next"][m.top.index MOD 2]
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
                height: itemHeight
                uri: "pkg://images/generic_left.9.png"
                blendColor: "#FCCC12"
                translation: [0, 0]

                unfocused: {
                    ' The offset we animate the translation to when unfocused
                    xCoordOffset: nowItemUnfocusedWidth + 1 ' We plus 1 pixel so the rounded corner is hidden but we still achieve the transition effect
                }
            }
            patch: {
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
                    translation: [nowItemUnfocusedWidth, 0]
                }
                patch: {
                    opacity: 1
                    color: "#FCCC12"
                }
            }
            nextColumnFootprint: {
                patch: {
                    opacity: 1
                    color: "#000000"
                }
                focusPoster: {
                    opacity: 0
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
            patch: {
                visible: false
            }
            footprint: {
                focusPoster: {
                    opacity: 0
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
            nextColumnFootprint: {
                focusPoster: {
                    opacity: 0
                }
                patch: {
                    opacity: 1
                    color: "#000000"
                }
            }
        }
    }
end function

