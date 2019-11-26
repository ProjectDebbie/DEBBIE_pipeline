FROM alpine:3.9
WORKDIR /usr/local/share/medical_materials
 
ARG	HEP_TAGGER_VERSION=1.0
COPY	docker-build.sh /usr/local/bin/docker-build.sh
COPY	dictionaries dictionaries
COPY	jape_rules jape_rules

RUN chmod u=rwx,g=rwx,o=r /usr/local/share/medical_materials -R

RUN	docker-build.sh ${MEDICAL_MATERIALS_TAGGER_VERSION}

