FROM public.ecr.aws/lambda/python:3.12

WORKDIR /build

RUN pip install --target /build/python Pillow \
    --platform manylinux2014_x86_64 \
    --only-binary=:all: \
    --no-cache-dir

WORKDIR /python

COPY --from=build-stage /build/python /python
