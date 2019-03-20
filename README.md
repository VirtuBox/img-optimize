## Bash script to optimize your images and convert them in WebP

![img-optimize](https://raw.githubusercontent.com/VirtuBox/img-optimize/master/img-optimize.png)

### Prerequisite

* jpegoptim
* optipng
* WebP

Debian/Ubuntu :

```bash
sudo apt install jpegoptim optipng webp -y
```

Centos 7  :

```bash
sudo yum install optipng jpegoptim libwebp-tools -y
```

---

### Installation

1) Download the script

```bash
git clone https://github.com/VirtuBox/img-optimize.git $HOME/.img-optimize
```

2) Add an alias in your bashrc

```bash
echo "alias img-optimize=$HOME/.img-optimize/optimize.sh" >> $HOME/.bashrc
source $HOME/.bashrc
```

### Usage

```bash
Usage: img-optimize [options] <images path>
If images path is not defined, img-optimize will use the current directory
  Options:
       --jpg <images path> ..... optimize all jpg images
       --png <images path> ..... optimize all png images
       --webp <images path> ..... convert all images in webp
       --nowebp <images path> ..... optimize all png & jpg images
       --all <images path> ..... optimize all images (png + jpg + webp)
 Other options :
       -h, --help, help ... displays this help information
Examples:
  optimize all jpg images in /var/www/images
    img-optimize --jpg /var/www/images
```

### Update the script

To update the script, just run :

```bash
git -C $HOME/.img-optimize pull

source .bashrc
```

### Setup daily cronjob

You copy the scripts to /etc/cron.daily :

```bash
cp $HOME/.img-optimize/crons/jpg-png-cron.sh /etc/cron.daily/jpg-png-cron
cp $HOME/.img-optimize/crons/jpg-png-cron.sh /etc/cron.daily/webp-cron

chmod +x /etc/cron.daily/jpg-png-cron
chmod +x /etc/cron.daily/webp-cron
```

Then just edit your websites path set with the variables `sites` at the beginning of the cron scripts.

### Warning

Conversion process can take a while, you can use `tmux` to launch the script and be able to close your ssh connection without interrupting conversion. Then just use `tmux attach` to login back in your tmux session.

### Credits

WebP conversion script was inspired by this [DigitalOcean Community Tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-and-serve-webp-images-to-speed-up-your-website)