import QtQuick
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    pluginId: "hyprlandSubmapIndicator"

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
        description: "Assign custom labels and/or text colors to certain submaps"
        defaultValue: []
        fields: [
            {
                id: "submap",
                label: "Submap",
                placeholder: "resize",
                width: 150,
                required: true
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
        description: "Material icon name displayed by default. Leave blank to disable"
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
        description: "Assign specific icons and/or icon colors to certain submaps"
        defaultValue: []
        fields: [
            {
                id: "submap",
                label: "Submap",
                placeholder: "resize",
                width: 150,
                required: true
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
