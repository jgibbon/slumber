import QtQuick 2.6

import QtQuick.LocalStorage 2.0
import "PersistentObjectStore.js" as Store

QtObject {
	id: settings
	objectName: "default"

    property bool doPersist: true

	Component.onCompleted: {
        Store.initialize(['Talefish','1.0','Settings'], LocalStorage);

        doPersist && Store.load(settings);
	}

	Component.onDestruction: {
        //save defaults even if !doPersist?
        doPersist && Store.save(settings);
	}
}
