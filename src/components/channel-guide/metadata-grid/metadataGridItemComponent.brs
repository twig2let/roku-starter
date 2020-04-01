function init()
    m.layout = getLayout()

    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.logoPoster = m.top.findNode("logoPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")
    m.backgroundPosterAnimation = m.top.findNode("backgroundPosterAnimation")
    m.backgroundPosterAnimationInterp = m.top.findNode("backgroundPosterAnimationInterp")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")
    m.top.getParent().ObserveField("currFocusColumn", "onCurrFocusColumnChanged")
end function

function onItemContentChanged(evt = {} as object) as void
    itemContent = m.top.itemContent
    m.titleLabel.text = itemContent.title
    m.synopsisLabel.text = itemContent.synopsis

    if itemContent.isNext
        m.logoPoster.visible = false
        m.synopsisLabel.visible = false
        m.backgroundPoster.setFields(m.layout.next.backgroundPoster)
    else
        m.backgroundPoster.setFields(m.layout.now.backgroundPoster)
    end if
end function

function onFocusPercentChanged()
    if m.top.focusPercent > 0
        setFocusedStyle()
    end if

    if m.top.focusPercent < 1
        setUnfocusedStyle()
    end if

    '  If this is a now item
    if not m.top.itemContent.isNext and m.top.focusPercent < 1
        m.backgroundPoster.translation = [(560*m.top.focusPercent), 0]
    end if

end function

function setFocusedStyle()
    m.backgroundPoster.blendColor = "#FCCC12"
    m.titleLabel.color = "#000000"
    m.synopsisLabel.color = "#000000"
    m.logoPoster.uri="pkg:/images/metadata-logo-focused.png"
end function

function setUnfocusedStyle()
    m.backgroundPoster.blendColor = "#222222"
    m.titleLabel.color = "#ffffff"
    m.synopsisLabel.color = "#ffffff"
    m.logoPoster.uri="pkg:/images/metadata-logo.png"
end function

function onCurrFocusColumnChanged() as Void
    ' Next column focused...
    if m.top.getParent().currFocusColumn > 0
        ' associatedNowItem = m.top.getParent().content.getChild(m.top.index - 1)
        ' associatedNowItem.findNode("backgroundPoster").translation = [(800 * m.top.focusPercent),0]
    end if
end function

function getLayout()
    return {
        now: {
            backgroundPoster: {
                width: 1036
                height: 152
                uri: "pkg://images/generic_left.9.png"
                blendColor: "#222222"
            }
        }
        next: {
            backgroundPoster: {
                width: 560
                height: 152
                uri: "pkg://images/generic_right.9.png"
                blendColor: "#222222"
            }
        }
    }
end function
