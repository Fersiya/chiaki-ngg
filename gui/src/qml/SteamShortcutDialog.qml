import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

import org.streetpea.chiaking

import "controls" as C

DialogView {
    id: dialog
    property bool opening: false
    property bool succeeded: false
    property bool fromReminder
    title: qsTr("Создать игру вне Steam")
    buttonText: qsTr("Создать")
    buttonEnabled: name.text.trim() && !opening
    function close() {
        root.closeDialog();
        if(dialog.fromReminder && Chiaki.settings.remotePlayAsk)
        {
            if(!Chiaki.settings.psnRefreshToken || !Chiaki.settings.psnAuthToken || !Chiaki.settings.psnAuthTokenExpiry || !Chiaki.settings.psnAccountId)
                root.showRemindDialog(qsTr("Удалённая игра через PSN"), qsTr("Подключиться к PSN? Это позволит:\n- автоматически регистрировать консоль;\n- играть вне домашней сети без настройки перенаправления портов.") + "\n\n" + qsTr("(Примечание: если сейчас отказаться, подключиться можно позже в разделе «Конфигурация» настроек.)"), true, () => root.showPSNTokenDialog(false));
            else
                Chiaki.settings.remotePlayAsk = false;
        }
    }
    onAccepted: {
        opening = true;
        logDialog.open();
        Chiaki.createSteamShortcut(name.text.trim(), options.text.trim(), function(msg, ok, done) {
            if(ok)
            {
                succeeded = true;
                Chiaki.settings.addSteamShortcutAsk = false;
            }
            if (!done)
                logArea.text += msg + "\n";
            else
            {
                logArea.text += msg + "\n";
                logDialog.standardButtons = Dialog.Close;
                opening = false;
            }
        }, shortcutGrid.steamBasePath);
    }

    Item {
        GridLayout {
            id: shortcutGrid
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 20
            }
            columns: 2
            rowSpacing: 40
            columnSpacing: 20
            property var steamBasePath: ""

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Название игры в Steam")
            }

            C.TextField {
                id: name
                Layout.preferredWidth: 400
                text: Chiaki.settings.currentProfile ? qsTr("chiaki-ng ") + Chiaki.settings.currentProfile: qsTr("chiaki-ng")
                firstInFocusChain: true
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Параметры запуска [необязательно]")
            }

            C.TextField {
                id: options
                text: Chiaki.settings.currentProfile ? qsTr("--profile=") + Chiaki.settings.currentProfile : ""
                Layout.preferredWidth: 400
            }

            Label {
                Layout.alignment: Qt.AlignRight
                text: qsTr("Пользовательский путь к папке Steam (необязательно)")
            }

            Label {
                Layout.alignment: Qt.AlignRight
                Layout.preferredWidth: 400
                text: shortcutGrid.steamBasePath
            }

            Label {
            }

            C.Button {
                id: choosePathButton
                text: qsTr("Выбрать новый путь к папке Steam")
                onClicked: {
                    shortcutGrid.steamBasePath = Chiaki.settings.chooseSteamBasePath();
                }
                Material.roundedScale: Material.SmallScale
            }
        }

        Item {
            Dialog {
                id: logDialog
                parent: Overlay.overlay
                x: Math.round((root.width - width) / 2)
                y: Math.round((root.height - height) / 2)
                title: qsTr("Создать игру вне Steam")
                modal: true
                closePolicy: Popup.NoAutoClose
                standardButtons: Dialog.Cancel
                Material.roundedScale: Material.MediumScale
                onOpened: logArea.forceActiveFocus(Qt.TabFocusReason)
                onClosed: if(succeeded) { restartDialog.open(); }

                Flickable {
                    id: logFlick
                    implicitWidth: 600
                    implicitHeight: 400
                    clip: true
                    contentWidth: logArea.contentWidth
                    contentHeight: logArea.contentHeight
                    flickableDirection: Flickable.AutoFlickIfNeeded
                    ScrollBar.vertical: ScrollBar {
                        id: logScrollbar
                        policy: ScrollBar.AlwaysOn
                        visible: logFlick.contentHeight > logFlick.implicitHeight
                    }

                    Label {
                        id: logArea
                        width: logFlick.width
                        height: logFlick.height
                        wrapMode: Text.Wrap
                        Keys.onReturnPressed: if (logDialog.standardButtons == Dialog.Close) logDialog.close()
                        Keys.onEscapePressed: logDialog.close()
                        Keys.onPressed: (event) => {
                            switch (event.key) {
                            case Qt.Key_Up:
                                if(logScrollbar.position > 0.001)
                                    logFlick.flick(0, 500);
                                event.accepted = true;
                                break;
                            case Qt.Key_Down:
                                if(logScrollbar.position < 1.0 - logScrollbar.size - 0.001)
                                    logFlick.flick(0, -500);
                                event.accepted = true;
                                break;
                            }
                        }
                    }
                }
            }
        }

        Dialog {
            id: restartDialog
            parent: Overlay.overlay
            x: Math.round((root.width - width) / 2)
            y: Math.round((root.height - height) / 2)
            title: qsTr("Перезапустите Steam")
            modal: true
            closePolicy: Popup.NoAutoClose
            standardButtons: Dialog.Close
            Material.roundedScale: Material.MediumScale
            onOpened: restartArea.forceActiveFocus(Qt.TabFocusReason)
            onClosed: dialog.close()

            Flickable {
                id: restartFlick
                implicitWidth: 600
                implicitHeight: 50
                clip: true
                contentWidth: restartArea.contentWidth
                contentHeight: restartArea.contentHeight
                flickableDirection: Flickable.AutoFlickIfNeeded
                ScrollIndicator.vertical: ScrollIndicator { }

                Label {
                    id: restartArea
                    text: qsTr("Чтобы игра «%1» появилась в Steam,\nперезапустите Steam!").arg(name.text.trim())
                    wrapMode: Text.Wrap
                    Keys.onReturnPressed: if (restartDialog.standardButtons == Dialog.Close) restartDialog.close()
                    Keys.onEscapePressed: restartDialog.close()
                }
            }
        }
    }
}