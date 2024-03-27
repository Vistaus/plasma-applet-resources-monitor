import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "../controls" as RMControls

Kirigami.FormLayout {
    id: root

    signal changed // Notify some settings as been changed

    /**
     * Settings format:
     * {
     *   "_v": 1, // Version of data (for compatibility)
     *   "type": "cpu",
     *   "colors": ["usageColor", "clockColor", "tempColor"],
     *   "sensorsType": ["usage", "clock", temperature], // Values: "usage/system/user" | "none/classic/ecores" | true/false
     *   "thresholds": [0, 0], // Temperature
     *   "clockAgregator": "average", // Values: average, minimum, maximum
     *   "eCoresCount": 0
     * }
     */
    required property var item

    QQC2.ComboBox {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("First line:")

        textRole: "label"
        valueRole: "value"
        model: [
            {
                "label": i18n("Total usage"),
                "value": "usage"
            },
            {
                "label": i18n("System usage"),
                "value": "system"
            },
            {
                "label": i18n("User usage"),
                "value": "user"
            }
        ]

        Component.onCompleted: currentIndex = indexOfValue(item.sensorsType[0])
        onActivated: {
            item.sensorsType[0] = currentValue;
            root.changed();
        }
    }

    // Clock
    QQC2.ComboBox {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Second Line:")

        textRole: "label"
        valueRole: "value"
        model: [
            {
                "label": i18n("Disabled"),
                "value": "none"
            },
            {
                "label": i18n("Classic/P-cores clock frequency"),
                "value": "classic"
            },
            {
                "label": i18n("E-cores clock frequency"),
                "value": "ecores"
            }
        ]

        Component.onCompleted: currentIndex = indexOfValue(item.sensorsType[1])
        onActivated: {
            item.sensorsType[1] = currentValue;
            root.changed();
        }
    }
    QQC2.ComboBox {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Clock aggregator:")

        textRole: "label"
        valueRole: "value"
        model: [
            {
                "label": i18nc("Agregator", "Average"),
                "value": "average"
            },
            {
                "label": i18nc("Agregator", "Minimum"),
                "value": "minimum"
            },
            {
                "label": i18nc("Agregator", "Maximum"),
                "value": "maximum"
            }
        ]

        Component.onCompleted: currentIndex = indexOfValue(item.clockAgregator)
        onActivated: {
            item.clockAgregator = currentValue;
            root.changed();
        }
    }
    // TODO: find way to show only when detect "e-cores" (maybe: compare first and last core frequency)
    // Define Number of E-Cores, it's used for separating Intel
    // E-cores and P-Cores when calculating CPU frequency,
    // because they have different frequencies.
    RMControls.SpinBox {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("E-cores")
        from: 0
        to: 100

        realValue: item.eCoresCount
        onRealValueChanged: {
            item.eCoresCount = value;
            root.changed();
        }

        QQC2.ToolTip.text: i18nc("@info:tooltip", "<b>For Intel 12+ gen only</b><br>Number of E-Cores your CPU have, it's for seperate it from P-Cores in frequency average calculation.")
        QQC2.ToolTip.visible: hovered
    }

    QQC2.CheckBox {
        text: i18n("Show temperature")
        checked: item.sensorsType[2]
        onClicked: {
            item.sensorsType[2] = checked;
            root.changed();
        }
    }

    RMControls.Thresholds {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Temperature threshold:")

        values: item.thresholds
        onValuesChanged: {
            item.thresholds = values;
            root.changed();
        }

        decimals: 1
        stepSize: 1
        realFrom: 0.1
        realTo: 120
        suffix: " °C"
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
    RMControls.ColorSelector {
        Layout.fillWidth: true
        Kirigami.FormData.label: i18n("Third Line:")
        dialogTitle: i18nc("Chart color", "Choose text color")

        value: item.colors[2]
        onValueChanged: {
            item.colors[2] = value;
            root.changed();
        }
    }
}
