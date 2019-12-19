From xqdocker/ubuntu-openjdk:8

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

RUN apt-get update && \
    apt-get install -y git python3-pip wget zip && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    pip3 install --no-cache --upgrade pip setuptools wheel boto3 && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION
ENV MAVEN_VERSION 3.6.3
ENV MAVEN_HOME /usr/lib/mvn
ENV SPARK_HOME /usr/lib/spark
ENV PATH $MAVEN_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

RUN wget https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-1.0/spark-2.4.3-bin-hadoop2.8.tgz && \
    tar -xzvf spark-2.4.3-bin-hadoop2.8.tgz && \
    rm spark-2.4.3-bin-hadoop2.8.tgz && \
    mv spark-2.4.3-bin-spark-2.4.3-bin-hadoop2.8 /usr/lib/spark

COPY . /aws-glue-libs

RUN mvn -f /aws-glue-libs/pom.xml -DoutputDirectory=/aws-glue-libs/jarsv1 dependency:copy-dependencies && \
    rm -rf /aws-glue-libs/jarsv1/netty*

ENTRYPOINT [ "/aws-glue-libs/bin/gluepyspark" ]
