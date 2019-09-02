![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nassos/emailrelay)
![MicroBadger Size](https://img.shields.io/microbadger/image-size/nassos/emailrelay)
![MicroBadger Layers](https://img.shields.io/microbadger/layers/nassos/emailrelay)
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/nassos/emailrelay)

![GitHub language count](https://img.shields.io/github/languages/count/nmichas/emailrelay)
![GitHub top language](https://img.shields.io/github/languages/top/nmichas/emailrelay)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/nmichas/emailrelay)
![GitHub repo size](https://img.shields.io/github/repo-size/nmichas/emailrelay)
![Docker Pulls](https://img.shields.io/docker/pulls/nassos/emailrelay)
![Docker Stars](https://img.shields.io/docker/stars/nassos/emailrelay)

![GitHub last commit](https://img.shields.io/github/last-commit/nmichas/emailrelay)
![GitHub issues](https://img.shields.io/github/issues/nmichas/emailrelay)
![GitHub](https://img.shields.io/github/license/nmichas/emailrelay)
![GitHub stars](https://img.shields.io/github/stars/nmichas/emailrelay?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/nmichas/emailrelay?style=social)


# E-MailRelay Docker container

[E-MailRelay](http://emailrelay.sourceforge.net) is an e-mail store-and-forward message transfer agent and proxy server. It runs on Unix-like operating systems (including Linux and Mac OS X), and on Windows.
E-MailRelay does three things: it stores any incoming e-mail messages that it receives, it forwards e-mail messages on to another remote e-mail server, and it serves up stored e-mail messages to local e-mail reader programs. More technically, it acts as an SMTP storage daemon, an SMTP forwarding agent, and a POP3 server.

## About this image

This image is a Dockerized version of the E-MailRelay application. It is built directly from the sources
of E-MailRelay, using an Alpine parent image.

### Tags versioning

The tags of this image follow the official releases of E-MailRelay,
complemented with a local tag, so that updates on an official image
can be generated when necessary.

For example, for the 2.0.1 release of E-MailRelay local tags are generated
such as: 
- 2.0.1-1 
- 2.0.1-2 
- 2.0.1-3 
- etc.

The latest image is also available under the _latest_ tag.

### Automated builds

Image versions are automatically built upon pushes on project's GitHub repository
using Docker Hub Cloud. If you want to learn how to automatically build your own images when you push code on GitHUb, you can have a look on my tutorial [Build your Docker images automatically when you push on GitHub](https://medium.com/@NMichas/build-your-docker-images-automatically-when-you-push-on-github-18e80ece76af).

### Attribution

The `Dockerfile` of this image is based on an original version from
[https://github.com/drdaeman/docker-emailrelay](https://github.com/drdaeman/docker-emailrelay).

## Usage
Run the container with no arugments to obtain usage information:

`docker run --rm nassos/emailrelay`

### As an SMTP open relay server
#### Using Apple's mail servers
Create a file (e.g. `~/emailrelay/auth.txt`) with your authentication details of the target SMTP server you plan to have your
email being relayed to. The content of this file should be:
```
client plain userid password
```
Replace `userid` with your email user id, and `password` with your email password. Please note that
both `userid` and
`password` should be xtext encoded, as defined in RFC-1891, which basically means that non-alphanumeric
characters (including space, `+`, `#` and `=`) should be represented in uppercase hexadecimal
ascii as `+XX`. So a space should be written as `+20`, `+` as `+2B`, `##` as `+23`, and `=` as `+3D`.

Start the container by mounting the folder to the above path and exposing port 25:
```
docker run -d --restart=always -p 25:25 -v ~/emailrelay/auth:/auth nassos/emailrelay \
emailrelay \
--log \
--port=25 \
--forward-on-disconnect \
--forward-to=smtp.mail.me.com:587 \
--verbose \
--no-daemon \
--remote-clients \
--client-tls \
--client-auth=/auth/auth.txt
```

TIP: You need to generate an app-specific password, you can not use your main Apple account password to authenticate with.

## Testing from CLI
You can quickly test your configuration works as intended by sending a test email from the command-line using [swaks](http://www.jetmore.org/john/code/swaks/):

```
echo "This is the message body" | swaks \
	--to recipient@someserver.com \
	--from sender@someserver.com \
	--server localhost \
	--port 25
```