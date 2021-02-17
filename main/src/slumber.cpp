/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifdef QT_QML_DEBUG
#endif
#include <QtQuick>

#include <sailfishapp.h>
#include "lib/launcher.h"
#include "lib/volumefade.h"
#include "lib/pavolume.h"
#include "lib/sleeptimer.h"
#include "lib/applicationsettings.h"
//#include "lib/slumbervaluearc.h"


int main(int argc, char *argv[])
{
    PAVolume::registerMetaTypes();

    const char *uri = "de.gibbon.slumber";

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

//    QScopedPointer<QGuiApplication> app(Sailfish::createApplication(argc, argv));
    QScopedPointer<QQuickView> v(SailfishApp::createView());

    QQuickView *viewData = v.data();
    QQmlContext *context = viewData->rootContext();

    VolumeFade *vf = new VolumeFade(viewData);
    ApplicationSettings *appSettings = new ApplicationSettings(viewData);
    SleepTimer *sleeptimer = new SleepTimer(viewData, appSettings);

    qmlRegisterUncreatableType<ApplicationSettings>(uri, 1, 0, "Settings", QString());
//    qmlRegisterType<SlumberValueArc>(uri, 1, 0, "SlumberValueArc");
    qmlRegisterType<Launcher>(uri, 1 , 0 , "Launcher");
    context->setContextProperty("settings", appSettings);
    context->setContextProperty("VolumeControl", vf);
    context->setContextProperty("SleepTimer", sleeptimer);
    // Start the application.
    v->setSource(SailfishApp::pathTo("qml/harbour-slumber.qml"));
    v->show();

    return app->exec();

}

