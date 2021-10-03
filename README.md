# Dockerized Paper Minecraft

Status: Builds & Runs

Pulls paper and runs it, essentially. 

## Infos

CentOS based container. Builds OpenJDK-16.0.2 from source, pulls down paper and runs it.

No need for a start script; just used an endpoint to achieve the exact same thing.

## Environment Variables

| Variable              | Default Value | Description                                                                                                            |
|-----------------------|---------------|------------------------------------------------------------------------------------------------------------------------|
| MC_MAX_RAM            |"1G"           | Max RAM that Minecraft can use.                                                                                        |
| MC_MIN_RAM            |"1G"           | Minimum amount of RAM for Minecraft to run with. Often set to max.                                                     |
| MCGID                 |"1000"         | UNIX Group ID. Configurable so that you can make it match a user on your host for cross compatible permissions.        |
| MCUID                 |"1000"         | UNIX User ID. Configurable so that you can make it match a user on your host for cross compatible permissions.         |
| MC_SERVER_DL_URL      | In DF         | The endpoint to pull the Minecraft Server JAR from                                                                     |
| MC_JAVA_DL_URL        | In DF         | The endpoint to pull the OpenJDK source from                                                                           |

## Build & Run

I haven't released this on Docker Hub yet. 

```
docker build . -t surprise-automation/minecraft:1.17.1-paper
docker run --name my_mc_server -p 25565:25565/tcp surprise-automation/minecraft:1.17.1-paper
## If on RH
#firewall-cmd --zone=public --permanent --add-port=25565/tcp
#firewall-cmd --reload
## If on Deb
#ufw allow 25565/tcp
```

## Extended to run a central repo of jars

If you're running a host or whatever you can just map /jar/ to a folder containing your binaries. It will run whatever jar is called `/jar/minecraft_server_1.17.1.jar`.