FROM enonic/xp-app:6.2.0

ENV JAVA_OPTS "-Xms1024M -Xmx1024M"

USER root

RUN cp -r $XP_ROOT/home.org $XP_ROOT/home

# Getting Enonic XP applications from deploy folder
COPY deploy/* $XP_ROOT/home/deploy/

# automatic download superhero module from repo.enonic.net
ENV SUPERHERO_VERSION 1.1.0
RUN wget -O $XP_ROOT/home/deploy/superhero-$SUPERHERO_VERSION.jar http://repo.enonic.com/public/com/enonic/theme/superhero/$SUPERHERO_VERSION/superhero-$SUPERHERO_VERSION.jar

COPY config/* $XP_ROOT/home/config/

RUN mkdir $XP_ROOT/home/repo
RUN chown enonic-xp -R $XP_ROOT/home

COPY scripts/* /usr/local/bin/
RUN chmod +x /usr/local/bin/exp*

USER enonic-xp
