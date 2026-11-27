import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

import org.streetpea.chiaking

import "controls" as C

DialogView {
    id: dialog
    property alias gridHeight: displayGrid.height
    title: qsTr("Настройки изображения")
    header: qsTr("* Значения по умолчанию указаны в скобках или помечены как (По умолчанию)")
    buttonVisible: false

    Item {
        // Stream Настройки изображения
        GridLayout {
            id: displayGrid
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 20
            }
            columns: 3
            rowSpacing: 10
            columnSpacing: 20

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Целевые основные цвета:")
            }

            C.ComboBox {
                firstInFocusChain: true
                Layout.preferredWidth: 600
                model: [qsTr("Авто"), qsTr("ITU-R Rec. BT.601 NTSC (стандартный охват)"), qsTr("ITU-R Rec. BT.601 PAL (стандартный охват)"), qsTr("ITU-R Rec. BT.709 (стандартный охват)"), qsTr("ITU-R Rec. BT.470 M (стандартный охват)"), qsTr("EBU Tech. 3213-E (стандартный охват)"), qsTr("ITU-R Rec. BT.2020 (широкий охват)"), qsTr("Apple RGB (широкий охват)"), qsTr("Adobe RGB (широкий охват)"), qsTr("ProPhoto RGB (широкий охват)"), qsTr("Основные цвета CIE 1931 RGB (широкий охват)"), qsTr("DCI-P3 (широкий охват)"), qsTr("DCI-P3 с точкой белого D65 (широкий охват)"), qsTr("Panasonic V-Gamut (широкий охват)"), qsTr("Sony S-Gamut (широкий охват)"), qsTr("Традиционные киноплёночные основные цвета с источником света C (широкий охват)"), qsTr("Основные цвета ACES #0 (широкий охват)"), qsTr("Основные цвета ACES #1 (широкий охват)")]
                currentIndex: Chiaki.settings.displayTargetPrim
                onActivated: index => Chiaki.settings.displayTargetPrim = index
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("(Авто)")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Целевая передаточная характеристика:")
            }

            C.ComboBox {
                Layout.preferredWidth: 600
                model: [qsTr("Авто"), qsTr("ITU-R Rec. BT.1886 (SDR)"), qsTr("IEC 61966-2-4 sRGB (SDR)"), qsTr("Линейное световое содержимое (SDR)"), qsTr("Степенная гамма 1.8 (SDR)"), qsTr("Степенная гамма 2.0 (SDR)"), qsTr("Степенная гамма 2.2 (SDR)"), qsTr("Степенная гамма 2.4 (SDR)"), qsTr("Степенная гамма 2.6 (SDR)"), qsTr("Степенная гамма 2.8 (SDR)"), qsTr("ProPhoto RGB (SDR)"), qsTr("Мастер цифрового кинематографа (SDR)"), qsTr("ITU-R BT.2100 PQ / SMPTE ST2048 (HDR)"), qsTr("ITU-R BT.2100 HLG / ARIB STD-B67 (HDR)"), qsTr("Panasonic V-Log (HDR)"), qsTr("Sony S-Log1 (HDR)"), qsTr("Sony S-Log2 (HDR)")]
                currentIndex: Chiaki.settings.displayTargetTrc
                onActivated: index => Chiaki.settings.displayTargetTrc = index
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("(Авто)")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Целевая яркость:")
            }

            C.ComboBox {
                id: targetPeakChoice
                Layout.preferredWidth: 400
                model: [qsTr("Авто"), qsTr("Числовое значение")]
                currentIndex: {
                    if(Chiaki.settings.displayTargetPeak == 0)
                        0;
                    else
                        1;
                }
                onActivated: index => {
                    if(index == 0)
                        Chiaki.settings.displayTargetPeak = 0;
                    else if(index == 1)
                        Chiaki.settings.displayTargetPeak = 1000;
                }
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("(Авто)")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Целевое значение яркости:")
                visible: targetPeakChoice.currentIndex == 1
            }
            
            C.Slider {
                id: targetPeakValue
                Layout.preferredWidth: 250
                from: 10
                to: 10000
                stepSize: 10
                value: Chiaki.settings.displayTargetPeak
                onMoved: Chiaki.settings.displayTargetPeak = value

                Label {
                    anchors {
                        left: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                    text: parent.value + qsTr(" нит")
                }
                visible: targetPeakChoice.currentIndex == 1
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("(1000 нит)")
                visible: targetPeakChoice.currentIndex == 1
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Целевая контрастность:")
            }

            C.ComboBox {
                id: targetContrastChoice
                Layout.preferredWidth: 400
                lastInFocusChain: currentIndex != 2
                model: [qsTr("Авто"), qsTr("Бесконечность"), qsTr("Числовое значение")]
                currentIndex: {
                    if(Chiaki.settings.displayTargetContrast == -1)
                        1;
                    else if(Chiaki.settings.displayTargetContrast == 0)
                        0;
                    else
                        2;
                }
                onActivated: index => {
                    if(index == 0)
                        Chiaki.settings.displayTargetContrast = 0;
                    else if(index == 1)
                        Chiaki.settings.displayTargetContrast = -1;
                    else if(index == 2)
                        Chiaki.settings.displayTargetContrast = 1000;
                }
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("(Авто)")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Целевое значение контрастности:")
                visible: targetContrastChoice.currentIndex == 2
            }
            
            C.Slider {
                id: targetContrastValue
                Layout.preferredWidth: 250
                from: 10
                to: 1000000
                stepSize: 1000
                value: Chiaki.settings.displayTargetContrast
                onMoved: Chiaki.settings.displayTargetContrast = value

                Label {
                    anchors {
                        left: parent.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                    }
                    text: parent.value
                }
                visible: targetContrastChoice.currentIndex == 2
                lastInFocusChain: true
            }

            Label {
                Layout.alignment: Qt.AlignRight
                visible: targetContrastChoice.currentIndex == 2
                text: qsTr("(1000)")
            }
        }
    }
}