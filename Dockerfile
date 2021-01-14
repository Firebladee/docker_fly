FROM arbourd/concourse-fly

COPY fly_script.sh /usr/bin/fly_script
RUN chmod +x /usr/bin/fly_script

WORKDIR /workdir

ENTRYPOINT ["/usr/bin/fly_script"]
