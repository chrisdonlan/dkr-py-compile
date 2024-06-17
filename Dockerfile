# Use the lightweight Python 3.9 slim image
FROM python:3.11-slim as build

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV NOINCLUDE_DEFAULT_MODE=True

# Install system dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
	build-essential \
	make \
	patchelf \
	ccache
RUN rm -rf /var/lib/apt/lists/*


# Install python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir nuitka
RUN pip install --no-cache-dir -r requirements.txt

# Install project
COPY . .
RUN python -m pip install .

# COMPILE the python executable as a binary (>1.2Gb -> ~150mb)
RUN make py-compile
