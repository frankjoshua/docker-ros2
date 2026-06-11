#!/bin/bash

# Check that buildx is enabled
docker buildx version > /dev/null
if [[ $? -ne 0 ]]; then
    echo "Docker must have experimental features enabled"
    exit 1
fi
ARCHITECTURE="--platform linux/arm64,linux/amd64"
usage() {
    echo "Usage: $0 -t <DOCKER_TAG> [-t <DOCKER_TAG>...] [-d <ROS_DISTRO>] [-a <ARCHITECTURE>] [-p Push] [-l Local build]"
    echo "Default architecture: linux/arm64,linux/amd64"
    echo "Default ROS distro: humble"
    exit 1
}
while getopts ":a:t:d:pql" o; do
    case "${o}" in
        t)
            TAGS="${TAGS} -t ${OPTARG}"
            ;;
        d)
            BUILD_ARGS="--build-arg ROS_DISTRO=${OPTARG}"
            ;;
        p)
            PUSH="--push"
            ;;
        q)
            QUIET="2> /dev/null"
            ;;
        a)
            ARCHITECTURE="--platform ${OPTARG}"
            ;;
        l)
            LOCAL="true"
            ARCHITECTURE=""
            ;;
        :)  
            echo "ERROR: Option -$OPTARG requires an argument"
            usage
            ;;
        \?)
            echo "ERROR: Invalid option -$OPTARG"
            usage
            ;;
    esac
done
shift $((OPTIND-1))

echo "${TAGS}"
if [[ -z "${TAGS}" ]]; then
    echo "Missing Tag!"
    usage
    exit 1
fi

if [[ -z "${LOCAL}" ]]; then
  echo "Creating multi platform builder."
  # Create builder for docker
  BUILDER=$(docker buildx create --use)
  # Setup qemu for multiplatform builds
  docker run --rm --privileged multiarch/qemu-user-static --reset -p yes --credential yes
fi
# Build container on all achitectures in parallel and push to Docker Hub
eval "docker buildx build $PUSH $TAGS $BUILD_ARGS $ARCHITECTURE . $QUIET"
# Clean up and return error code for CI system if needed
ERROR_CODE=$?
if [[ -z "${LOCAL}" ]]; then
  docker buildx rm $BUILDER
fi
if [[ $ERROR_CODE -ne 0 ]]; then
 exit $ERROR_CODE
fi