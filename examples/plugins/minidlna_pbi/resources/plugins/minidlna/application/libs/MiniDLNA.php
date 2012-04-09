<?php

require_once APPLICATION_PATH . '/../library/tivoka/include.php';

class FreeNAS_Lib_MiniDLNA {

    public $ARCH = null;
    public $BASE = null;
    public $CONF = null;
    public $CONTROL = null;
    public $RCOPTIONS = array(
        'getRescan' => array(
            'opt' => '-R',
            'type' => 'boolean',
            ),
    );

    function __construct() {

        $this->ARCH = php_uname("m");
        $this->BASE = "/usr/pbi/minidlna-" . $this->ARCH;
        $this->CONF = $this->BASE . "/etc/minidlna.conf";
        $this->RCCONF = $this->BASE . "/etc/rc.conf";
        $this->CONTROL = $this->BASE . "/bin/sudo /usr/local/etc/rc.d/minidlna";

    }

    public static function isAuthorized($session) {

        // FIX HTTPS
        $target = sprintf('http://%s/plugins/json/', $_SERVER['HTTP_HOST']);
        $request = Tivoka::createRequest('1', 'plugins.is_authenticated', array($session));
        Tivoka::connect($target)->send($request);
        if($request->isError() || $request->result !== TRUE) {
            exit("Not authorized");
        }

    }

    public function writeConf($obj) {

        $fp = fopen($this->RCCONF, "w");
        if($obj->getEnabled() == true)
            fwrite($fp, "minidlna_enable=\"YES\"\n");
        else
            fwrite($fp, "minidlna_enable=\"NO\"\n");

        $flags = "";
        foreach($this->RCOPTIONS as $key => $val) {
            if(!method_exists($obj, $key)) continue;
            if($val['type'] == "boolean") {
                if($obj->$key())
                    $flags .= $val['opt'] . " ";
            }
        }
        fwrite($fp, sprintf("minidlna_flags=\"%s\"\n", $flags));
        fclose($fp);

        $fp = fopen($this->CONF, "w");
        fwrite($fp, sprintf("media_dir=%s\n", $obj->getMediaDir()));
        fwrite($fp, sprintf("port=%d\n", $obj->getPort()));
        if($obj->getInotify())
            fwrite($fp, "inotify=yes\n");
        else
            fwrite($fp, "inotify=no\n");
        if($obj->getTivo())
            fwrite($fp, "enable_tivo=yes\n");
        else
            fwrite($fp, "enable_tivo=no\n");
        fwrite($fp, sprintf("notify_interval=%d\n", $obj->getNotifyInterval()));
        if($obj->getFriendlyName())
            fwrite($fp, sprintf("friendly_name=%s\n", $obj->getFriendlyName()));
        fclose($fp);

        shell_exec($this->BASE . "/bin/sudo " . $this->BASE . "/tweak-rcconf");

    }

    public function status() {

        $desc = array(
           0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
           1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
        );
        $proc = proc_open("/usr/bin/pgrep minidlna", $desc, $pipes);
        $pids = stream_get_contents($pipes[1]);
        $retval = proc_close($proc);
        $status = 'STOPPED';
        $pid = null;

        if($retval == 0) {
            $status = "RUNNING";
            $pid = explode("\n", $pids);
            $pid = $pid[0];
        }

        return array(
            'status' => $status,
            'pid' => $pid,
        );

    }

    public function start() {

        $desc = array(
           0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
           1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
           2 => array("pipe", "STDOUT"),  // stdout is a pipe that the child will write to
        );
        $proc = proc_open($this->CONTROL . " start", $desc, $pipes);
        $stdout = stream_get_contents($pipes[1]);
        $retval = proc_close($proc);
        return $stdout;

    }

    public function stop() {

        $desc = array(
           0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
           1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
           2 => array("pipe", "STDOUT"),  // stdout is a pipe that the child will write to
        );
        $proc = proc_open($this->CONTROL . " forcestop", $desc, $pipes);
        $stdout = stream_get_contents($pipes[1]);
        $retval = proc_close($proc);
        return $stdout;

    }

}

?>