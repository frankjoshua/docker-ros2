# ROS master in Docker [![](https://img.shields.io/docker/pulls/frankjoshua/ros2)](https://hub.docker.com/r/frankjoshua/ros2)

## Description

Base image that most of my ROS2 Docker containers are based one. 

## Supported tags

| Tag | ROS 2 Distro | Supported until |
| --- | --- | --- |
| `humble`, `latest` | Humble Hawksbill (LTS) | May 2027 |
| `jazzy` | Jazzy Jalisco (LTS) | May 2029 |
| `lyrical` | Lyrical Luth (LTS) | May 2031 |

Only the currently supported LTS distros are built. Non-LTS distros (e.g. kilted) are skipped. `latest` points to `humble` — pin a distro tag in downstream images instead of relying on it:

```
FROM frankjoshua/ros2:humble
```

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

Use [build.sh](build.sh) to build the docker containers. Select the ROS distro with `-d` (defaults to `humble`).

<br>Local builds are as follows:

```
./build.sh -t frankjoshua/ros2:humble -l
./build.sh -t frankjoshua/ros2:jazzy -d jazzy -l
./build.sh -t frankjoshua/ros2:lyrical -d lyrical -l
```

## Testing

Github Actions expects the DOCKERHUB_USERNAME and DOCKERHUB_TOKEN variables to be set in your environment.

## License

Apache 2.0

## Author Information

Joshua Frank [@frankjoshua77](https://www.twitter.com/@frankjoshua77)
<br>
[http://roboticsascode.com](http://roboticsascode.com)
