import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Web 0.2
import QtQuick.Window 2.0
import Ubuntu.Connectivity 1.0

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.mkamenjak77.bugapp"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false
    width: Screen.width
    height: Screen.height
    automaticOrientation :true
    anchorToKeyboard :true
    //Sets the screen size and allows for orientation change
    PageWithBottomEdge
    {
        id: cropPage
        head
        {
            //title: i18n.tr("Crop")

            //leftAction: goBack
            //rightAction: goNext
        }
        bottomEdgeTitle: i18n.tr("Menu")
        bottomEdgePageOpacity: 0.6
        bottomEdgePanelData: Item
        {
            anchors.fill: parent
        }
    }//the actual bottom page panel.At the moment everything else is inside of it in PageWithBottomEdge.qml
}

