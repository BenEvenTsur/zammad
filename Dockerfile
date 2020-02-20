FROM zammad/zammad:2.10.0-487
VOLUME /shared/zammad
COPY ./zammad_run.sh /opt/zammad_run.sh
RUN chmod 777 /opt/zammad_run.sh
ENTRYPOINT /opt/zammad_run.sh
