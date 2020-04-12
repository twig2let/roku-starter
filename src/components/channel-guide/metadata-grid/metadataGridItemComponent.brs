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
    m.top.getParent().ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
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
    end if
end function

function onFocusPercentChanged()
    ' ? "onFocusPercentChanged..."
    ' ?"item index: "; m.top.index; " focus percent: "; m.top.focusPercent
end function

function onItemHasFocusChanged()
    ' If is Now item
    if m.top.itemHasFocus and m.top.itemContent <> invalid and not m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.now.focused.focusPoster)
    end if

    ' If is Next item
    if m.top.itemHasFocus and m.top.itemContent <> invalid and m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.next.focused.focusPoster)
    end if
end function

function onCurrFocusColumnChanged(evt as object) as void

    ' **** Now Item Animations ****

    if evt.getData() = 0 and not m.top.itemContent.isNext
        ?"setting item "; m.top.index; " as focused "
        m.focusPoster.setFields(m.layout.now.focused.focusPoster)
    end if

    ' When moving from now column to next column
    if evt.getData() > 0 and not m.top.itemContent.isNext
        ? "Col Changed, animating focus for index "; m.top.index
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
    end if

    ' When moving from next column to now column
    if evt.getData() = 0 and not m.top.itemContent.isNext
        ? "Col Changed, animating focus for index "; m.top.index
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
    end if

    ' **** End Now Item Animations ****


    ' **** Next Item Animations ****

    if evt.getData() = 1 and m.top.itemContent.isNext
        m.focusPoster.setFields(m.layout.next.focused.focusPoster)
    end if

    ' When moving from now column to next column
    if evt.getData() > 0 and m.top.itemContent.isNext
        m.focusedPosterWidthAnimationInterp.keyValue = [
            0,
            1002
        ]
        m.focusedPosterWidthAnimation.control = "start"
    end if

    if evt.getData() = 0 and m.top.itemContent.isNext
        m.focusedPosterWidthAnimationInterp.keyValue = [
            m.focusPoster.width,
            0
        ]
        m.focusedPosterWidthAnimation.control = "start"
    end if
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
                }
            }
            focused: {
                focusPoster: {
                    width: 1152
                    height: 169
                    uri: "pkg://images/generic_left.9.png"
                    blendColor: "#FDCD00"
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