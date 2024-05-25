# Hello

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

* Official website: <https://www.phoenixframework.org/>
* Guides: <https://hexdocs.pm/phoenix/overview.html>
* Docs: <https://hexdocs.pm/phoenix>
* Forum: <https://elixirforum.com/c/phoenix-forum>
* Source: <https://github.com/phoenixframework/phoenix>

## Start project with liveview as super repo

```sh
# First, start the project with node name
iex --name hello@127.0.0.1 --cookie some_token -S mix phx.server
Erlang/OTP 26 [erts-14.2.5] [source] [64-bit] [smp:24:24] [ds:24:24:10] [async-threads:1] [jit:ns]

[info] Running HelloWeb.Endpoint with Bandit 1.5.2 at 127.0.0.1:4000 (http)
[info] Access HelloWeb.Endpoint at http://localhost:4000
Interactive Elixir (1.18.0-dev) - press Ctrl+C to exit (type h() ENTER for help)
[watch] build finished, watching for changes...

Rebuilding...

Done in 240ms.
iex(hello@127.0.0.1)1> Node.self
:"hello@127.0.0.1"
```

* `--name` specify we running node using full name mode.
  * `:"hello@127.0.0.1"` is the node name checked by `Node.self`
  * There is also a `--sname` short name option.
* `--cookie` is the shared token for all connecting nodes. Here is `some_token`.

```sh
# Then, from another terminal 
sudo docker run \
--network=host \
-e LIVEBOOK_DISTRIBUTION=name \
-e LIVEBOOK_COOKIE=some_token \
-e LIVEBOOK_NODE=livebook@localhost \
-e LIVEBOOK_PORT=8007 \
-e LIVEBOOK_IFRAME_PORT=8008 \
-e RELEASE_NODE=livebook_hello \
-u $(id -u):$(id -g) \
-v $(pwd):/data \
ghcr.io/livebook-dev/livebook:0.12.1
```

* `--network` specify the docker container we run use [Host network driver](https://docs.docker.com/network/drivers/host/).
* Those LIVEBOOK options are from [Livebook README](https://github.com/livebook-dev/livebook/releases).
* Tag `0.12.1` from Livebook image support OTP26.
* If succeed, it should oupt something like:

  ```sh
  [Livebook] Application running at http://0.0.0.0:8007/?token=gwc234cmrxsfnqkaeeu6hv7wjhg3qe2g
  ```

## Connect to the phoenix project from Livebook

* Create or open a Livebook.
* Go to
  * Runtime settings
  * Configure
    * `Name` should be: `hello@127.0.0.1` which could be checked in target project's iex with `Node.self`
    * `Cookie` should be: the cookie we used above, such as `some_token`.
  * If connect succeed, it should shows the reconnect and disconnect option along with memory metric for the connect node.
* If connected, it means we could create code block and execute any code as if we are using `iex`.
  * For example, if we visit `http://localhost:4000/route`, we shall see the existing routes available in phoenix.
  * We could also get the same infomation in livebook by executing the code: `Mix.Tasks.Phx.Routes.run ''` in evaluation cell.

## Start Postgres via dockerfile

* Create a `dev.yaml`:

```yaml
services:
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: postgres
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - 5432:5432
  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
      
volumes:
  pgdata:
```

* Start up using `sudo docker compose -f dev.yaml up`
* Visit: [Login - Adminer](http://localhost:8080/)

## Proxy hex packages

* Elixir use `hex` to manage packages.
* Permanently select a mirror
  * For mix
  
      ```sh
      # For mix 
      mix hex.config mirror_url https://repo.hex.pm 
      ```

  * For rebar3
  
    Add to the global or a project’s top level `rebar.config, {rebar_packages_cdn, "https://repo.hex.pm"}.`. For more information see rebar3’s package support and configuration documentation.

  See: [Mirrors](https://hex.pm/docs/mirrors)

* Temporarily select a mirror, Hex commands can be prefixed with an environment variable in the shell.
  
  ```sh
  HEX_MIRROR=https://repo.hex.pm mix deps.get
  HEX_CDN=https://repo.hex.pm rebar3 update

  # Or 
  export HEX_MIRROR="https://hexpm.upyun.com"
  export HEX_CDN="https://hexpm.upyun.com"
  ```

## Proxy docker images

Edit or create the Docker daemon configuration file (`sudo vi /etc/docker/daemon.json`) to include the following mirror configurations:

```json
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com"
  ]
}
```

After adding the mirror configurations, restart the Docker daemon to apply the changes:

```sh
sudo service docker restart
sudo docker info
```

You shall see information like:

```txt
 Registry Mirrors:
  https://registry.docker-cn.com/
  https://docker.mirrors.ustc.edu.cn/
  https://hub-mirror.c.163.com/
  https://mirror.baidubce.com/
```

## Troubleshooting

### [error] `inotify-tools` is needed to run `file_system` for your system

Solution: `sudo apt install inotify-tools`

### Cannot get connection id for node :":myapp@localhost"

* If connect `xxx@localhost` doesn't work, try `xxx@127.0.0.1` instead when start project with `--name`.

### Protocol 'inet_tcp': the name livebook_server@zwpdbh seems to be in use by another Erlang node

* Possible reason01:
  * see [--name xxxxx appears to be ignored when provided with livebook start](https://github.com/livebook-dev/livebook/discussions/1356)
  * Reason: [Docker is using release scripts, which is separate from the Livebook CLI.](https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-environment-variables).
  * Solution: provide `-e RELEASE_NODE=elixir_horizion`.
* Possible reason02:
  * `sudo docker ps` and shutdown previous running liview instance.

### Others

* Evaluator.IOProxy module into the remote node, potentially due to Erlang/OTP version mismatch.
  * We have to make sure the Livebook's OTP version is compatibe with connecting node's OTP version.
* docker: Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?.
  * On ubuntu (WSL), remember to start Docker service by: `sudo service docker start`.
* Livebook docker image could start without problem, but could not visit its address from windows 11.

  From my experience, it is caused by I started the docker in WSL2 while the docker engine is using is Docker desktop in windows 11.

  * uninstall docker desktop from windows 11
  * [install docker in Ubuntu20.04](https://docs.docker.com/engine/install/ubuntu/)
  * Start livebook docker as before, you should click and visit Livebook from that address now.