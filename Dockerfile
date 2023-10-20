FROM flyingjoe/uvicorn-gunicorn-fastapi:python3.9-slim

WORKDIR /app

ENV PATH="${PATH}:/root/.local/bin"

ADD . /app/

EXPOSE 20000

#RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list && rm -Rf /var/lib/apt/lists/* && apt-get update
RUN apt update
RUN apt install -y curl wget fonts-noto locales fontconfig locales-all fonts-noto libnss3-dev libxss1 libasound2 libxrandr2 libatk1.0-0 libgtk-3-0 libgbm-dev libxshmfence1

RUN wget -O /tmp/YaHei.Consolas.1.12.zip https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/uigroupcode/YaHei.Consolas.1.12.zip && \
    unzip /tmp/YaHei.Consolas.1.12.zip && \
    mkdir -p /usr/share/fonts/consolas && \
    mv YaHei.Consolas.1.12.ttf /usr/share/fonts/consolas/ && \
    chmod 644 /usr/share/fonts/consolas/YaHei.Consolas.1.12.ttf && \
    cd /usr/share/fonts/consolas && \
    mkfontscale && \
    mkfontdir && \
    fc-cache -fv

# Generate the locale
RUN sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen
RUN update-locale LC_ALL=zh_CN.UTF-8 LANG=zh_CN.UTF-8

# Update font cache
RUN fc-cache -fv

RUN pip install playwright && \
    playwright install-deps

RUN curl -sSL https://install.python-poetry.org | python3 -

RUN /usr/local/bin/python -m pip install  --no-cache-dir --upgrade --quiet pip

RUN poetry install

VOLUME /app/accounts /app/data

CMD poetry run python3 main.py
