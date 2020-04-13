function init()
    m.layout = getLayout()
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.logoPoster = m.top.findNode("logoPoster")
    m.focusPoster = m.top.findNode("focusPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    ' Parallel Animation
    m.parallelAnimation = m.top.findNode("parallelAnimation")

    ' Now Item Animations
    m.focusedPosterAnimation = m.top.findNode("focusedPosterAnimation")
    m.focusedPosterAnimationInterp = m.top.findNode("focusedPosterAnimationInterp")

    ' Next Item Animations
    m.focusedPosterWidthAnimation = m.top.findNode("focusedPosterWidthAnimation")
    m.focusedPosterWidthAnimationInterp = m.top.findNode("focusedPosterWidthAnimationInterp")

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
    else
        m.backgroundPoster.setFields(m.layout.now.footprint.backgroundPoster)
        m.focusPoster.setFields(m.layout.now.focused.focusPoster)
    end if
end function

function onFocusPercentChanged()
    ' ? "onFocusPercentChanged..."
    ?"item index: "; m.top.index; " focus percent: "; m.top.focusPercent

    ' If now item is Focused e.g. focusPercent is 1
    if m.top.focusPercent = 1 and not m.top.itemContent.isNext
        ' m.focusPoster.setFields(m.layout.now.focused.focusPoster)
        animateNowItemFocused()
    end if

    ' If now item is Unfocused e.g. focusPercent is 0
    if m.top.focusPercent = 0 and not m.top.itemContent.isNext
        ' m.focusPoster.setFields(m.layout.now.unfocused.focusPoster)
        animateNowItemUnfocused()
    end if

    ' If next item is Focused e.g. focusPercent is 1
    if m.top.focusPercent = 1 and m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.next.focused.focusPoster)
    end if

    ' If next item is Unfocused e.g. focusPercent is 0
    if m.top.focusPercent = 0 and m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
    end if


end function

function onItemHasFocusChanged()

    ' if m.top.itemContent <> invalid
    '     if m.top.itemHasFocus
    '         ' If now item
    '         if not m.top.itemContent.isNext
    '             m.focusPoster.setFields(m.layout.now.focused.focusPoster)
    '         else
    '             m.focusPoster.setFields(m.layout.next.focused.focusPoster)
    '         end if
    '     else
    '         ' If now item
    '         if not m.top.itemContent.isNext
    '             m.focusPoster.setFields(m.layout.now.unfocused.focusPoster)
    '         else
    '             m.focusPoster.setFields(m.layout.next.unfocused.focusPoster)
    '         end if
    '     end if
    ' end if
end function

' When user changes the column focus then set the focused states for
' all the items in that column.
function onCurrFocusColumnChanged(evt as object) as void

    ' if not m.focusedPosterAnimation.state = "running"
    '     if not m.top.itemContent.isNext
    '         m.focusPoster.setFields(m.layout.now.focused.focusPoster)
    '     else
    '         m.focusPoster.setFields(m.layout.next.focused.focusPoster)
    '     end if
    ' end if


    ' **** Now Item Animations ****

    ' ' When moving from now column to next column
    ' if evt.getData() > 0 and not m.top.itemContent.isNext
    '     ' ? "Col Changed, animating focus for index "; m.top.index
    '     m.focusedPosterAnimationInterp.keyValue = [
    '         [
    '             m.focusPoster.translation[0],
    '             m.focusPoster.translation[1]
    '         ],
    '         [
    '             740,
    '             0
    '         ]
    '     ]
    '     m.focusedPosterAnimation.control = "start"
    ' end if

    ' ' When moving from next column to now column
    ' if evt.getData() = 0 and not m.top.itemContent.isNext
    '     m.focusPoster.uri = "pkg://images/generic_left.9.png"
    '     ' ? "Col Changed, animating focus for index "; m.top.index
    '     m.focusedPosterAnimationInterp.keyValue = [
    '         [
    '             m.focusPoster.translation[0],
    '             m.focusPoster.translation[1]
    '         ],
    '         [
    '             0,
    '             0
    '         ]
    '     ]
    '     m.focusedPosterAnimation.control = "start"
    ' end if

    ' ' **** End Now Item Animations ****


    ' ' **** Next Item Animations ****

    ' if evt.getData() > 0 and m.top.itemContent.isNext
    '     m.focusPoster.setFields(m.layout.next.focused.focusPoster)
    ' end if

    ' ' When moving from now column to next column
    ' if evt.getData() > 0 and m.top.itemContent.isNext
    '     m.focusedPosterWidthAnimationInterp.keyValue = [
    '         0,
    '         1002
    '     ]
    '     m.focusedPosterWidthAnimation.control = "start"
    ' end if

    ' if evt.getData() = 0 and m.top.itemContent.isNext
    '     m.focusedPosterWidthAnimationInterp.keyValue = [
    '         m.focusPoster.width,
    '         0
    '     ]
    '     m.focusedPosterWidthAnimation.control = "start"
    ' end if
end function


' Animations States
function animateNowItemUnfocused() as void
    ' if m.focusedPosterAnimation.state = "running" return

    m.focusedPosterAnimationInterp.keyValue = [
        [
            m.focusPoster.translation[0],
            m.focusPoster.translation[1]
        ],
        [
            740,
            0
        ]
    ]
    m.focusedPosterAnimation.control = "start"
end function

function animateNowItemFocused() as void

    ' if m.focusedPosterAnimation.state = "running" return

    m.focusedPosterAnimationInterp.keyValue = [
        [
            m.focusPoster.translation[0],
            m.focusPoster.translation[1]
        ],
        [
            0,
            0
        ]
    ]
    m.focusedPosterAnimation.control = "start"
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
                blendColor: "#000000"
            }
            focusPoster: {
                width: 0
                height: 169
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#FDCD00"
                translation: [ - 296, 0]
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
                translation: [ - 412, 0]
            }
        }
    }
}
end function