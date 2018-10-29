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
Usage: img-optimize [options] <image path>
  Options:
       --jpg <image path> ..... optimize all jpg images
       --png <image path> ..... optimize all png images
       --webp <image path> ..... convert all images in webp
       --nowebp <image path> ..... optimize all png & jpg images
       --all <image path> ..... optimize all images (png + jpg + webp)
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

### Warning

Conversion process can take a while, you can use `tmux` to launch the script and be able to close your ssh connection without interrupting conversion. Then just use `tmux attach` to login back in your tmux session.

### Credits

WebP conversion script is inspired by this [DigitalOcean Community Tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-and-serve-webp-images-to-speed-up-your-website)