#!/bin/bash
PROJNAME=$1
CURPWD=`pwd`

mkdir -p ./${PROJNAME}
mkdir -p ./${PROJNAME}/.vscode
cp ~/Project-Scripts/settings.json ./${PROJNAME}/.vscode

cd ${PROJNAME}
echo "{" > ${PROJNAME}-config.json
echo "  \"friendly_name\" : \"Switch\"," >> ${PROJNAME}-config.json
echo "  \"device_type\" : \"oic.d.switchdevice\"," >> ${PROJNAME}-config.json
echo "  \"ocf_base_path\" : \"~\"," >> ${PROJNAME}-config.json
echo "  \"implementation_paths\" : [" >> ${PROJNAME}-config.json
echo "    \"/iot-lite\"," >> ${PROJNAME}-config.json
echo "    \"~/new-imp\"" >> ${PROJNAME}-config.json
echo "  ]," >> ${PROJNAME}-config.json
echo "  \"platforms\" : [" >> ${PROJNAME}-config.json
echo "    \"linux\"," >> ${PROJNAME}-config.json
echo "    \"esp32\"," >> ${PROJNAME}-config.json
echo "    \"windows\"," >> ${PROJNAME}-config.json
echo "    \"android\"" >> ${PROJNAME}-config.json
echo "  ]," >> ${PROJNAME}-config.json
echo "  \"device_description\" : [" >> ${PROJNAME}-config.json
echo "    {" >> ${PROJNAME}-config.json
echo "      \"path\" : \"/binaryswitch\"," >> ${PROJNAME}-config.json
echo "      \"rt\"   : [ \"oic.r.switch.binary\" ]," >> ${PROJNAME}-config.json
echo "      \"if\"   : [\"oic.if.a\", \"oic.if.baseline\" ]," >> ${PROJNAME}-config.json
echo "      \"remove_properties\" : [ \"range\", \"step\" , \"id\", \"precision\" ]" >> ${PROJNAME}-config.json
echo "    }," >> ${PROJNAME}-config.json
echo "    {" >> ${PROJNAME}-config.json
echo "      \"path\" : \"/oic/p\"," >> ${PROJNAME}-config.json
echo "      \"rt\"   : [ \"oic.wk.p\" ]," >> ${PROJNAME}-config.json
echo "      \"if\"   : [\"oic.if.baseline\", \"oic.if.r\" ]," >> ${PROJNAME}-config.json
echo "      \"remove_properties\" : [ \"n\", \"range\", \"value\", \"step\", \"precision\", \"vid\"  ]" >> ${PROJNAME}-config.json
echo "    }" >> ${PROJNAME}-config.json
echo "  ]" >> ${PROJNAME}-config.json
echo "}" >> ${PROJNAME}-config.json

mkdir main

echo "bin\/" > .gitignore
echo "device_output\/" >> .gitignore
echo "build\/" >> .gitignore

cd ${CURPWD}
