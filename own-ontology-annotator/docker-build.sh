#!/bin/sh

BASEDIR=/usr/local
MEDICAL_MATERIALS_TAGGER_HOME="${BASEDIR}/share/medical_materials/"

MEDICAL_MATERIALS_TAGGER_VERSION=1.0

# Exit on error 
set -e

if [ $# -ge 1 ] ; then
	MEDICAL_MATERIALS_TAGGER_VERSION="$1"
fi

if [ -f /etc/alpine-release ] ; then
	# Installing OpenJDK 8
	apk add --update openjdk8-jre
	
	# dict tagger development dependencies
	apk add openjdk8 git maven
else
	# Runtime dependencies
	apt-get update
	apt-get install openjdk-8-jre
	
	# The development dependencies
	apt-get install openjdk-8-jdk git maven
fi

git clone https://gitlab.bsc.es/inb/text-mining/generic-tools/nlp-gate-generic-component.git
cd nlp-gate-generic-component
mvn clean install -DskipTests
cd ..
#rename jar
mv nlp-gate-generic-component/target/nlp-gate-generic-component-0.0.1-SNAPSHOT-jar-with-dependencies.jar nlp-gate-generic-component-${MEDICAL_MATERIALS_TAGGER_VERSION}.jar

cat > /usr/local/bin/medical-materials <<EOF
#!/bin/sh
exec java \$JAVA_OPTS -jar "${MEDICAL_MATERIALS_TAGGER_HOME}/nlp-gate-generic-component-${MEDICAL_MATERIALS_TAGGER_VERSION}.jar" -workdir "${MEDICAL_MATERIALS_TAGGER_HOME}" -l dictionaries/lists.def -j jape_rules/main.jape "\$@" 
EOF
chmod +x /usr/local/bin/medical-materials

#delete target, do not delete for now because it has the jape rules inside
#rm -R nlp_generic_annotation

#add bash for nextflow
apk add bash

if [ -f /etc/alpine-release ] ; then
	# Removing not needed tools
	apk del openjdk8 git maven
	rm -rf /var/cache/apk/*
else
	apt-get remove openjdk-8-jdk git maven
	rm -rf /var/cache/dpkg
fi

