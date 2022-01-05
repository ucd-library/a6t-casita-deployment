ARG A6T_BASE
FROM ${A6T_BASE}

RUN mkdir /casita
WORKDIR /casita
ENV ARGONAUT_GRAPH=/casita/lib/graph.js

COPY package.json .
COPY package-lock.json .
RUN npm install --production

COPY lib lib

WORKDIR /service/composer
CMD node instance.js