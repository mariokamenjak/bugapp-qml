// PageWithBottomEdge.qml
/*
  This file is part of instantfx
  Copyright (C) 2014 Stefano Verzegnassi

    This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License 3 as published by
  the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Web 0.2
import QtQuick.Window 2.0
import Ubuntu.Connectivity 1.0

Page {
    id: page

    //readonly property alias head: header
    default property alias containerData: container.data

    property alias bottomEdgePanelData: bottomEdgeContainer.data
    property alias bottomEdgeTitle: tipLabel.text

    property real bottomEdgePageOpacity: 0.85

    property bool bottomEdgeEnabled: true
//Works better without it.I might need it later though so I am keeping it.
    /*CustomHeader {
        id: header

        Connections {
            target: bottomEdge
            onPositionChanged: {
                if (bottomEdge.position < (bottomEdge.height / 2))
                    header.opacity = (bottomEdge.position / bottomEdge.height) * 2
                if (bottomEdge.position > (bottomEdge.height / 2))
                    header.opacity = 1
            }
        }
    }*/
    Label {
        // use the online property
        text: NetworkingStatus.online ? "Online" : "Not online"
        fontSize: "large"
    }
    Label {
        // use the limitedBandwith property
        text: NetworkingStatus.limitedBandwith ? "Bandwith limited" : "Bandwith not limited"
        fontSize: "large"
    }
    Column {
        /*In here I put all the elements that are supposed to be displayed on the outside of the panel.So far it works but I might want to move it to main.qml for stability reasons.*/
        height:parent.height
        width:parent.width
        //The progress bar displays on how mmuch has the webpage loaded.Height is set to 0.1 because I want it to be tiny and barely noticeable.
        ProgressBar {
                id: determinateBar
                minimumValue: 0
                maximumValue: 100
                value:webview.loadProgress
                width:parent.width
                height:units.gu(0.1)
            }
        WebView {
            id: webview
            width: parent.width
            height: parent.height
            filePicker: filePickerLoader.item
            //puts the loader for uploading into the application
            Component.onCompleted: {
                url = "http://bug.hr"
            }
            onDownloadRequested: {
                    /*if (!request.suggestedFilename && request.mimeType &&
                        internal.downloadMimeTypesBlacklist.indexOf(request.mimeType) > -1) {
                        return
                    }*/
                console.log('Downloading image: ')

                    if (downloadLoader.status == Loader.Ready) {
                        var headers = { }
                        if(request.cookies.length > 0) {
                            headers["Cookie"] = request.cookies.join(";")
                        }
                        if(request.referrer) {
                            headers["Referer"] = request.referrer
                        }
                        headers["User-Agent"] = webview.context.userAgent
                        downloadLoader.item.downloadMimeType(request.url, request.mimeType, headers, request.suggestedFilename)
                    }
                }
            Loader {
                    id: filePickerLoader

                       function sizeweb(){
                        var size="ContentPickerDialog.qml"
                        if(webview.width>units.gu(137)){
                                size="FilePickerDialog.qml"
                            }
                       if(webview.width<units.gu(137))
                        {
                            size="ContentPickerDialog.qml"
                        }
                            return size
                        }
                    source: sizeweb()
                    //source:"FilePickerDialog.qml"
                    asynchronous: true
                }
            Loader {
                    id: downloadLoader
                    source: "Downloader.qml"
                    asynchronous: true
                }
            //the instance of the upload loader.I might add the download loader soon.
        }
    }

    Item {
        id: container

        clip: true

        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    // tip
    UbuntuShape {
        id: tip

        visible: page.bottomEdgeEnabled
        color: Qt.rgba(0.0, 0.0, 0.0, 0.3)

        // Size from the official PageWithBottomEdge component
        width: tipLabel.paintedWidth + units.gu(6)
        height: units.gu(4)

        y: page.height - units.gu(3) + (bottomEdge.height - bottomEdge.position)
        anchors.horizontalCenter: parent.horizontalCenter

        Label {
            id: tipLabel

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            text: "test"

            fontSize: "x-small"
            height: units.gu(2)
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // bottom edge panel
    Panel {
        id: bottomEdge

        enabled: page.bottomEdgeEnabled
        visible: page.bottomEdgeEnabled
        locked: !page.bottomEdgeEnabled

        height: units.gu(10)

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }


        Rectangle {
            height: 1
            color: "black"
            opacity: bottomEdgePageOpacity * (page.height - bottomEdge.position) / page.height

            anchors.fill: parent
        }

        Item {
            id: bottomEdgeContainer

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                //bottom: closeButton.top
            }
        }
        //In here I put all the elements that will be displayed only in the bottom edge panel
        Column
        {
            Row
            {
                //first (from top) row of elements
                Button {
                    objectName: "button"
                    iconSource: "refresh.png"
                    width: units.gu(8)
                    //text: i18n.tr("Osvježi")
                    onClicked: {
                        webview.reload()
                    }
                }
                Button {
                    objectName: "button"
                    width: units.gu(8)
                    iconSource: "backward.png"
                    //text: i18n.tr("Natrag")
                    onClicked: {
                        webview.goBack()
                    }
                }
                Button {
                    objectName: "button"
                    width: units.gu(8)
                    iconSource: "forward.png"
                    //text: i18n.tr("Naprijed")
                    onClicked: {
                        webview.goForward()
                    }
                }
                Button {
                    objectName: "button"
                    width: units.gu(8)
                    //iconSource: "forward.png"
                    text: i18n.tr("Forum")
                    onClicked: {
                        webview.url="http://www.bug.hr/forum/"
                    }
                }
                /*Label {
                    // use the online property
                    text: NetworkingStatus.online ? "Online" : "Not online"
                    fontSize: "large"
                }
                Label {
                    // use the limitedBandwith property
                    text: NetworkingStatus.limitedBandwith ? "Bandwith limited" : "Bandwith not limited"
                    fontSize: "large"
                }*/
            }
            Row
            {
                //second row of elements
                Button {
                    objectName: "button"
                    width: units.gu(12)
                    //iconSource: "forward.png"
                    text: i18n.tr("Sudjelujem")
                    onClicked: {
                        webview.url="http://www.bug.hr/forum/contributedtopics/?sort=act"
                    }
                }
                Button {
                    objectName: "button"
                    width: units.gu(8)
                    //iconSource: "forward.png"
                    text: i18n.tr("Pratim")
                    onClicked: {
                        webview.url="http://www.bug.hr/forum/favtopics/?sort=act"
                    }
                }
                Button {
                    objectName: "button"
                    width: units.gu(7)
                    //iconSource: "forward.png"
                    text: i18n.tr("G.M.")
                        onClicked: {
                        webview.url="http://www.bug.hr/master/"
                    }
                }
                Button {
                    objectName: "button"
                    width: units.gu(8)
                    //iconSource: "forward.png"
                    text: i18n.tr("Home")
                    onClicked: {
                        webview.url="http://www.bug.hr/"
                    }
                }


            }
            Row
            {
                //third row of elements
                Text {
                    id: text1
                    text: NetworkingStatus.online ? "  Online" : "  Not online"
                    font.family: "Helvetica"
                    //font.pointSize: 24

                    function color1()
                    {
                        var color
                        if(NetworkingStatus.online==true)
                        {
                            color="orange"
                        }
                        else
                        {
                            color="purple"
                        }

                        return color
                    }
                    color:color1()

                }
                Text {
                    text: NetworkingStatus.limitedBandwith ? "  Bandwith limited" : "  Bandwith not limited"
                    font.family: "Helvetica"
                    //font.pointSize: 24
                    function color2()
                    {
                        var color
                        if(NetworkingStatus.limitedBandwith==false)
                        {
                            color="orange"
                        }
                        else
                        {
                            color="purple"
                        }

                        return color
                    }
                    color:color2()
                }
            }
        }
    }
}
