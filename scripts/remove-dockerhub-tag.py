#!/usr/bin/env python
import click
import requests


@click.command()
@click.option("--username")
@click.option("--token")
@click.option("--tag")
def remove_tag(username, token, tag):
    jwt = requests.post(
        "https://hub.docker.com/v2/users/login",
        json={"username": username, "password": token},
    )
    jwt = jwt.json()["token"]

    requests.delete(
        f"https://hub.docker.com/v2/repositories/hreeder/krill/tags/{tag}",
        headers={"Authorization": f"JWT {jwt}"},
    )


if __name__ == "__main__":
    remove_tag()
