import QtQuick
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: settingsRoot
    pluginId: "hyprlandSubmapIndicator"

    property bool alwaysShowOn: false
    property bool idleAppearanceMissing: false

    function updateIdleWarning() {
        settingsRoot.alwaysShowOn = settingsRoot.loadValue("alwaysShow", false) === true
        const showLabelText = settingsRoot.loadValue("fontSize", "small") !== "none"
        const idleIcon = (settingsRoot.loadValue("submapIcons", []) || []).find(s => !s.submap)?.icon
        const idleLabel = (settingsRoot.loadValue("submapLabels", []) || []).find(s => !s.submap)?.label
        const hasIdleIcon = (idleIcon || "") !== ""
        const hasIdleLabel = showLabelText && (idleLabel || "") !== ""
        settingsRoot.idleAppearanceMissing = !hasIdleIcon && !hasIdleLabel
    }

    Component.onCompleted: Qt.callLater(settingsRoot.updateIdleWarning)

    Connections {
        target: settingsRoot

        function onSettingChanged() {
            settingsRoot.updateIdleWarning()
        }

        function onPluginServiceChanged() {
            Qt.callLater(settingsRoot.updateIdleWarning)
        }
    }

    StyledText {
        width: parent.width
        text: "Behavior"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    ToggleSetting {
        settingKey: "clickToReset"
        label: "Click to reset"
        description: "Clicking the indicator resets to the default submap"
        defaultValue: true
    }

    ToggleSetting {
        settingKey: "alwaysShow"
        label: "Always show"
        description: "Keep the indicator visible even when no submap is active"
        defaultValue: false
    }

    StyledText {
        width: parent.width
        visible: settingsRoot.alwaysShowOn && settingsRoot.idleAppearanceMissing
        text: "'Always show' is enabled, but no idle appearance is configured. A fallback icon will be shown.\n\n" +
            "Add an entry below with a blank submap name to assign an idle label and/or icon."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.warning
        wrapMode: Text.WordWrap
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        width: parent.width
        text: "Label appearance"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    SelectionSetting {
        settingKey: "fontSize"
        label: "Font size"
        description: "Font size of the submap name"
        options: [
            { label: "None (Icon only)", value: "none" },
            { label: "Small", value: "small" },
            { label: "Medium", value: "medium" },
            { label: "Large", value: "large" },
            { label: "X-Large", value: "xlarge" }
        ]
        defaultValue: "small"
    }

    ColorSetting {
        settingKey: "defaultTextColor"
        label: "Default text color"
        description: "Default color for the submap name. #00000000 uses the default theme"
        defaultValue: "transparent"
    }

    ListSettingWithInput {
        settingKey: "submapLabels"
        label: "Submap labels"
        description: settingsRoot.alwaysShowOn
            ? "Assign custom labels and/or text colors to certain submaps. Leave the submap name blank to configure the idle (no submap) label."
            : "Assign custom labels and/or text colors to certain submaps."
        defaultValue: []
        fields: [
            {
                id: "submap",
                label: "Submap",
                placeholder: "resize",
                width: 150,
                required: false
            },
            {
                id: "label",
                label: "Label (optional)",
                placeholder: "Resizing…",
                width: 125,
                required: false
            },
            {
                id: "color",
                label: "Color (optional)",
                placeholder: "#F38BA8",
                width: 125,
                required: false
            }
        ]
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Theme.outline
        opacity: 0.3
    }

    StyledText {
        text: "Icon appearance"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
        width: parent.width
    }

    StringSetting {
        settingKey: "defaultIconName"
        label: "Default icon"
        description: "Material icon name displayed by default when a submap is active. Leave blank to disable"
        defaultValue: ""
    }

    StyledText {
        text: "For a list of available icon names, visit " +
            "<a href=\"https://fonts.google.com/icons\">https://fonts.google.com/icons</a>."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        linkColor: Theme.primary
        textFormat: Text.RichText
        width: parent.width
        onLinkActivated: (link) => Quickshell.execDetached(["xdg-open", link]);
    }

    Row {
        width: parent.width
        spacing: Theme.spacingM

        ToggleSetting {
            settingKey: "iconInheritColor"
            label: "Inherit label color"
            description: "Icon matches the label color.\nDisable to use default icon color instead"
            defaultValue: true
            width: (parent.width - parent.spacing) / 2
        }

        ColorSetting {
            settingKey: "defaultIconColor"
            label: "Default icon color"
            description: "Default color for the icon.\n#00000000 uses the default theme"
            defaultValue: "#00000000"
            width: (parent.width - parent.spacing) / 2
        }
    }

    ListSettingWithInput {
        settingKey: "submapIcons"
        label: "Submap icons"
        description: settingsRoot.alwaysShowOn
            ? "Assign specific icons and/or icon colors to certain submaps. Leave the submap name blank to configure the idle (no submap) appearance."
            : "Assign specific icons and/or icon colors to certain submaps."
        defaultValue: []
        fields: [
            {
                id: "submap",
                label: "Submap",
                placeholder: "resize",
                width: 150,
                required: false
            },
            {
                id: "icon",
                label: "Icon (optional)",
                placeholder: "open_in_full",
                width: 125,
                required: false
            },
            {
                id: "color",
                label: "Color (optional)",
                placeholder: "#F38BA8",
                width: 125,
                required: false
            }
        ]
    }
}
