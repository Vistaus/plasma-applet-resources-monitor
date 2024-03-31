import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import "../controls" as RMControls

Kirigami.FormLayout {
    id: root

    signal changed // Notify some settings as been changed

    /**
     * Settings format:
     * {
     *   "_v": 1, // Version of data (for compatibility)
     *   "type": "disk",
     *   "colors": ["readColor", "writeColor"],
     *   "sensorsType": [invert], // Values: true/false (swap r/w)
     *   "uplimits": [0, 0], // Chart1, Chart2
     *   "device": "all" // Device id (eg. sda, sdc) | Could be "all" | [managed by graphs]
     * }
     */
    required property var item

    readonly property string dialectSuffix: i18nc("kibibyte suffix", "iB/s")
    readonly property var speedOptions: [
        {
            "label": i18n("Custom"),
            "value": -1
        },
        {
            "label": i18n("Automatic"),
            "value": 0.0
        },
        {
            "label": "10 M" + dialectSuffix,
            "value": 10000.0
        },
        {
            "label": "100 M" + dialectSuffix,
            "value": 100000.0
        },
        {
            "label": "200 M" + dialectSuffix,
            "value": 200000.0
        },
        {
            "label": "500 M" + dialectSuffix,
            "value": 500000.0
        },
        {
            "label": "1 G" + dialectSuffix,
            "value": 1000000.0
        },
        {
            "label": "2 G" + dialectSuffix,
            "value": 2000000.0
        },
        {
            "label": "5 G" + dialectSuffix,
            "value": 5000000.0
        },
        {
            "label": "10 G" + dialectSuffix,
            "value": 10000000.0
        }
    ]

    QQC2.CheckBox {
        text: i18n("Swap first and second line")
        checked: item.sensorsType[0]
        onClicked: {
            item.sensorsType[0] = checked;
            root.changed();
        }
    }

    // Transfer speed
    Item {
        Kirigami.FormData.label: i18n("Maximum transfer speed")
        Kirigami.FormData.isSection: true
    }
    RMControls.PredefinedSpinBox {
        id: readSpeed
        Layout.fillWidth: true
        Kirigami.FormData.label: i18nc("Chart config", "Read:")
        factor: 1000

        realValue: item.uplimits[0]
        onRealValueChanged: {
            item.uplimits[0] = readSpeed.realValue;
            root.changed();
        }

        predefinedChoices {
            textRole: "label"
            valueRole: "value"
            model: speedOptions
        }

        spinBox {
            decimals: 3
            stepSize: 1
            realFrom: 0.001
            suffix: " M" + dialectSuffix
        }
    }
    RMControls.PredefinedSpinBox {
        id: writeSpeed
        Layout.fillWidth: true
        Kirigami.FormData.label: i18nc("Chart config", "Write:")
        factor: 1000

        realValue: item.uplimits[1]
        onRealValueChanged: {
            item.uplimits[1] = writeSpeed.realValue;
            root.changed();
        }

        predefinedChoices {
            textRole: "label"
            valueRole: "value"
            model: speedOptions
        }

        spinBox {
            decimals: 3
            stepSize: 1
            realFrom: 0.001
            suffix: " MiB/s"
        }
    }

    // Colors
    Kirigami.Separator {
        Kirigami.FormData.label: i18n("Colors")
        Kirigami.FormData.isSection: true
    }
    RMControls.ColorSelector {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("First line:")
        dialogTitle: i18nc("Chart color", "Choose series color")

        value: item.colors[0]
        onValueChanged: {
            item.colors[0] = value;
            root.changed();
        }
    }
    RMControls.ColorSelector {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Second Line:")
        dialogTitle: i18nc("Chart color", "Choose text color")

        value: item.colors[1]
        onValueChanged: {
            item.colors[1] = value;
            root.changed();
        }
    }
}