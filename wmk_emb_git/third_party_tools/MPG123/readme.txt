High Performance MPEG 1.0/2.0/2.5 Audio Player for Layer 1, 2 and 3.
Version 0.59s-mh2 (1999/Sep/21). Written and copyrights by Michael Hipp.
Win32 port v0.01 (Feb 18 2000) by Dmitry Rahalov

usage: mpg123 [option(s)] [file(s) | URL(s) | -]
supported options:

 -k <n> --skip <n>
 -a <f> --audiodevice <f>
 -2     --2to1             2:1 Downsampling
 -4     --4to1             4:1 Downsampling
 -t     --test
 -s     --stdout
 -S     --STDOUT           Play AND output stream (not implemented yet)
 -c     --check
 -v[*]  --verbose          Increase verboselevel
 -q     --quiet            Enables quiet mode
        --title            Prints filename in xterm title bar
 -y     --resync           DISABLES resync on error
 -0     --left --single0   Play only left channel
 -1     --right --single1  Play only right channel
 -m     --mono --mix       Mix stereo to mono
        --stereo           Duplicate mono channel
        --reopen           Force close/open on audiodevice
 -g     --gain             Set audio hardware output gain
 -r     --rate             Force a specific audio output rate
        --8bit             Force 8 bit output
 -o h   --headphones       Output on headphones
 -o s   --speaker          Output on speaker
 -o l   --lineout          Output to lineout
 -f <n> --scale <n>        Scale output samples (soft gain)
 -n     --frames <n>       Play only <n> frames of every stream
 -b <n> --buffer <n>       Set play buffer ("output cache")
 -C     --control          Enable control keys
 -d     --doublespeed      Play only every second frame
 -h     --halfspeed        Play every frame twice
 -p <f> --proxy <f>        Set WWW proxy
 -@ <f> --list <f>         Play songs in <f> file-list
 -z     --shuffle          Shuffle song-list before playing
 -Z     --random           full random play
        --equalizer        Exp.: scales freq. bands acrd. to 'equalizer.dat'
        --aggressive       Tries to get higher priority (nice)
 -u     --auth             Set auth values for HTTP access
 -T     --realtime         Tries to get realtime priority
 -w <f> --wav <f>          Writes samples as WAV file in <f> (- is stdout)
        --au <f>           Writes samples as Sun AU file in <f> (- is stdout)
        --cdr <f>          Writes samples as CDR file in <f> (- is stdout)

See the manpage mpg123(1) for more information.
