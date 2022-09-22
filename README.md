# anotaçoes que fiz no processo, depois embelezo isso
pra compilar zenith-os pra colibri (!TESTANDO!), inicia o docker e segue o ultimo tutorial

os outros tutoriais não funcionam com o docker diretamente, pq eu fui modificando o msm dockerfile pra fazer todos, se pa faço um bonitinho pra cada dps

# como usa o docker +/-

build image (vai no diretorio que ta a dockerfile)
` docker build -t yocto-build . `

to.do import image

run new container
` docker run -it --rm --name yocto-build-run yocto-build `

pegar informacoes do container que ta rodando
` docker ps `

copiar um arquivo de dentro do container (troca o nome do container ali)
` docker cp 91957adfe630:/home/build/ARQUIVO /home/USUARIO/DESTINO `

# build toradex reference image (vai ter que mudar no docker)

` source export ` 
edit build/conf/local.conf
` vim conf/local.conf `

coloca isso lá: MACHINE=colibri-imx7-emmc

` bitbake tdx-reference-minimal-image `

tarball em build/deploy/images/${MACHINE}/

# instalar na toradex
extrai *Image-Tezi*.tar pro sdcard

boota a toradex e instala pelo easy intaler

se não tiver com o easy instaler vai ter que entrar no modo recovery e instala-lo


se não tiver tela pode acessar via vnc:

liga conectado a ethernet (com o usb não consegui)

pega o ip dela
` sudo arp-scan --localnet --interface=SUA_INTERFACE_DE_REDE `

conecta
` vncviewer 192.168.0.15 `

# conectar via ssh
` ssh -oHostKeyAlgorithms=+ssh-rsa root@192.168.0.15 `

se tiver trocado de distro, gera uma nova ssh-key
` ssh-keygen -R 192.168.0.15 `

# build yocto poky generico (precisa mudar no docker)
```
cd poky
#fix ERROR: Variable BB_ENV_EXTRAWHITE has been renamed to BB_ENV_PASSTHROUGH_ADDITIONS
python scripts/contrib/convert-variable-renames.py meta*

source oe-init-build-env
# compilar uma imagem
bitbake core-image-sato
# emular
runqemu qemux86-64 slirp nographic
# desliga pra sair
```
# build custom yocto pra colibri, do jeito da toradex
parei de fazer quando vi que era diferente do jeito do yocto

# build custom yocto pra colibri, do jeito do yocto
só tirar o que é do zenith no docker e seguir o tutorial de baixo (não mudando a distro na local.conf)

# build zenith-os pra colibri, do jeito do yocto (nao precisa mudar o docker)(ainda nao sei se ta funcionando)
status: nao funfou, se pah faltou overlay necessario pro kernel
```
source oe-init-build-env

# edit build/conf/local.conf
vim conf/local.conf
MACHINE=colibri-imx7-emmc
MACHINE = "colibri-imx7-emmc"
DISTRO ?= "zenithos"

#SE APARECER ESSE ERRO
#fix ERROR: Variable BB_ENV_EXTRAWHITE has been renamed to BB_ENV_PASSTHROUGH_ADDITIONS
python scripts/contrib/convert-variable-renames.py meta*

#compile padrao
bitbake core-image-minimal
```

pra instalar eu ainda to testando mas aparentemente, tu pega um arquivo de instalação de referencia ai, troca os arquivos de lá, pelos da sua build, e modifica na imagem.json o nome dos arquivos e o tamanho descomprimido dos .tar

pra descobrir esse tamanho eu uso:
``` tar -tvf Image-rootfs.tar.xz | awk '{s+=$3} END{print (s/1024/1024), "MB"}' ```

depois dessa gambiarra, coloca no sdcard e instala via toradex easy installer
