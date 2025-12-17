# Используем образ с Spark (PySpark) — пример: bitnami/spark
FROM spark:3.5.7-python3

USER root

ENV PATH="/opt/spark/bin:${PATH}"

RUN mkdir -p /opt/spark/jars


# Создаём папку для jar-файлов
RUN mkdir -p /opt/spark/jars

# Загружаем JDBC-драйвер PostgreSQL
RUN apt update && apt install -y curl && \
    curl -sSL https://repo1.maven.org/maven2/org/postgresql/postgresql/42.5.4/postgresql-42.5.4.jar \
    -o /opt/spark/jars/postgresql-42.5.4.jar && \
    curl -sSL https://repo1.maven.org/maven2/com/clickhouse/clickhouse-jdbc/0.9.4/clickhouse-jdbc-0.9.4-all.jar \
    -o /opt/spark/jars/clickhouse-jdbc-0.9.4-all.jar

# Загрузка JDBC-драйверов (Maven Central)
# версии можно обновить при необходимости
# ADD https://repo1.maven.org/maven2/org/postgresql/postgresql/42.5.4/postgresql-42.5.4.jar /opt/spark/jars/postgresql-42.5.4.jar
# ADD https://repo1.maven.org/maven2/com/clickhouse/clickhouse-jdbc/0.4.6/clickhouse-jdbc-0.4.6.jar /opt/spark/jars/clickhouse-jdbc-0.4.6.jar

# Если нужен ClickHouse native spark-connector — можно добавить сюда jar'ы тоже
# ADD https://repo1.maven.org/maven2/ru/yandex/clickhouse/clickhouse-spark-connect/0.4.6/clickhouse-spark-connect-0.4.6.jar /opt/spark/jars/

# Копировать локальные файлы (jobs/utils) в образ (необязательно, монтируем тома)
WORKDIR /app
COPY spark /app/spark
COPY app/data /app/data
RUN chmod +x /app/spark/init.sh


ENV PYTHONPATH="/app:${PYTHONPATH}"

ENV SPARK_HOME=/opt/spark
# Текущий пользователь bitnami обычно uid 1001; переключаем обратно

RUN useradd --create-home --shell /bin/bash sparkuser

USER sparkuser
# Контейнер остаётся интерактивным — запуск spark-submit делаем вручную через docker exec
# USER 1001
# COPY spark/init.sh /app/spark/init.sh


# Устанавливаем entrypoint который запустит init.sh
ENTRYPOINT ["bash", "/app/spark/init.sh"]
