import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import MeuiKit 1.0 as Meui
import Cyber.Settings 1.0
import Cyber.Accounts 1.0

ItemPage {
    headerTitle: qsTr("Accounts")

    UserAccount {
        id: currentUser
    }

    UsersModel {
        id: userModel
    }

    AccountsManager {
        id: accountsManager
    }

    AddUserDialog {
        id: addUserDialog
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            anchors.fill: parent

            Label {
                text: qsTr("Currently logged in as")
                color: Meui.Theme.disabledTextColor
                bottomPadding: Meui.Units.largeSpacing
            }

            RowLayout {
                Image {
                    id: currentUserImage
                    width: 64
                    height: width
                    sourceSize: Qt.size(width, height)
                    source: "file:///" + currentUser.iconFileName
                    visible: status === Image.Ready

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Item {
                            width: currentUserImage.width
                            height: width

                            Rectangle {
                                anchors.fill: parent
                                radius: width / 2
                            }
                        }
                    }
                }
                Label {
                    Layout.alignment: Qt.AlignVCenter
                    id: currentUserLabel
                    text: currentUser.displayName
                    font.pointSize: 16
                    bottomPadding: Meui.Units.smallSpacing
                    leftPadding: Meui.Units.largeSpacing
                }

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    id: currentUserLabel2
                    text: currentUser.userName
                    color: Meui.Theme.disabledTextColor
                    visible: currentUser.displayName !== currentUser.userName
                    font.pointSize: 16
                    bottomPadding: Meui.Units.smallSpacing
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: additionalSettings.shown ? qsTr("Hide additional settings") : qsTr("Show additional settings")
                    onClicked: additionalSettings.toggle()
                }
            }

            Hideable {
                id: additionalSettings

                HorizontalDivider {}

                Label {
                    text: qsTr("Additional settings")
                    color: Meui.Theme.disabledTextColor
                    Layout.bottomMargin: Meui.Units.largeSpacing
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.bottomMargin: Meui.Units.smallSpacing

                    Label {
                        text: qsTr("Automatic login")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Switch {
                        id: automaticLoginSwitch
                        Layout.fillHeight: true
                        leftPadding: 0
                        rightPadding: 0
                        onCheckedChanged: currentUser.automaticLogin = checked
                    }

                    Component.onCompleted: {
                        automaticLoginSwitch.checked = currentUser.automaticLogin
                    }
                }
            }

            Label {
                text: qsTr("Other Accounts")
                color: Meui.Theme.disabledTextColor
                topPadding: Meui.Units.largeSpacing
                bottomPadding: Meui.Units.largeSpacing
                visible: _userView.count > 1
            }

            Repeater {
                id: _userView
                model: userModel
                Layout.fillHeight: true
                Layout.fillWidth: true

                delegate: Item {
                    width: _userView.width
                    height: _itemLayout.implicitHeight + Meui.Units.largeSpacing * 2
                    visible: userId !== currentUser.userId

                    RowLayout {
                        id: _itemLayout
                        anchors.fill: parent

                        Image {
                            width: 64
                            height: width
                            sourceSize: Qt.size(width, height)
                            source: iconFileName ? "file:///" + iconFileName : ""
                            visible: status === Image.Ready

                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Item {
                                    width: currentUserImage.width
                                    height: width

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: width / 2
                                    }
                                }
                            }
                        }
                        Label {
                            Layout.alignment: Qt.AlignVCenter
                            text: userName
                            font.pointSize: 16
                            bottomPadding: Meui.Units.smallSpacing
                            leftPadding: Meui.Units.largeSpacing
                        }

                        Label {
                            Layout.alignment: Qt.AlignVCenter
                            text: realName
                            color: Meui.Theme.disabledTextColor
                            visible: realName !== userName
                            font.pointSize: 16
                            bottomPadding: Meui.Units.smallSpacing
                        }
                    }
                }
            }

            HorizontalDivider {}

            Button {
                id: _addUserButton
                text: qsTr("Add user")
                onClicked: addUserDialog.open()
            }
        }
    }
}
