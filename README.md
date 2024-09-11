# ROS master in Docker [![](https://img.shields.io/docker/pulls/frankjoshua/ros2)](https://hub.docker.com/r/frankjoshua/ros2) [![CI](https://github.com/frankjoshua/docker-ros2/workflows/CI/badge.svg)](https://github.com/frankjoshua/docker-ros2/actions)

## Description

Base image that most of my ROS2 Docker containers are based one. 

## Example

```
docker run -it \
    --network=host \
    --ipc=host \
    --pid=host \
    frankjoshua/ros2
```

--ipc=host is required for shared memory access. --pid=host is recommended for unique guid for dds.

Quick test:

Run the following in one terminal:
```
docker run -it \
--network="host" \
--ipc=host \
--pid=host \
frankjoshua/ros2 \
ros2 topic pub /test_topic std_msgs/msg/String 'data: "Hello, ROS 2!"'
```

Run the following in another terminal:
```
docker run -it \
--network=host \
--ipc=host \
--pid=host \
frankjoshua/ros2 \
ros2 topic echo /test_topic
```

## Building

Use [build.sh](build.sh) to build the docker containers.

<br>Local builds are as follows:

```
./build.sh -t frankjoshua/ros2 -l
```

## Testing

Github Actions expects the DOCKERHUB_USERNAME and DOCKERHUB_TOKEN variables to be set in your environment.

## License

Apache 2.0

## Author Information

Joshua Frank [@frankjoshua77](https://www.twitter.com/@frankjoshua77)
<br>
[http://roboticsascode.com](http://roboticsascode.com)
