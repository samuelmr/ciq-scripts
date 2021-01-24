 #!/bin/bash

if [ "$1" = "-t" ]
then
	TYPE=$2
  PROJECT=$3
else
	echo "Usage: iqinit -t [app|face] ProjectName"
	exit
fi

echo "Creating template for watch$TYPE called $PROJECT."

UUID=`uuidgen`
BETA_UUID=`uuidgen`

mkdir $PROJECT
mkdir $PROJECT/releases
mkdir $PROJECT/resources
echo """
<resources>
  <string id=\"AppName\">$PROJECT</string>
</resources>
""" > $PROJECT/resources/strings.xml

mkdir $PROJECT/resources/images
cp ~/connectiq/samples/Analog/resources/images/icon.png $PROJECT/resources/images/

echo """
<resources>
    <bitmap id=\"LauncherIcon\" filename=\"images/icon.png\" />
</resources>
""" > $PROJECT/resources/bitmaps.xml

mkdir $PROJECT/source

if [ "$TYPE" = "face" ]
then
	MANIFEST_TYPE="watchface"
  echo """
using Toybox.Application;

class ${PROJECT}App extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        if( Toybox.WatchUi has :WatchFaceDelegate ) {
            return [new ${PROJECT}View(), new ${PROJECT}Delegate()];
        } else {
            return [new ${PROJECT}View()];
        }
    }
}
""" > $PROJECT/source/${PROJECT}App.mc

  echo """
using Toybox.WatchUi;

class ${PROJECT}View extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }
}
""" > $PROJECT/source/${PROJECT}View.mc

  echo """
using Toybox.WatchUi;

class ${PROJECT}Delegate extends WatchUi.WatchFaceDelegate {
    function onPowerBudgetExceeded(powerInfo) {
        System.println(\"Average execution time: \" + powerInfo.executionTimeAverage);
        System.println(\"Allowed execution time: \" + powerInfo.executionTimeLimit);
    }
}
""" > $PROJECT/source/${PROJECT}Delegate.mc
else
	MANIFEST_TYPE="watch-app"
  echo """
using Toybox.Application;

class ${PROJECT}App extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [new ${PROJECT}View(), new ${PROJECT}Delegate()];
    }
}
""" > $PROJECT/source/${PROJECT}App.mc

echo """
using Toybox.WatchUi;

class ${PROJECT}View extends WatchUi.View {
    function initialize() {
        WatchUi.View.initialize();
    }

    function onUpdate(dc) {
    }

}

""" > $PROJECT/source/${PROJECT}View.mc

echo """
using Toybox.WatchUi;

class ${PROJECT}Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        WatchUi.InputDelegate.initialize();
    }

    function onNextPage() {
    }

    function onPreviousPage() {
    }

    function onKey(evt) {
        var key = evt.getKey();
        if (WatchUi.KEY_DOWN == key) {
            onNextPage();
        } else if (WatchUi.KEY_UP == key) {
            onPreviousPage();
        }
    }

    function onMenu() {
    }

    function onSelect() {
    }

    function onBack() {
    }
}
""" > $PROJECT/source/${PROJECT}Delegate.mc
fi

echo """
<iq:manifest xmlns:iq=\"http://www.garmin.com/xml/connectiq\" version=\"1\">
    <iq:application entry=\"${PROJECT}App\" id=\"$UUID\" launcherIcon=\"@Drawables.LauncherIcon\" minSdkVersion=\"1.2.0\" name=\"@Strings.AppName\" type=\"${MANIFEST_TYPE}\">
        <iq:products>
            <iq:product id=\"approachs60\"/>
            <iq:product id=\"d2bravo\"/>
            <iq:product id=\"d2bravo_titanium\"/>
            <iq:product id=\"d2charlie\"/>
            <iq:product id=\"d2delta\"/>
            <iq:product id=\"d2deltapx\"/>
            <iq:product id=\"d2deltas\"/>
            <iq:product id=\"descentmk1\"/>
            <iq:product id=\"epix\"/>
            <iq:product id=\"fenix3\"/>
            <iq:product id=\"fenix3_hr\"/>
            <iq:product id=\"fenix5\"/>
            <iq:product id=\"fenix5plus\"/>
            <iq:product id=\"fenix5s\"/>
            <iq:product id=\"fenix5splus\"/>
            <iq:product id=\"fenix5x\"/>
            <iq:product id=\"fenix5xplus\"/>
            <iq:product id=\"fenix6\"/>
            <iq:product id=\"fenix6pro\"/>
            <iq:product id=\"fenix6s\"/>
            <iq:product id=\"fenix6spro\"/>
            <iq:product id=\"fenix6xpro\"/>
            <iq:product id=\"fenixchronos\"/>
            <iq:product id=\"fr230\"/>
            <iq:product id=\"fr235\"/>
            <iq:product id=\"fr245\"/>
            <iq:product id=\"fr245m\"/>
            <iq:product id=\"fr45\"/>
            <iq:product id=\"fr630\"/>
            <iq:product id=\"fr645\"/>
            <iq:product id=\"fr645m\"/>
            <iq:product id=\"fr735xt\"/>
            <iq:product id=\"fr920xt\"/>
            <iq:product id=\"fr935\"/>
            <iq:product id=\"fr945\"/>
            <iq:product id=\"legacyherocaptainmarvel\"/>
            <iq:product id=\"legacyherofirstavenger\"/>
            <iq:product id=\"marqathlete\"/>
            <iq:product id=\"marqaviator\"/>
            <iq:product id=\"marqcaptain\"/>
            <iq:product id=\"marqdriver\"/>
            <iq:product id=\"marqexpedition\"/>
            <iq:product id=\"venu\"/>
            <iq:product id=\"vivoactive\"/>
            <iq:product id=\"vivoactive3\"/>
            <iq:product id=\"vivoactive3d\"/>
            <iq:product id=\"vivoactive3m\"/>
            <iq:product id=\"vivoactive3mlte\"/>
            <iq:product id=\"vivoactive4\"/>
            <iq:product id=\"vivoactive4s\"/>
            <iq:product id=\"vivoactive_hr\"/>
            <iq:product id=\"vivolife\"/>
        </iq:products>
        <iq:languages>
            <iq:language>eng</iq:language>
        </iq:languages>
    </iq:application>
</iq:manifest>
""" > $PROJECT/manifest.xml

echo """
<iq:manifest xmlns:iq=\"http://www.garmin.com/xml/connectiq\" version=\"1\">
    <iq:application entry=\"${PROJECT}App\" id=\"${BETA_UUID}\" launcherIcon=\"@Drawables.LauncherIcon\" minSdkVersion=\"1.2.0\" name=\"@Strings.AppName\" type=\"watch-${TYPE}\">
        <iq:products>
            <iq:product id=\"approachs60\"/>
            <iq:product id=\"d2bravo\"/>
            <iq:product id=\"d2bravo_titanium\"/>
            <iq:product id=\"d2charlie\"/>
            <iq:product id=\"d2delta\"/>
            <iq:product id=\"d2deltapx\"/>
            <iq:product id=\"d2deltas\"/>
            <iq:product id=\"descentmk1\"/>
            <iq:product id=\"epix\"/>
            <iq:product id=\"fenix3\"/>
            <iq:product id=\"fenix3_hr\"/>
            <iq:product id=\"fenix5\"/>
            <iq:product id=\"fenix5plus\"/>
            <iq:product id=\"fenix5s\"/>
            <iq:product id=\"fenix5splus\"/>
            <iq:product id=\"fenix5x\"/>
            <iq:product id=\"fenix5xplus\"/>
            <iq:product id=\"fenix6\"/>
            <iq:product id=\"fenix6pro\"/>
            <iq:product id=\"fenix6s\"/>
            <iq:product id=\"fenix6spro\"/>
            <iq:product id=\"fenix6xpro\"/>
            <iq:product id=\"fenixchronos\"/>
            <iq:product id=\"fr230\"/>
            <iq:product id=\"fr235\"/>
            <iq:product id=\"fr245\"/>
            <iq:product id=\"fr245m\"/>
            <iq:product id=\"fr45\"/>
            <iq:product id=\"fr630\"/>
            <iq:product id=\"fr645\"/>
            <iq:product id=\"fr645m\"/>
            <iq:product id=\"fr735xt\"/>
            <iq:product id=\"fr920xt\"/>
            <iq:product id=\"fr935\"/>
            <iq:product id=\"fr945\"/>
            <iq:product id=\"legacyherocaptainmarvel\"/>
            <iq:product id=\"legacyherofirstavenger\"/>
            <iq:product id=\"marqathlete\"/>
            <iq:product id=\"marqaviator\"/>
            <iq:product id=\"marqcaptain\"/>
            <iq:product id=\"marqdriver\"/>
            <iq:product id=\"marqexpedition\"/>
            <iq:product id=\"venu\"/>
            <iq:product id=\"vivoactive\"/>
            <iq:product id=\"vivoactive3\"/>
            <iq:product id=\"vivoactive3d\"/>
            <iq:product id=\"vivoactive3m\"/>
            <iq:product id=\"vivoactive3mlte\"/>
            <iq:product id=\"vivoactive4\"/>
            <iq:product id=\"vivoactive4s\"/>
            <iq:product id=\"vivoactive_hr\"/>
            <iq:product id=\"vivolife\"/>
        </iq:products>
        <iq:languages>
            <iq:language>eng</iq:language>
        </iq:languages>
    </iq:application>
</iq:manifest>
""" > $PROJECT/manifest-beta.xml

echo """
project.manifest = manifest.xml
""" > $PROJECT/monkey.jungle

echo """
project.manifest = manifest-beta.xml
""" > $PROJECT/beta.jungle
