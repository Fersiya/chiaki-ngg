import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Dialogs

import org.streetpea.chiaking

import "controls" as C

DialogView {
    enum GamutMappingFunction {
        Обрезка,
        Перцептивный,
        SoftОбрезка,
        Относительный,
        Насыщенность,
        Абсолютный,
        Обесцветить,
        Затемнить,
        Светлые участки,
        Линейный
    }
    enum ToneMappingFunction {
        Обрезка,
        Spline,
        St209440,
        St209410,
        Bt2390,
        Bt2446a,
        Reinhard,
        Mobius,
        Hable,
        Gamma,
        Линейный,
        ЛинейныйLight
    }
    id: dialog
    title: qsTr("Настройки цветового отображения")
    header: qsTr("* Значения по умолчанию указаны в скобках справа от параметра или отмечены как (по умолчанию)")
    buttonVisible: false
    Keys.onPressed: (event) => {
        if (event.modifiers)
            return;
        switch (event.key) {
        case Qt.Key_PageUp:
            bar.decrementCurrentIndex();
            event.accepted = true;
            break;
        case Qt.Key_PageDown:
            bar.incrementCurrentIndex();
            event.accepted = true;
            break;
        }
    }

    Item {
        TabBar {
            id: bar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: 5
            }

            TabButton {
                text: qsTr("Преобразование цветового охвата 1")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Преобразование цветового охвата 2")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Тональное отображение 1")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Тональное отображение 2")
                focusPolicy: Qt.NoFocus
            }

           TabButton {
                text: qsTr("Тональное отображение 3")
                focusPolicy: Qt.NoFocus
            }
        }

        StackLayout {
            anchors {
                top: bar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            currentIndex: bar.currentIndex
            onCurrentIndexChanged: nextItemInFocusChain().forceActiveFocus(Qt.TabFocusReason)

            Item {
                // Преобразование цветового охвата 1
                GridLayout {
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
                        text: qsTr("Метод преобразования цветового охвата:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Обрезка"), qsTr("Перцептивный"), qsTr("Мягкая обрезка"), qsTr("Относительный"), qsTr("Насыщенность"), qsTr("Абсолютный"), qsTr("Обесцветить"), qsTr("Затемнить"), qsTr("Светлые участки"), qsTr("Линейный")]
                        currentIndex: Chiaki.settings.placeboGamutMappingFunction
                        onActivated: index => Chiaki.settings.placeboGamutMappingFunction = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Перцептивный)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Мёртвая зона восприятия:")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingПерцептивныйDeadzone
                        onMoved: Chiaki.settings.placeboGamutMappingПерцептивныйDeadzone = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.30)")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Интенсивность перцептивного преобразования:")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingПерцептивныйStrength
                        onMoved: Chiaki.settings.placeboGamutMappingПерцептивныйStrength = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный

                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.80)")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Колориметрическая гамма:")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Относительный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Абсолютный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Затемнить
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 10.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingColorimetricGamma
                        onMoved: Chiaki.settings.placeboGamutMappingColorimetricGamma = value
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Относительный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Абсолютный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Затемнить

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(1.80)")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Относительный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Абсолютный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Затемнить
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Порог мягкого ограничения:")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftОбрезка
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingSoftОбрезкаKnee
                        onMoved: Chiaki.settings.placeboGamutMappingSoftОбрезкаKnee = value
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftОбрезка

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.70)")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.Перцептивный || Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftОбрезка
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Обесцвечивание при мягком ограничении:")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftОбрезка
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboGamutMappingSoftОбрезкаDesat
                        onMoved: Chiaki.settings.placeboGamutMappingSoftОбрезкаDesat = value
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftОбрезка

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.35)")
                        visible: Chiaki.settings.placeboGamutMappingFunction == PlaceboColorMappingDialog.GamutMappingFunction.SoftОбрезка
                    }
                }
            }

            Item {
                // Преобразование цветового охвата 2
                GridLayout {
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
                        text: qsTr("Размер 3D LUT I:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 1024
                        stepSize: 1
                        value: Chiaki.settings.placeboGamutMappingLut3dSizeI
                        onMoved: Chiaki.settings.placeboGamutMappingLut3dSizeI = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr("%1").arg(parent.value)
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(48)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Размер 3D LUT C:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 1024
                        stepSize: 1
                        value: Chiaki.settings.placeboGamutMappingLut3dSizeC
                        onMoved: Chiaki.settings.placeboGamutMappingLut3dSizeC = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr("%1").arg(parent.value)
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(32)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Размер 3D LUT h:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 1024
                        stepSize: 1
                        value: Chiaki.settings.placeboGamutMappingLut3dSizeH
                        onMoved: Chiaki.settings.placeboGamutMappingLut3dSizeH = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr("%1").arg(parent.value)
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(256)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Триквадратичная интерполяция 3D LUT включена:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить трикубическую интерполяцию для 3D LUT")
                        checked: Chiaki.settings.placeboGamutMappingLut3dTricubicEnabled
                        onToggled: Chiaki.settings.placeboGamutMappingLut3dTricubicEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(выключено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Расширение цветового охвата включено:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить расширение цветового охвата")
                        checked: Chiaki.settings.placeboGamutMappingGamutExpansionEnabled
                        onToggled: Chiaki.settings.placeboGamutMappingGamutExpansionEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(выключено)")
                    }
                }
            }

            Item {
                // Тональное отображение 1
                GridLayout {
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
                        text: qsTr("Метод тонального отображения:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Обрезка"), qsTr("Сплайн"), qsTr("ST 2094-40"), qsTr("ST 2094-10"), qsTr("BT.2390"), qsTr("BT.2446a"), qsTr("Рейнхард"), qsTr("Мёбиус"), qsTr("Хейбл"), qsTr("Гамма"), qsTr("Линейный"), qsTr("Линейный свет")]
                        currentIndex: Chiaki.settings.placeboToneMappingFunction
                        onActivated: index => Chiaki.settings.placeboToneMappingFunction = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Spline)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Адаптация порога:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209440 || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209410
                    }

                    C.Slider {
                        id: kneeadaptation
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeAdaptation
                        onMoved: Chiaki.settings.placeboToneMappingKneeAdaptation = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209440 || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209410

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.40)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209440 || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.St209410
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Минимальный порог:")
                        visible: kneeadaptation.visible
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 0.50
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeMinimum
                        onMoved: Chiaki.settings.placeboToneMappingKneeMinimum = value
                        visible: kneeadaptation.visible

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.10)")
                        visible: kneeadaptation.visible
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Максимальный порог:")
                        visible: kneeadaptation.visible
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.50
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeMaximum
                        onMoved: Chiaki.settings.placeboToneMappingKneeMaximum = value
                        visible: kneeadaptation.visible

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.80)")
                        visible: kneeadaptation.visible
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Порог по умолчанию:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeDefault
                        onMoved: Chiaki.settings.placeboToneMappingKneeDefault = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.40)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Смещение порога:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Bt2390
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.50
                        to: 2.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingKneeOffset
                        onMoved: Chiaki.settings.placeboToneMappingKneeOffset = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Bt2390

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(1.00)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Bt2390
                    }
                }
            }

            Item {
                // Тональное отображение 2
                GridLayout {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 20
                    }
                    columns: 3
                    rowSpacing: 10
                    columnSpacing: 100

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Настройка наклона:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 10.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboToneMappingSlopeTuning
                        onMoved: Chiaki.settings.placeboToneMappingSlopeTuning = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline

                        Label {
                            id: slopeTuningLabel
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(1.5)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Смещение наклона:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingSlopeOffset
                        onMoved: Chiaki.settings.placeboToneMappingSlopeOffset = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.20)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Контрастность сплайна:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.50
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingSplineContrast
                        onMoved: Chiaki.settings.placeboToneMappingSplineContrast = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.50)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Spline
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Контрастность Рейнхарда:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Reinhard
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingReinhardContrast
                        onMoved: Chiaki.settings.placeboToneMappingReinhardContrast = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Reinhard

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.50)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Reinhard
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Линейный порог:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Mobius || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Gamma
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingЛинейныйKnee
                        onMoved: Chiaki.settings.placeboToneMappingЛинейныйKnee = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Mobius || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Gamma

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.3)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Mobius || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Gamma
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Экспозиция:")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Линейный || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.ЛинейныйLight
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 10.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboToneMappingExposure
                        onMoved: Chiaki.settings.placeboToneMappingExposure = value
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Линейный || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.ЛинейныйLight

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(1.0)")
                        visible: Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.Линейный || Chiaki.settings.placeboToneMappingFunction == PlaceboColorMappingDialog.ToneMappingFunction.ЛинейныйLight
                    }
                }
            }
            
            Item {
                // Тональное отображение 3
                GridLayout {
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
                        text: qsTr("Обратное тональное отображение включено:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить обратное тональное отображение")
                        checked: Chiaki.settings.placeboToneMappingInverseToneMappingEnabled
                        onToggled: Chiaki.settings.placeboToneMappingInverseToneMappingEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(выключено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Метаданные тонального отображения:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Любые"), qsTr("Нет"), qsTr("HDR10"), qsTr("HDR10+"), qsTr("Cie_y")]
                        currentIndex: Chiaki.settings.placeboToneMappingMetadata
                        onActivated: index => Chiaki.settings.placeboToneMappingMetadata = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Любые)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Размер тональной LUT:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 4096
                        stepSize: 1
                        value: Chiaki.settings.placeboToneMappingToneLutSize
                        onMoved: Chiaki.settings.placeboToneMappingToneLutSize = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr("%1").arg(parent.value)
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(256)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Восстановление контрастности:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 2.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboToneMappingContrastRecovery
                        onMoved: Chiaki.settings.placeboToneMappingContrastRecovery = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(2))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.30)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Сглаживание контрастности:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 1.0
                        to: 32.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboToneMappingContrastSmoothness
                        onMoved: Chiaki.settings.placeboToneMappingContrastSmoothness = value

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(1))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(3.5)")
                    }
                }
            }
        }
    }
}