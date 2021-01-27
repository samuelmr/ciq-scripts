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
cat << EOS > $PROJECT/resources/strings.xml
<resources>
  <string id="AppName">$PROJECT</string>
</resources>
EOS


mkdir $PROJECT/resources/images
cp ~/connectiq/samples/Analog/resources/images/icon.png $PROJECT/resources/images/

cat << EOR > $PROJECT/resources/bitmaps.xml
<resources>
    <bitmap id="LauncherIcon" filename="images/icon.png" />
</resources>
EOR

mkdir $PROJECT/source

if [ "$TYPE" = "face" ]
then
	MANIFEST_TYPE="watchface"
  cat << EOA > $PROJECT/source/${PROJECT}App.mc
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
EOA

  cat << EOV > $PROJECT/source/${PROJECT}View.mc
using Toybox.WatchUi;

class ${PROJECT}View extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }
}
EOV

  cat << EOD > $PROJECT/source/${PROJECT}Delegate.mc
using Toybox.WatchUi;

class ${PROJECT}Delegate extends WatchUi.WatchFaceDelegate {
    function onPowerBudgetExceeded(powerInfo) {
        System.println("Average execution time: " + powerInfo.executionTimeAverage);
        System.println("Allowed execution time: " + powerInfo.executionTimeLimit);
    }
}
EOD
else
	MANIFEST_TYPE="watch-app"
  cat << EOAA > $PROJECT/source/${PROJECT}App.mc
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
EOAA

cat << EOAV > $PROJECT/source/${PROJECT}View.mc
using Toybox.WatchUi;

class ${PROJECT}View extends WatchUi.View {
    function initialize() {
        WatchUi.View.initialize();
    }

    function onUpdate(dc) {
    }

}
EOAV

cat << EOAD > $PROJECT/source/${PROJECT}Delegate.mc
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
EOAD
fi

PRODUCTS="        <iq:products>\n"
TARGETS=($(ls -1 "${CIQ_HOME}../../devices"))
for TARGET in "${TARGETS[@]}"
do
  PRODUCTS+="            <iq:product id=\"${TARGET}\"/>\n"
done
PRODUCTS+="        </iq:products>\n"

cat << EOM > $PROJECT/manifest.xml
<iq:manifest xmlns:iq="http://www.garmin.com/xml/connectiq" version="1">
    <iq:application entry="${PROJECT}App" id="$UUID" launcherIcon="@Drawables.LauncherIcon" minSdkVersion="1.2.0" name="@Strings.AppName" type="${MANIFEST_TYPE}">
${PRODUCTS}
        <iq:languages>
            <iq:language>eng</iq:language>
        </iq:languages>
    </iq:application>
</iq:manifest>
EOM

cat << EOBM > $PROJECT/manifest-beta.xml
<iq:manifest xmlns:iq=\"http://www.garmin.com/xml/connectiq\" version=\"1\">
    <iq:application entry=\"${PROJECT}App\" id=\"${BETA_UUID}\" launcherIcon=\"@Drawables.LauncherIcon\" minSdkVersion=\"1.2.0\" name=\"@Strings.AppName\" type=\"watch-${TYPE}\">
${PRODUCTS}
        <iq:languages>
            <iq:language>eng</iq:language>
        </iq:languages>
    </iq:application>
</iq:manifest>
EOBM

cat << EOJ > $PROJECT/monkey.jungle
project.manifest = manifest.xml
EOJ

cat << EOBJ > $PROJECT/beta.jungle
project.manifest = manifest-beta.xml
EOBJ
