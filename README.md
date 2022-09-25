# anotaçoes que fiz no processo
## basico de como usar o docker

build image (vai no diretorio que ta a dockerfile)
` docker build -t yocto-build . `

to.do import image

run new container
` docker run -it --rm --name yocto-build-run yocto-build `

pegar informacoes do container que ta rodando
` docker ps `

copiar um arquivo de dentro do container (troca o nome do container ali)
` docker cp 91957adfe630:/home/build/ARQUIVO /home/USUARIO/DESTINO `


## build zenith-os pra colibri, do jeito do yocto

` source ../oe-init-build-env `

edit build/conf/local.conf

` vim conf/local.conf `

```
MACHINE = "colibri-imx7-emmc"
DISTRO ?= "zenithos"
``` 

compile padrao

` bitbake core-image-minimal `

## instalação da custom image
baixa uma imagem de referencia e extrai ela, troca o uboot e o uboot-env e o tar.xz do rootfs pelo que voce compilou.
cria um boot.tar.xz com a zImage, os modulos, os dtb e o boot.scr(renomeia pra ter exatamente esse nome), troca o boot.tar.xz da imagem de referencia por esse.
modifica imagem.json: troca o nome o tamanho descomprimido dos tar.xz

pra descobrir esse tamanho eu uso:
``` tar -tvf Image-rootfs.tar.xz | awk '{s+=$3} END{print (s/1024/1024), "MB"}' ```

depois dessa gambiarra, coloca no sdcard e instala via toradex easy installer

## instalar na toradex
extrai *Image-Tezi*.tar pro sdcard

boota a toradex e instala pelo easy intaler

se não tiver com o easy instaler vai ter que entrar no modo recovery e instala-lo


se não tiver tela pode acessar via vnc:

liga conectado a ethernet (com o usb não consegui)

pega o ip dela
` sudo arp-scan --localnet --interface=SUA_INTERFACE_DE_REDE `

conecta
` vncviewer 192.168.0.15 `

## conectar via ssh
` ssh -oHostKeyAlgorithms=+ssh-rsa root@192.168.0.15 `

se tiver trocado de distro, gera uma nova ssh-key
` ssh-keygen -R 192.168.0.15 `

## conectar via serial (a aster já tem um usb serial)
instale o minicom

` minicom -s `

muda o serial device em serial port setup pra /dev/ttyUSB0

esc, agora os logs do boot vao aparecer nessa tela e depois um terminal
