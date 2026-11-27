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
    property string options_url: ""
    title: qsTr("Настройки рендерера Placebo")
    header: qsTr("* Значения по умолчанию указаны в скобках или помечены как (По умолчанию)")
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
                text: qsTr("Конфигурация")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Масштабирование")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Деинтерлейсинг")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Устранение полос")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Сигмоидальное преобразование")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Цвет")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Определение пиков")
                focusPolicy: Qt.NoFocus
            }

            TabButton {
                text: qsTr("Преобразование цвета")
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
                // Конфигурация
                GridLayout {
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 20
                    }
                    columns: 2
                    rowSpacing: 10
                    columnSpacing: 20

                    Label {
                        text: qsTr("Подробная информация о параметрах рендерера libplacebo")
                        visible: !options_url
                    }

                    C.Button {
                        id: openwebpage
                        text: qsTr("Открыть документацию")
                        onClicked: {
                            options_url = Chiaki.openPlaceboOptionsLink()
                        }
                        visible: !options_url
                    }

                    Label {
                        text: qsTr("Открыть документацию в браузере (ссылка скопирована)")
                        visible: options_url
                    }

                    TextField {
                        id: openurl
                        echoMode: Chiaki.settings.streamerMode ? TextInput.Password : TextInput.Normal
                        text: options_url
                        visible: false
                        Layout.preferredWidth: 400
                    }

                    C.Button {
                        id: copyUrl
                        text: qsTr("Нажмите, чтобы скопировать ссылку повторно")
                        onClicked: {
                            openurl.selectAll()
                            openurl.copy()
                        }
                        visible: options_url
                    }

                    Label {
                        text: qsTr("Экспортировать настройки рендеринга в файл")
                    }

                    C.Button {
                        id: exportButton
                        text: qsTr("Экспорт")
                        onClicked: {
                            Chiaki.settings.exportPlaceboSettings();
                        }
                        Material.roundedScale: Material.SmallScale
                        KeyNavigation.down: importButton
                        KeyNavigation.right: importButton
                    }

                    Label {
                        text: qsTr("Импортировать настройки рендеринга из файла")
                    }

                    C.Button {
                        id: importButton
                        lastInFocusChain: true
                        text: qsTr("Импорт")
                        onClicked: {
                            Chiaki.settings.importPlaceboSettings();
                        }
                        Material.roundedScale: Material.SmallScale
                        KeyNavigation.up: exportButton
                        KeyNavigation.left: exportButton
                    }
                }
            }

            Item {
                // Масштабирование
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
                        text: qsTr("Алгоритм увеличения разрешения:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Пользовательский"), qsTr("Ближайший сосед"), qsTr("Билинейный"), qsTr("Сверхдискретизация"), qsTr("Бикубический"), qsTr("Гауссов"), qsTr("Катмулла — Рома"), qsTr("Ланцош"), qsTr("EwaLanczos"), qsTr("EwaLanczosSharp"), qsTr("EwaLanczosSharpest"), qsTr("FSR"), qsTr("FSRCNNX x2 8-0-4-1"), qsTr("FSRCNNX x2 16-0-4-1")]
                        currentIndex: Chiaki.settings.placeboUpscaler
                        onActivated: index => Chiaki.settings.placeboUpscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(EwaLanczos)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Алгоритм увеличения разрешения плоскости:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Выбранный алгоритм увеличения"), qsTr("Ближайший сосед"), qsTr("Билинейный"), qsTr("Сверхдискретизация"), qsTr("Бикубический"), qsTr("Гауссов"), qsTr("Катмулла — Рома"), qsTr("Ланцош"), qsTr("EwaLanczos"), qsTr("EwaLanczosSharp"), qsTr("EwaLanczosSharpest")]
                        currentIndex: Chiaki.settings.placeboPlaneUpscaler
                        onActivated: index => Chiaki.settings.placeboPlaneUpscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Выбранный алгоритм увеличения)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Алгоритм уменьшения разрешения:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Пользовательский"), qsTr("Блочный"), qsTr("Эрмитов"), qsTr("Билинейный"), qsTr("Бикубический"), qsTr("Гауссов"), qsTr("Катмулла — Рома"), qsTr("Mitchell"), qsTr("Ланцош")]
                        currentIndex: Chiaki.settings.placeboDownscaler
                        onActivated: index => Chiaki.settings.placeboDownscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Hermite)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Алгоритм уменьшения разрешения плоскости:")
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        firstInFocusChain: true
                        model: [qsTr("Выбранный алгоритм уменьшения"), qsTr("Блочный"), qsTr("Эрмитов"), qsTr("Билинейный"), qsTr("Бикубический"), qsTr("Гауссов"), qsTr("Катмулла — Рома"), qsTr("Mitchell"), qsTr("Ланцош")]
                        currentIndex: Chiaki.settings.placeboPlaneDownscaler
                        onActivated: index => Chiaki.settings.placeboPlaneDownscaler = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Выбранный алгоритм уменьшения)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Сила подавления звона:")
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboAntiringingStrength
                        onMoved: Chiaki.settings.placeboAntiringingStrength = value

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
                        text: qsTr("(0.00)")
                    }
                }
            }

            Item {
                // Деинтерлейсинг
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
                        text: qsTr("Включить деинтерлейсинг:")
                    }

                    C.CheckBox {
                        checked: Chiaki.settings.placeboДеинтерлейсингEnabled
                        onToggled: Chiaki.settings.placeboДеинтерлейсингEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(нет)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Предустановка:")
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("По умолчанию")]
                        currentIndex: Chiaki.settings.placeboДеинтерлейсингPreset
                        enabled: Chiaki.settings.placeboДеинтерлейсингEnabled
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                        onActivated: index => Chiaki.settings.placeboДеинтерлейсингPreset = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(По умолчанию)")
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Алгоритм:")
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Слияние полей"), qsTr("Боб"), qsTr("YADIF"), qsTr("BWDIF")]
                        currentIndex: Chiaki.settings.placeboДеинтерлейсингAlgorithm
                        enabled: Chiaki.settings.placeboДеинтерлейсингEnabled
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                        onActivated: index => Chiaki.settings.placeboДеинтерлейсингAlgorithm = index
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Yadif)")
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Пропускать пространственную проверку:")
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                    }

                    C.CheckBox {
                        checked: Chiaki.settings.placeboДеинтерлейсингSkipSpatial
                        enabled: Chiaki.settings.placeboДеинтерлейсингEnabled
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                        onToggled: Chiaki.settings.placeboДеинтерлейсингSkipSpatial = checked
                        Material.roundedScale: Material.SmallScale
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(нет)")
                        visible: Chiaki.settings.placeboДеинтерлейсингEnabled
                    }
                }
            }

            Item {
                // Устранение полос
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
                        text: qsTr("Устранение полос:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить устранение полос")
                        checked: Chiaki.settings.placeboDebandEnabled
                        onToggled: Chiaki.settings.placeboDebandEnabled = checked
                    }


                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Включено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Предустановка устранения полос:")
                        visible: Chiaki.settings.placeboDebandEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Пользовательский"), qsTr("По умолчанию")]
                        currentIndex: Chiaki.settings.placeboDebandPreset
                        onActivated: index => Chiaki.settings.placeboDebandPreset = index
                        visible: Chiaki.settings.placeboDebandEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Пользовательский)")
                        visible: Chiaki.settings.placeboDebandEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Количество итераций устранения полос:")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0
                        to: 16
                        stepSize: 1
                        value: Chiaki.settings.placeboDebandIterations
                        onMoved: Chiaki.settings.placeboDebandIterations = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

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
                        text: qsTr("(1)")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Порог устранения полос:")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboDebandThreshold
                        onMoved: Chiaki.settings.placeboDebandThreshold = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

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
                        text: qsTr("(3.0)")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Радиус устранения полос:")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboDebandRadius
                        onMoved: Chiaki.settings.placeboDebandRadius = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

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
                        text: qsTr("(16.0)")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Зернистость при устранении полос:")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboDebandGrain
                        onMoved: Chiaki.settings.placeboDebandGrain = value
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)

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
                        text: qsTr("(4.0)")
                        visible: Chiaki.settings.placeboDebandEnabled && (Chiaki.settings.placeboDebandPreset == 0)
                    }
                }
            }

            Item {
                // Сигмоидальное преобразование
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
                        text: qsTr("Сигмоидальное преобразование:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить сигмоидальное преобразование")
                        checked: Chiaki.settings.placeboSigmoidEnabled
                        onToggled: Chiaki.settings.placeboSigmoidEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Включено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Предустановка сигмоидального преобразования:")
                        visible: Chiaki.settings.placeboSigmoidEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Пользовательский"), qsTr("По умолчанию")]
                        currentIndex: Chiaki.settings.placeboSigmoidPreset
                        onActivated: index => Chiaki.settings.placeboSigmoidPreset = index
                        visible: Chiaki.settings.placeboSigmoidEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Пользовательский)")
                        visible: Chiaki.settings.placeboSigmoidEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Центр сигмоиды:")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboSigmoidCenter
                        onMoved: Chiaki.settings.placeboSigmoidCenter = value
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)

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
                        text: qsTr("(0.75)")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Наклон сигмоиды:")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 1.0
                        to: 20.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboSigmoidSlope
                        onMoved: Chiaki.settings.placeboSigmoidSlope = value
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)

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
                        text: qsTr("(6.5)")
                        visible: Chiaki.settings.placeboSigmoidEnabled && (Chiaki.settings.placeboSigmoidPreset == 0)
                    }
                }
            }

            Item {
                // Цвет
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
                        text: qsTr("Коррекция цвета:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить коррекцию цвета")
                        checked: Chiaki.settings.placeboЦветAdjustmentEnabled
                        onToggled: Chiaki.settings.placeboЦветAdjustmentEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Включено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Предустановка коррекции цвета:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Пользовательский"), qsTr("Нейтральная")]
                        currentIndex: Chiaki.settings.placeboЦветAdjustmentPreset
                        onActivated: index => Chiaki.settings.placeboЦветAdjustmentPreset = index
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Пользовательский)")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Яркость:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: -1.00
                        to: 1.00
                        stepSize: 0.01
                        value: Chiaki.settings.placeboЦветAdjustmentBrightness
                        onMoved: Chiaki.settings.placeboЦветAdjustmentBrightness = value
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)

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
                        text: qsTr("(0.00)")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Контрастность:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboЦветAdjustmentContrast
                        onMoved: Chiaki.settings.placeboЦветAdjustmentContrast = value
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)

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
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Насыщенность:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboЦветAdjustmentSaturation
                        onMoved: Chiaki.settings.placeboЦветAdjustmentSaturation = value
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)

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
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Оттенок:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.00
                        to: 6.28
                        stepSize: 0.01
                        value: Chiaki.settings.placeboЦветAdjustmentHue
                        onMoved: Chiaki.settings.placeboЦветAdjustmentHue = value
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)

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
                        text: qsTr("(0.00)")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Гамма:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboЦветAdjustmentGamma
                        onMoved: Chiaki.settings.placeboЦветAdjustmentGamma = value
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)

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
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Цветовая температура:")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: -1.143
                        to: 5.286
                        stepSize: 0.001
                        value: Chiaki.settings.placeboЦветAdjustmentTemperature
                        onMoved: Chiaki.settings.placeboЦветAdjustmentTemperature = value
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(3))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(0.000)")
                        visible: Chiaki.settings.placeboЦветAdjustmentEnabled && (Chiaki.settings.placeboЦветAdjustmentPreset == 0)
                    }
                }
            }

            Item {
                // Определение пиков
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
                        text: qsTr("Определение пиков HDR:")
                    }

                    C.CheckBox {
                        text: qsTr("Включить определение пиков HDR")
                        checked: Chiaki.settings.placeboPeakDetectionEnabled
                        onToggled: Chiaki.settings.placeboPeakDetectionEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Включено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Предустановка определения пиков:")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Пользовательский"), qsTr("По умолчанию"), qsTr("High Quality")]
                        currentIndex: Chiaki.settings.placeboPeakDetectionPreset
                        onActivated: index => Chiaki.settings.placeboPeakDetectionPreset = index
                        visible: Chiaki.settings.placeboPeakDetectionEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(High Quality)")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Период сглаживания пиков:")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 1000.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionPeakSmoothingPeriod
                        onMoved: Chiaki.settings.placeboPeakDetectionPeakSmoothingPeriod = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

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
                        text: qsTr("(20.0)")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Нижний порог сцены:")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionSceneThresholdLow
                        onMoved: Chiaki.settings.placeboPeakDetectionSceneThresholdLow = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

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
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Верхний порог сцены:")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionSceneThresholdHigh
                        onMoved: Chiaki.settings.placeboPeakDetectionSceneThresholdHigh = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

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
                        text: qsTr("(3.0)")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Процентиль пиков:")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.001
                        value: Chiaki.settings.placeboPeakDetectionPeakPercentile
                        onMoved: Chiaki.settings.placeboPeakDetectionPeakPercentile = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

                        Label {
                            anchors {
                                left: parent.right
                                verticalCenter: parent.verticalCenter
                                leftMargin: 10
                            }
                            text: qsTr(parent.value.toFixed(3))
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(99.995)")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Отсечение чёрного:")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    C.Slider {
                        Layout.preferredWidth: 250
                        from: 0.0
                        to: 100.0
                        stepSize: 0.1
                        value: Chiaki.settings.placeboPeakDetectionBlackCutoff
                        onMoved: Chiaki.settings.placeboPeakDetectionBlackCutoff = value
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)

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
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Разрешить задержку пика:")
                    visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }   

                    C.CheckBox {
                        text: qsTr("Включить задержку пика на 1 кадр")
                        checked: Chiaki.settings.placeboPeakDetectionAllowDelayedPeak
                        onToggled: Chiaki.settings.placeboPeakDetectionAllowDelayedPeak = checked
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Unchecked)")
                        visible: Chiaki.settings.placeboPeakDetectionEnabled && (Chiaki.settings.placeboPeakDetectionPreset == 0)
                    }
                }
            }

            Item {
                // Цвет Mapping
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
                        text: qsTr("Преобразование цвета:")
                    }

                    C.CheckBox {
                        text: qsTr("Использовать настройки преобразования цвета")
                        checked: Chiaki.settings.placeboЦветMappingEnabled
                        onToggled: Chiaki.settings.placeboЦветMappingEnabled = checked
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(Включено)")
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Предустановка преобразования цвета:")
                        visible: Chiaki.settings.placeboЦветMappingEnabled
                    }

                    C.ComboBox {
                        Layout.preferredWidth: 400
                        model: [qsTr("Пользовательский"), qsTr("По умолчанию"), qsTr("High Quality")]
                        currentIndex: Chiaki.settings.placeboЦветMappingPreset
                        onActivated: index => Chiaki.settings.placeboЦветMappingPreset = index
                        visible: Chiaki.settings.placeboЦветMappingEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("(High Quality)")
                        visible: Chiaki.settings.placeboЦветMappingEnabled
                    }

                    Label {
                        Layout.alignment: Qt.AlignRight
                        text: qsTr("Настройки преобразования цвета:")
                        visible: Chiaki.settings.placeboЦветMappingEnabled && Chiaki.settings.placeboЦветMappingPreset == 0
                    }

                    C.Button {
                        text: qsTr("Open")
                        onClicked: root.showPlaceboЦветMappingDialog()
                        visible: Chiaki.settings.placeboЦветMappingEnabled && Chiaki.settings.placeboЦветMappingPreset == 0
                        Material.roundedScale: Material.SmallScale
                    }
                }
            }
        }
    }
}
