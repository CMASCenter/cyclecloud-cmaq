## Install Anaconda on the /shared/build directory 

Follow instructions available here: https://docs.anaconda.com/free/anaconda/install/linux/


cd /shared/build/

```
sudo yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver
curl -O https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
```

select installation directory as /shared/build/anaconda3

add to your .cshrc

```
set path = ($path /shared/build/anaconda3/bin)
# The base environment is activated by default
conda config --set auto_activate_base True
```
