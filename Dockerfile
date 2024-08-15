FROM waggle/plugin-base:1.1.1-ml

# || true is to prevent apt-get update from failing,
# https://developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key/
RUN apt-get update || true \
  && apt-get install -y \
  build-essential \
  python3-dev \
  libeigen3-dev \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y

COPY requirements.txt /app/
RUN pip3 install --upgrade pip
RUN pip3 install --ignore-installed PyYAML
RUN pip3 install --no-cache-dir -r /app/requirements.txt

COPY libs /app/libs
COPY configs /app/configs
COPY data /app/data
COPY app.py convert.py demo.py hubconf.py main.py /app/

ADD https://web.lcrc.anl.gov/public/waggle/models/deeplabv2_resnet101_msc-cocostuff164k-100000.pth /app/deeplabv2_resnet101_msc-cocostuff164k-100000.pth

WORKDIR /app
ENTRYPOINT ["python3", "-u", "/app/app.py"]
