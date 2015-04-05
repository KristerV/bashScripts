#!/bin/bash
source ~/newDropbox/cmd/kuti_mixins.sh

# MAIN
function press_enter {
    echo ""
    #echo -n "Press Enter to continue.."
    #read
    clear
}

function rem {
    rm -f rec.mkv
    rm -f rec.mp4
    rm -f rec.gif
}

function recRegion {
    ffcast -s rec rec.mkv
}
## Add -vv for verbosity

function rec720pulse {
    
    # change resolution to 1280x720
    xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
    xrandr --addmode LVDS1 1280x720_60.00
    xrandr --output LVDS1 --mode 1280x720_60.00

    # start recording
    getdatetime
    ffmpeg -f alsa -i pulse -acodec pcm_s16le -f x11grab -s `xdpyinfo | grep 'dimensions:'|awk '{print $2}'` -r 25 -i :0.0 screencast_$datetime.mkv 2> ~/.tmp/error.txt
}

function killrec {
    killall ffmpeg 2> ~/.tmp/error.txt
    confirm "recording_stopped"
}

function res {
    if [[ -z "$1" ]] ;
        then
            framerate=""
        else
            framerate="-r $1"
    fi

    if [[ -z "$2" ]] ;
        then
            resize=""
        else
            resize="-filter:v scale=$2:-1 -c:a copy"
    fi
    eval "ffmpeg -i rec.mkv $framerate $resize rec.mp4"
}

## gif delay
function gif {
    if [[ -z "$1" ]] ;
        then
            delay=""
        else
            d=$(expr 100 / $1)
            delay="-delay $d"
    fi
    
    eval "convert $delay -layers Optimize$2 rec.mp4 rec.gif"
}

function r {
    if [[ -z "$1" ]] ;
        then
            fps=25
        else
            fps=$1
    fi
    echo "clear files"
    rem
    echo "record screen"
    rec
    echo "resize"
    res $fps $2
    echo "convert to gif"
    gif $fps $3
}

clear=True
if [ $1 ]; then
    $1
    exit
fi
selection=
until [ "$selection" = "0" ]; do
    if [ $clear = True ]; then
        clear
    fi
    echo "      "
    echo "      "
    echo "        SCREENCAST COMMANDS  "
    echo "      -----------------------"
    echo "      "
    echo "      rem. remove files"
    echo "      recRegion. Record region"
    echo "      rec720pulse. Record fullscreen with audio"
    echo "      res. Resize fps width"
    echo "      gif. convert Plus"
    echo "      "
    echo "      r. batch fps width Plus"
    echo "      "
    echo "      "
    echo "      "
    echo "      "
    echo "      "
    echo "      "
    echo "      0. exit"
    echo "      "
    echo -n "      "
    read selection
    echo ""
    case $selection in
        0 ) clear; exit ;;
        * ) $selection
    esac
done
