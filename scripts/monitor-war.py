import subprocess
import sys
import re
import os.path
import pyinotify
import shutil

tomcat_base = '/data/webapps/'
tomcat_listen = '/data/war-listen/'
watchmgr = pyinotify.WatchManager()
# 
mask = pyinotify.IN_DELETE | pyinotify.IN_CREATE | pyinotify.IN_MODIFY# | pyinotify.IN_CLOSE_WRITE

class EventHandler(pyinotify.ProcessEvent):

    def process_IN_CREATE(self, event):
        self.rebuild(event)

    def process_IN_DELETE(self, event):
        self.rebuild(event)

    def process_IN_MODIFY(self, event):
        self.rebuild(event)

    # def process_IN_CLOSE_NOWRITE(self, event):
    #     self.rebuild(event)

    def rebuild(self, event):
        chang_name = re.compile(".+\.swp$|.+\.swx$|.+\.swpx$")
        path_name = event.pathname
        #print path_name
        folder_name = event.name
        print folder_name
        if (not chang_name.match(path_name)) and (folder_name.find('/') == -1):
            if (os.path.exists(tomcat_base + folder_name + '.war')) and (os.path.isdir(tomcat_base + folder_name)):
                if (not os.path.exists(tomcat_listen + folder_name + '.war')):
                    shutil.copy2(tomcat_base + folder_name + '.war', tomcat_listen + folder_name + '.war')
                else:
                    src_war_version = subprocess.check_output("unzip -q -c " + tomcat_base + folder_name + ".war" + " META-INF/MANIFEST.MF | grep 'Manifest-Version' | cut -d ':' -f 2", shell=True)
                    dest_war_version = subprocess.check_output("unzip -q -c " + tomcat_listen + folder_name + ".war" + " META-INF/MANIFEST.MF | grep 'Manifest-Version' | cut -d ':' -f 2", shell=True)
                    if (src_war_version != dest_war_version):
                        shutil.copy2(tomcat_base + folder_name + '.war', tomcat_listen + folder_name + '.war')
            else:
                if (not os.path.exists(tomcat_base + folder_name)) and (os.path.exists(tomcat_listen + folder_name + '.war')):
                    os.remove(tomcat_listen + folder_name + '.war');


handler = EventHandler()

notifier = pyinotify.Notifier(watchmgr, handler)

wdd = watchmgr.add_watch('/data/webapps', mask, rec=True, auto_add=True)

notifier.loop()
