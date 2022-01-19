ARG A6T_BASE
FROM ${A6T_BASE} as a6tBase

FROM node:16

COPY --from=a6tBase /service /service

RUN apt-get update && apt-get install -y ssh

RUN mkdir /root/.ssh/
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan grb-box.cstars.ucdavis.edu >> /root/.ssh/known_hosts

RUN cd /service && npm install && npm link

RUN mkdir /decoder
WORKDIR /decoder

COPY package.json .
COPY package-lock.json .
RUN npm install
RUN npm link @ucd-lib/argonaut

COPY index.js .
COPY lib lib
# COPY test.js .
COPY run.sh .

ENV GRB_FILE ${GRB_FILE}
ENV SSH_KEY_USERNAME ${SSH_KEY_USERNAME}

CMD ./run.sh