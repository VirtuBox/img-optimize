## Bash script to optimize your images and convert them in WebP 

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

### What does the script do

1) optimize jpg images with jpegoptim
2) optimize png images with optipng
3) convert jpg & png images in WebP (without deleting them)

WebP image name example for mybackground.png : mybackground.png.webp

---

### Usage

1) Download the script and make it executable

```bash
wget https://raw.githubusercontent.com/VirtuBox/wp-optimize/master/optimize.sh
chmod +x optimize.sh
```

2) Launch the script and set the path of your images as first argument

```bash
./optimize.sh /path/to/your/images
```

To avoid permissions issues, you can run the script with another user with sudo

```bash
sudo -u www-data ./optimize.sh /path/to/your/images
```

### Warning

Conversion process can take a while, you can use `tmux` to launch the script and be able to close your ssh connection without interrupting conversion. Then just use `tmux attach` to login back in your tmux session.

### Credits
WebP conversion script is inspired by this [DigitalOcean Community Tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-and-serve-webp-images-to-speed-up-your-website)