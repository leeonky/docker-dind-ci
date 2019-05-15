FROM gitlab/dind

RUN apt-get update && apt-get install -y git bash && apt-get clean

