# Stream Recorder  
这是一个视频直播的推流/录制工具，支持youtube/twitch/twitcasting/bilibili四个直播平台  
有自动运行、自动备份、自动清理功能，以及使用配置文件大幅简化了使用方法，可以自动推流与录制
已知支持linux x64和arm64（包括树莓派），macos理论可用但是建议用别的，windows用户直接用别的。
## 安装说明
### 配置环境 
本工具依赖于以下程序。  
  + ffmpeg
  + yt-dlp
  + streamlink
  + you-get
  + screen 
  + ~~BaiduPCS-Go~~ 
  + Rclone(可选)

下面是安装教程
#### 检查
在shell上请依次输入命令以下检查
```bash
ffmpeg -h

yt-dlp --version

you-get --version

screen --version

python3 --version

python3 -m pip --version
```

#### 安装

哪个不显示版本号就开始安装了
debian/ubuntu系、树莓派os 可抄，centos fedora archlinux用户请自己变通。

[登录教程](https://xtls.github.io/document/level-0/ch03-ssh.html)

答应我不要用root用户好吗

[新建用户教程](
https://xtls.github.io/document/level-0/ch04-security.html)

**安装的时候看屏幕，有什么要按的y或者说明请看清了再按**

安装ffmpeg

```bash
sudo apt install ffmpeg
```

安装screen

```bash
sudo apt install screen
```

安装pip

```bash
sudo apt install python3-pip
```

或者

```bash
python3 -m ensurepip --default-pip
```

安装streamlink、you-get、yt-dlp
由于python高版本要求，不让直接将python package安装到系统里。
一、你安装homebrew，然后用

```bash
brew install streamlink

brew install you-get

brew install yt-dlp
```
代价是homebrew多占了存储空间，好处是更新省事

二、用python虚拟环境
venv生成

```bash
python3 -m venv /path/to/your/venv
```

/path/to/your/venv就是venv生成的位置，不想要了直接可以用rm删了，不影响系统

```bash
rm -r /path/to/your/venv
```

激活虚拟环境

```bash
source /path/to/your/venv/bin/activate
```

/path/to/your/venv记得替换

用pip安装streamlink、you-get、yt-dlp
```bash
pip install streamlink

pip install you-get

pip install yt-dlp
```

退出虚拟环境
```bash
deactivate
```

### 配置文件
下载解压本项目

```bash
cd ~

wget https://github.com/agustyuzu/StreamRecorder/archive/refs/heads/master.zip

unzip master.zip -d ./streamrecorder

rm master.zip

ls
```

应当显示有一个叫streamrecorder的文件夹

```bash
cd ~

wget https://github.com/agustyuzu/StreamRecorder/archive/refs/heads/master.zip

unzip master.zip -d ./streamrecorder

rm master.zip

ls
```

**注意：**
autorun.sh中的这一行请根据你的虚拟环境路径/path/to/your/venv修改。如果你用homebrew安装的streamlink、you-get、yt-dlp，请删除这一行。

> source ~/samsung/streamrecorder/bin/activate

~~这个路径是我自用的~~

```bash
nano ~/streamrecorder/autorun.sh
```

改好了按ctrl+o，按回车，按ctrl+x，按回车，就是保存和退出。

#### global.config

全局配置文件，用于配置推流地址，视频保存目录等  
具体参数说明:  
StreamOrRecord  
可选: stream/record/both，此参数决定是推流还是录制，或者二者兼顾  

Savefolder  
此参数是视频录制保存的根目录  
  
Logfolder  
Log文件保存的目录  
  
Screenlogfolder  
Screen Log文件保存的目录，和/etc/screenrc里的screen log路径一致，也可以设置成和Logfolder一样的值    
  
Autobackup  
可选: on/off，此参数是自动备份开关，选择on则视频录制后会自动备份到指定网盘并删除本地文件  
  
Backupmethod  
可选: rclone/baidu/both，此参数决定备份方式，可以是rclone或者BaiduPCS-Go，备份到onedrive或者度盘  
  
Saveformat  
可选: ts/mp4，此参数是视频录制的文件格式  
  
Rcloneremotename  
此参数是rclone的remote name，在配置rclone的时候remote name相当于网盘的别名  
  
Servername  
此参数是rclone备份时上传到网盘的目录名称，多个服务器同时运行本工具，需要以不同的服务器名字作为区分  
  
Rtmpurl  
此参数是推流地址，如rtmp://live.mobcrush.net/stream/115ed1677062e51c7339ebe7f1142a0f66db42cb86a5d27  
  
Twitchkey  
此参数是Twitch平台的api key，可以在Twitch官网申请，用于Twitch开播检测，如果不监控Twitch频道则可以忽略  
  
Twitchpwd  
  此参数是Twitch平台的api key对应的password，可以在Twitch官网申请，用于Twitch开播检测，如果不监控Twitch频道则可以忽略  
  
#### name.config  
**自带一个korone.config，不喜请用rm 删除，为原作者magicalz设置，仍保留致敬**

频道配置文件，用于配置单个频道的具体地址以及推流和备份方式等，可以建立多个  

具体参数说明:  
Interval  
此参数是开播检测的时间间隔，默认30，即30秒  

LoopOrOnce  
可选: loop/once，此参数决定程序是一直运行还是单次运行  

Backupmethod  
同global.config，如果在此设置则会覆盖global.config里的值，用于单独设置某个频道的备份方式  

StreamOrRecord  
同global.config，如果在此设置则会覆盖global.config里的值，用于单独设置某个频道是推流还是录制  

Rtmpurl  
同global.config，如果在此设置则会覆盖global.config里的值，用于单独设置某个频道的推流地址  

Youtube  
youtube频道的地址，需要注意的是只需要填写频道ID，如UC1opHUrw8rvnsadT-iGp7Cg
[可以在这个网站找到](https://commentpicker.com/youtube-channel-id.php)

Bilibili  
bilibili频道的地址，只需要填写**直播房间号数字**，如14917277  

Twitch  
twitch频道的地址，只需要填写频道ID，如rin_co_co  

Twitcast  
twitcasting频道的地址，只需要填写频道ID，如c:rin_co  

#### bilicookie说明

b站人多的直播间，比如 赛事直播 ，不登录就是最低画质。
在./config中已放入一个没有后缀没有内容的文本文件bilicookie，b站录制相关会读取。
没有内容时不会有问题。

浏览器打开https://live.bilibili.com/ ，按f12

获取如下项目的值并改好写在bilicookie内，注意保持没有后缀：

```
http-cookie=SESSDATA=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
http-cookie=bili_jct=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
http-cookie=DedeUserID__ckMd5=9xxxxxxxxxxxxxxx
http-cookie=DedeUserID=123456789

```

你可以用nano编辑：

```bash
nano ~/streamrecorder/config/bilicookie
```

这是示例，分别是中文/en界面，值在红框内，双击后复制。

[![pktQ9s0.png](https://s21.ax1x.com/2024/06/07/pktQ9s0.png)](https://imgse.com/i/pktQ9s0)

[![pktQpMq.png](https://s21.ax1x.com/2024/06/07/pktQpMq.png)](https://imgse.com/i/pktQpMq)


## 运行说明

```bash
  ./streamrecorder/streamrecorder.sh [start|restart|stop|cleanfile|cleanlog|backup]
```

程序总入口，用于统一调用其他脚本  
以下脚本均可通过streamrecorder.sh来运行

```bash
./streamrecorder/autorun.sh
程序启动脚本，只需运行一次，会自动遍历配置文件夹里的各个频道并开始推流和录制，每个频道会新建一个screen进程方便随时监控
```

```bash
./streamrecorder/autobackup.sh
```

备份脚本，如果在全局设置里设置为on，则视频录制以后会自动上传到指定网盘并删除本地文件，也可以手动运行  

```bash
./streamrecorder/autoclean.sh
```

清理脚本，每次备份后会自动调用，也可以手动运行  

```bash
./streamrecorder/closescreen.sh
```

手动运行，运行后会列出当前活动的screen子进程，输入screen名称关闭指定子进程或者输入all关闭所有子进程  

```bash
./streamrecorder/cleanlog.sh
```

手动运行，用于清理24小时以上的日志文件和空白文件  

<div style="display:none">
开机自启（不确定是否有效不建议使用）
nano /etc/rc.local  
添加以下内容，recorder是运行程序的用户名，如果不指定则默认以root用户运行  
su - recorder -c "/home/recorder/StreamRecorder/streamrecorder.sh start  
</div>


## work in process

- [x] 配置bilibili cookie，以支持录制大明星的最高清直播
- [ ] 自动安装依赖
- [ ] 自动配置这该死的venv
- [ ] rclone替换成alist或者直接删了
- [ ] 加入systemd豪华午餐
- [ ] streamlink支持获取直播信息，把you-get、yt-dlp删了

## 致谢
感谢本项目原作者magicalz，这是他的[github链接](https://github.com/magicalz)，这是他的[bilibili链接](https://space.bilibili.com/950519)，项目同名不作更改。

感谢作者printempw的[live-stream-recorder](https://github.com/printempw/live-stream-recorder)项目