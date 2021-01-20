ARG MELTANO_IMAGE=meltano/meltano:latest
FROM $MELTANO_IMAGE

WORKDIR /project

# Install any additional requirements
COPY ./requirements.txt . 
RUN pip install -r requirements.txt

RUN mkdir -p ./output

# Install all plugins into the `.meltano` directory
COPY ./meltano.yml . 
RUN meltano install

# Pin `discovery.yml` manifest by copying cached version to project root
RUN cp -n .meltano/cache/discovery.yml . 2>/dev/null || :

# Don't allow changes to containerized project files
ENV MELTANO_PROJECT_READONLY 1

# Copy over remaining project files
COPY . .

# Expose default port used by `meltano ui`
EXPOSE 5000

ENTRYPOINT ["meltano"]
