import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property string submapName: ""
    readonly property bool alwaysShow: pluginData?.alwaysShow === true
    readonly property bool hasSubmap: submapName !== ""
    readonly property bool indicatorVisible: root.alwaysShow || root.hasSubmap

    readonly property bool clickToReset: pluginData?.clickToReset !== undefined ? pluginData.clickToReset : true
    readonly property bool iconInheritColor: pluginData?.iconInheritColor !== undefined ? pluginData.iconInheritColor : true
    readonly property bool useLabel: pluginData?.fontSize !== "none"
    readonly property var submapIcons: pluginData?.submapIcons || []
    readonly property var submapLabels: pluginData?.submapLabels || []
    readonly property string defaultIconColor: pluginData?.defaultIconColor || ""
    readonly property string defaultTextColor: pluginData?.defaultTextColor || ""
    readonly property string defaultIconName: pluginData?.defaultIconName || (useLabel ? "" : "layers")

    readonly property int fontSize: {
        const size = pluginData?.fontSize
        if (size === "medium") return Theme.fontSizeMedium
        if (size === "large") return Theme.fontSizeLarge
        if (size === "xlarge") return Theme.fontSizeXLarge
        return Theme.fontSizeSmall
    }

    readonly property int pillSpacing: {
        const size = pluginData?.fontSize
        if (size === "medium") return Theme.spacingXS
        if (size === "large") return Theme.spacingS
        if (size === "xlarge") return Theme.spacingS
        return Theme.spacingXS
    }

    function colorIsSet(colorStr) {
        return colorStr && colorStr !== "#00000000"
    }

    readonly property var currentLabelOverride: root.submapLabels.find(s => s.submap === root.submapName) || null
    readonly property var currentIconOverride: root.submapIcons.find(s => s.submap === root.submapName) || null

    readonly property bool hasExplicitLabelColor: colorIsSet(currentLabelOverride?.color || root.defaultTextColor)
    readonly property bool hasExplicitIconColor: colorIsSet(currentIconOverride?.color || root.defaultIconColor)

    readonly property color currentLabelColor: hasExplicitLabelColor
        ? (currentLabelOverride?.color || root.defaultTextColor)
        : Theme.surfaceText

    readonly property color currentIconColor: {
        if (hasExplicitIconColor) return currentIconOverride?.color || root.defaultIconColor
        if (root.iconInheritColor && hasExplicitLabelColor) return currentLabelColor
        return Theme.surfaceText
    }

    readonly property string currentLabel: currentLabelOverride?.label || root.submapName
    readonly property bool showLabel: useLabel && root.currentLabel !== ""
    readonly property bool showIcon: root.currentIcon !== ""
    readonly property string currentIcon: {
        if (!root.indicatorVisible) return ""
        if (root.hasSubmap) return currentIconOverride?.icon || root.defaultIconName
        if (root.showLabel) return currentIconOverride?.icon || ""
        return currentIconOverride?.icon || "layers_clear"
    }

    opacity: indicatorVisible ? 1 : 0

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "submap") {
                const name = event.data.trim()
                root.submapName = name
            }
        }
    }

    pillClickAction: function() {
        if (!root.clickToReset) return
        if (Hyprland.usingLua === false) {
            Hyprland.dispatch("submap reset")
        } else {
            Hyprland.dispatch("hl.dsp.submap(\"reset\")")
        }
    }

    states: [
        State {
            name: "hidden_horizontal"
            when: !root.indicatorVisible && !root.isVertical
            PropertyChanges {
                target: root
                width: 0
            }
        },
        State {
            name: "hidden_vertical"
            when: !root.indicatorVisible && root.isVertical
            PropertyChanges {
                target: root
                height: 0
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "width,height"
                duration: Theme.shortDuration
                easing.type: Theme.standardEasing
            }
        }
    ]

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.shortDuration
            easing.type: Theme.standardEasing
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: root.pillSpacing

            DIcon {
                name: root.currentIcon
                size: root.iconSize
                color: root.currentIconColor
                visible: root.showIcon
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                text: root.currentLabel
                font.pixelSize: root.fontSize
                color: root.currentLabelColor
                visible: root.showLabel
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: root.pillSpacing

            DIcon {
                name: root.currentIcon
                size: root.iconSize
                color: root.currentIconColor
                visible: root.showIcon
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                text: root.currentLabel
                font.pixelSize: root.fontSize
                color: root.currentLabelColor
                visible: root.showLabel
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
