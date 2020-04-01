function init()
    m.layout = getLayout()

    m.backgroundPoster = m.top.findNode("backgroundPoster")
    m.logoPoster = m.top.findNode("logoPoster")
    m.titleLabel = m.top.findNode("titleLabel")
    m.synopsisLabel = m.top.findNode("synopsisLabel")

    m.top.ObserveFieldScoped("itemContent", "onItemContentChanged")
    m.top.ObserveFieldScoped("focusPercent", "onFocusPercentChanged")
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
    if m.top.focusPercent > 0 then setFocusedState() else setUnfocusedState()
end function

function setFocusedState()
    m.backgroundPoster.blendColor = "#FCCC12"
    m.titleLabel.color = "#000000"
    m.synopsisLabel.color = "#000000"
    m.logoPoster.uri="pkg:/images/metadata-logo-focused.png"
end function

function setUnfocusedState()
    m.backgroundPoster.blendColor = "#222222"
    m.titleLabel.color = "#ffffff"
    m.synopsisLabel.color = "#ffffff"
    m.logoPoster.uri="pkg:/images/metadata-logo.png"
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
